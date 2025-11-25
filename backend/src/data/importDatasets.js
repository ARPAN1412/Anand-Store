require('dotenv').config();
const { Sequelize } = require('sequelize');
const foodDataset = require('./foodDataset');
const groceryDataset = require('./groceryDataset');
const clothesDataset = require('./clothesDataset');

/**
 * Import all datasets into the database
 * This script will:
 * 1. Create categories if they don't exist
 * 2. Import all food items
 * 3. Import all grocery items
 * 4. Import all clothes items
 */

// Database connection
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

async function importDatasets() {
  try {
    console.log('🚀 Starting dataset import...\n');

    // Connect to database
    await sequelize.authenticate();
    console.log('✅ Database connected\n');

    // Define all categories
    const categories = [
      // Food categories
      { name: 'Appetizers', description: 'Starters and appetizers', type: 'food' },
      { name: 'Main Course', description: 'Main dishes and entrees', type: 'food' },
      { name: 'Breads', description: 'Indian breads', type: 'food' },
      { name: 'Desserts', description: 'Sweet treats and desserts', type: 'food' },
      { name: 'Beverages', description: 'Drinks and beverages', type: 'food' },
      
      // Grocery categories
      { name: 'Dairy', description: 'Milk, cheese, and dairy products', type: 'grocery' },
      { name: 'Fruits & Vegetables', description: 'Fresh produce', type: 'grocery' },
      { name: 'Staples', description: 'Rice, flour, pulses, and staples', type: 'grocery' },
      { name: 'Cooking Essentials', description: 'Oil, spices, and cooking needs', type: 'grocery' },
      { name: 'Snacks', description: 'Packaged snacks and munchies', type: 'grocery' },
      
      // Clothes categories
      { name: "Men's Wear", description: 'Clothing for men', type: 'clothes' },
      { name: "Women's Wear", description: 'Clothing for women', type: 'clothes' },
      { name: "Kids Wear", description: 'Clothing for children', type: 'clothes' },
      { name: 'Accessories', description: 'Fashion accessories', type: 'clothes' }
    ];

    // Create categories
    console.log('📂 Creating categories...');
    const categoryMap = {};
    
    for (const cat of categories) {
      // Check if category exists
      const [existing] = await sequelize.query(
        `SELECT id FROM categories WHERE name = $1`,
        { bind: [cat.name] }
      );
      
      if (existing.length > 0) {
        categoryMap[cat.name] = existing[0].id;
        console.log(`  ⏭️  ${cat.name} (${cat.type}) - already exists`);
      } else {
        // Create new category
        const [result] = await sequelize.query(
          `INSERT INTO categories (id, name, description, is_active, created_at, updated_at)
           VALUES (gen_random_uuid(), $1, $2, true, NOW(), NOW())
           RETURNING id`,
          {
            bind: [cat.name, cat.description]
          }
        );
        
        if (result.length > 0) {
          categoryMap[cat.name] = result[0].id;
          console.log(`  ✓ ${cat.name} (${cat.type}) - created`);
        }
      }
    }

    // Helper function to import items
    async function importItems(dataset, type) {
      console.log(`\n🍽️  Importing ${type} items...`);
      let count = 0;

      for (const item of dataset) {
        const categoryId = categoryMap[item.category];
        
        if (!categoryId) {
          console.log(`  ⚠️  Category not found: ${item.category}`);
          continue;
        }

        // Check if item already exists
        const [existing] = await sequelize.query(
          `SELECT id FROM menu_items WHERE name = $1`,
          { bind: [item.name] }
        );

        if (existing.length > 0) {
          console.log(`  ⏭️  Skipping (exists): ${item.name}`);
          continue;
        }

        // Insert item
        try {
          // Convert tags array to PostgreSQL array format
          const tagsArray = item.tags && item.tags.length > 0 
            ? `{${item.tags.map(t => `"${t}"`).join(',')}}` 
            : '{}';
          
          await sequelize.query(
            `INSERT INTO menu_items (
              id, name, description, price, category_id, 
              is_vegetarian, is_available, preparation_time,
              tags, image,
              created_at, updated_at
            ) VALUES (
              gen_random_uuid(), $1, $2, $3, $4,
              $5, true, $6,
              $7::text[], $8,
              NOW(), NOW()
            )`,
            {
              bind: [
                item.name,
                item.description,
                item.price,
                categoryId,
                item.isVegetarian || false,
                item.preparationTime || null,
                tagsArray,
                item.image || null
              ]
            }
          );
          count++;
          console.log(`  ✓ ${item.name} - ₹${item.price}`);
        } catch (error) {
          console.log(`  ❌ Error inserting ${item.name}:`, error.message);
        }
      }

      console.log(`  ✅ Imported ${count} ${type} items`);
      return count;
    }

    // Import all datasets
    const foodCount = await importItems(foodDataset, 'food');
    const groceryCount = await importItems(groceryDataset, 'grocery');
    const clothesCount = await importItems(clothesDataset, 'clothes');

    // Summary
    console.log('\n' + '='.repeat(50));
    console.log('📊 IMPORT SUMMARY');
    console.log('='.repeat(50));
    console.log(`Categories created: ${categories.length}`);
    console.log(`Food items imported: ${foodCount}`);
    console.log(`Grocery items imported: ${groceryCount}`);
    console.log(`Clothes items imported: ${clothesCount}`);
    console.log(`Total items: ${foodCount + groceryCount + clothesCount}`);
    console.log('='.repeat(50));
    console.log('✨ Dataset import completed successfully!\n');

    await sequelize.close();
    process.exit(0);
  } catch (error) {
    console.error('❌ Error importing datasets:', error);
    await sequelize.close();
    process.exit(1);
  }
}

// Run the import
importDatasets();
