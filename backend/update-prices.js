require('dotenv').config();
const { Sequelize } = require('sequelize');

const sequelize = new Sequelize(process.env.DB_NAME, process.env.DB_USER, process.env.DB_PASSWORD, {
  host: process.env.DB_HOST,
  dialect: 'postgres',
  logging: false
});

(async () => {
  try {
    // Update food items
    await sequelize.query(`
      UPDATE menu_items SET price = CASE name 
        WHEN 'Wagyu Beef Burger' THEN '899'
        WHEN 'Pepperoni Pizza' THEN '499'
        WHEN 'Grilled Salmon' THEN '799'
        WHEN 'Caesar Salad' THEN '299'
        WHEN 'Margherita Pizza' THEN '399'
        WHEN 'Chicken Wings' THEN '349'
        WHEN 'BBQ Ribs' THEN '699'
        WHEN 'Greek Salad' THEN '249'
        WHEN 'Chocolate Cake' THEN '199'
        WHEN 'Tiramisu' THEN '249'
        WHEN 'Fresh Lemonade' THEN '99'
        WHEN 'Iced Coffee' THEN '149'
        WHEN 'Fresh Milk' THEN '60'
        WHEN 'Brown Bread' THEN '40'
        WHEN 'Fresh Eggs' THEN '80'
        WHEN 'Organic Apples' THEN '120'
        WHEN 'Basmati Rice' THEN '450'
        WHEN 'Olive Oil' THEN '650'
        WHEN 'Cotton T-Shirt' THEN '499'
        WHEN 'Denim Jeans' THEN '1499'
        WHEN 'Summer Dress' THEN '999'
        WHEN 'Leather Jacket' THEN '4999'
        WHEN 'Sports Sneakers' THEN '2499'
        WHEN 'Winter Sweater' THEN '1299'
        ELSE price 
      END
    `);
    
    console.log('✅ All prices updated to INR successfully!');
    console.log('Food items: ₹199-₹899');
    console.log('Grocery items: ₹40-₹650');
    console.log('Clothing items: ₹499-₹4999');
    
    process.exit(0);
  } catch (err) {
    console.error('❌ Error:', err.message);
    process.exit(1);
  }
})();
