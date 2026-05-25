# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

这是一个 AI Vibe Coding 一人项目开发实战教程仓库，展示从 PRD 到实际产品开发的完整流程。

## 当前章节

- **chapter-1**: HTML5 贪食蛇游戏
  - `chapter-1/snake.html`: 可爱的粉色主题贪食蛇游戏，Canvas 绘制，键盘方向键控制
  - `chapter-1/index.html`: 占位文件

- **chapter-2**: 轻账本 - 个人财务管理应用
  - `chapter-2/001.产品PRD(产品经理)/轻账本-产品PRD.md`: 产品需求文档
  - `chapter-2/001.产品PRD(产品经理)/index.html`: 完整的 Web 应用（单文件，约 900 行）

## 常用命令

```bash
# 启动本地服务器（用于开发 chapter-2）
cd /Users/oscarzhang/code/AI/Vibe\ Coding一人项目开发实战
python3 -m http.server 8080

# 浏览器直接打开（单文件 HTML 无需服务器）
open chapter-1/snake.html
open "chapter-2/001.产品PRD(产品经理)/index.html"
```

## 技术栈

- **纯 HTML5 + CSS3 + JavaScript**（单文件，无框架依赖）
- **LocalStorage** 用于本地数据持久化
- **Canvas 2D API** 用于游戏渲染
- **移动端优先** 响应式设计，模拟 480px 手机屏幕

## 应用架构（轻账本）

```
index.html (单文件)
├── CSS: 粉嫩色系主题（#FF8FAB 主色）、响应式布局、底部 Tab 导航
├── HTML: Header + 4个页面 + 记账弹窗 + Toast
└── JS:
    ├── 数据层: LocalStorage 存储 records[] + budget{}
    ├── 页面: 首页/账单/预算/我的（Tab 切换）
    ├── 记账: 分类选择 → 金额输入（数字键盘） → 保存
    └── 工具: exportData() CSV导出、showToast() 提示
```

## 文件命名规范

产品 PRD 文档放在 `001.产品PRD(产品经理)` 文件夹中，格式为 `产品名-产品PRD.md`。