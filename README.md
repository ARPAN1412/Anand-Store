# GoGrocer - Flutter Grocery App

A beautiful and modern grocery shopping Flutter application with a red and white color scheme.

## Features

- 🏠 **Home Screen** with categories and product grid
- 🔍 **Search Functionality** for finding products
- 📦 **Product Details** with images, ratings, and descriptions
- 🛒 **Shopping Cart** with quantity management
- 👤 **User Profile** with account settings
- 🎨 **Modern UI** with red and white theme
- 📱 **Responsive Design** for all screen sizes

## Screenshots

Check the `gogrocer ss` folder for app screenshots.

## Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Android Emulator or iOS Simulator

### Installation

1. Clone or navigate to this repository:
```bash
cd "c:\Users\ggod2\Videos\Restaurent Flutter"
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   ├── product.dart         # Product model and sample data
│   └── cart_item.dart       # Cart item model
├── providers/
│   └── cart_provider.dart   # Cart state management
├── screens/
│   ├── home_screen.dart     # Home page with products
│   ├── product_detail_screen.dart  # Product details
│   ├── cart_screen.dart     # Shopping cart
│   └── profile_screen.dart  # User profile
└── utils/
    └── app_theme.dart       # App theme and colors
```

## Features in Detail

### Home Screen
- Search bar for products
- Category filters (Vegetables, Fruits, Dairy, Bakery, etc.)
- Product grid with images, ratings, and prices
- Quick add to cart functionality
- Shopping cart badge with item count

### Product Detail Screen
- Large product image
- Product name, category, and rating
- Price per unit
- Stock status indicator
- Detailed description
- Product features
- Quantity controls
- Add to cart button

### Shopping Cart
- List of all cart items
- Quantity increment/decrement
- Remove item option
- Clear all items
- Subtotal calculation
- Delivery fee (FREE for orders above $50)
- Total amount
- Proceed to checkout

### Profile Screen
- User information display
- Order statistics
- Total spent
- Account settings menu
- Address management
- Payment methods
- Notifications
- Help center
- Privacy policy and terms

## Color Scheme

- **Primary Red**: `#E31E24`
- **Accent Red**: `#FF4444`
- **Light Red**: `#FFEBEE`
- **White**: `#FFFFFF`
- **Off White**: `#F5F5F5`

## Dependencies

- `provider`: ^6.0.5 - State management
- `google_fonts`: ^6.1.0 - Custom fonts
- `badges`: ^3.1.2 - Cart badge

## Customization

To customize the app:

1. **Colors**: Edit `lib/utils/app_theme.dart`
2. **Products**: Edit `lib/models/product.dart`
3. **Categories**: Edit the categories list in `product.dart`

## Future Enhancements

- User authentication
- Real backend integration
- Payment gateway
- Order tracking
- Product reviews and ratings
- Wishlist functionality
- Push notifications
- Multiple language support

## License

This project is created for educational purposes.

## Contact

For any queries or suggestions, feel free to reach out!
