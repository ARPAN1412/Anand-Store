/**
 * Clothes Dataset - Fashion & Apparel Items
 * Categories: Men's Wear, Women's Wear, Kids Wear, Accessories
 */

const clothesDataset = [
  // MEN'S WEAR
  {
    name: "Cotton T-Shirt",
    description: "Comfortable round neck cotton t-shirt, available in multiple colors",
    price: 499,
    category: "Men's Wear",
    brand: "Allen Solly",
    sizes: ["S", "M", "L", "XL", "XXL"],
    colors: ["Black", "White", "Navy Blue", "Grey"],
    material: "100% Cotton",
    stock: 150,
    season: "All Season",
    careInstructions: "Machine wash cold, tumble dry low",
    tags: ["casual", "cotton", "comfortable"],
    image: "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=500"
  },
  {
    name: "Formal Shirt",
    description: "Slim fit formal shirt perfect for office wear",
    price: 1299,
    category: "Men's Wear",
    brand: "Peter England",
    sizes: ["38", "40", "42", "44"],
    colors: ["White", "Light Blue", "Pink"],
    material: "Poly-Cotton Blend",
    stock: 80,
    season: "All Season",
    tags: ["formal", "office wear"],
    image: "https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?w=500"
  },
  {
    name: "Denim Jeans",
    description: "Classic fit denim jeans with comfortable stretch",
    price: 1799,
    category: "Men's Wear",
    brand: "Levi's",
    sizes: ["30", "32", "34", "36", "38"],
    colors: ["Blue", "Black", "Grey"],
    material: "Denim with stretch",
    stock: 100,
    season: "All Season",
    tags: ["denim", "casual", "popular"],
    image: "https://images.unsplash.com/photo-1542272604-787c3835535d?w=500"
  },
  {
    name: "Sports Track Pants",
    description: "Comfortable track pants for gym and casual wear",
    price: 799,
    category: "Men's Wear",
    brand: "Adidas",
    sizes: ["S", "M", "L", "XL"],
    colors: ["Black", "Navy", "Grey"],
    material: "Polyester",
    stock: 90,
    season: "All Season",
    tags: ["sports", "casual", "comfortable"],
    image: "https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=500"
  },

  // WOMEN'S WEAR
  {
    name: "Kurti",
    description: "Elegant ethnic kurti with beautiful prints",
    price: 899,
    category: "Women's Wear",
    brand: "W",
    sizes: ["S", "M", "L", "XL"],
    colors: ["Pink", "Blue", "Yellow", "Green"],
    material: "Rayon",
    stock: 120,
    season: "All Season",
    tags: ["ethnic", "kurti", "indian wear"],
    image: "https://images.unsplash.com/photo-1610652492500-ded49ceeb52d?w=500"
  },
  {
    name: "Cotton Saree",
    description: "Traditional cotton saree with contemporary design",
    price: 1599,
    category: "Women's Wear",
    brand: "Fabindia",
    colors: ["Red", "Blue", "Green", "Yellow"],
    material: "Pure Cotton",
    stock: 60,
    season: "All Season",
    tags: ["saree", "traditional", "ethnic"],
    image: "https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=500"
  },
  {
    name: "Palazzo Pants",
    description: "Comfortable palazzo pants for casual and ethnic wear",
    price: 699,
    category: "Women's Wear",
    brand: "W",
    sizes: ["S", "M", "L", "XL"],
    colors: ["Black", "Navy", "Maroon", "Beige"],
    material: "Rayon",
    stock: 90,
    season: "All Season",
    tags: ["palazzo", "comfortable", "ethnic"],
    image: "https://images.unsplash.com/photo-1594633313593-bab3825d0caf?w=500"
  },
  {
    name: "Western Dress",
    description: "Trendy western dress for parties and casual outings",
    price: 1499,
    category: "Women's Wear",
    brand: "Vero Moda",
    sizes: ["S", "M", "L", "XL"],
    colors: ["Black", "Red", "Blue"],
    material: "Polyester",
    stock: 70,
    season: "All Season",
    tags: ["western", "dress", "party wear"],
    image: "https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?w=500"
  },
  {
    name: "Leggings",
    description: "Stretchable cotton leggings for comfort",
    price: 399,
    category: "Women's Wear",
    brand: "W",
    sizes: ["S", "M", "L", "XL"],
    colors: ["Black", "Navy", "Grey", "Brown"],
    material: "Cotton Lycra",
    stock: 200,
    season: "All Season",
    tags: ["leggings", "comfortable", "casual"],
    image: "https://images.unsplash.com/photo-1506629082955-511b1aa562c8?w=500"
  },

  // KIDS WEAR
  {
    name: "Kids T-Shirt Set",
    description: "Colorful printed t-shirts pack of 3 for kids",
    price: 899,
    category: "Kids Wear",
    brand: "FirstCry",
    sizes: ["2-3 Years", "3-4 Years", "5-6 Years", "7-8 Years"],
    colors: ["Multicolor"],
    material: "100% Cotton",
    stock: 100,
    season: "All Season",
    tags: ["kids", "comfortable", "pack"],
    image: "https://images.unsplash.com/photo-1503944583220-79d8926ad5e2?w=500"
  },
  {
    name: "Kids Frock",
    description: "Cute printed frock for baby girls",
    price: 699,
    category: "Kids Wear",
    brand: "Hopscotch",
    sizes: ["2-3 Years", "3-4 Years", "5-6 Years"],
    colors: ["Pink", "Yellow", "Purple"],
    material: "Cotton",
    stock: 80,
    season: "All Season",
    tags: ["kids", "girls", "frock"],
    image: "https://images.unsplash.com/photo-1518831959646-742c3a14ebf7?w=500"
  },
  {
    name: "Kids Shorts Set",
    description: "Comfortable shorts and t-shirt combo for boys",
    price: 599,
    category: "Kids Wear",
    brand: "FirstCry",
    sizes: ["2-3 Years", "3-4 Years", "5-6 Years", "7-8 Years"],
    colors: ["Blue", "Red", "Green"],
    material: "Cotton",
    stock: 120,
    season: "Summer",
    tags: ["kids", "boys", "comfortable"],
    image: "https://images.unsplash.com/photo-1519238263530-99bdd11df2ea?w=500"
  },

  // ACCESSORIES
  {
    name: "Leather Belt",
    description: "Genuine leather belt with metal buckle",
    price: 599,
    category: "Accessories",
    brand: "Woodland",
    sizes: ["Free Size (Adjustable)"],
    colors: ["Brown", "Black"],
    material: "Genuine Leather",
    stock: 120,
    season: "All Season",
    tags: ["accessories", "belt", "leather"],
    image: "https://images.unsplash.com/photo-1624222247344-550fb60583b2?w=500"
  },
  {
    name: "Sports Socks (Pack of 3)",
    description: "Comfortable cotton sports socks",
    price: 299,
    category: "Accessories",
    brand: "Jockey",
    sizes: ["Free Size"],
    colors: ["White", "Black", "Grey"],
    material: "Cotton",
    stock: 200,
    season: "All Season",
    tags: ["accessories", "socks", "sports"],
    image: "https://images.unsplash.com/photo-1586350977771-b3b0abd50c82?w=500"
  },
  {
    name: "Cotton Dupatta",
    description: "Light and elegant cotton dupatta to match ethnic wear",
    price: 399,
    category: "Accessories",
    brand: "Fabindia",
    colors: ["Pink", "Blue", "Yellow", "Green"],
    material: "Cotton",
    stock: 150,
    season: "All Season",
    tags: ["accessories", "dupatta", "ethnic"],
    image: "https://images.unsplash.com/photo-1594633312681-425c7b97ccd1?w=500"
  },
  {
    name: "Watch (Analog)",
    description: "Stylish analog watch with leather strap",
    price: 1299,
    category: "Accessories",
    brand: "Titan",
    colors: ["Black", "Brown"],
    material: "Leather Strap",
    stock: 80,
    season: "All Season",
    tags: ["accessories", "watch", "formal"],
    image: "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500"
  }
];

module.exports = clothesDataset;
