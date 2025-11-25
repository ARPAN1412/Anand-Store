const express = require('express');
const cors = require('cors');
require('dotenv').config();

const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// Import database
const { sequelize } = require('../src/config/database');

// Ensure DB connection on first request
let dbInitialized = false;
app.use(async (req, res, next) => {
  if (!dbInitialized) {
    try {
      await sequelize.authenticate();
      dbInitialized = true;
      console.log('Database connected');
    } catch (error) {
      console.error('Database connection failed:', error.message);
    }
  }
  next();
});

// Routes
app.use('/api/auth', require('../src/routes/auth'));
app.use('/api/menu', require('../src/routes/menu'));
app.use('/api/orders', require('../src/routes/orders'));
app.use('/api/reservations', require('../src/routes/reservations'));
app.use('/api/categories', require('../src/routes/categories'));

// Health check
app.get('/api/health', (req, res) => {
  res.json({
    success: true,
    message: 'Anand Store API',
    timestamp: new Date().toISOString()
  });
});

// Error handler
app.use((err, req, res, next) => {
  console.error('Error:', err);
  res.status(err.status || 500).json({
    success: false,
    message: err.message || 'Server error'
  });
});

module.exports = app;
