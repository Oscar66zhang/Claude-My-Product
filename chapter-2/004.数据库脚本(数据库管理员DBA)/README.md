# 轻账本数据库设计文档

## 概述

本文档描述轻账本应用的数据库设计，基于 SQLite 数据库。

## 表结构

| 表名 | 说明 |
|------|------|
| [users](#users-用户表) | 用户账户信息 |
| [sessions](#sessions-会话表) | 用户登录状态管理 |
| [categories](#categories-分类表) | 收支分类定义 |
| [records](#records-记账记录表) | 记账记录明细 |
| [budgets](#budgets-预算表) | 月度预算设置 |
| [anonymous_data](#anonymous_data-游客数据表) | 游客模式临时数据 |
| [app_config](#app_config-应用配置表) | 应用配置存储 |

## ER 关系图

```
┌─────────────┐       ┌─────────────┐       ┌─────────────┐
│   users     │──┐    │  sessions   │      │   records   │
│  用户表     │  │    │  会话表     │      │  记账记录   │
└─────────────┘  │    └─────────────┘      └──────┬──────┘
                 │                                │
    ┌────────────┘                           ┌────▼────┐
    │                                        │categories│
    │  ┌─────────────┐                       │  分类表  │
    └──│  budgets    │                       └─────────┘
       │  预算表      │
       └─────────────┘

┌─────────────┐
│anonymous_data│
│  游客数据   │
└─────────────┘
```

## 字段说明

### users 用户表

| 字段 | 类型 | 说明 |
|------|------|------|
| id | TEXT (UUID) | 用户唯一标识 |
| username | TEXT | 用户名 (4-20位字母/数字，唯一) |
| password_hash | TEXT | 密码 SHA-256 哈希值 |
| nickname | TEXT | 昵称 (可选) |
| avatar_url | TEXT | 头像 URL (可选) |
| created_at | TEXT | 注册时间 |
| updated_at | TEXT | 更新时间 |
| is_deleted | INTEGER | 软删除标记 (0=正常, 1=已删除) |

### sessions 会话表

| 字段 | 类型 | 说明 |
|------|------|------|
| id | TEXT (UUID) | 会话唯一标识 |
| user_id | TEXT | 关联用户 ID |
| token | TEXT | Session Token |
| device_info | TEXT | 设备信息 |
| ip_address | TEXT | 登录 IP |
| expires_at | TEXT | 过期时间 |
| created_at | TEXT | 创建时间 |
| is_revoked | INTEGER | 是否已撤销 (0=正常, 1=已撤销) |

### categories 分类表

| 字段 | 类型 | 说明 |
|------|------|------|
| id | TEXT | 分类唯一标识 |
| name | TEXT | 分类名称 |
| icon | TEXT | 图标名称 (Lucide 图标名) |
| type | TEXT | 类型: expense / income |
| parent_id | TEXT | 父分类 ID (用于二级分类) |
| display_order | INTEGER | 展示排序 |
| is_system | INTEGER | 是否系统预设 (1=系统, 0=用户自定义) |

### records 记账记录表

| 字段 | 类型 | 说明 |
|------|------|------|
| id | TEXT (UUID) | 记录唯一标识 |
| user_id | TEXT | 关联用户 ID |
| date | TEXT | 记账日期 (YYYY-MM-DD) |
| type | TEXT | 类型: expense / income |
| category_id | TEXT | 关联分类 ID |
| amount | REAL | 金额 (正数, 精确到分) |
| remark | TEXT | 备注 (最长 100 字) |
| created_at | TEXT | 创建时间 |
| updated_at | TEXT | 更新时间 |
| is_deleted | INTEGER | 软删除标记 |

### budgets 预算表

| 字段 | 类型 | 说明 |
|------|------|------|
| id | TEXT (UUID) | 预算唯一标识 |
| user_id | TEXT | 关联用户 ID |
| month | TEXT | 预算所属月份 (YYYY-MM) |
| amount | REAL | 月预算金额 |
| created_at | TEXT | 创建时间 |
| updated_at | TEXT | 更新时间 |
| is_deleted | INTEGER | 软删除标记 |

### anonymous_data 游客数据表

| 字段 | 类型 | 说明 |
|------|------|------|
| id | TEXT (UUID) | 记录唯一标识 |
| device_id | TEXT | 设备唯一标识 |
| date | TEXT | 记账日期 (YYYY-MM-DD) |
| type | TEXT | 类型: expense / income |
| category_id | TEXT | 关联分类 ID |
| amount | REAL | 金额 |
| remark | TEXT | 备注 |
| created_at | TEXT | 创建时间 |

### app_config 应用配置表

| 字段 | 类型 | 说明 |
|------|------|------|
| key | TEXT | 配置键 |
| value | TEXT | 配置值 (JSON 格式) |
| description | TEXT | 配置说明 |
| updated_at | TEXT | 更新时间 |

## 索引设计

| 索引名 | 表 | 字段 | 类型 | 用途 |
|--------|-----|------|------|------|
| idx_users_username | users | username | UNIQUE | 用户名唯一性校验 |
| idx_sessions_token | sessions | token | UNIQUE | Token 快速查找 |
| idx_sessions_user_id | sessions | user_id | NORMAL | 用户会话查询 |
| idx_sessions_expires_at | sessions | expires_at | NORMAL | 过期会话清理 |
| idx_categories_type | categories | type | NORMAL | 支出/收入分类查询 |
| idx_categories_display_order | categories | display_order | NORMAL | 分类排序展示 |
| idx_records_user_date | records | user_id, date | COMPOSITE | 用户日期范围查询 |
| idx_records_user_type | records | user_id, type | COMPOSITE | 用户收支类型查询 |
| idx_records_category | records | category_id | NORMAL | 分类统计查询 |
| idx_budgets_user_month | budgets | user_id, month | UNIQUE | 用户月度预算唯一性 |

## 视图

### v_user_record_stats 用户每月收支统计

按用户和月份统计收支情况。

| 字段 | 说明 |
|------|------|
| user_id | 用户 ID |
| month | 月份 (YYYY-MM) |
| type | 收支类型 |
| total_amount | 总额 |
| record_count | 记录条数 |

### v_category_stats 各分类支出统计

按用户、月份、分类统计支出。

| 字段 | 说明 |
|------|------|
| user_id | 用户 ID |
| month | 月份 (YYYY-MM) |
| category_id | 分类 ID |
| category_name | 分类名称 |
| category_icon | 分类图标 |
| type | 收支类型 |
| total_amount | 总额 |
| record_count | 记录条数 |

## 预设分类

### 支出分类

| 一级分类 | 二级分类 |
|----------|----------|
| 餐饮 | 早餐、午餐、晚餐、下午茶、零食 |
| 交通 | 打车、地铁、公交、停车、油费 |
| 购物 | 服装、电子产品、日用品、化妆品 |
| 居住 | 房租、水电煤、物业、维修 |
| 娱乐 | 电影、游戏、旅游、演出 |
| 医疗 | 门诊、药品、体检 |
| 教育 | 书籍、课程、培训 |
| 其他 | 社交、捐赠、意外丢失 |

### 收入分类

| 一级分类 | 二级分类 |
|----------|----------|
| 工资 | - |
| 奖金 | - |
| 投资 | 股票、基金、利息 |
| 礼金 | 红包、礼金 |
| 其他 | - |

## 触发器

| 触发器 | 表 | 事件 | 说明 |
|--------|-----|------|------|
| trg_users_updated_at | users | UPDATE | 更新时自动刷新 updated_at |
| trg_records_updated_at | records | UPDATE | 更新时自动刷新 updated_at |
| trg_budgets_updated_at | budgets | UPDATE | 更新时自动刷新 updated_at |
| trg_categories_updated_at | categories | UPDATE | 更新时自动刷新 updated_at |

## 使用说明

### 初始化数据库

```bash
# 创建数据库
sqlite3 light_account_book.db

# 执行建表脚本
.read schema.sql

# 插入初始化数据
.read seed_data.sql

# 退出
.quit
```

### 导出数据库结构

```bash
sqlite3 light_account_book.db ".schema" > schema_export.sql
```

## 版本历史

| 版本 | 日期 | 说明 |
|------|------|------|
| v1.0.1 | 2026-05-27 | 初始版本，支持用户体系、记账、预算、分类管理 |