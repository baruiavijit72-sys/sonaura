const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');
const bcrypt = require('bcrypt');
const jsonwebtoken = require('jsonwebtoken');

try { require('dotenv').config(); } catch (e) { console.log('No .env file, using system envs'); }

const app = express();
const PORT = process.env.PORT || 3000;
const JWT_SECRET = process.env.JWT_SECRET || 'sonaura-secret-2024';
const DATABASE_URL = process.env.DATABASE_URL;

const pool = DATABASE_URL ? new Pool({ connectionString: DATABASE_URL, ssl: { rejectUnauthorized: false } }) : null;

app.use(cors());
app.use(express.json());

// Health check
app.get('/', function(req, res) {
  res.json({ name: 'Sonaura Auth API', version: '1.0.0', status: 'live' });
});

// Login
app.post('/api/v1/auth/login', function(req, res) {
  try {
    const email = req.body.email;
    const password = req.body.password;

    if (!email || !password) {
      return res.status(400).json({ error: 'Email and password required' });
    }

    // Demo user login
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
        { id: 'admin-001', email: email, username: 'admin', role: 'super_admin' },
        JWT_SECRET,
        { expiresIn: '7d' }
      );
      return res.json({
        accessToken: token,
        refreshToken: token,
        user: {
          id: 'admin-001',
          email: email,
          username: 'admin',
          displayName: 'Super Admin',
          themePref: 'dark',
          role: 'super_admin'
        }
      });
    }

    return res.status(401).json({ error: 'Invalid credentials' });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Register
app.post('/api/v1/auth/register', function(req, res) {
  try {
    const email = req.body.email;
    const username = req.body.username;
    const password = req.body.password;

    if (!email || !username || !password) {
      return res.status(400).json({ error: 'All fields required' });
    }

    const token = jsonwebtoken.sign(
      { id: 'user-' + Date.now(), email: email, username: username, role: 'user' },
      JWT_SECRET,
      { expiresIn: '7d' }
    );

    res.status(201).json({
      accessToken: token,
      refreshToken: token,
      user: { id: 'user-new', email: email, username: username, role: 'user' }
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Tracks endpoint (seed data)
app.get('/api/v1/tracks', function(req, res) {
  const tracks = [
    { id: 't001', title: 'City Lights at 3 AM', artist: 'Quarter Notes', album: 'Midnight Reverie', genre: 'Rock', duration: 237 },
    { id: 't002', title: 'Ocean of Stars', artist: 'Luna Wave', album: 'Ethereal Tides', genre: 'Ambient', duration: 258 },
    { id: 't003', title: 'Smoke and Mirrors', artist: 'The Midnight Quartet', album: 'Jazz Noir', genre: 'Jazz', duration: 312 },
    { id: 't004', title: 'Highway 2089', artist: 'Neon Pulse', album: 'Neon Horizons', genre: 'Synthwave', duration: 278 },
    { id: 't005', title: 'Wanderers Anthem', artist: 'Quarter Notes', album: 'Midnight Reverie', genre: 'Indie', duration: 264 },
    { id: 't006', title: 'Echoes in the Hall', artist: 'Quarter Notes', album: 'Midnight Reverie', genre: 'Rock', duration: 226 },
    { id: 't007', title: 'Pulse of the Nebula', artist: 'Luna Wave', album: 'Ethereal Tides', genre: 'Electronic', duration: 245 },
    { id: 't008', title: 'Last Light on Kepler-22b', artist: 'Luna Wave', album: 'Ethereal Tides', genre: 'Ambient', duration: 251 },
    { id: 't009', title: 'The Bassists Lament', artist: 'The Midnight Quartet', album: 'Jazz Noir', genre: 'Jazz', duration: 234 },
    { id: 't010', title: 'Data Stream', artist: 'Neon Pulse', album: 'Neon Horizons', genre: 'Electronic', duration: 256 },
    { id: 't011', title: 'Digital Sunset', artist: 'Neon Pulse', album: 'Neon Horizons', genre: 'Synthwave', duration: 223 },
    { id: 't012', title: 'Velvet Underground Station', artist: 'The Midnight Quartet', album: 'Jazz Noir', genre: 'Classical', duration: 210 }
  ];
  res.json({ data: tracks, total: tracks.length });
});

app.listen(PORT, function() {
  console.log('🇸 Sonaura API Live on port ' + PORT);
});