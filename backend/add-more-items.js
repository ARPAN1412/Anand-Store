require('dotenv').config();
const { Sequelize } = require('sequelize');

// Database connection - supports both DATABASE_URL and individual vars
let sequelize;
if (process.env.DATABASE_URL) {
  sequelize = new Sequelize(process.env.DATABASE_URL, {
    dialect: 'postgres',
    dialectOptions: {
      ssl: {
        require: true,
        rejectUnauthorized: false
      }
    },
    logging: false
  });
} else {
  sequelize = new Sequelize(
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
}

// Additional items for Fresh Foods (Fruits & Vegetables)
const freshFoodsItems = [
  {
    name: "Fresh Spinach (500g)",
    description: "Fresh green spinach leaves, rich in iron and nutrients",
    price: 30,
    category: "Fruits & Vegetables",
    isVegetarian: true,
    preparationTime: 0,
    tags: ["fresh", "organic", "vegetables", "healthy"],
    image: "https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=500"
  },
  {
    name: "Fresh Carrots (500g)",
    description: "Crunchy orange carrots, perfect for salads and cooking",
    price: 35,
    category: "Fruits & Vegetables",
    isVegetarian: true,
    preparationTime: 0,
    tags: ["fresh", "vegetables", "healthy"],
    image: "https://images.unsplash.com/photo-1598170845058-32b9d6a5da37?w=500"
  },
  {
    name: "Fresh Cauliflower (1 piece)",
    description: "Fresh white cauliflower, ideal for curries",
    price: 45,
    category: "Fruits & Vegetables",
    isVegetarian: true,
    preparationTime: 0,
    tags: ["fresh", "vegetables"],
    image: "https://images.unsplash.com/photo-1568584711271-6c7c4f050b8d?w=500"
  },
  {
    name: "Green Capsicum (250g)",
    description: "Fresh green bell peppers for cooking",
    price: 40,
    category: "Fruits & Vegetables",
    isVegetarian: true,
    preparationTime: 0,
    tags: ["fresh", "vegetables"],
    image: "https://images.unsplash.com/photo-1563565375-f3fdfdbefa83?w=500"
  },
  {
    name: "Fresh Ginger (250g)",
    description: "Fresh ginger root, essential for Indian cooking",
    price: 30,
    category: "Fruits & Vegetables",
    isVegetarian: true,
    preparationTime: 0,
    tags: ["fresh", "vegetables", "spices"],
    image: "https://images.unsplash.com/photo-1576533439824-8c7c5d66f20f?w=500"
  },
  {
    name: "Fresh Garlic (250g)",
    description: "Fresh garlic bulbs for flavor and health",
    price: 50,
    category: "Fruits & Vegetables",
    isVegetarian: true,
    preparationTime: 0,
    tags: ["fresh", "vegetables", "spices"],
    image: "https://images.unsplash.com/photo-1588180699889-2d8e0b08eedc?w=500"
  },
  {
    name: "Fresh Lemons (250g)",
    description: "Juicy lemons for cooking and drinks",
    price: 25,
    category: "Fruits & Vegetables",
    isVegetarian: true,
    preparationTime: 0,
    tags: ["fresh", "fruits", "citrus"],
    image: "https://images.unsplash.com/photo-1590502593747-42a996133562?w=500"
  },
  {
    name: "Green Chilies (100g)",
    description: "Fresh green chilies for spicy dishes",
    price: 20,
    category: "Fruits & Vegetables",
    isVegetarian: true,
    preparationTime: 0,
    tags: ["fresh", "vegetables", "spicy"],
    image: "https://images.unsplash.com/photo-1583663848850-46af132dc08e?w=500"
  },
  {
    name: "Fresh Coriander (100g)",
    description: "Fresh coriander leaves for garnishing",
    price: 15,
    category: "Fruits & Vegetables",
    isVegetarian: true,
    preparationTime: 0,
    tags: ["fresh", "herbs", "garnish"],
    image: "https://images.unsplash.com/photo-1607984838763-9cc5e29f6db7?w=500"
  },
  {
    name: "Fresh Mint (50g)",
    description: "Fresh mint leaves for flavor and drinks",
    price: 15,
    category: "Fruits & Vegetables",
    isVegetarian: true,
    preparationTime: 0,
    tags: ["fresh", "herbs", "aromatic"],
    image: "https://images.unsplash.com/photo-1628556270448-4d4e4148e1b1?w=500"
  },
  {
    name: "Fresh Cucumber (500g)",
    description: "Cool and crunchy cucumbers for salads",
    price: 30,
    category: "Fruits & Vegetables",
    isVegetarian: true,
    preparationTime: 0,
    tags: ["fresh", "vegetables", "salad"],
    image: "https://images.unsplash.com/photo-1604977042946-1eecc30f269e?w=500"
  },
  {
    name: "Fresh Peas (500g)",
    description: "Sweet green peas, fresh and tender",
    price: 60,
    category: "Fruits & Vegetables",
    isVegetarian: true,
    preparationTime: 0,
    tags: ["fresh", "vegetables", "protein"],
    image: "https://images.unsplash.com/photo-1587735243615-c03f25aaff93?w=500"
  },
  {
    name: "Grapes (500g)",
    description: "Sweet and juicy green/black grapes",
    price: 80,
    category: "Fruits & Vegetables",
    isVegetarian: true,
    preparationTime: 0,
    tags: ["fresh", "fruits", "sweet"],
    image: "https://images.unsplash.com/photo-1599819177661-d9a2e18cd5e5?w=500"
  },
  {
    name: "Watermelon (1 piece)",
    description: "Fresh juicy watermelon, perfect for summer",
    price: 120,
    category: "Fruits & Vegetables",
    isVegetarian: true,
    preparationTime: 0,
    tags: ["fresh", "fruits", "summer"],
    image: "https://images.unsplash.com/photo-1587049352846-4a222e784760?w=500"
  },
  {
    name: "Mangoes (1kg)",
    description: "Sweet Alphonso mangoes, king of fruits",
    price: 200,
    category: "Fruits & Vegetables",
    isVegetarian: true,
    preparationTime: 0,
    tags: ["fresh", "fruits", "premium", "seasonal"],
    image: "https://images.unsplash.com/photo-1553279768-865429fa0078?w=500"
  }
];

// Additional items for Groceries & Essentials (Staples, Cooking Essentials, Snacks)
const groceriesItems = [
  // More Staples
  {
    name: "Moong Dal (1kg)",
    description: "Split green gram, protein-rich and easy to digest",
    price: 130,
    category: "Staples",
    isVegetarian: true,
    preparationTime: 0,
    tags: ["staple", "pulses", "protein", "healthy"],
    image: "https://images.unsplash.com/photo-1599909533835-e5a0baef9a94?w=500"
  },
  {
    name: "Urad Dal (1kg)",
    description: "Black gram lentils for dal makhani",
    price: 150,
    category: "Staples",
    isVegetarian: true,
    preparationTime: 0,
    tags: ["staple", "pulses", "protein"],
    image: "https://images.unsplash.com/photo-1599909533835-e5a0baef9a94?w=500"
  },
  {
    name: "Rajma (1kg)",
    description: "Red kidney beans for rajma curry",
    price: 160,
    category: "Staples",
    isVegetarian: true,
    preparationTime: 0,
    tags: ["staple", "pulses", "protein"],
    image: "https://images.unsplash.com/photo-1599909533835-e5a0baef9a94?w=500"
  },
  {
    name: "Chickpeas (1kg)",
    description: "Whole chickpeas for chole and salads",
    price: 100,
    category: "Staples",
    isVegetarian: true,
    preparationTime: 0,
    tags: ["staple", "pulses", "protein"],
    image: "https://images.unsplash.com/photo-1599909533835-e5a0baef9a94?w=500"
  },
  {
    name: "Poha (500g)",
    description: "Flattened rice for breakfast dishes",
    price: 60,
    category: "Staples",
    isVegetarian: true,
    preparationTime: 0,
    tags: ["staple", "breakfast", "rice"],
    image: "https://images.unsplash.com/photo-1586201375761-83865001e31c?w=500"
  },
  {
    name: "Sooji/Rava (1kg)",
    description: "Semolina for upma and halwa",
    price: 70,
    category: "Staples",
    isVegetarian: true,
    preparationTime: 0,
    tags: ["staple", "breakfast"],
    image: "https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=500"
  },
  
  // More Cooking Essentials
  {
    name: "Turmeric Powder (100g)",
    description: "Pure turmeric powder for color and health",
    price: 50,
    category: "Cooking Essentials",
    isVegetarian: true,
    preparationTime: 0,
    tags: ["spices", "cooking", "healthy"],
    image: "https://images.unsplash.com/photo-1615485500834-bc10199bc6dd?w=500"
  },
  {
    name: "Coriander Powder (100g)",
    description: "Aromatic coriander powder for curries",
    price: 55,
    category: "Cooking Essentials",
    isVegetarian: true,
    preparationTime: 0,
    tags: ["spices", "cooking"],
    image: "https://images.unsplash.com/photo-1599639832472-a8f75f4e921c?w=500"
  },
  {
    name: "Cumin Seeds (100g)",
    description: "Whole cumin seeds for tempering",
    price: 60,
    category: "Cooking Essentials",
    isVegetarian: true,
    preparationTime: 0,
    tags: ["spices", "cooking"],
    image: "https://images.unsplash.com/photo-1599639832472-a8f75f4e921c?w=500"
  },
  {
    name: "Garam Masala (50g)",
    description: "Traditional blend of Indian spices",
    price: 80,
    category: "Cooking Essentials",
    isVegetarian: true,
    preparationTime: 0,
    tags: ["spices", "cooking", "blend"],
    image: "https://images.unsplash.com/photo-1599639832472-a8f75f4e921c?w=500"
  },
  {
    name: "Mustard Oil (1L)",
    description: "Pure mustard oil for authentic flavors",
    price: 200,
    category: "Cooking Essentials",
    isVegetarian: true,
    preparationTime: 0,
    tags: ["cooking", "oil", "traditional"],
    image: "https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=500"
  },
  {
    name: "Ghee (500ml)",
    description: "Pure clarified butter for cooking and sweets",
    price: 450,
    category: "Cooking Essentials",
    isVegetarian: true,
    preparationTime: 0,
    tags: ["cooking", "ghee", "premium"],
    image: "https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=500"
  },
  {
    name: "Tomato Ketchup (500g)",
    description: "Tangy tomato ketchup for snacks",
    price: 120,
    category: "Cooking Essentials",
    isVegetarian: true,
    preparationTime: 0,
    tags: ["sauce", "condiment"],
    image: "https://images.unsplash.com/photo-1530712413451-bb8e0e575e10?w=500"
  },
  
  // More Snacks
  {
    name: "Potato Chips (200g)",
    description: "Crispy potato chips in various flavors",
    price: 60,
    category: "Snacks",
    isVegetarian: true,
    preparationTime: 0,
    tags: ["snacks", "crispy", "ready-to-eat"],
    image: "https://images.unsplash.com/photo-1566478989037-eec170784d0b?w=500"
  },
  {
    name: "Instant Noodles (Pack of 5)",
    description: "Quick and tasty instant noodles",
    price: 85,
    category: "Snacks",
    isVegetarian: true,
    preparationTime: 2,
    tags: ["snacks", "instant", "quick meal"],
    image: "https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=500"
  },
  {
    name: "Bhujia (400g)",
    description: "Spicy gram flour noodles snack",
    price: 100,
    category: "Snacks",
    isVegetarian: true,
    preparationTime: 0,
    tags: ["snacks", "indian", "spicy"],
    image: "https://images.unsplash.com/photo-1599490659213-e2b9527bd087?w=500"
  },
  {
    name: "Mathri (300g)",
    description: "Crispy traditional Indian savory biscuits",
    price: 90,
    category: "Snacks",
    isVegetarian: true,
    preparationTime: 0,
    tags: ["snacks", "traditional", "crispy"],
    image: "https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=500"
  },
  {
    name: "Roasted Peanuts (250g)",
    description: "Crunchy roasted peanuts with salt",
    price: 70,
    category: "Snacks",
    isVegetarian: true,
    preparationTime: 0,
    tags: ["snacks", "healthy", "protein"],
    image: "https://images.unsplash.com/photo-1615485290382-441e4d049cb5?w=500"
  },
  {
    name: "Cashew Nuts (250g)",
    description: "Premium quality cashew nuts",
    price: 250,
    category: "Snacks",
    isVegetarian: true,
    preparationTime: 0,
    tags: ["snacks", "dry fruits", "premium"],
    image: "https://images.unsplash.com/photo-1585478259715-876acc5be8eb?w=500"
  },
  {
    name: "Almonds (250g)",
    description: "Healthy almonds rich in nutrients",
    price: 280,
    category: "Snacks",
    isVegetarian: true,
    preparationTime: 0,
    tags: ["snacks", "dry fruits", "healthy"],
    image: "https://images.unsplash.com/photo-1508736793122-f516e3ba5569?w=500"
  }
];

// Additional items for Sweets & Desserts
const sweetsItems = [
  {
    name: "Rasgulla (4 pieces)",
    description: "Soft spongy cottage cheese balls in sugar syrup",
    price: 89,
    category: "Desserts",
    isVegetarian: true,
    preparationTime: 15,
    tags: ["indian", "sweet", "popular"],
    image: "https://images.unsplash.com/photo-1619441550782-c6e0e2ede1dd?w=500"
  },
  {
    name: "Jalebi (250g)",
    description: "Crispy sweet pretzel-shaped dessert in sugar syrup",
    price: 120,
    category: "Desserts",
    isVegetarian: true,
    preparationTime: 15,
    tags: ["indian", "sweet", "crispy"],
    image: "https://images.unsplash.com/photo-1631452180519-c014fe946bc7?w=500"
  },
  {
    name: "Kulfi (2 pieces)",
    description: "Traditional Indian ice cream on stick",
    price: 80,
    category: "Desserts",
    isVegetarian: true,
    preparationTime: 0,
    tags: ["indian", "frozen", "cold dessert"],
    image: "https://images.unsplash.com/photo-1582716401301-b2407dc7563d?w=500"
  },
  {
    name: "Ice Cream Tub (500ml)",
    description: "Creamy vanilla/chocolate ice cream tub",
    price: 180,
    category: "Desserts",
    isVegetarian: true,
    preparationTime: 0,
    tags: ["frozen", "cold dessert", "family pack"],
    image: "https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=500"
  },
  {
    name: "Gajar Halwa",
    description: "Sweet carrot pudding with nuts and ghee",
    price: 150,
    category: "Desserts",
    isVegetarian: true,
    preparationTime: 20,
    tags: ["indian", "sweet", "traditional"],
    image: "https://images.unsplash.com/photo-1606471191009-7c0e4e91e21f?w=500"
  },
  {
    name: "Kheer (Bowl)",
    description: "Creamy rice pudding with cardamom and nuts",
    price: 100,
    category: "Desserts",
    isVegetarian: true,
    preparationTime: 15,
    tags: ["indian", "sweet", "traditional"],
    image: "https://images.unsplash.com/photo-1610988671950-c9617f2bbecd?w=500"
  },
  {
    name: "Kaju Katli (250g)",
    description: "Diamond-shaped cashew fudge sweet",
    price: 350,
    category: "Desserts",
    isVegetarian: true,
    preparationTime: 0,
    tags: ["indian", "sweet", "premium", "dry fruit"],
    image: "https://images.unsplash.com/photo-1631452180519-c014fe946bc7?w=500"
  },
  {
    name: "Ladoo (6 pieces)",
    description: "Traditional Indian sweet balls made with gram flour",
    price: 120,
    category: "Desserts",
    isVegetarian: true,
    preparationTime: 0,
    tags: ["indian", "sweet", "traditional"],
    image: "https://images.unsplash.com/photo-1631452180519-c014fe946bc7?w=500"
  },
  {
    name: "Barfi Mix (250g)",
    description: "Assorted milk-based sweet squares",
    price: 180,
    category: "Desserts",
    isVegetarian: true,
    preparationTime: 0,
    tags: ["indian", "sweet", "variety"],
    image: "https://images.unsplash.com/photo-1631452180519-c014fe946bc7?w=500"
  },
  {
    name: "Peda (6 pieces)",
    description: "Soft milk-based sweet rounds",
    price: 100,
    category: "Desserts",
    isVegetarian: true,
    preparationTime: 0,
    tags: ["indian", "sweet", "traditional"],
    image: "https://images.unsplash.com/photo-1631452180519-c014fe946bc7?w=500"
  },
  {
    name: "Pastry Slice",
    description: "Fresh cream pastry slice with fruit topping",
    price: 120,
    category: "Desserts",
    isVegetarian: true,
    preparationTime: 0,
    tags: ["western", "cake", "cream"],
    image: "https://images.unsplash.com/photo-1464349095431-e9a21285b5f3?w=500"
  },
  {
    name: "Donut (2 pieces)",
    description: "Soft glazed donuts with sprinkles",
    price: 90,
    category: "Desserts",
    isVegetarian: true,
    preparationTime: 0,
    tags: ["western", "sweet", "glazed"],
    image: "https://images.unsplash.com/photo-1551024601-bec78aea704b?w=500"
  }
];

async function addMoreItems() {
  try {
    console.log('🚀 Starting to add more items...\n');

    await sequelize.authenticate();
    console.log('✅ Database connected\n');

    // Get category IDs
    const [categories] = await sequelize.query(
      `SELECT id, name FROM categories`
    );

    const categoryMap = {};
    categories.forEach(cat => {
      categoryMap[cat.name] = cat.id;
    });

    // Helper function to import items
    async function importItems(dataset, typeName) {
      console.log(`\n📦 Adding ${typeName} items...`);
      let added = 0;
      let skipped = 0;

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
          skipped++;
          continue;
        }

        // Insert item
        try {
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
          added++;
          console.log(`  ✓ ${item.name} - ₹${item.price}`);
        } catch (error) {
          console.log(`  ❌ Error inserting ${item.name}:`, error.message);
        }
      }

      console.log(`  ✅ Added ${added} items, skipped ${skipped} existing items`);
      return added;
    }

    // Import all new items
    const freshCount = await importItems(freshFoodsItems, 'Fresh Foods');
    const groceryCount = await importItems(groceriesItems, 'Groceries & Essentials');
    const sweetsCount = await importItems(sweetsItems, 'Sweets & Desserts');

    // Summary
    console.log('\n' + '='.repeat(60));
    console.log('📊 IMPORT SUMMARY');
    console.log('='.repeat(60));
    console.log(`Fresh Foods added: ${freshCount}`);
    console.log(`Groceries & Essentials added: ${groceryCount}`);
    console.log(`Sweets & Desserts added: ${sweetsCount}`);
    console.log(`Total new items: ${freshCount + groceryCount + sweetsCount}`);
    console.log('='.repeat(60));
    console.log('✨ Items added successfully!\n');

    await sequelize.close();
    process.exit(0);
  } catch (error) {
    console.error('❌ Error adding items:', error);
    await sequelize.close();
    process.exit(1);
  }
}

// Run the import
addMoreItems();
