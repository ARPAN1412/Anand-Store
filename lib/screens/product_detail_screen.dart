import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../utils/app_theme.dart';
import '../providers/cart_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  Container(
                    width: double.infinity,
                    height: 300,
                    color: AppTheme.offWhite,
                    child: Center(
                      child: Text(
                        product.image,
                        style: const TextStyle(fontSize: 120),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Name and Rating
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                product.name,
                                style: AppTheme.heading1,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.lightYellow,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    size: 16,
                                    color: AppTheme.primaryYellow,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${product.rating}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.darkYellow,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Category
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.offWhite,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            product.category,
                            style: const TextStyle(
                              color: AppTheme.darkGrey,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Price
                        Row(
                          children: [
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.black,
                              ),
                            ),
                            if (product.preparationTime != null) ...[
                              const SizedBox(width: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryYellow.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '⏱️ ${product.preparationTime} min',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.grey,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Stock Status
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: product.isAvailable
                                    ? AppTheme.success
                                    : AppTheme.error,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              product.isAvailable ? 'Available' : 'Unavailable',
                              style: TextStyle(
                                color: product.isAvailable
                                    ? AppTheme.success
                                    : AppTheme.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (product.isVegetarian) ...[
                              const SizedBox(width: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  border: Border.all(color: Colors.green),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  '🌱 Vegetarian',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Description Title
                        const Text(
                          'Description',
                          style: AppTheme.heading2,
                        ),

                        const SizedBox(height: 12),

                        // Description
                        Text(
                          product.description,
                          style: AppTheme.bodyText.copyWith(height: 1.6),
                        ),

                        const SizedBox(height: 24),

                        // Features
                        const Text(
                          'Product Features',
                          style: AppTheme.heading3,
                        ),

                        const SizedBox(height: 12),

                        _buildFeatureItem(Icons.verified, 'Quality Assured'),
                        const SizedBox(height: 8),
                        _buildFeatureItem(Icons.local_shipping, 'Fast Delivery'),
                        const SizedBox(height: 8),
                        _buildFeatureItem(Icons.recycling, 'Fresh & Organic'),
                        const SizedBox(height: 8),
                        _buildFeatureItem(Icons.star, 'Top Rated'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Add to Cart Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Consumer<CartProvider>(
                builder: (context, cart, child) {
                  final isInCart = cart.isInCart(product.id);
                  final quantity = cart.getQuantity(product.id);

                  return Row(
                    children: [
                      if (isInCart) ...[
                        // Quantity Controls
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppTheme.green,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                color: AppTheme.green,
                                onPressed: () {
                                  cart.decreaseQuantity(product.id);
                                },
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Text(
                                  '$quantity',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.green,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add),
                                color: AppTheme.green,
                                onPressed: () {
                                  cart.increaseQuantity(product.id);
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (!isInCart) {
                              cart.addItem(product);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${product.name} added to cart'),
                                  duration: const Duration(seconds: 1),
                                  backgroundColor: AppTheme.success,
                                ),
                              );
                            }
                          },
                          style: AppTheme.primaryButton,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.shopping_cart),
                              const SizedBox(width: 8),
                              Text(
                                isInCart ? 'In Cart' : 'Add to Cart',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.lightYellow,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 16,
            color: AppTheme.primaryYellow,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: AppTheme.bodyText.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
