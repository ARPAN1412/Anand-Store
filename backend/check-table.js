const { sequelize } = require('./src/config/database');

(async () => {
  try {
    const result = await sequelize.query(
      "SELECT column_name FROM information_schema.columns WHERE table_name = 'menu_items'",
      { type: sequelize.QueryTypes.SELECT }
    );
    console.log('Columns in menu_items table:');
    console.log(JSON.stringify(result, null, 2));
  } catch (error) {
    console.error('Error:', error.message);
  } finally {
    process.exit(0);
  }
})();
