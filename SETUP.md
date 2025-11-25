# Setup Instructions for GoGrocer Flutter App

## Prerequisites Check

Before running this app, make sure you have Flutter installed. Check by running:
```bash
flutter --version
```

If Flutter is not installed, download it from: https://docs.flutter.dev/get-started/install/windows

## Steps to Run the App

### 1. Install Dependencies

Open a terminal in this project directory and run:
```bash
flutter pub get
```

### 2. Check for Connected Devices

Ensure you have a device/emulator connected:
```bash
flutter devices
```

### 3. Run the App

To run the app:
```bash
flutter run
```

Or use VS Code:
- Press F5, or
- Click "Run > Start Debugging" from the menu

### 4. For Web (Optional)

To run on Chrome:
```bash
flutter run -d chrome
```

## Troubleshooting

### Flutter command not found
- Make sure Flutter is added to your system PATH
- Restart your terminal/VS Code after installing Flutter

### Dependencies Error
- Run: `flutter clean`
- Then: `flutter pub get`

### Android SDK Issues
- Make sure Android Studio is installed
- Run: `flutter doctor`
- Follow the instructions to fix any issues

### iOS Issues (Mac only)
- Make sure Xcode is installed
- Run: `flutter doctor`
- Accept Xcode license if prompted

## Quick Start Commands

```bash
# Navigate to project directory
cd "c:\Users\ggod2\Videos\Restaurent Flutter"

# Get dependencies
flutter pub get

# Run on connected device
flutter run

# Run on specific device
flutter run -d <device-id>

# Build APK (Android)
flutter build apk

# Build for web
flutter build web
```

## Project Features

✅ Home screen with product categories
✅ Search functionality
✅ Product detail page
✅ Shopping cart with quantity controls
✅ Profile screen with user settings
✅ Red and white color theme
✅ Responsive design
✅ State management with Provider

## Color Scheme

- Primary Red: #E31E24
- White: #FFFFFF
- Clean and modern design

Enjoy building with GoGrocer! 🛒🍎
