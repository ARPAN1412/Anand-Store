require('dotenv').config();
const { connectDB } = require('./src/config/database');
const { seedDatabase } = require('./src/config/seed');

async function runSeed() {
  try {
    console.log('🌱 Starting Neon database seeding...\n');
    
    // Connect to database
    await connectDB();
    
    // Run seed
    await seedDatabase();
    
    console.log('\n✅ Seeding completed successfully!');
    process.exit(0);
  } catch (error) {
    console.error('❌ Error:', error);
    process.exit(1);
  }
}

runSeed();
