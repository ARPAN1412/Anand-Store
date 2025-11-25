require('dotenv').config();
const { Sequelize } = require('sequelize');

const sequelize = new Sequelize(
  process.env.DB_NAME || 'restaurant_db',
  process.env.DB_USER || 'postgres',
  process.env.DB_PASSWORD || '1234',
  {
    host: process.env.DB_HOST || 'localhost',
    port: process.env.DB_PORT || 5432,
    dialect: 'postgres',
    logging: false
  }
);

async function checkSchema() {
  try {
    await sequelize.authenticate();
    const [results] = await sequelize.query(
      `SELECT column_name, data_type 
       FROM information_schema.columns 
       WHERE table_name = 'menu_items' 
       ORDER BY ordinal_position`
    );
    
    console.log('\n📋 Menu Items Table Columns:');
    console.log('='.repeat(50));
    results.forEach(col => {
      console.log(`- ${col.column_name} (${col.data_type})`);
    });
    console.log('='.repeat(50) + '\n');
    
    await sequelize.close();
    process.exit(0);
  } catch (error) {
    console.error('Error:', error.message);
    process.exit(1);
  }
}

checkSchema();
