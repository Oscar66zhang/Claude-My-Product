-- ============================================
-- 轻账本 Light Account Book - MySQL 数据库设计
-- ============================================
-- 版本: v1.0.1
-- 创建日期: 2026-05-27
-- 数据库: MySQL 8.0+
-- ============================================

-- 创建数据库
CREATE DATABASE IF NOT EXISTS light_account_book
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

USE light_account_book;

-- ============================================
-- 一、用户表 (users)
-- ============================================
CREATE TABLE IF NOT EXISTS users (
    id              VARCHAR(36) PRIMARY KEY COMMENT 'UUID 用户唯一标识',
    username        VARCHAR(20) NOT NULL UNIQUE COMMENT '用户名 (4-20位字母/数字)',
    password_hash   VARCHAR(64) NOT NULL COMMENT '密码 SHA-256 哈希值',
    nickname        VARCHAR(50) DEFAULT NULL COMMENT '昵称',
    avatar_url      VARCHAR(255) DEFAULT NULL COMMENT '头像 URL',
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
    updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_deleted      TINYINT(1) NOT NULL DEFAULT 0 COMMENT '软删除标记 (0=正常, 1=已删除)',
    INDEX idx_users_username (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 二、会话表 (sessions)
-- ============================================
CREATE TABLE IF NOT EXISTS sessions (
    id              VARCHAR(36) PRIMARY KEY COMMENT 'UUID 会话唯一标识',
    user_id         VARCHAR(36) NOT NULL COMMENT '关联用户 ID',
    token           VARCHAR(512) NOT NULL UNIQUE COMMENT 'Session Token',
    device_info     VARCHAR(255) DEFAULT NULL COMMENT '设备信息',
    ip_address      VARCHAR(45) DEFAULT NULL COMMENT '登录 IP (支持IPv6)',
    expires_at      DATETIME NOT NULL COMMENT '过期时间',
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    is_revoked      TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否已撤销 (0=正常, 1=已撤销)',
    INDEX idx_sessions_token (token),
    INDEX idx_sessions_user_id (user_id),
    INDEX idx_sessions_expires_at (expires_at),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 三、分类表 (categories)
-- ============================================
CREATE TABLE IF NOT EXISTS categories (
    id              VARCHAR(32) PRIMARY KEY COMMENT '分类唯一标识',
    name            VARCHAR(20) NOT NULL COMMENT '分类名称',
    icon            VARCHAR(50) NOT NULL COMMENT '图标名称 (Lucide 图标名)',
    type            ENUM('expense', 'income') NOT NULL COMMENT '类型: 支出/收入',
    parent_id       VARCHAR(32) DEFAULT NULL COMMENT '父分类 ID (用于二级分类)',
    display_order   INT NOT NULL DEFAULT 0 COMMENT '展示排序',
    is_system       TINYINT(1) NOT NULL DEFAULT 1 COMMENT '是否系统预设 (1=系统, 0=用户自定义)',
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_categories_type (type),
    INDEX idx_categories_display_order (display_order),
    FOREIGN KEY (parent_id) REFERENCES categories(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 四、记账记录表 (records)
-- ============================================
CREATE TABLE IF NOT EXISTS records (
    id              VARCHAR(36) PRIMARY KEY COMMENT 'UUID 记录唯一标识',
    user_id         VARCHAR(36) NOT NULL COMMENT '关联用户 ID',
    date            DATE NOT NULL COMMENT '记账日期 (YYYY-MM-DD)',
    type            ENUM('expense', 'income') NOT NULL COMMENT '类型: 支出/收入',
    category_id     VARCHAR(32) NOT NULL COMMENT '关联分类 ID',
    amount          DECIMAL(12,2) NOT NULL COMMENT '金额 (正数, 精确到分)',
    remark          VARCHAR(100) DEFAULT NULL COMMENT '备注 (最长 100 字)',
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_deleted      TINYINT(1) NOT NULL DEFAULT 0 COMMENT '软删除标记',
    INDEX idx_records_user_date (user_id, date DESC),
    INDEX idx_records_user_type (user_id, type),
    INDEX idx_records_category (category_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 五、预算表 (budgets)
-- ============================================
CREATE TABLE IF NOT EXISTS budgets (
    id              VARCHAR(36) PRIMARY KEY COMMENT 'UUID 预算唯一标识',
    user_id         VARCHAR(36) NOT NULL COMMENT '关联用户 ID',
    month           VARCHAR(7) NOT NULL COMMENT '预算所属月份 (YYYY-MM)',
    amount          DECIMAL(12,2) NOT NULL DEFAULT 0 COMMENT '月预算金额',
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_deleted      TINYINT(1) NOT NULL DEFAULT 0 COMMENT '软删除标记',
    UNIQUE KEY uk_budgets_user_month (user_id, month),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 六、游客数据表 (anonymous_data)
-- ============================================
CREATE TABLE IF NOT EXISTS anonymous_data (
    id              VARCHAR(36) PRIMARY KEY COMMENT 'UUID 记录唯一标识',
    device_id       VARCHAR(64) NOT NULL COMMENT '设备唯一标识',
    date            DATE NOT NULL COMMENT '记账日期 (YYYY-MM-DD)',
    type            ENUM('expense', 'income') NOT NULL COMMENT '类型: 支出/收入',
    category_id     VARCHAR(32) NOT NULL COMMENT '关联分类 ID',
    amount          DECIMAL(12,2) NOT NULL COMMENT '金额',
    remark          VARCHAR(100) DEFAULT NULL COMMENT '备注',
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    INDEX idx_anonymous_device (device_id),
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 七、应用配置表 (app_config)
-- ============================================
CREATE TABLE IF NOT EXISTS app_config (
    config_key       VARCHAR(50) PRIMARY KEY COMMENT '配置键',
    value           TEXT COMMENT '配置值',
    description     VARCHAR(255) DEFAULT NULL COMMENT '配置说明',
    updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 八、视图: 常用查询
-- ============================================

-- v_user_record_stats: 用户每月收支统计视图
CREATE OR REPLACE VIEW v_user_record_stats AS
SELECT
    user_id,
    DATE_FORMAT(date, '%Y-%m') AS month,
    type,
    SUM(amount) AS total_amount,
    COUNT(*) AS record_count
FROM records
WHERE is_deleted = 0
GROUP BY user_id, DATE_FORMAT(date, '%Y-%m'), type;

-- v_category_stats: 用户各分类支出统计视图
CREATE OR REPLACE VIEW v_category_stats AS
SELECT
    r.user_id,
    DATE_FORMAT(r.date, '%Y-%m') AS month,
    r.category_id,
    c.name AS category_name,
    c.icon AS category_icon,
    r.type,
    SUM(r.amount) AS total_amount,
    COUNT(*) AS record_count
FROM records r
JOIN categories c ON r.category_id = c.id
WHERE r.is_deleted = 0
GROUP BY r.user_id, DATE_FORMAT(r.date, '%Y-%m'), r.category_id, r.type;