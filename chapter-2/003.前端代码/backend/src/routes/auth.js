const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { v4: uuidv4 } = require('uuid');
const db = require('../db');
const authMiddleware = require('../middleware/auth');

const router = express.Router();

// POST /api/auth/register - 用户注册
router.post('/register', async (req, res, next) => {
  try {
    const { username, password, nickname } = req.body;

    // Validation
    if (!username || !password) {
      return res.status(400).json({
        success: false,
        message: '用户名和密码不能为空'
      });
    }

    if (username.length < 4 || username.length > 20) {
      return res.status(400).json({
        success: false,
        message: '用户名长度必须是4-20位'
      });
    }

    if (password.length < 6) {
      return res.status(400).json({
        success: false,
        message: '密码长度不能少于6位'
      });
    }

    // Check if username exists
    const [existingUsers] = await db.query(
      'SELECT id FROM users WHERE username = ?',
      [username]
    );

    if (existingUsers.length > 0) {
      return res.status(409).json({
        success: false,
        message: '用户名已存在'
      });
    }

    // Hash password
    const passwordHash = bcrypt.hashSync(password, 10);

    // Create user
    const userId = uuidv4();
    const [result] = await db.query(
      'INSERT INTO users (id, username, password_hash, nickname) VALUES (?, ?, ?, ?)',
      [userId, username, passwordHash, nickname || username]
    );

    // Generate token
    const token = jwt.sign(
      { userId, username },
      process.env.JWT_SECRET,
      { expiresIn: process.env.JWT_EXPIRES_IN || '7d' }
    );

    res.status(201).json({
      success: true,
      message: '注册成功',
      data: {
        userId,
        username,
        nickname: nickname || username,
        token
      }
    });
  } catch (err) {
    next(err);
  }
});

// POST /api/auth/login - 用户登录
router.post('/login', async (req, res, next) => {
  try {
    const { username, password } = req.body;

    // Validation
    if (!username || !password) {
      return res.status(400).json({
        success: false,
        message: '用户名和密码不能为空'
      });
    }

    // Find user
    const [users] = await db.query(
      'SELECT id, username, password_hash, nickname FROM users WHERE username = ? AND is_deleted = 0',
      [username]
    );

    if (users.length === 0) {
      return res.status(401).json({
        success: false,
        message: '用户名或密码错误'
      });
    }

    const user = users[0];

    // Verify password
    const isValidPassword = bcrypt.compareSync(password, user.password_hash);
    if (!isValidPassword) {
      return res.status(401).json({
        success: false,
        message: '用户名或密码错误'
      });
    }

    // Generate token
    const token = jwt.sign(
      { userId: user.id, username: user.username },
      process.env.JWT_SECRET,
      { expiresIn: process.env.JWT_EXPIRES_IN || '7d' }
    );

    // Create session
    const sessionId = uuidv4();
    const expiresAt = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000); // 7 days
    await db.query(
      'INSERT INTO sessions (id, user_id, token, expires_at) VALUES (?, ?, ?, ?)',
      [sessionId, user.id, token, expiresAt]
    );

    res.json({
      success: true,
      message: '登录成功',
      data: {
        userId: user.id,
        username: user.username,
        nickname: user.nickname,
        token
      }
    });
  } catch (err) {
    next(err);
  }
});

// POST /api/auth/logout - 用户登出
router.post('/logout', authMiddleware, async (req, res, next) => {
  try {
    const token = req.headers.authorization.split(' ')[1];

    // Revoke session
    await db.query(
      'UPDATE sessions SET is_revoked = 1 WHERE token = ?',
      [token]
    );

    res.json({
      success: true,
      message: '登出成功'
    });
  } catch (err) {
    next(err);
  }
});

// GET /api/auth/me - 获取当前用户信息
router.get('/me', authMiddleware, async (req, res, next) => {
  try {
    const [users] = await db.query(
      'SELECT id, username, nickname, avatar_url, created_at FROM users WHERE id = ?',
      [req.user.userId]
    );

    if (users.length === 0) {
      return res.status(404).json({
        success: false,
        message: '用户不存在'
      });
    }

    res.json({
      success: true,
      data: users[0]
    });
  } catch (err) {
    next(err);
  }
});

module.exports = router;