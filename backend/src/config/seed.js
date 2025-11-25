const { User, Category, MenuItem } = require('../models');

const seedDatabase = async () => {
  try {
    // Check if data already exists
    const userCount = await User.count();
    if (userCount > 0) {
      console.log('📊 Database already seeded');
      return;
    }

    console.log('🌱 Seeding database...');

    // Create admin user
    await User.create({
      name: 'Admin User',
      email: 'admin@restaurant.com',
      password: 'admin123',
      role: 'admin',
      phone: '+1234567890'
    });

    // Create customer user
    await User.create({
      name: 'John Doe',
      email: 'john@example.com',
      password: 'password123',
      role: 'customer',
      phone: '+1234567891'
    });

    // Create categories
    const categories = await Category.bulkCreate([
      { name: 'Burgers', description: 'Delicious burgers', sortOrder: 1 },
      { name: 'Pizza', description: 'Italian pizza', sortOrder: 2 },
      { name: 'Seafood', description: 'Fresh seafood', sortOrder: 3 },
      { name: 'Salads', description: 'Healthy salads', sortOrder: 4 },
      { name: 'Desserts', description: 'Sweet desserts', sortOrder: 5 },
      { name: 'Beverages', description: 'Refreshing drinks', sortOrder: 6 }
    ]);

    // Create menu items
    await MenuItem.bulkCreate([
      {
        name: 'Wagyu Beef Burger',
        description: 'Premium wagyu patty with aged cheddar and truffle aioli',
        price: 18.99,
        image: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800',
        rating: 4.9,
        reviews: 389,
        tags: ['Beef', 'Premium'],
        discount: 15,
        categoryId: categories[0].id,
        isVegetarian: false,
        preparationTime: 20
      },
      {
        name: 'Margherita Pizza',
        description: 'Wood-fired pizza with fresh mozzarella and basil',
        price: 16.99,
        image: 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=800',
        rating: 4.7,
        reviews: 512,
        tags: ['Italian', 'Vegetarian'],
        categoryId: categories[1].id,
        isVegetarian: true,
        preparationTime: 15
      },
      {
        name: 'Grilled Salmon',
        description: 'Fresh Atlantic salmon with herbs and lemon butter sauce',
        price: 24.99,
        image: 'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=800',
        rating: 4.8,
        reviews: 245,
        tags: ['Seafood', 'Healthy'],
        badge: 'Popular',
        categoryId: categories[2].id,
        isVegetarian: false,
        preparationTime: 25
      },
      {
        name: 'Caesar Salad',
        description: 'Crisp romaine with parmesan and house-made dressing',
        price: 12.99,
        image: 'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=800',
        rating: 4.6,
        reviews: 198,
        tags: ['Salad', 'Vegetarian', 'Healthy'],
        categoryId: categories[3].id,
        isVegetarian: true,
        preparationTime: 10
      },
      {
        name: 'Chicken Wings',
        description: 'Crispy wings with buffalo sauce',
        price: 14.99,
        image: 'https://images.unsplash.com/photo-1527477396000-e27163b481c2?w=800',
        rating: 4.7,
        reviews: 320,
        tags: ['Chicken', 'Spicy'],
        categoryId: categories[0].id,
        isVegetarian: false,
        preparationTime: 18
      },
      {
        name: 'Chocolate Lava Cake',
        description: 'Warm chocolate cake with molten center',
        price: 8.99,
        image: 'https://images.unsplash.com/photo-1624353365286-3f8d62daad51?w=800',
        rating: 4.9,
        reviews: 450,
        tags: ['Dessert', 'Chocolate'],
        badge: 'Popular',
        categoryId: categories[4].id,
        isVegetarian: true,
        preparationTime: 12
      },
      {
        name: 'Fresh Lemonade',
        description: 'Homemade lemonade with fresh lemons',
        price: 4.99,
        image: 'https://images.unsplash.com/photo-1523677011781-c91d1bbe2f0d?w=800',
        rating: 4.5,
        reviews: 180,
        tags: ['Beverage', 'Refreshing'],
        categoryId: categories[5].id,
        isVegetarian: true,
        preparationTime: 5
      },
      {
        name: 'Pepperoni Pizza',
        description: 'Classic pizza with pepperoni and mozzarella',
        price: 18.99,
        image: 'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=800',
        rating: 4.8,
        reviews: 620,
        tags: ['Italian', 'Popular'],
        categoryId: categories[1].id,
        isVegetarian: false,
        preparationTime: 15
      }
    ]);

    console.log('✅ Database seeded successfully');
    console.log('👤 Admin credentials: admin@restaurant.com / admin123');
    console.log('👤 Customer credentials: john@example.com / password123');
  } catch (error) {
    console.error('❌ Seeding error:', error.message);
  }
};

module.exports = { seedDatabase };
