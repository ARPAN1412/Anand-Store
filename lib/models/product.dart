class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? discountPrice;
  final String image;
  final String category;
  final double rating;
  final int reviews;
  final bool isVegetarian;
  final bool isAvailable;
  final int? preparationTime;
  final List<String> tags;
  final String? badge;
  final int? discount;
  final String unit;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.discountPrice,
    required this.image,
    required this.category,
    this.rating = 0.0,
    this.reviews = 0,
    this.isVegetarian = false,
    this.isAvailable = true,
    this.preparationTime,
    this.tags = const [],
    this.badge,
    this.discount,
    this.unit = 'unit',
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']?.toString() ?? '0',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      discountPrice: json['discount_price'] != null 
          ? double.tryParse(json['discount_price'].toString())
          : null,
      image: json['image'] ?? '🍽️',
      category: json['category']?['name'] ?? json['category_name'] ?? 'Others',
      rating: double.tryParse(json['rating']?.toString() ?? '0') ?? 0.0,
      reviews: json['reviews'] ?? 0,
      isVegetarian: json['is_vegetarian'] ?? false,
      isAvailable: json['is_available'] ?? true,
      preparationTime: json['preparation_time'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      badge: json['badge'],
      discount: json['discount'],
      unit: json['unit']?.toString() ?? 'unit',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'discount_price': discountPrice,
      'image': image,
      'category': category,
      'rating': rating,
      'reviews': reviews,
      'is_vegetarian': isVegetarian,
      'is_available': isAvailable,
      'preparation_time': preparationTime,
      'tags': tags,
      'badge': badge,
      'discount': discount,
      'unit': unit,
    };
  }
}

// Sample Data
List<Product> sampleProducts = [
  Product(
    id: '1',
    name: 'Fresh Tomatoes',
    description: 'Fresh and juicy red tomatoes, perfect for salads and cooking.',
    price: 2.99,
    image: '🍅',
    category: 'Vegetables',
    rating: 4.5,
  ),
  Product(
    id: '2',
    name: 'Organic Apples',
    description: 'Sweet and crispy organic apples, rich in vitamins.',
    price: 4.99,
    image: '🍎',
    category: 'Fruits',
    rating: 4.8,
  ),
  Product(
    id: '3',
    name: 'Fresh Milk',
    description: 'Farm fresh full cream milk, 1 liter pack.',
    price: 3.49,
    image: '🥛',
    category: 'Dairy',
    rating: 4.6,
  ),
  Product(
    id: '4',
    name: 'Whole Wheat Bread',
    description: 'Freshly baked whole wheat bread, healthy and nutritious.',
    price: 2.49,
    image: '🍞',
    category: 'Bakery',
    rating: 4.4,
  ),
  Product(
    id: '5',
    name: 'Fresh Carrots',
    description: 'Crunchy orange carrots, high in beta-carotene.',
    price: 1.99,
    image: '🥕',
    category: 'Vegetables',
    rating: 4.5,
  ),
  Product(
    id: '6',
    name: 'Bananas',
    description: 'Ripe yellow bananas, natural energy booster.',
    price: 1.49,
    image: '🍌',
    category: 'Fruits',
    rating: 4.7,
  ),
  Product(
    id: '7',
    name: 'Fresh Eggs',
    description: 'Farm fresh eggs, pack of 12.',
    price: 4.99,
    image: '🥚',
    category: 'Dairy',
    rating: 4.8,
  ),
  Product(
    id: '8',
    name: 'Strawberries',
    description: 'Sweet and juicy strawberries, perfect for desserts.',
    price: 5.99,
    image: '🍓',
    category: 'Fruits',
    rating: 4.9,
  ),
  Product(
    id: '9',
    name: 'Fresh Broccoli',
    description: 'Green and healthy broccoli, rich in nutrients.',
    price: 2.99,
    image: '🥦',
    category: 'Vegetables',
    rating: 4.3,
  ),
  Product(
    id: '10',
    name: 'Cheese',
    description: 'Premium quality cheddar cheese.',
    price: 6.99,
    image: '🧀',
    category: 'Dairy',
    rating: 4.7,
  ),
];

List<String> categories = [
  'All',
  'Vegetables',
  'Fruits',
  'Dairy',
  'Bakery',
  'Meat',
  'Snacks',
];
