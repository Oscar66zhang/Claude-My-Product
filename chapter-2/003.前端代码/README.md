# 轻账本 (Serene Ledger)

轻量级个人财务管理应用，采用纯前端实现，数据本地存储。

## 项目结构

```
frontEnd/
├── index.html              # 入口页面 (重定向到登录页)
├── src/
│   ├── pages/              # 页面文件
│   │   ├── login.html      # 登录页
│   │   ├── register.html    # 注册页
│   │   ├── reset-password.html  # 找回密码页
│   │   ├── home.html        # 首页
│   │   ├── records.html     # 账单页
│   │   ├── budget.html      # 预算页
│   │   ├── profile.html     # 我的页面
│   │   ├── add-record.html  # 记一笔页
│   │   └── settings.html    # 设置页
│   ├── styles/              # 样式文件
│   │   └── global.css      # 全局样式 (设计系统变量)
│   ├── scripts/             # 脚本文件
│   │   └── app.js          # 主应用逻辑 (状态管理、路由)
│   └── assets/              # 静态资源
├── README.md
└── package.json            # (可选) 项目配置
```

## 技术栈

- **HTML5 + CSS3 + JavaScript** (原生实现，无框架依赖)
- **Tailwind CSS** (通过 CDN 引入，用于原型快速开发)
- **Manrope 字体** (Google Fonts)
- **Material Symbols** (Google Fonts Icons)
- **LocalStorage** (数据持久化)

## 页面导航

```
登录/注册流程:
  login.html → register.html
            → reset-password.html

主应用流程 (需要登录):
  home.html (首页)
    ├── add-record.html (记一笔)
    ├── records.html (账单)
    ├── budget.html (预算)
    ├── profile.html (我的)
    └── settings.html (设置)

底部导航: 首页 | 账单 | [记一笔] | 预算 | 我的/设置
```

## 数据结构

```javascript
AppState = {
  isLoggedIn: Boolean,
  user: { name, email },
  records: [{
    id: Number,
    type: 'expense' | 'income',
    amount: Number,
    category: String,
    note: String,
    date: String,
    createdAt: ISO8601
  }],
  budget: {
    monthly: Number,
    categories: { [categoryId]: Number }
  },
  settings: {
    darkMode: Boolean,
    notifications: Boolean,
    currency: 'CNY' | 'USD' | 'EUR' | 'JPY'
  }
}
```

## 启动方式

### 方式一: 直接打开
```bash
open index.html
# 或直接在浏览器中打开 index.html
```

### 方式二: 本地服务器 (推荐)
```bash
cd /Users/oscarzhang/code/AI/Vibe\ Coding一人项目开发实战/chapter-2/003.前端代码
python3 -m http.server 8080
# 访问 http://localhost:8080
```

### 方式三: VSCode Live Server
在 VSCode 中安装 Live Server 扩展，右键 index.html → "Open with Live Server"

## 功能清单

- [x] 用户注册/登录
- [x] 找回密码
- [x] 记一笔 (收入/支出)
- [x] 账单查看与删除
- [x] 预算管理
- [x] 数据导出 (CSV)
- [x] 偏好设置 (深色模式、货币)
- [x] 响应式设计 (桌面+移动)
- [x] 本地数据持久化

## 设计系统

颜色系统基于 Material Design 3:
- **Primary (Teal)**: #006a6a - 主要操作
- **Income Teal**: #4EBABA - 收入标识
- **Expense Red**: #F26D5F - 支出标识
- **Surface**: #f8fafb - 背景色

详细设计规范见 [DESIGN.md](./serene_ledger/DESIGN.md)

## 开发说明

页面之间通过 HTML 文件直接跳转，所有页面共享 `src/scripts/app.js` 中的全局状态管理。

如需添加新页面:
1. 在 `src/pages/` 下创建新 HTML 文件
2. 引入全局样式和脚本
3. 参考现有页面实现布局和功能

## License

启动方式

cd "/Users/oscarzhang/code/AI/Vibe Coding一人项目开发实战/chapter-2/003.前端代码"
python3 -m http.server 8080
# 访问 http://localhost:8080