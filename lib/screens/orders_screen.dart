import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../services/api_service.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _orders = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final orders = await _apiService.getMyOrders();
      if (mounted) {
        setState(() {
          _orders = orders;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          // Check if it's a 401 error (unauthorized)
          if (e.toString().contains('401')) {
            _errorMessage = 'UNAUTHORIZED';
          } else {
            _errorMessage = e.toString();
          }
          _isLoading = false;
        });
      }
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppTheme.orange;
      case 'confirmed':
        return Colors.blue;
      case 'preparing':
        return Colors.purple;
      case 'on_the_way':
      case 'out_for_delivery':
        return Colors.teal;
      case 'delivered':
        return AppTheme.green;
      case 'cancelled':
        return Colors.red;
      default:
        return AppTheme.grey;
    }
  }

  String _formatStatus(String status) {
    return status.replaceAll('_', ' ').split(' ').map((word) {
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM dd, yyyy - HH:mm').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.primaryYellow,
        elevation: 0,
        title: const Text(
          'My Orders',
          style: TextStyle(
            color: AppTheme.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppTheme.black),
            onPressed: _loadOrders,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryYellow,
              ),
            )
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _errorMessage == 'UNAUTHORIZED'
                              ? Icons.login
                              : Icons.error_outline,
                          size: 64,
                          color: isDark ? AppTheme.darkTextSecondary : AppTheme.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage == 'UNAUTHORIZED'
                              ? 'Please Login'
                              : 'Unable to load orders',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppTheme.darkText : AppTheme.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _errorMessage == 'UNAUTHORIZED'
                              ? 'You need to login to view your order history'
                              : 'Check your connection and try again',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isDark ? AppTheme.darkTextSecondary : AppTheme.grey,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            if (_errorMessage == 'UNAUTHORIZED') {
                              // Navigate to profile/login screen
                              Navigator.pop(context);
                              // You could also navigate to a login page if you have one
                            } else {
                              _loadOrders();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryYellow,
                            foregroundColor: AppTheme.black,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                          ),
                          child: Text(_errorMessage == 'UNAUTHORIZED' ? 'Go to Profile' : 'Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : _orders.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shopping_bag_outlined,
                              size: 80,
                              color: isDark ? AppTheme.darkTextSecondary : AppTheme.grey,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'No Orders Yet',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppTheme.darkText : AppTheme.black,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Your order history will appear here',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark ? AppTheme.darkTextSecondary : AppTheme.grey,
                              ),
                            ),
                            const SizedBox(height: 32),
                            ElevatedButton.icon(
                              onPressed: () {
                                // Navigate back to home
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(Icons.shopping_cart),
                              label: const Text('Start Shopping'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryYellow,
                                foregroundColor: AppTheme.black,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadOrders,
                      color: AppTheme.primaryYellow,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _orders.length,
                        itemBuilder: (context, index) {
                          final order = _orders[index];
                          return _buildOrderCard(order, isDark);
                        },
                      ),
                    ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order, bool isDark) {
    final status = order['status'] ?? 'pending';
    final statusColor = _getStatusColor(status);
    final totalAmount = order['totalAmount'] ?? 0.0;
    final items = order['items'] as List<dynamic>? ?? [];
    final orderDate = order['createdAt'] ?? order['created_at'] ?? '';
    final orderId = order['id']?.toString() ?? '#';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: isDark ? AppTheme.darkCard : Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          _showOrderDetails(order);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order $orderId',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppTheme.darkText : AppTheme.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(orderDate),
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppTheme.darkTextSecondary : AppTheme.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _formatStatus(status),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              Divider(
                color: isDark ? AppTheme.darkTextSecondary.withOpacity(0.2) : AppTheme.lightGrey,
              ),
              const SizedBox(height: 12),

              // Order Items
              Column(
                children: [
                  for (var i = 0; i < (items.length > 3 ? 3 : items.length); i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: isDark ? AppTheme.darkTextSecondary : AppTheme.grey,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${items[i]['quantity']}x ${items[i]['name'] ?? items[i]['menuItem']?['name'] ?? 'Item'}',
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark ? AppTheme.darkText : AppTheme.black,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '₹${(items[i]['price'] * items[i]['quantity']).toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: isDark ? AppTheme.darkText : AppTheme.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (items.length > 3)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '+${items.length - 3} more items',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppTheme.darkTextSecondary : AppTheme.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 12),
              Divider(
                color: isDark ? AppTheme.darkTextSecondary.withOpacity(0.2) : AppTheme.lightGrey,
              ),
              const SizedBox(height: 12),

              // Order Total and Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Amount',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppTheme.darkTextSecondary : AppTheme.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₹${totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppTheme.darkText : AppTheme.black,
                        ),
                      ),
                    ],
                  ),
                  OutlinedButton(
                    onPressed: () {
                      _showOrderDetails(order);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryYellow,
                      side: const BorderSide(color: AppTheme.primaryYellow),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('View Details'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOrderDetails(Map<String, dynamic> order) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final items = order['items'] as List<dynamic>? ?? [];
    final status = order['status'] ?? 'pending';
    final statusColor = _getStatusColor(status);
    final totalAmount = order['totalAmount'] ?? 0.0;
    final deliveryAddress = order['deliveryAddress'] ?? 'N/A';
    final phone = order['phone'] ?? 'N/A';
    final notes = order['notes'] ?? '';
    final orderDate = order['createdAt'] ?? order['created_at'] ?? '';
    final orderId = order['id']?.toString() ?? '#';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkCard : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppTheme.darkTextSecondary : AppTheme.grey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppTheme.darkText : AppTheme.black,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: isDark ? AppTheme.darkText : AppTheme.black,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            Divider(
              color: isDark ? AppTheme.darkTextSecondary.withOpacity(0.2) : AppTheme.lightGrey,
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order Info
                    _buildDetailRow('Order ID', orderId, isDark),
                    _buildDetailRow('Date', _formatDate(orderDate), isDark),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Status',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? AppTheme.darkTextSecondary : AppTheme.grey,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _formatStatus(status),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    Text(
                      'Items',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppTheme.darkText : AppTheme.black,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Items list
                    ...items.map((item) => Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppTheme.darkBackground
                                : AppTheme.offWhite,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['name'] ?? item['menuItem']?['name'] ?? 'Item',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: isDark ? AppTheme.darkText : AppTheme.black,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '₹${item['price']} × ${item['quantity']}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDark ? AppTheme.darkTextSecondary : AppTheme.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '₹${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? AppTheme.darkText : AppTheme.black,
                                ),
                              ),
                            ],
                          ),
                        )),

                    const SizedBox(height: 24),
                    Text(
                      'Delivery Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppTheme.darkText : AppTheme.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow('Address', deliveryAddress, isDark),
                    _buildDetailRow('Phone', phone, isDark),
                    if (notes.isNotEmpty)
                      _buildDetailRow('Notes', notes, isDark),

                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryYellow.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Amount',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppTheme.darkText : AppTheme.black,
                            ),
                          ),
                          Text(
                            '₹${totalAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppTheme.darkText : AppTheme.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? AppTheme.darkTextSecondary : AppTheme.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark ? AppTheme.darkText : AppTheme.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
