/**
 * Grocery Dataset - Essential Indian Grocery Items
 * Categories: Dairy, Fruits & Vegetables, Staples, Cooking Essentials, Beverages, Snacks
 */

const groceryDataset = [
  // DAIRY
  {
    name: "Fresh Milk (1L)",
    description: "Farm-fresh full cream milk, pasteurized and homogenized",
    price: 65,
    category: "Dairy",
    brand: "Amul",
    unit: "1 Liter",
    stock: 100,
    expiryDays: 3,
    isOrganic: false,
    tags: ["dairy", "fresh", "daily need"],
    image: "https://images.unsplash.com/photo-1563636619-e9143da7973b?w=500"
  },
  {
    name: "Paneer (200g)",
    description: "Fresh cottage cheese, ideal for Indian dishes",
    price: 95,
    category: "Dairy",
    brand: "Mother Dairy",
    unit: "200 grams",
    stock: 50,
    expiryDays: 5,
    isOrganic: false,
    tags: ["dairy", "protein", "vegetarian"],
    image: "https://images.unsplash.com/photo-1628773822990-202f4e6c4e0a?w=500"
  },
  {
    name: "Curd (400g)",
    description: "Thick and creamy curd, rich in probiotics",
    price: 45,
    category: "Dairy",
    brand: "Amul",
    unit: "400 grams",
    stock: 80,
    expiryDays: 4,
    isOrganic: false,
    tags: ["dairy", "healthy", "probiotics"],
    image: "https://images.unsplash.com/photo-1628088062854-d1870b4553da?w=500"
  },
  {
    name: "Butter (100g)",
    description: "Pure salted butter made from fresh cream",
    price: 55,
    category: "Dairy",
    brand: "Amul",
    unit: "100 grams",
    stock: 120,
    expiryDays: 60,
    isOrganic: false,
    tags: ["dairy", "butter"],
    image: "https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=500"
  },

  // FRUITS & VEGETABLES
  {
    name: "Fresh Tomatoes (1kg)",
    description: "Ripe and juicy tomatoes, perfect for curries and salads",
    price: 40,
    category: "Fruits & Vegetables",
    unit: "1 kg",
    stock: 200,
    expiryDays: 5,
    isOrganic: true,
    tags: ["fresh", "organic", "vegetables"],
    image: "https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=500"
  },
  {
    name: "Onions (1kg)",
    description: "Fresh red onions, essential for Indian cooking",
    price: 35,
    category: "Fruits & Vegetables",
    unit: "1 kg",
    stock: 300,
    expiryDays: 15,
    isOrganic: false,
    tags: ["fresh", "vegetables", "staple"],
    image: "https://images.unsplash.com/photo-1580201092675-a0a6a6cafbb1?w=500"
  },
  {
    name: "Potatoes (2kg)",
    description: "Fresh farm potatoes, versatile for all dishes",
    price: 50,
    category: "Fruits & Vegetables",
    unit: "2 kg",
    stock: 250,
    expiryDays: 20,
    isOrganic: false,
    tags: ["fresh", "vegetables", "staple"],
    image: "https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=500"
  },
  {
    name: "Bananas (1 dozen)",
    description: "Ripe yellow bananas, rich in potassium",
    price: 60,
    category: "Fruits & Vegetables",
    unit: "12 pieces",
    stock: 150,
    expiryDays: 3,
    isOrganic: false,
    tags: ["fresh", "fruits", "healthy"],
    image: "https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=500"
  },
  {
    name: "Apples (1kg)",
    description: "Crisp and sweet Kashmiri apples",
    price: 180,
    category: "Fruits & Vegetables",
    unit: "1 kg",
    stock: 100,
    expiryDays: 10,
    isOrganic: false,
    tags: ["fresh", "fruits", "premium"],
    image: "https://images.unsplash.com/photo-1568702846914-96b305d2aaeb?w=500"
  },

  // STAPLES
  {
    name: "Basmati Rice (5kg)",
    description: "Premium aged basmati rice with long grains",
    price: 450,
    category: "Staples",
    brand: "India Gate",
    unit: "5 kg",
    stock: 100,
    expiryDays: 365,
    isOrganic: false,
    tags: ["staple", "rice", "premium"],
    image: "https://images.unsplash.com/photo-1586201375761-83865001e31c?w=500"
  },
  {
    name: "Wheat Flour (10kg)",
    description: "Whole wheat flour for making chapatis and breads",
    price: 400,
    category: "Staples",
    brand: "Aashirvaad",
    unit: "10 kg",
    stock: 80,
    expiryDays: 180,
    isOrganic: false,
    tags: ["staple", "flour", "wheat"],
    image: "https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=500"
  },
  {
    name: "Toor Dal (1kg)",
    description: "Split pigeon peas, protein-rich lentils",
    price: 140,
    category: "Staples",
    unit: "1 kg",
    stock: 120,
    expiryDays: 365,
    isOrganic: false,
    tags: ["staple", "pulses", "protein"],
    image: "https://images.unsplash.com/photo-1599909533835-e5a0baef9a94?w=500"
  },
  {
    name: "Chana Dal (1kg)",
    description: "Split chickpeas, perfect for dal and snacks",
    price: 120,
    category: "Staples",
    unit: "1 kg",
    stock: 100,
    expiryDays: 365,
    isOrganic: false,
    tags: ["staple", "pulses", "protein"],
    image: "https://images.unsplash.com/photo-1599909533835-e5a0baef9a94?w=500"
  },

  // COOKING ESSENTIALS
  {
    name: "Sunflower Oil (1L)",
    description: "Pure sunflower oil for healthy cooking",
    price: 180,
    category: "Cooking Essentials",
    brand: "Sundrop",
    unit: "1 Liter",
    stock: 90,
    expiryDays: 365,
    isOrganic: false,
    tags: ["cooking", "oil", "healthy"],
    image: "https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=500"
  },
  {
    name: "Iodized Salt (1kg)",
    description: "Pure iodized salt for daily cooking",
    price: 25,
    category: "Cooking Essentials",
    brand: "Tata Salt",
    unit: "1 kg",
    stock: 200,
    expiryDays: 730,
    isOrganic: false,
    tags: ["cooking", "essential"],
    image: "https://images.unsplash.com/photo-1598485628671-a1e4e4239c2d?w=500"
  },
  {
    name: "Sugar (1kg)",
    description: "Pure white crystal sugar",
    price: 45,
    category: "Cooking Essentials",
    brand: "Madhur",
    unit: "1 kg",
    stock: 150,
    expiryDays: 730,
    isOrganic: false,
    tags: ["cooking", "sweetener"],
    image: "https://images.unsplash.com/photo-1518724761172-0692b3c1d95e?w=500"
  },
  {
    name: "Red Chilli Powder (100g)",
    description: "Hot and spicy red chilli powder",
    price: 60,
    category: "Cooking Essentials",
    brand: "Everest",
    unit: "100 grams",
    stock: 180,
    expiryDays: 365,
    isOrganic: false,
    tags: ["spices", "cooking"],
    image: "https://images.unsplash.com/photo-1599639832472-a8f75f4e921c?w=500"
  },

  // BEVERAGES
  {
    name: "Tea Powder (500g)",
    description: "Premium Assam tea leaves for strong refreshing tea",
    price: 220,
    category: "Beverages",
    brand: "Taj Mahal",
    unit: "500 grams",
    stock: 70,
    expiryDays: 365,
    isOrganic: false,
    tags: ["beverage", "tea"],
    image: "https://images.unsplash.com/photo-1563636619-e9143da7973b?w=500"
  },
  {
    name: "Coffee Powder (200g)",
    description: "Rich and aromatic filter coffee powder",
    price: 180,
    category: "Beverages",
    brand: "Nescafe",
    unit: "200 grams",
    stock: 60,
    expiryDays: 365,
    isOrganic: false,
    tags: ["beverage", "coffee"],
    image: "https://images.unsplash.com/photo-1511920170033-f8396924c348?w=500"
  },

  // SNACKS
  {
    name: "Biscuits Pack",
    description: "Assorted cream biscuits, perfect for tea time",
    price: 85,
    category: "Snacks",
    brand: "Parle",
    unit: "400 grams",
    stock: 150,
    expiryDays: 180,
    isOrganic: false,
    tags: ["snacks", "biscuits"],
    image: "https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=500"
  },
  {
    name: "Namkeen Mix",
    description: "Crispy and spicy Indian snack mix",
    price: 120,
    category: "Snacks",
    brand: "Haldiram's",
    unit: "500 grams",
    stock: 100,
    expiryDays: 120,
    isOrganic: false,
    tags: ["snacks", "indian", "spicy"],
    image: "https://images.unsplash.com/photo-1599490659213-e2b9527bd087?w=500"
  },
  {
    name: "Cookies Pack",
    description: "Chocolate chip cookies for sweet cravings",
    price: 95,
    category: "Snacks",
    brand: "Britannia",
    unit: "300 grams",
    stock: 120,
    expiryDays: 180,
    isOrganic: false,
    tags: ["snacks", "cookies", "sweet"],
    image: "https://images.unsplash.com/photo-1499636136210-6f4ee915583e?w=500"
  }
];

module.exports = groceryDataset;
