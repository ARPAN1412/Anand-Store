# Flutter Installation and Setup Guide for Windows

## Step 1: Install Flutter SDK

### Option A: Using Winget (Recommended - Easiest)
Open PowerShell as Administrator and run:
```powershell
winget install --id=Google.Flutter -e
```

### Option B: Manual Installation
1. Download Flutter SDK from: https://docs.flutter.dev/get-started/install/windows
2. Extract to: `C:\src\flutter` (or your preferred location)
3. Add Flutter to PATH:
   - Search "Environment Variables" in Windows
   - Edit "Path" under System Variables
   - Add: `C:\src\flutter\bin`
   - Restart terminal/VS Code

## Step 2: Verify Installation

After installation, close and reopen your terminal, then run:
```powershell
flutter --version
flutter doctor
```

## Step 3: Install Dependencies

The `flutter doctor` command will show what's missing. Typically you need:

### Android Studio (for Android development)
```powershell
winget install --id=Google.AndroidStudio -e
```

Or download from: https://developer.android.com/studio

### Visual Studio (for Windows development)
```powershell
winget install --id=Microsoft.VisualStudio.2022.Community -e
```

### Git (if not installed)
```powershell
winget install --id=Git.Git -e
```

## Step 4: Accept Android Licenses

After installing Android Studio:
```powershell
flutter doctor --android-licenses
```
Press 'y' to accept all licenses.

## Step 5: Install Project Dependencies

Once Flutter is installed, navigate to the project and run:
```powershell
cd "c:\Users\ggod2\Videos\Restaurent Flutter"
flutter pub get
```

## Step 6: Run the App

### For Android:
1. Open Android Studio
2. Open AVD Manager (Tools > Device Manager)
3. Create/Start a virtual device
4. Run: `flutter run`

### For Web:
```powershell
flutter run -d chrome
```

### For Windows:
```powershell
flutter run -d windows
```

## Quick Command Summary

```powershell
# Install Flutter (Administrator PowerShell)
winget install --id=Google.Flutter -e

# After installation (close/reopen terminal)
flutter --version
flutter doctor

# Install Android Studio
winget install --id=Google.AndroidStudio -e

# Accept licenses
flutter doctor --android-licenses

# Install project dependencies
cd "c:\Users\ggod2\Videos\Restaurent Flutter"
flutter pub get

# Run the app
flutter run
```

## Troubleshooting

### "flutter command not found" after installation
- Close and reopen your terminal/VS Code
- Verify PATH was added correctly
- Log out and log back in to Windows

### "cmdline-tools component is missing"
Open Android Studio:
- Go to Settings > Languages & Frameworks > Android SDK
- SDK Tools tab
- Check "Android SDK Command-line Tools"
- Click Apply

### "Android licenses not accepted"
```powershell
flutter doctor --android-licenses
```

## VS Code Setup (Optional but Recommended)

Install VS Code extensions:
1. Flutter (includes Dart)
2. Android iOS Emulator

Then press F5 to run the app directly from VS Code!

---

**Need Help?** Run `flutter doctor -v` for detailed diagnostics.
