import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/product.dart';
import '../utils/app_theme.dart';
import '../providers/cart_provider.dart';
import '../services/api_service.dart';
import 'product_detail_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';
import 'categories_screen.dart';
import 'orders_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _currentLocation = 'HOME - Aniket Chakraborty, 238/2/2';
  String _selectedAddress = 'HOME';
  final ApiService _apiService = ApiService();
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  List<dynamic> _categories = [];
  bool _isLoading = true;
  String? _errorMessage;
  int _displayLimit = 20; // Initially show only 20 items
  String? _selectedCategory; // Track selected category for filtering

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Fetch menu items (products) and categories from backend
      final menuItems = await _apiService.getMenuItems();
      final categories = await _apiService.getCategories();
      
      if (!mounted) return;
      
      setState(() {
        _products = menuItems.map((item) => Product.fromJson(item)).toList();
        _filteredProducts = _products;
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _errorMessage = 'Failed to load data: $e';
        _isLoading = false;
      });
    }
  }

  void _loadMoreProducts() {
    if (_displayLimit < _filteredProducts.length) {
      setState(() {
        _displayLimit = (_displayLimit + 20).clamp(0, _filteredProducts.length);
      });
    }
  }

  void _filterByCategory(String categoryName) {
    setState(() {
      _selectedCategory = categoryName;
      _displayLimit = 20;
      
      if (categoryName == 'All') {
        _filteredProducts = _products;
      } else {
        // Map button names to category names in database
        List<String> categoryFilters = [];
        switch (categoryName) {
          case 'Fresh\nFoods':
          case 'Fresh Foods':
            categoryFilters = ['Fruits & Vegetables'];
            break;
          case 'Groceries &\nEssentials':
          case 'Groceries & Essentials':
            categoryFilters = ['Dairy', 'Staples', 'Cooking Essentials', 'Snacks'];
            break;
          case 'Sweets &\nDesserts':
          case 'Sweets & Desserts':
            categoryFilters = ['Desserts'];
            break;
          case 'Beverages':
            categoryFilters = ['Beverages'];
            break;
        }
        
        _filteredProducts = _products.where((product) {
          return categoryFilters.any((filter) => 
            product.category.toLowerCase() == filter.toLowerCase()
          );
        }).toList();
      }
    });
  }

  Future<void> _requestLocationPermission() async {
    // Request location permission when app starts
    // You can implement actual location permission here
  }

  void _showLocationPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select Location',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.my_location, color: AppTheme.primaryYellow),
                title: const Text('Use Current Location'),
                subtitle: const Text('Enable location services'),
                onTap: () {
                  setState(() {
                    _selectedAddress = 'CURRENT';
                    _currentLocation = 'CURRENT - Detecting location...';
                  });
                  Navigator.pop(context);
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.home, color: AppTheme.green),
                title: const Text('HOME'),
                subtitle: const Text('Aniket Chakraborty, 238/2/2'),
                trailing: _selectedAddress == 'HOME'
                    ? const Icon(Icons.check_circle, color: AppTheme.green)
                    : null,
                onTap: () {
                  setState(() {
                    _selectedAddress = 'HOME';
                    _currentLocation = 'HOME - Aniket Chakraborty, 238/2/2';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.work, color: AppTheme.orange),
                title: const Text('WORK'),
                subtitle: const Text('Office Building, 45/A'),
                trailing: _selectedAddress == 'WORK'
                    ? const Icon(Icons.check_circle, color: AppTheme.green)
                    : null,
                onTap: () {
                  setState(() {
                    _selectedAddress = 'WORK';
                    _currentLocation = 'WORK - Office Building, 45/A';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.add_location_alt, color: AppTheme.primaryYellow),
                title: const Text('Add New Address'),
                onTap: () {
                  Navigator.pop(context);
                  _showAddAddressDialog();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddAddressDialog() {
    final addressController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Address'),
          content: TextField(
            controller: addressController,
            decoration: const InputDecoration(
              hintText: 'Enter your address',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (addressController.text.isNotEmpty) {
                  setState(() {
                    _selectedAddress = 'OTHER';
                    _currentLocation = 'OTHER - ${addressController.text}';
                  });
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryYellow,
              ),
              child: const Text('Save', style: TextStyle(color: AppTheme.black)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBackground : AppTheme.primaryYellow,
      body: _currentIndex == 0
          ? _buildHomeContent()
          : _currentIndex == 1
              ? const OrdersScreen()
              : _currentIndex == 2
                  ? const CategoriesScreen()
                  : _currentIndex == 3
                      ? const ProfileScreen()
                      : _buildComingSoon(),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: AppTheme.primaryYellow,
        unselectedItemColor: AppTheme.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.repeat),
            label: 'Order Again',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined),
            activeIcon: Icon(Icons.grid_view),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildComingSoon() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: Text(
          'Coming Soon',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppTheme.darkText
                : AppTheme.black,
          ),
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      children: [
        // Top Yellow Section
        Container(
          color: isDark ? AppTheme.darkSurface : AppTheme.primaryYellow,
          child: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: _showLocationPicker,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Anand Store',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDark ? AppTheme.darkText : AppTheme.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '14 minutes',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? AppTheme.darkText : AppTheme.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        _selectedAddress,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: isDark ? AppTheme.darkText : AppTheme.black,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          ' - ${_currentLocation.split(' - ').length > 1 ? _currentLocation.split(' - ')[1] : 'Select address'}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: isDark ? AppTheme.darkText : AppTheme.black,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(
                                        Icons.keyboard_arrow_down,
                                        size: 18,
                                        color: isDark ? AppTheme.darkText : AppTheme.black,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const CartScreen(),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Stack(
                                    children: [
                                      const Icon(
                                        Icons.shopping_bag_outlined,
                                        color: AppTheme.black,
                                        size: 24,
                                      ),
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: Consumer<CartProvider>(
                                          builder: (context, cart, child) {
                                            if (cart.itemCount == 0) {
                                              return const SizedBox();
                                            }
                                            return Container(
                                              padding: const EdgeInsets.all(2),
                                              decoration: const BoxDecoration(
                                                color: Colors.red,
                                                shape: BoxShape.circle,
                                              ),
                                              constraints: const BoxConstraints(
                                                minWidth: 16,
                                                minHeight: 16,
                                              ),
                                              child: Text(
                                                '${cart.itemCount}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _currentIndex = 3;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.person_outline,
                                    color: AppTheme.black,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Search Bar
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            hintText: 'Search "milk"',
                            hintStyle: TextStyle(color: AppTheme.grey),
                            prefixIcon: Icon(Icons.search, color: AppTheme.grey),
                            suffixIcon: Icon(Icons.mic, color: AppTheme.grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // White Content Section
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // Loading or Error State
                  if (_isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(
                          color: AppTheme.primaryYellow,
                        ),
                      ),
                    )
                  else if (_errorMessage != null)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 48,
                              color: AppTheme.grey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _errorMessage!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: AppTheme.grey,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadData,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryYellow,
                              ),
                              child: const Text(
                                'Retry',
                                style: TextStyle(color: AppTheme.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else ...[
                    // Category Sections - Only Food Related
                    _buildCategorySection(
                      'Foods & Groceries',
                      [
                        {'name': 'All', 'emoji': '🍽️'},
                        {'name': 'Fresh\nFoods', 'emoji': '🍕'},
                        {'name': 'Groceries &\nEssentials', 'emoji': '🛒'},
                        {'name': 'Sweets &\nDesserts', 'emoji': '🍰'},
                        {'name': 'Beverages', 'emoji': '🥤'},
                      ],
                    ),
                  ],

                  const SizedBox(height: 20),

                  // Welcome Banner
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppTheme.darkYellow,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'WELCOME',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Order now and enjoy great offers',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.black,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star,
                                color: AppTheme.primaryYellow,
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'OFFERS FOR YOU',
                                style: TextStyle(
                                  color: AppTheme.primaryYellow,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.star,
                                color: AppTheme.primaryYellow,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Products from Database
                  if (!_isLoading && _errorMessage == null) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Available Items',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.black,
                                ),
                              ),
                              if (_selectedCategory != null && _selectedCategory != 'All')
                                Container(
                                  margin: const EdgeInsets.only(top: 4),
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryYellow.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Filtered: $_selectedCategory',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: AppTheme.darkYellow,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      GestureDetector(
                                        onTap: () => _filterByCategory('All'),
                                        child: const Icon(
                                          Icons.close,
                                          size: 14,
                                          color: AppTheme.darkYellow,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          Text(
                            '${_filteredProducts.length} items',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppTheme.grey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Products Grid from Database
                    if (_filteredProducts.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Center(
                          child: Text(
                            'No items available',
                            style: TextStyle(
                              color: AppTheme.grey,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 0.68,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: _displayLimit.clamp(0, _filteredProducts.length),
                          itemBuilder: (context, index) {
                            return _buildProductCard(_filteredProducts[index]);
                          },
                        ),
                      ),

                    // Load more button
                    if (_filteredProducts.length > _displayLimit)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: ElevatedButton.icon(
                            onPressed: _loadMoreProducts,
                            icon: const Icon(Icons.expand_more),
                            label: Text('Load More (${_filteredProducts.length - _displayLimit} remaining)'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryYellow,
                              foregroundColor: AppTheme.black,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 24),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySection(
      String title, List<Map<String, String>> categories) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.black,
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: categories.map((cat) {
              final isSelected = _selectedCategory == cat['name'];
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    _filterByCategory(cat['name']!);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primaryYellow : AppTheme.offWhite,
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected 
                          ? Border.all(color: AppTheme.darkYellow, width: 2)
                          : null,
                    ),
                    child: Column(
                      children: [
                        Text(
                          cat['emoji']!,
                          style: const TextStyle(fontSize: 32),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          cat['name']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            color: isSelected ? Colors.white : AppTheme.black,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.lightGrey, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppTheme.offWhite,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: Stack(
                  children: [
                    if (product.image.startsWith('http'))
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: product.image,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          memCacheWidth: 400,
                          memCacheHeight: 400,
                          maxWidthDiskCache: 400,
                          maxHeightDiskCache: 400,
                          fadeInDuration: const Duration(milliseconds: 100),
                          fadeOutDuration: const Duration(milliseconds: 100),
                          placeholder: (context, url) => Container(
                            color: AppTheme.offWhite,
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: AppTheme.offWhite,
                            child: const Center(
                              child: Icon(
                                Icons.fastfood,
                                size: 40,
                                color: AppTheme.grey,
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      Center(
                        child: Text(
                          product.image.isNotEmpty ? product.image : '🍽️',
                          style: const TextStyle(fontSize: 40),
                        ),
                      ),
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Row(
                        children: [
                          if (product.badge != null && product.badge!.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.orange,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                product.badge!,
                                style: const TextStyle(
                                  fontSize: 8,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          if (product.discount != null && product.discount! > 0)
                            Container(
                              margin: const EdgeInsets.only(left: 4),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.green,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '${product.discount}% OFF',
                                style: const TextStyle(
                                  fontSize: 8,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const Positioned(
                      top: 6,
                      right: 6,
                      child: Icon(
                        Icons.favorite_border,
                        size: 18,
                        color: AppTheme.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Product Info
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (product.rating > 0)
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star, size: 10, color: AppTheme.green),
                              const SizedBox(width: 2),
                              Text(
                                '${product.rating}',
                                style: const TextStyle(
                                  fontSize: 8,
                                  color: AppTheme.green,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (product.reviews > 0) ...[
                                const SizedBox(width: 2),
                                Text(
                                  '(${product.reviews})',
                                  style: const TextStyle(
                                    fontSize: 7,
                                    color: AppTheme.grey,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 4),
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (product.description.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        product.description,
                        style: const TextStyle(
                          fontSize: 9,
                          color: AppTheme.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '₹${product.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.black,
                            ),
                          ),
                          if (product.discountPrice != null && product.discountPrice! > 0)
                            Text(
                              '₹${product.discountPrice!.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppTheme.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                        ],
                      ),
                      Consumer<CartProvider>(
                        builder: (context, cart, child) {
                          return GestureDetector(
                            onTap: () {
                              cart.addItem(product);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${product.name} added to cart'),
                                  duration: const Duration(seconds: 1),
                                  backgroundColor: AppTheme.green,
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppTheme.green,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.white,
                              ),
                              child: const Text(
                                'ADD',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.green,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
