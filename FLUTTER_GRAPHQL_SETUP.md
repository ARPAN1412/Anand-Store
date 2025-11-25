# Flutter GraphQL Integration Guide

## Overview
This guide shows how to connect your Flutter app to the WordPress headless backend using GraphQL.

## What's Included

### WordPress Backend
- ✅ Custom post types (Products, Orders)
- ✅ Custom taxonomies (Categories, Tags)
- ✅ GraphQL queries for products
- ✅ GraphQL mutations for orders
- ✅ User authentication with JWT
- ✅ Custom fields (price, rating, stock, etc.)

### Flutter App
- ✅ GraphQL client setup
- ✅ Product fetching from WordPress
- ✅ Category filtering
- ✅ Search functionality
- ✅ Order creation
- ✅ User authentication

## Setup Steps

### 1. Configure WordPress URL

Edit `lib/services/graphql_config.dart`:

```dart
static const String wordpressUrl = 'https://your-wordpress-site.com';
```

Replace `your-wordpress-site.com` with your actual WordPress domain.

### 2. Install Flutter Dependencies

```bash
flutter pub get
```

This installs:
- `graphql_flutter`: GraphQL client
- `http`: HTTP requests
- `shared_preferences`: Token storage

### 3. Test the Connection

Create a simple test screen:

```dart
import 'package:flutter/material.dart';
import '../services/graphql_service.dart';

class TestConnectionScreen extends StatefulWidget {
  @override
  _TestConnectionScreenState createState() => _TestConnectionScreenState();
}

class _TestConnectionScreenState extends State<TestConnectionScreen> {
  bool _loading = false;
  String _result = 'Not tested yet';

  Future<void> _testConnection() async {
    setState(() {
      _loading = true;
      _result = 'Testing...';
    });

    try {
      final products = await GraphQLService.fetchAllProducts();
      setState(() {
        _loading = false;
        _result = 'Success! Found ${products.length} products';
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _result = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Test Connection')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_loading)
              CircularProgressIndicator()
            else
              Text(_result),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _testConnection,
              child: Text('Test Connection'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Using GraphQL Service

### Fetch All Products

```dart
import 'package:your_app/services/graphql_service.dart';

// Fetch products
final products = await GraphQLService.fetchAllProducts();

// Use products
for (var product in products) {
  print('Product: ${product['title']}');
  print('Price: ${product['price']}');
}
```

### Fetch Products by Category

```dart
// Fetch vegetables
final vegetables = await GraphQLService.fetchProductsByCategory('vegetables');
```

### Search Products

```dart
// Search for milk
final results = await GraphQLService.searchProducts('milk');
```

### Create Order

```dart
import 'dart:convert';

// Prepare order items
final orderItems = jsonEncode([
  {
    'productId': 123,
    'quantity': 2,
    'price': 5.98,
    'name': 'Fresh Milk'
  },
  {
    'productId': 456,
    'quantity': 1,
    'price': 2.99,
    'name': 'Bread'
  }
]);

// Create order
final result = await GraphQLService.createOrder(
  orderItems: orderItems,
  totalAmount: 8.97,
  deliveryAddress: '123 Main St, City',
  customerPhone: '1234567890',
  customerName: 'John Doe',
);

if (result != null && result['success'] == true) {
  print('Order created! ID: ${result['orderId']}');
} else {
  print('Failed to create order');
}
```

### User Login

```dart
final loginResult = await GraphQLService.login(
  username: 'user@example.com',
  password: 'password123',
);

if (loginResult != null && loginResult['authToken'] != null) {
  // Save token
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('auth_token', loginResult['authToken']);
  
  print('Login successful!');
  print('User: ${loginResult['user']['name']}');
} else {
  print('Login failed');
}
```

## Updating the Home Screen to Use WordPress Data

Replace sample data with real WordPress products:

```dart
// In home_screen.dart

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _products = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => _loading = true);
    
    final products = await GraphQLService.fetchAllProducts();
    
    setState(() {
      _products = products;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Center(child: CircularProgressIndicator());
    }

    // Use _products instead of sampleProducts
    // ...
  }
}
```

## Converting WordPress Data to Product Model

Create a factory method in `product.dart`:

```dart
class Product {
  // ... existing fields

  factory Product.fromWordPress(Map<String, dynamic> data) {
    return Product(
      id: data['databaseId'].toString(),
      name: data['title'] ?? '',
      description: data['content'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      image: data['featuredImage'] ?? '🛒',
      category: data['productCategories']?['nodes']?[0]?['name'] ?? 'All',
      rating: (data['rating'] ?? 4.5).toDouble(),
      unit: data['unit'] ?? 'pc',
      inStock: data['inStock'] ?? true,
    );
  }
}
```

Usage:

```dart
final wpProducts = await GraphQLService.fetchAllProducts();
final products = wpProducts.map((data) => Product.fromWordPress(data)).toList();
```

## Error Handling

Always wrap GraphQL calls in try-catch:

```dart
try {
  final products = await GraphQLService.fetchAllProducts();
  // Use products
} catch (e) {
  print('Error: $e');
  // Show error to user
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Failed to load products')),
  );
}
```

## Caching

GraphQL client automatically caches responses. To force fresh data:

```dart
// In graphql_service.dart, the FetchPolicy is already set to:
fetchPolicy: FetchPolicy.networkOnly  // Always fetch from network

// To use cache:
fetchPolicy: FetchPolicy.cacheFirst  // Use cache if available
```

## Testing Checklist

- [ ] WordPress plugin installed and activated
- [ ] WPGraphQL installed
- [ ] Sample products added in WordPress
- [ ] GraphQL endpoint accessible
- [ ] CORS enabled
- [ ] Flutter app can connect
- [ ] Products load correctly
- [ ] Categories work
- [ ] Search works
- [ ] Orders can be created

## Common Issues

### Issue: Connection timeout
**Solution**: Check WordPress URL and ensure server is accessible

### Issue: CORS error
**Solution**: Enable CORS in WordPress (see WordPress README)

### Issue: No products returned
**Solution**: Add products in WordPress admin and publish them

### Issue: Authentication failed
**Solution**: Check JWT configuration in wp-config.php

## Production Considerations

1. **SSL Required**: Use HTTPS in production
2. **Rate Limiting**: Implement rate limiting on WordPress
3. **Caching**: Use caching for better performance
4. **Error Logging**: Implement proper error logging
5. **Token Refresh**: Implement token refresh logic
6. **Offline Mode**: Consider caching for offline use

## Next Steps

1. Test connection with your WordPress site
2. Import real product data
3. Implement user registration
4. Add payment gateway
5. Set up push notifications
6. Implement order tracking

## Resources

- WPGraphQL Docs: https://www.wpgraphql.com/
- GraphQL Flutter: https://pub.dev/packages/graphql_flutter
- WordPress REST API: https://developer.wordpress.org/rest-api/

## Support

For issues:
1. Check WordPress error logs
2. Check Flutter console for errors
3. Test GraphQL queries in GraphiQL
4. Verify network connectivity
