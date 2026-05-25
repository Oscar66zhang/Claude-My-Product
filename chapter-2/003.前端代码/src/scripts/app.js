/**
 * Serene Ledger - Main Application
 * Handles routing, page navigation, and global state
 */

// Page definitions with metadata
const PAGES = {
  'login': { title: '登录 - 轻账本', file: 'login.html' },
  'register': { title: '注册 - 轻账本', file: 'register.html' },
  'reset-password': { title: '找回密码 - 轻账本', file: 'reset-password.html' },
  'home': { title: '首页 - 轻账本', file: 'home.html' },
  'records': { title: '账单 - 轻账本', file: 'records.html' },
  'budget': { title: '预算 - 轻账本', file: 'budget.html' },
  'profile': { title: '我的 - 轻账本', file: 'profile.html' },
  'add-record': { title: '记一笔 - 轻账本', file: 'add-record.html' },
  'settings': { title: '设置 - 轻账本', file: 'settings.html' }
};

// Simple hash-based router
class Router {
  constructor() {
    this.currentPage = this.getPageFromHash();
    window.addEventListener('hashchange', () => this.handleRouteChange());
  }

  getPageFromHash() {
    const hash = window.location.hash.slice(1) || 'login';
    return PAGES[hash] ? hash : 'login';
  }

  navigate(page) {
    if (PAGES[page]) {
      window.location.hash = page;
    } else {
      console.error(`Page "${page}" not found`);
    }
  }

  handleRouteChange() {
    this.currentPage = this.getPageFromHash();
    this.loadPage(this.currentPage);
  }

  loadPage(page) {
    // For multi-page app, we just navigate to the HTML file
    // The HTML files are self-contained
    if (window.location.pathname.endsWith(PAGES[page].file)) {
      return;
    }
    // Navigate to the page
    window.location.href = PAGES[page].file + window.location.hash;
  }
}

// Global state
const AppState = {
  isLoggedIn: false,
  user: null,
  records: [],
  budget: {
    monthly: 5000,
    categories: {}
  },
  settings: {
    darkMode: false,
    notifications: true,
    currency: 'CNY'
  },

  // Load data from localStorage
  load() {
    const savedState = localStorage.getItem('sereneLedgerState');
    if (savedState) {
      const parsed = JSON.parse(savedState);
      Object.assign(this, parsed);
    }
  },

  // Save data to localStorage
  save() {
    localStorage.setItem('sereneLedgerState', JSON.stringify({
      isLoggedIn: this.isLoggedIn,
      user: this.user,
      records: this.records,
      budget: this.budget,
      settings: this.settings
    }));
  },

  // Add a record
  addRecord(record) {
    this.records.push({
      id: Date.now(),
      ...record,
      createdAt: new Date().toISOString()
    });
    this.save();
  },

  // Delete a record
  deleteRecord(id) {
    this.records = this.records.filter(r => r.id !== id);
    this.save();
  },

  // Get records for current month
  getMonthlyRecords() {
    const now = new Date();
    const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);
    return this.records.filter(r => new Date(r.createdAt) >= startOfMonth);
  },

  // Calculate totals
  getMonthlyTotals() {
    const records = this.getMonthlyRecords();
    const income = records
      .filter(r => r.type === 'income')
      .reduce((sum, r) => sum + r.amount, 0);
    const expense = records
      .filter(r => r.type === 'expense')
      .reduce((sum, r) => sum + r.amount, 0);
    return { income, expense, balance: income - expense };
  },

  // Login simulation
  login(email, password) {
    this.isLoggedIn = true;
    this.user = { email, name: '用户' };
    this.save();
  },

  // Logout
  logout() {
    this.isLoggedIn = false;
    this.user = null;
    this.save();
    router.navigate('login');
  }
};

// Initialize router
const router = new Router();

// Initialize app
document.addEventListener('DOMContentLoaded', () => {
  AppState.load();

  // Update UI based on auth state
  updateUIForAuthState();
});

// Update UI based on auth state
function updateUIForAuthState() {
  const navLinks = document.querySelectorAll('[data-nav]');
  navLinks.forEach(link => {
    const page = link.dataset.nav;
    if (page === 'login' || page === 'register' || page === 'reset-password') {
      if (AppState.isLoggedIn) {
        link.style.display = 'none';
      }
    }
  });
}

// Toast notification helper
function showToast(message, type = 'info') {
  const toast = document.createElement('div');
  toast.className = `toast toast-${type}`;
  toast.innerHTML = `
    <span class="material-symbols-outlined">${type === 'success' ? 'check_circle' : 'info'}</span>
    <span>${message}</span>
  `;

  // Add styles
  toast.style.cssText = `
    position: fixed;
    bottom: 100px;
    left: 50%;
    transform: translateX(-50%);
    background: var(--color-surface-white);
    padding: 12px 24px;
    border-radius: var(--radius-lg);
    box-shadow: var(--shadow-lg);
    display: flex;
    align-items: center;
    gap: 8px;
    z-index: 9999;
    animation: slideUp 0.3s ease;
  `;

  document.body.appendChild(toast);

  // Auto remove after 3 seconds
  setTimeout(() => {
    toast.style.animation = 'slideDown 0.3s ease';
    setTimeout(() => toast.remove(), 300);
  }, 3000);
}

// Format currency
function formatCurrency(amount, currency = 'CNY') {
  const symbols = { CNY: '¥', USD: '$', EUR: '€', JPY: '¥' };
  return `${symbols[currency] || '¥'}${amount.toFixed(2)}`;
}

// Format date
function formatDate(dateString) {
  const date = new Date(dateString);
  const now = new Date();
  const diff = now - date;
  const dayInMs = 24 * 60 * 60 * 1000;

  if (diff < dayInMs) {
    return '今天';
  } else if (diff < 2 * dayInMs) {
    return '昨天';
  } else {
    return `${date.getMonth() + 1}月${date.getDate()}日`;
  }
}

// Category definitions
const CATEGORIES = {
  expense: [
    { id: 'food', name: '餐饮', icon: 'restaurant' },
    { id: 'transport', name: '交通', icon: 'directions_bus' },
    { id: 'shopping', name: '购物', icon: 'shopping_bag' },
    { id: 'living', name: '居住', icon: 'home' },
    { id: 'entertainment', name: '娱乐', icon: 'sports_esports' },
    { id: 'medical', name: '医疗', icon: 'medical_services' },
    { id: 'education', name: '教育', icon: 'school' },
    { id: 'other', name: '其他', icon: 'more_horiz' }
  ],
  income: [
    { id: 'salary', name: '工资', icon: 'payments' },
    { id: 'bonus', name: '奖金', icon: 'card_giftcard' },
    { id: 'investment', name: '投资', icon: 'trending_up' },
    { id: 'gift', name: '礼金', icon: 'redeem' },
    { id: 'other', name: '其他', icon: 'more_horiz' }
  ]
};

// Export for use in pages
window.AppState = AppState;
window.router = router;
window.showToast = showToast;
window.formatCurrency = formatCurrency;
window.formatDate = formatDate;
window.CATEGORIES = CATEGORIES;