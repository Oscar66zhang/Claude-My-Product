/**
 * 轻账本 API 服务层
 * 封装所有与后端的 HTTP 请求
 */

const API_BASE_URL = 'http://localhost:3000/api';

// 存储 Token
const TokenManager = {
  getToken() {
    return localStorage.getItem('light_account_token');
  },

  setToken(token) {
    localStorage.setItem('light_account_token', token);
  },

  removeToken() {
    localStorage.removeItem('light_account_token');
  },

  getUser() {
    const userStr = localStorage.getItem('light_account_user');
    return userStr ? JSON.parse(userStr) : null;
  },

  setUser(user) {
    localStorage.setItem('light_account_user', JSON.stringify(user));
  },

  removeUser() {
    localStorage.removeItem('light_account_user');
  },

  clear() {
    this.removeToken();
    this.removeUser();
  }
};

// 通用请求方法
async function request(endpoint, options = {}) {
  const url = `${API_BASE_URL}${endpoint}`;
  const token = TokenManager.getToken();

  const headers = {
    'Content-Type': 'application/json',
    ...options.headers
  };

  if (token) {
    headers['Authorization'] = `Bearer ${token}`;
  }

  try {
    const response = await fetch(url, {
      ...options,
      headers
    });

    const data = await response.json();

    if (!response.ok) {
      throw new Error(data.message || '请求失败');
    }

    return data;
  } catch (error) {
    if (error.message === 'Failed to fetch') {
      throw new Error('无法连接到服务器，请检查后端服务是否启动');
    }
    throw error;
  }
}

// 认证 API
const AuthAPI = {
  /**
   * 用户注册
   * @param {string} username 用户名
   * @param {string} password 密码
   * @param {string} nickname 昵称（可选）
   */
  async register(username, password, nickname) {
    const data = await request('/auth/register', {
      method: 'POST',
      body: JSON.stringify({ username, password, nickname })
    });

    if (data.success && data.data) {
      TokenManager.setToken(data.data.token);
      TokenManager.setUser({
        userId: data.data.userId,
        username: data.data.username,
        nickname: data.data.nickname
      });
    }

    return data;
  },

  /**
   * 用户登录
   * @param {string} username 用户名
   * @param {string} password 密码
   */
  async login(username, password) {
    const data = await request('/auth/login', {
      method: 'POST',
      body: JSON.stringify({ username, password })
    });

    if (data.success && data.data) {
      TokenManager.setToken(data.data.token);
      TokenManager.setUser({
        userId: data.data.userId,
        username: data.data.username,
        nickname: data.data.nickname
      });
    }

    return data;
  },

  /**
   * 用户登出
   */
  async logout() {
    try {
      await request('/auth/logout', { method: 'POST' });
    } finally {
      TokenManager.clear();
    }
  },

  /**
   * 获取当前用户信息
   */
  async getCurrentUser() {
    return request('/auth/me');
  },

  /**
   * 检查是否已登录
   */
  isLoggedIn() {
    return !!TokenManager.getToken();
  },

  /**
   * 获取本地存储的用户信息
   */
  getUserInfo() {
    return TokenManager.getUser();
  }
};

// 导出
window.API_BASE_URL = API_BASE_URL;
window.TokenManager = TokenManager;
window.AuthAPI = AuthAPI;
window.request = request;