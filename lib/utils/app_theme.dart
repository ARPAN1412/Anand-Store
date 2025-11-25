import 'package:flutter/material.dart';

class AppTheme {
  // Primary Colors (Yellow/Golden theme like Blinkit)
  static const Color primaryYellow = Color(0xFFF8C200);
  static const Color accentYellow = Color(0xFFFFD700);
  static const Color lightYellow = Color(0xFFFFF8E1);
  static const Color darkYellow = Color(0xFFE6A500);
  
  // Secondary Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFFAFAFA);
  static const Color lightGrey = Color(0xFFE8E8E8);
  static const Color grey = Color(0xFF888888);
  static const Color darkGrey = Color(0xFF333333);
  static const Color black = Color(0xFF1A1A1A);
  static const Color brownAccent = Color(0xFF8B4513);
  
  // Status Colors
  static const Color success = Color(0xFF0DBF73);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color green = Color(0xFF0DBF73);
  static const Color orange = Color(0xFFFF6B35);
  
  // Dark Mode Colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF2C2C2C);
  static const Color darkText = Color(0xFFE0E0E0);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);
  
  // Light Theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryYellow,
    scaffoldBackgroundColor: offWhite,
    colorScheme: const ColorScheme.light(
      primary: primaryYellow,
      secondary: darkYellow,
      surface: white,
      background: offWhite,
      error: error,
    ),
    cardColor: white,
    appBarTheme: const AppBarTheme(
      backgroundColor: white,
      elevation: 0,
      iconTheme: IconThemeData(color: black),
      titleTextStyle: TextStyle(
        color: black,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    useMaterial3: true,
  );
  
  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryYellow,
    scaffoldBackgroundColor: darkBackground,
    colorScheme: const ColorScheme.dark(
      primary: primaryYellow,
      secondary: darkYellow,
      surface: darkSurface,
      background: darkBackground,
      error: error,
    ),
    cardColor: darkCard,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkSurface,
      elevation: 0,
      iconTheme: IconThemeData(color: darkText),
      titleTextStyle: TextStyle(
        color: darkText,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    useMaterial3: true,
  );
  
  // Text Styles
  static const TextStyle heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: black,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: black,
  );
  
  static const TextStyle heading3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: black,
  );
  
  static const TextStyle bodyText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: darkGrey,
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: grey,
  );
  
  // Button Styles
  static ButtonStyle primaryButton = ElevatedButton.styleFrom(
    backgroundColor: primaryYellow,
    foregroundColor: black,
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 0,
  );
  
  static ButtonStyle outlineButton = OutlinedButton.styleFrom(
    foregroundColor: green,
    side: const BorderSide(color: green, width: 1.5),
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  );
  
  static ButtonStyle addButton = ElevatedButton.styleFrom(
    backgroundColor: white,
    foregroundColor: green,
    side: const BorderSide(color: green, width: 1),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    elevation: 0,
  );
  
  // Border Radius
  static BorderRadius smallRadius = BorderRadius.circular(8);
  static BorderRadius mediumRadius = BorderRadius.circular(12);
  static BorderRadius largeRadius = BorderRadius.circular(16);
  
  // Shadows
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];
}
