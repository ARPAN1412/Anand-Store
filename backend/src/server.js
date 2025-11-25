const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const compression = require('compression');
const rateLimit = require('express-rate-limit');
require('dotenv').config();

const { connectDB } = require('./config/database');
const { seedDatabase } = require('./config/seed');

// Initialize Express
const app = express();

// Middleware
app.use(helmet());
app.use(cors({
  origin: [
    process.env.CLIENT_URL,
    process.env.ADMIN_URL,
    process.env.MOBILE_URL,
    'http://localhost:3002',
    'http://localhost:3003'
  ],
  credentials: true
}));
app.use(morgan('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(compression());

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100 // limit each IP to 100 requests per windowMs
});
app.use('/api/', limiter);

// Routes
app.use('/api/auth', require('./routes/auth'));
app.use('/api/menu', require('./routes/menu'));
app.use('/api/orders', require('./routes/orders'));
app.use('/api/reservations', require('./routes/reservations'));
app.use('/api/categories', require('./routes/categories'));

// Health check
app.get('/api/health', (req, res) => {
  res.json({
    success: true,
    message: 'Server is running',
    timestamp: new Date().toISOString()
  });
});

// Root route
app.get('/', (req, res) => {
  res.json({
    message: 'Restaurant API',
    version: '1.0.0',
    endpoints: {
      auth: '/api/auth',
      menu: '/api/menu',
      orders: '/api/orders',
      reservations: '/api/reservations',
      categories: '/api/categories'
    }
  });
});

// Error handler
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(err.status || 500).json({
    success: false,
    message: err.message || 'Server Error'
  });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: 'Route not found'
  });
});

const PORT = process.env.PORT || 5000;

// Start server
async function startServer() {
  try {
    // Connect to database first
    await connectDB();
    
    const server = app.listen(PORT, () => {
      console.log(`🚀 Server running on port ${PORT}`);
      console.log(`📱 Environment: ${process.env.NODE_ENV}`);
      
      // Seed database with sample data
      if (process.env.NODE_ENV === 'development') {
        setTimeout(async () => {
          try {
            await seedDatabase();
          } catch (error) {
            console.error('Seeding error:', error);
          }
        }, 2000);
      }
    });

    // Socket.IO for real-time updates
    const io = require('socket.io')(server, {
      cors: {
        origin: '*',
        credentials: true
      }
    });

    io.on('connection', (socket) => {
      console.log('👤 Client connected:', socket.id);
      
      socket.on('disconnect', () => {
        console.log('👤 Client disconnected:', socket.id);
      });
    });

    // Export io for use in controllers
    app.set('io', io);

    // Handle process termination
    process.on('SIGTERM', () => {
      console.log('SIGTERM received, closing server');
      server.close(() => {
        console.log('Server closed');
        process.exit(0);
      });
    });

    process.on('SIGINT', () => {
      console.log('SIGINT received, closing server');
      server.close(() => {
        console.log('Server closed');
        process.exit(0);
      });
    });
  } catch (error) {
    console.error('Failed to start server:', error);
    process.exit(1);
  }
}

// Only start server if not in Vercel serverless environment
if (require.main === module) {
  startServer().catch(error => {
    console.error('Unhandled error in startServer:', error);
    process.exit(1);
  });
}

module.exports = app;
