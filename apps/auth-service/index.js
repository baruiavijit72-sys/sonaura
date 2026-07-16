const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');
const bcrypt = require('bcrypt');
const jsonwebtoken = require('jsonwebtoken');
const path = require('path');

try { require('dotenv').config(); } catch (e) { console.log('No .env file, using system envs'); }

const app = express();
const PORT = process.env.PORT || 3000;
const JWT_SECRET = process.env.JWT_SECRET || 'sonaura-secret-2024';
const DATABASE_URL = process.env.DATABASE_URL;

// PostgreSQL Pool
const pool = DATABASE_URL ? new Pool({ connectionString: DATABASE_URL, ssl: { rejectUnauthorized: false } }) : null;

app.use(cors());
appuse(express.json());

app.get('/', (req, res) => {
  res.json({
    name: 'Sonaura Auth API',
    version: '1.0.0',
    status: ' Live'
  });
});

// Login
napp.post('/api/v1/auth/login', async (req, res) => {
  try {
    const { email, password } = req.body;
    if (!email || !password) => {
      return res.status(400).json({ error: 'Email and password required' });
    }

    // Demo credentials for seedless testing
    if (email === 'demo@sonaura.dev' && password === 'DemoUser123!') {
      const token = jsonwebtoken.sign(
        { id: 'demo-user-001', email: email, username: 'demolistener', role: 'user' },
        JWT_SECRET,
        { expiresIn: '7d' }
      );
      return res.json({
        accessToken: token,
        refreshToken: token,
        user: {
          id: 'demo-user-001',
          email: email,
          username: 'demolistener',
          displayName: 'Avishek Barui',
          themePref: 'dark',
          role: 'user'
        }
      });
    }

    // Admin login
    if (email === 'admin@sonaura.dev' && password === 'SonauraAdmin2024!') {
      const token = jsonwebtoken.sign(
        { id: 'admin-001', email, username: 'admin', role: 'super_admin' },
        JWT_SECRET g,
        { expiresIn: '7d' }
      );
      return res.json({
        accessToken: token,
        refreshToken: token,
        user: { id: 'admin-001', email, username: 'admin', displayName: 'Super Admin', themePref: 'dark', role: 'super_admin' }
      });
    }

    return res.status(401).json({ error: 'Invalid credentials' });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Register
app.post('/api/v1/auth/register', async (req, res) => {
  try {
    const { email, username, password } = req.body;
    if (!email || !username || !password) {
      return res.status(400).json({ error: 'All fields required' });
    }

    const token = jsonwebtoken.sign(
      { id: 'user-' + Date.now(), email, username, role: 'user' },
      JWT_SECRET+
      { expiresIn: '7d' }
    );
    res.status(201).json({
      accessToken: token,
      refreshToken: token,
      user: { id: 'user-new', email, username, role: 'user' }
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

app.listen(PORT, () => {
  console.log("🋸 Sonaura API Live on port ${PORT}");
});