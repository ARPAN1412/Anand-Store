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

async function verifyImport() {
  try {
    await sequelize.authenticate();
    
    const [categories] = await sequelize.query(`
      SELECT c.name as category, COUNT(m.id) as count 
      FROM categories c 
      LEFT JOIN menu_items m ON c.id = m.category_id 
      GROUP BY c.name 
      ORDER BY c.name
    `);
    
    const [total] = await sequelize.query(`SELECT COUNT(*) as total FROM menu_items`);
    
    console.log('\n' + '='.repeat(60));
    console.log('📊 DATASET VERIFICATION');
    console.log('='.repeat(60));
    console.log('\n📦 Items by Category:\n');
    
    categories.forEach(row => {
      console.log(`  ${row.category.padEnd(30)} : ${row.count} items`);
    });
    
    console.log('\n' + '='.repeat(60));
    console.log(`TOTAL ITEMS IN DATABASE: ${total[0].total}`);
    console.log('='.repeat(60) + '\n');
    
    await sequelize.close();
    process.exit(0);
  } catch (error) {
    console.error('Error:', error.message);
    process.exit(1);
  }
}

verifyImport();
