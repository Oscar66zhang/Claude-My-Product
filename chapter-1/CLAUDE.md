# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

这是一个AI Vibe Coding一人项目开发实战教程仓库，专注于开发HTML5小游戏。目前进度在 chapter-1。

## 游戏开发方式

所有游戏均为单文件HTML实现，可直接在浏览器中打开运行，无需任何构建步骤。

## 当前章节

- **chapter-1**: 贪食蛇游戏
  - `snake.html`: 可爱的绿色主题贪食蛇游戏，使用Canvas绘制，键盘方向键控制

## 常用命令

直接用浏览器打开HTML文件即可运行游戏：
```bash
# macOS
open snake.html

# 或指定浏览器
open -a "Google Chrome" snake.html
```

## 技术栈

- 纯HTML5 + CSS3 + JavaScript
- Canvas 2D API 用于游戏渲染
- 无外部依赖，单文件可运行