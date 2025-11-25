const { Sequelize } = require('sequelize');
require('dotenv').config();

// Create Sequelize instance - supports both DATABASE_URL (Railway) and individual vars (local)
let sequelize;

if (process.env.DATABASE_URL) {
  // Railway or other cloud provider with DATABASE_URL
  sequelize = new Sequelize(process.env.DATABASE_URL, {
    dialect: 'postgres',
    dialectOptions: {
      ssl: {
        require: true,
        rejectUnauthorized: false
      }
    },
    logging: process.env.NODE_ENV === 'development' ? console.log : false,
    pool: {
      max: 5,
      min: 0,
      acquire: 30000,
      idle: 10000
    },
    define: {
      timestamps: true,
      underscored: true,
      createdAt: 'created_at',
      updatedAt: 'updated_at'
    }
  });
} else {
  // Local development with individual environment variables
  sequelize = new Sequelize(
    process.env.DB_NAME,
    process.env.DB_USER,
    process.env.DB_PASSWORD,
    {
      host: process.env.DB_HOST,
      port: process.env.DB_PORT,
      dialect: 'postgres',
      logging: process.env.NODE_ENV === 'development' ? console.log : false,
      pool: {
        max: 5,
        min: 0,
        acquire: 30000,
        idle: 10000
      },
      define: {
        timestamps: true,
        underscored: true,
        createdAt: 'created_at',
        updatedAt: 'updated_at'
      }
    }
  );
}

const connectDB = async () => {
  try {
    // Connect to the database
    await sequelize.authenticate();
    console.log('✅ PostgreSQL Database connected successfully');
    
    // Sync database (creates tables if they don't exist)
    await sequelize.sync({ alter: true });
    console.log('📊 Database synced');
  } catch (error) {
    console.error('❌ Database connection error:', error.message);
    console.log('💡 Please check your database configuration');
    if (process.env.DATABASE_URL) {
      console.log('   Using DATABASE_URL from environment');
    } else {
      console.log('   DB_USER:', process.env.DB_USER);
      console.log('   DB_HOST:', process.env.DB_HOST);
      console.log('   DB_PORT:', process.env.DB_PORT);
    }
    process.exit(1);
  }
};

module.exports = { sequelize, connectDB };
