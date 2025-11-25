import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../services/api_service.dart';
import 'category_products_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _categories = [];
  Map<String, int> _categoryItemCounts = {};
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final categories = await _apiService.getCategories();
      final menuItems = await _apiService.getMenuItems();
      
      // Count items per category
      Map<String, int> counts = {};
      for (var item in menuItems) {
        // Extract category name from the nested category object
        String categoryName = 'Other';
        if (item['category'] != null && item['category'] is Map) {
          categoryName = item['category']['name']?.toString() ?? 'Other';
        }
        counts[categoryName] = (counts[categoryName] ?? 0) + 1;
      }

      setState(() {
        _categories = categories;
        _categoryItemCounts = counts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load categories: $e';
        _isLoading = false;
      });
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
          'Categories',
          style: TextStyle(
            color: AppTheme.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppTheme.black),
            onPressed: () {
              // Search functionality
            },
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: isDark ? AppTheme.darkTextSecondary : AppTheme.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isDark ? AppTheme.darkText : AppTheme.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadCategories,
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
                )
              : RefreshIndicator(
                  onRefresh: _loadCategories,
                  color: AppTheme.primaryYellow,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Section
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: isDark ? AppTheme.darkSurface : AppTheme.primaryYellow.withOpacity(0.1),
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(24),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Explore Categories',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? AppTheme.darkText : AppTheme.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Browse through ${_categories.length} categories',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isDark ? AppTheme.darkTextSecondary : AppTheme.darkGrey,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Categories Grid
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1.1,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            itemCount: _categories.length,
                            itemBuilder: (context, index) {
                              final category = _categories[index];
                              
                              // Handle both Map<String, dynamic> and direct access
                              String categoryId;
                              String categoryName;
                              String categoryDesc;
                              
                              if (category is Map<String, dynamic>) {
                                categoryId = (category['id'] ?? '').toString();
                                categoryName = (category['name'] ?? 'Unknown').toString();
                                categoryDesc = (category['description'] ?? '').toString();
                              } else {
                                categoryId = '';
                                categoryName = 'Unknown';
                                categoryDesc = '';
                              }
                              
                              return _buildCategoryCard(
                                categoryId,
                                categoryName,
                                categoryDesc,
                                isDark,
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildCategoryCard(String id, String name, String description, bool isDark) {
    final itemCount = _categoryItemCounts[name] ?? 0;
    
    // Category icon mapping
    IconData getIconForCategory(String categoryName) {
      switch (categoryName.toLowerCase()) {
        case 'appetizers':
          return Icons.restaurant;
        case 'main course':
          return Icons.dinner_dining;
        case 'breads':
          return Icons.breakfast_dining;
        case 'desserts':
          return Icons.cake;
        case 'beverages':
          return Icons.local_cafe;
        case 'dairy':
          return Icons.emoji_food_beverage;
        case 'fruits & vegetables':
          return Icons.eco;
        case 'staples':
          return Icons.grain;
        case 'cooking essentials':
          return Icons.kitchen;
        case 'snacks':
          return Icons.fastfood;
        default:
          return Icons.category;
      }
    }

    // Category color mapping
    Color getColorForCategory(String categoryName) {
      switch (categoryName.toLowerCase()) {
        case 'appetizers':
          return Colors.orange;
        case 'main course':
          return Colors.red;
        case 'breads':
          return Colors.brown;
        case 'desserts':
          return Colors.pink;
        case 'beverages':
          return Colors.blue;
        case 'dairy':
          return Colors.lightBlue;
        case 'fruits & vegetables':
          return Colors.green;
        case 'staples':
          return Colors.amber;
        case 'cooking essentials':
          return Colors.deepOrange;
        case 'snacks':
          return Colors.purple;
        default:
          return AppTheme.primaryYellow;
      }
    }

    final categoryColor = getColorForCategory(name);
    final categoryIcon = getIconForCategory(name);

    return GestureDetector(
      onTap: () {
        // Navigate to category products screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryProductsScreen(
              categoryId: id,
              categoryName: name,
              categoryDescription: description,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: categoryColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                categoryIcon,
                size: 40,
                color: categoryColor,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppTheme.darkText : AppTheme.black,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$itemCount items',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppTheme.darkTextSecondary : AppTheme.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
