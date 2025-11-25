import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../utils/app_theme.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              return cart.itemCount > 0
                  ? TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Clear Cart'),
                            content: const Text(
                                'Are you sure you want to remove all items?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  cart.clear();
                                  Navigator.of(ctx).pop();
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: AppTheme.error,
                                ),
                                child: const Text('Clear'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Text('Clear All'),
                    )
                  : const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.itemCount == 0) {
            return _buildEmptyCart(context);
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final cartItem = cart.items.values.toList()[index];
                    return _buildCartItem(context, cart, cartItem);
                  },
                ),
              ),
              _buildBottomSection(context, cart),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(40),
            decoration: const BoxDecoration(
              color: AppTheme.offWhite,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: AppTheme.grey,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Your cart is empty',
            style: AppTheme.heading2,
          ),
          const SizedBox(height: 8),
          const Text(
            'Add items to your cart to see them here',
            style: AppTheme.bodyText,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: AppTheme.primaryButton,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text('Start Shopping'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(
      BuildContext context, CartProvider cart, cartItem) {
    final product = cartItem.product;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppTheme.mediumRadius,
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        children: [
          // Product Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.offWhite,
              borderRadius: AppTheme.smallRadius,
            ),
            child: Center(
              child: Text(
                product.image,
                style: const TextStyle(fontSize: 40),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '₹${product.price.toStringAsFixed(2)} per ${product.unit}',
                  style: AppTheme.caption,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    // Quantity Controls
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppTheme.lightGrey,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              cart.decreaseQuantity(product.id);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              child: const Icon(
                                Icons.remove,
                                size: 16,
                                color: AppTheme.green,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              '${cartItem.quantity}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.black,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              cart.increaseQuantity(product.id);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              child: const Icon(
                                Icons.add,
                                size: 16,
                                color: AppTheme.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // Total Price
                    Text(
                      '₹${cartItem.totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Delete Button
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            color: AppTheme.error,
            onPressed: () {
              cart.removeItem(product.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${product.name} removed from cart'),
                  duration: const Duration(seconds: 1),
                  backgroundColor: AppTheme.error,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context, CartProvider cart) {
    return Container(
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
        child: Column(
          children: [
            // Subtotal
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Subtotal',
                  style: AppTheme.bodyText,
                ),
                Text(
                  '₹${cart.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.black,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Delivery
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Delivery Fee',
                  style: AppTheme.bodyText,
                ),
                Text(
                  cart.totalAmount > 50 ? 'FREE' : '₹5.00',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: cart.totalAmount > 50
                        ? AppTheme.success
                        : AppTheme.black,
                  ),
                ),
              ],
            ),

            const Divider(height: 24),

            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: AppTheme.heading2,
                ),
                Text(
                  '₹${(cart.totalAmount + (cart.totalAmount > 50 ? 0 : 5)).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.black,
                  ),
                ),
              ],
            ),

            if (cart.totalAmount < 50) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.lightYellow,
                  borderRadius: AppTheme.smallRadius,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 16,
                      color: AppTheme.darkYellow,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Add ₹${(50 - cart.totalAmount).toStringAsFixed(2)} more for FREE delivery!',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.darkYellow,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Checkout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Row(
                        children: [
                          Icon(Icons.check_circle, color: AppTheme.success),
                          SizedBox(width: 8),
                          Text('Order Placed!'),
                        ],
                      ),
                      content: const Text(
                          'Your order has been placed successfully. We will deliver soon!'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            cart.clear();
                            Navigator.of(ctx).pop();
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                style: AppTheme.primaryButton,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    'Proceed to Checkout',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
