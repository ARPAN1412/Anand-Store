import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_theme.dart';
import '../providers/theme_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showThemeSelector(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose Theme',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.light_mode),
                title: const Text('Light Mode'),
                trailing: themeProvider.themeMode == ThemeMode.light
                    ? const Icon(Icons.check, color: AppTheme.green)
                    : null,
                onTap: () {
                  themeProvider.setThemeMode(ThemeMode.light);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.dark_mode),
                title: const Text('Dark Mode'),
                trailing: themeProvider.themeMode == ThemeMode.dark
                    ? const Icon(Icons.check, color: AppTheme.green)
                    : null,
                onTap: () {
                  themeProvider.setThemeMode(ThemeMode.dark);
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
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
          'Profile',
          style: TextStyle(
            color: AppTheme.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: AppTheme.primaryYellow,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: AppTheme.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Arpan Ganguly',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.phone, size: 14, color: AppTheme.darkGrey),
                      SizedBox(width: 4),
                      Text(
                        '7980245158',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.darkGrey,
                        ),
                      ),
                      SizedBox(width: 16),
                      Icon(Icons.cake, size: 14, color: AppTheme.darkGrey),
                      SizedBox(width: 4),
                      Text(
                        '14 Dec 2000',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.darkGrey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Quick Actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildQuickAction(
                      icon: Icons.shopping_basket_outlined,
                      title: 'Your orders',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildQuickAction(
                      icon: Icons.account_balance_wallet_outlined,
                      title: 'Anand Store',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildQuickAction(
                      icon: Icons.help_outline,
                      title: 'Need help?',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Appearance
            GestureDetector(
              onTap: () => _showThemeSelector(context),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.brightness_6_outlined,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppTheme.darkTextSecondary
                              : AppTheme.grey,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Appearance',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? AppTheme.darkText
                                : AppTheme.black,
                          ),
                        ),
                      ],
                    ),
                    Consumer<ThemeProvider>(
                      builder: (context, themeProvider, _) {
                        return Row(
                          children: [
                            Text(
                              themeProvider.themeName,
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? AppTheme.darkTextSecondary
                                    : AppTheme.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? AppTheme.darkTextSecondary
                                  : AppTheme.grey,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Hide Sensitive Items
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.remove_red_eye_outlined,
                      color: AppTheme.green,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hide sensitive items',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? AppTheme.darkText
                                : AppTheme.black,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Sexual wellness, nicotine products and other\nsensitive items will be hidden',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.grey,
                            height: 1.3,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Know more',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.green,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Your Information Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Your information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.black,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            _buildMenuItem(
              icon: Icons.location_on_outlined,
              title: 'Address book',
            ),
            _buildMenuItem(
              icon: Icons.menu_book_outlined,
              title: 'Bookmarked recipes',
            ),
            _buildMenuItem(
              icon: Icons.favorite_border,
              title: 'Your wishlist',
            ),
            _buildMenuItem(
              icon: Icons.receipt_long_outlined,
              title: 'GST details',
            ),
            _buildMenuItem(
              icon: Icons.card_giftcard_outlined,
              title: 'E-gift cards',
            ),
            _buildMenuItem(
              icon: Icons.medical_services_outlined,
              title: 'Your prescriptions',
            ),

            const SizedBox(height: 20),

            // Payment and Coupons Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Payment and coupons',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.black,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            _buildMenuItem(
              icon: Icons.account_balance_wallet_outlined,
              title: 'Wallet',
            ),
            _buildMenuItem(
              icon: Icons.account_balance_wallet_outlined,
              title: 'Anand Store',
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction({required IconData icon, required String title}) {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 28,
                color: isDark ? AppTheme.darkText : AppTheme.black,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppTheme.darkText : AppTheme.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
  }) {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          margin: const EdgeInsets.only(bottom: 8, left: 16, right: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Icon(
              icon,
              color: isDark ? AppTheme.darkTextSecondary : AppTheme.grey,
              size: 24,
            ),
            title: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: isDark ? AppTheme.darkText : AppTheme.black,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: isDark ? AppTheme.darkTextSecondary : AppTheme.grey,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
          ),
        );
      },
    );
  }
}
