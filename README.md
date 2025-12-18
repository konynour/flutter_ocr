# Flutter OCR Scanner App 📱

A complete Flutter application for extracting, enhancing, translating, and converting text using **Google ML Kit**, **TTS**, **QR/Barcode Scanning**, **Image Cropping**, and **PDF Exporting**.  

The app provides a smooth end-to-end workflow: **capture → crop → process → recognize → translate → read aloud → export**.

The project follows a **feature-based architecture** for better organization, scalability, and maintainability.

---

## 🚀 Features

### 🔍 OCR & Text Recognition
- Extract text from images using Google ML Kit
- Supports multilingual OCR (Arabic, English, French, Spanish, German, etc.)
- Live camera preview with scanning animation
- High accuracy text recognition with ML Kit Latin script support
- Copy recognized text to clipboard
- Display line count and detection statistics
- **Quick enhance button** for instant image improvement

### ✂️ Image Cropping (NEW!)
- Crop images before processing for better accuracy
- Rotate images left/right
- Multiple aspect ratios (Free, Square, 4:3, 16:9)
- Real-time crop preview
- Smooth, intuitive interface
- Integrated into the capture workflow

### 💳 Card Scanner
- Extract entities from business cards and documents
- Automatic detection of:
  - Phone numbers
  - Email addresses
  - Physical addresses
  - URLs and websites
  - Names and other entities
- One-tap copy functionality for each detected entity
- Smart icon mapping for different entity types

### 🖼 Image Enhancement
- Adjust contrast (80-200 range)
- Modify brightness (1-10 scale)
- Real-time preview of adjustments
- Save enhanced images to gallery
- Reset to default values
- Visual sliders with precise value display
- **Accessible from recognizer screen** for quick edits

### 🌐 Translation
- Translate recognized text between multiple languages:
  - Arabic, English, French, Spanish, German
  - Italian, Portuguese, Russian, Chinese, Japanese
- Smooth UI for switching languages
- Preserve formatting in translations
- Copy translated text to clipboard

### 🔊 Text-to-Speech (TTS)
- Read recognized or translated text aloud
- Multi-language voice support:
  - English (US), Arabic (SA), French (FR), Spanish (ES), German (DE)
- Adjustable speech rate and pitch
- Play/Stop controls with visual feedback
- Works with both original and translated text

### 📷 QR & Barcode Scanner
- Scan QR codes and barcodes from images
- Supports multiple barcode types:
  - QR Codes, URLs, WiFi credentials
  - Email addresses, Phone numbers, SMS
  - Contact information, Calendar events
  - Product barcodes (EAN, UPC, etc.)
- One-tap copy functionality
- Smart type detection with custom icons

### 📄 Export System
- **Export as PDF (Image)**: Preserve original image in PDF format
- **Export as PDF (Text)**: Clean text-only PDF document
- **Export as TXT**: Plain text file export
- Share exported files via system share sheet
- Automatic file naming with timestamps
- Temporary file management

### 🎨 Modern UI/UX
- Beautiful Material Design 3 interface
- **Full dark mode support with persistence** (NEW!)
- Theme preference saved locally
- Smooth animations using flutter_animate
- Glassmorphism effects and gradient accents
- Responsive design for all screen sizes
- Consistent design language across all screens
- Custom themed components and widgets

### 💾 Theme Persistence (NEW!)
- Automatically saves your theme preference (Dark/Light mode)
- Remembers your choice across app restarts
- Uses local storage (SharedPreferences)
- Seamless experience with no flash on startup

---

## 📦 Technologies & Packages

### Core
- **Flutter SDK** (>=3.2.6 <4.0.0)
- **Dart**
- **Provider** (State Management)

### ML Kit & Recognition
- **google_mlkit_text_recognition** (^0.15.0) - Text OCR
- **google_mlkit_entity_extraction** (^0.15.1) - Entity detection
- **google_mlkit_barcode_scanning** (^0.14.1) - QR/Barcode scanning

### Camera & Image Processing
- **camera** (^0.11.3) - Camera access
- **image_picker** (^1.2.1) - Gallery picker
- **image** (^4.5.4) - Image manipulation
- **crop_your_image** (^2.0.0) - Image cropping (NEW!)
- **image_gallery_saver_plus** (^4.0.1) - Save to gallery

### Text Processing
- **flutter_tts** (^4.2.3) - Text-to-Speech
- **translator** (^1.0.4+1) - Translation service

### File Operations
- **path_provider** (^2.1.5) - File system paths
- **pdf** (^3.11.3) - PDF generation
- **share_plus** (^12.0.1) - Share functionality

### Storage
- **shared_preferences** (^2.2.2) - Local data persistence (NEW!)

### UI/UX
- **flutter_animate** (^4.5.2) - Animations
- **url_launcher** (^6.3.2) - URL handling

---

## 📁 Project Structure (Feature-Based Architecture)

```
lib/
├── main.dart                          # App entry point
├── core/                              # Core app functionality
│   ├── providers/
│   │   └── theme_provider.dart        # Theme state + persistence
│   ├── constants/
│   │   └── app_constants.dart         # App-wide constants
│   └── utils/
│       └── helpers.dart               # Helper functions & utilities
│
├── features/                          # Feature modules
│   ├── home/
│   │   └── home_screen.dart           # Main camera & mode selection
│   ├── text_recognition/
│   │   └── recognizer_screen.dart     # Text OCR screen
│   ├── card_scanner/
│   │   └── card_scanner.dart          # Business card scanning
│   ├── qr_scanner/
│   │   └── scan_qr.dart               # QR/Barcode scanning
│   ├── image_enhancement/
│   │   └── enhance_screen.dart        # Image adjustments
│   └── text_to_speech/
│       └── tts_screen.dart            # TTS & Translation
│
└── shared/                            # Shared components
    ├── widgets/
    │   ├── loading_indicator.dart     # Reusable loading widget
    │   ├── text_card.dart             # Text display card
    │   ├── custom_button.dart         # Custom button widgets
    │   └── image_cropper_widget.dart  # Image cropping widget (NEW!)
    └── models/
        ├── entity_model.dart          # Entity data model
        └── barcode_model.dart         # Barcode data model
```

### Architecture Benefits
✅ **Feature Isolation**: Each feature is self-contained  
✅ **Reusability**: Shared widgets and models reduce duplication  
✅ **Scalability**: Easy to add new features without affecting existing code  
✅ **Maintainability**: Clear structure makes debugging easier  
✅ **Team Collaboration**: Multiple developers can work on different features  
✅ **Testing**: Isolated features are easier to test

---

## 🔧 Installation & Setup

### 1. Prerequisites
- Flutter SDK (>=3.2.6)
- Android Studio / VS Code
- Android SDK (for Android development)
- Xcode (for iOS development)

### 2. Clone the repository
```bash
git clone https://github.com/konynour/flutter_ocr.git
cd flutter_ocr
```

### 3. Install dependencies
```bash
flutter clean
flutter pub get
```

### 4. Android Setup

#### Minimum SDK Version
Edit `android/app/build.gradle`:
```gradle
android {
    defaultConfig {
        minSdkVersion 21  // Required for ML Kit
        targetSdkVersion 34
    }
}
```

#### Permissions
Ensure these are in `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.INTERNET" />
```

#### Optional: ML Kit Language Models
If you need additional language support, add to `android/app/build.gradle`:
```gradle
dependencies {
    implementation 'com.google.mlkit:text-recognition:16.0.0'
    // Add other language models if needed
    // implementation 'com.google.mlkit:text-recognition-chinese:16.0.0'
    // implementation 'com.google.mlkit:text-recognition-japanese:16.0.0'
    // implementation 'com.google.mlkit:text-recognition-korean:16.0.0'
}
```

### 5. iOS Setup

Add to `ios/Runner/Info.plist`:
```xml
<key>NSCameraUsageDescription</key>
<string>Camera access is required for scanning documents</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Photo library access is required to select images</string>
<key>NSPhotoLibraryAddUsageDescription</key>
<string>Photo library access is required to save images</string>
```

---

## ▶️ Run the App

### Debug Mode:
```bash
flutter run
```

### Release Mode:
```bash
flutter run --release
```

### Specific Device:
```bash
flutter devices
flutter run -d <device-id>
```

---

## 🛠 Build APK/AAB

### Build APK (for distribution):
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

### Build App Bundle (for Play Store):
```bash
flutter build appbundle --release
```
Output: `build/app/outputs/bundle/release/app-release.aab`

### Build for specific architecture:
```bash
flutter build apk --split-per-abi
```

---

## 📱 App Workflow

1. **Home Screen**: Choose scanning mode (Card, Text, QR, Enhance)
2. **Capture/Select**: Use camera or pick from gallery
3. **Crop Image**: Adjust crop area, rotate if needed (NEW!)
4. **Process**: Image is automatically processed
5. **Results**: View recognized text/entities/barcodes
6. **Actions**: 
   - Copy to clipboard
   - Enhance image (NEW!)
   - Translate (if applicable)
   - Read aloud with TTS
   - Export as PDF/TXT
   - Share or save

---

## 🎨 Customization

### Theme Configuration
Edit `lib/core/providers/theme_provider.dart` to customize colors:
```dart
// Light Theme Colors
static const Color lightPrimary = Color(0xFF2196F3);
static const Color lightBackground = Color(0xFFF5F7FA);

// Dark Theme Colors
static const Color darkPrimary = Color(0xFF42A5F5);
static const Color darkBackground = Color(0xFF121212);
```

### Constants
Edit `lib/core/constants/app_constants.dart` for app-wide settings:
```dart
class AppConstants {
  static const String appName = 'OCR Scanner';
  static const double borderRadius = 16.0;
  // Add your custom constants
}
```

---

## 🐞 Known Issues & Roadmap

### Current Known Issues

#### 🔊 TTS Language Switching
- **Issue**: After translating to Arabic, TTS continues playing in Arabic even when English is selected
- **Cause**: TTS engine state not properly reset between language changes
- **Workaround**: Restart the app to reset TTS state
- **Fix Status**: 🔄 In Progress

#### 📍 Geo Location Parsing
- **Issue**: `geo:` URL format in QR codes not properly supported by ML Kit
- **Cause**: ML Kit limitation + missing custom parser
- **Workaround**: Code is commented out
- **Fix Status**: 📋 Planned

---

### Roadmap

#### Recent Updates (v1.1) ✅
- [x] Image cropping with rotation
- [x] Theme persistence with local storage
- [x] Enhance button in recognizer screen
- [x] Feature-based architecture
- [x] Improved error handling

#### Short Term (v1.2)
- [ ] Fix TTS language switching bug
- [ ] Add more crop aspect ratios
- [ ] Add proper routing with named routes
- [ ] Add loading states for all async operations
- [ ] Implement batch processing

#### Medium Term (v1.3)
- [ ] Add OCR history feature
- [ ] Support for more barcode formats
- [ ] Custom geo-location parser for QR codes
- [ ] Add unit and widget tests
- [ ] Document scanning mode (multi-page)

#### Long Term (v2.0)
- [ ] Cloud sync for OCR history
- [ ] Advanced image filters
- [ ] Handwriting recognition
- [ ] Receipt/Invoice parsing
- [ ] Multi-language UI support
- [ ] Offline translation support
- [ ] Custom ML model training

---

## 🧪 Testing

### Run tests:
```bash
flutter test
```

### Test coverage:
```bash
flutter test --coverage
```

### Integration tests:
```bash
flutter drive --target=test_driver/app.dart
```

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Contribution Guidelines
- Follow the existing code style
- Write clear commit messages
- Add tests for new features
- Update documentation as needed
- Ensure all tests pass before submitting

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

**Nour Kontar**
- GitHub: [@konynour](https://github.com/konynour)
- Project Link: [https://github.com/konynour/flutter_ocr](https://github.com/konynour/flutter_ocr)

---

## 🙏 Acknowledgments

- [Google ML Kit](https://developers.google.com/ml-kit) - Machine Learning APIs
- [Flutter Team](https://flutter.dev) - Amazing framework
- [pub.dev](https://pub.dev) - Package repository
- All open-source contributors

---

## 📞 Support

If you encounter any issues or have questions:
1. Check the [Issues](https://github.com/konynour/flutter_ocr/issues) page
2. Create a new issue with detailed information
3. Include screenshots and error logs
4. Specify your Flutter version and device

---

## ⭐ Show Your Support

If you find this project useful, please consider:
- ⭐ Starring the repository
- 🐛 Reporting bugs
- 💡 Suggesting new features
- 🤝 Contributing to the code
- 📢 Sharing with others

---

## 📸 Screenshots

### Light Mode
![Home Screen](screenshots/home_light.png)
![Text Recognition](screenshots/recognition_light.png)
![Image Cropping](screenshots/crop_light.png)

### Dark Mode
![Home Screen](screenshots/home_dark.png)
![Text Recognition](screenshots/recognition_dark.png)
![Image Enhancement](screenshots/enhance_dark.png)

---

## 🎯 Feature Highlights

### ✂️ Image Cropping
Perfect your scans with:
- Free-form and fixed aspect ratios
- 90° rotation in both directions
- Real-time preview
- Smooth animations

### 💾 Theme Persistence
Your preferences matter:
- Automatically saves dark/light mode
- Instant load on app restart
- No flash or flicker
- Seamless experience

### 🎨 Enhanced Workflow
Boost your productivity:
- Quick enhance from any screen
- One-tap copy for all results
- Fast mode switching
- Intuitive navigation

---

**Made with ❤️ using Flutter**

Version: 1.1.0 | Last Updated: December 2024

### 💳 Card Scanner
- Extract entities from business cards and documents
- Automatic detection of:
  - Phone numbers
  - Email addresses
  - Physical addresses
  - URLs and websites
  - Names and other entities
- One-tap copy functionality for each detected entity
- Smart icon mapping for different entity types

### 🖼 Image Enhancement
- Adjust contrast (80-200 range)
- Modify brightness (1-10 scale)
- Real-time preview of adjustments
- Save enhanced images to gallery
- Reset to default values
- Visual sliders with precise value display

### 🌐 Translation
- Translate recognized text between multiple languages:
  - Arabic, English, French, Spanish, German
  - Italian, Portuguese, Russian, Chinese, Japanese
- Smooth UI for switching languages
- Preserve formatting in translations
- Copy translated text to clipboard

### 🔊 Text-to-Speech (TTS)
- Read recognized or translated text aloud
- Multi-language voice support:
  - English (US), Arabic (SA), French (FR), Spanish (ES), German (DE)
- Adjustable speech rate and pitch
- Play/Stop controls with visual feedback
- Works with both original and translated text

### 📷 QR & Barcode Scanner
- Scan QR codes and barcodes from images
- Supports multiple barcode types:
  - QR Codes, URLs, WiFi credentials
  - Email addresses, Phone numbers, SMS
  - Contact information, Calendar events
  - Product barcodes (EAN, UPC, etc.)
- One-tap copy functionality
- Smart type detection with custom icons

### 📄 Export System
- **Export as PDF (Image)**: Preserve original image in PDF format
- **Export as PDF (Text)**: Clean text-only PDF document
- **Export as TXT**: Plain text file export
- Share exported files via system share sheet
- Automatic file naming with timestamps
- Temporary file management

### 🎨 Modern UI/UX
- Beautiful Material Design 3 interface
- Full dark mode support with custom color schemes
- Smooth animations using flutter_animate
- Glassmorphism effects and gradient accents
- Responsive design for all screen sizes
- Consistent design language across all screens
- Custom themed components and widgets

---

## 📦 Technologies & Packages

### Core
- **Flutter SDK** (>=3.2.6 <4.0.0)
- **Dart**
- **Provider** (State Management)

### ML Kit & Recognition
- **google_mlkit_text_recognition** (^0.15.0) - Text OCR
- **google_mlkit_entity_extraction** (^0.15.1) - Entity detection
- **google_mlkit_barcode_scanning** (^0.14.1) - QR/Barcode scanning

### Camera & Image Processing
- **camera** (^0.11.3) - Camera access
- **image_picker** (^1.2.1) - Gallery picker
- **image** (^4.5.4) - Image manipulation
- **crop_your_image** (^2.0.0) - Image cropping
- **image_gallery_saver_plus** (^4.0.1) - Save to gallery

### Text Processing
- **flutter_tts** (^4.2.3) - Text-to-Speech
- **translator** (^1.0.4+1) - Translation service

### File Operations
- **path_provider** (^2.1.5) - File system paths
- **pdf** (^3.11.3) - PDF generation
- **share_plus** (^12.0.1) - Share functionality

### UI/UX
- **flutter_animate** (^4.5.2) - Animations
- **url_launcher** (^6.3.2) - URL handling

---

## 📁 Project Structure (Feature-Based Architecture)

```
lib/
├── main.dart                          # App entry point
├── core/                              # Core app functionality
│   ├── providers/
│   │   └── theme_provider.dart        # Theme state management
│   ├── constants/
│   │   └── app_constants.dart         # App-wide constants
│   └── utils/
│       └── helpers.dart               # Helper functions & utilities
│
├── features/                          # Feature modules
│   ├── home/
│   │   └── home_screen.dart           # Main camera & mode selection
│   ├── text_recognition/
│   │   └── recognizer_screen.dart     # Text OCR screen
│   ├── card_scanner/
│   │   └── card_scanner.dart          # Business card scanning
│   ├── qr_scanner/
│   │   └── scan_qr.dart               # QR/Barcode scanning
│   ├── image_enhancement/
│   │   └── enhance_screen.dart        # Image adjustments
│   └── text_to_speech/
│       └── tts_screen.dart            # TTS & Translation
│
└── shared/                            # Shared components
    ├── widgets/
    │   ├── loading_indicator.dart     # Reusable loading widget
    │   ├── text_card.dart             # Text display card
    │   └── custom_button.dart         # Custom button widgets
    └── models/
        ├── entity_model.dart          # Entity data model
        └── barcode_model.dart         # Barcode data model
```

### Architecture Benefits
✅ **Feature Isolation**: Each feature is self-contained  
✅ **Reusability**: Shared widgets and models reduce duplication  
✅ **Scalability**: Easy to add new features without affecting existing code  
✅ **Maintainability**: Clear structure makes debugging easier  
✅ **Team Collaboration**: Multiple developers can work on different features  
✅ **Testing**: Isolated features are easier to test

---

## 🔧 Installation & Setup

### 1. Prerequisites
- Flutter SDK (>=3.2.6)
- Android Studio / VS Code
- Android SDK (for Android development)
- Xcode (for iOS development)

### 2. Clone the repository
```bash
git clone https://github.com/konynour/flutter_ocr.git
cd flutter_ocr
```

### 3. Install dependencies
```bash
flutter clean
flutter pub get
```

### 4. Android Setup

#### Minimum SDK Version
Edit `android/app/build.gradle`:
```gradle
android {
    defaultConfig {
        minSdkVersion 21  // Required for ML Kit
        targetSdkVersion 34
    }
}
```

#### Permissions
Ensure these are in `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.INTERNET" />
```

#### Optional: ML Kit Language Models
If you need additional language support, add to `android/app/build.gradle`:
```gradle
dependencies {
    implementation 'com.google.mlkit:text-recognition:16.0.0'
    // Add other language models if needed
    // implementation 'com.google.mlkit:text-recognition-chinese:16.0.0'
    // implementation 'com.google.mlkit:text-recognition-japanese:16.0.0'
    // implementation 'com.google.mlkit:text-recognition-korean:16.0.0'
}
```

### 5. iOS Setup

Add to `ios/Runner/Info.plist`:
```xml
<key>NSCameraUsageDescription</key>
<string>Camera access is required for scanning documents</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Photo library access is required to select images</string>
<key>NSPhotoLibraryAddUsageDescription</key>
<string>Photo library access is required to save images</string>
```

---

## ▶️ Run the App

### Debug Mode:
```bash
flutter run
```

### Release Mode:
```bash
flutter run --release
```

### Specific Device:
```bash
flutter devices
flutter run -d <device-id>
```

---

## 🛠 Build APK/AAB

### Build APK (for distribution):
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

### Build App Bundle (for Play Store):
```bash
flutter build appbundle --release
```
Output: `build/app/outputs/bundle/release/app-release.aab`

### Build for specific architecture:
```bash
flutter build apk --split-per-abi
```

---

## 📱 App Workflow

1. **Home Screen**: Choose scanning mode (Card, Text, QR, Enhance)
2. **Capture/Select**: Use camera or pick from gallery
3. **Process**: Image is automatically processed
4. **Results**: View recognized text/entities/barcodes
5. **Actions**: 
   - Copy to clipboard
   - Translate (if applicable)
   - Read aloud with TTS
   - Export as PDF/TXT
   - Share or save

---

## 🎨 Customization

### Theme Configuration
Edit `lib/core/providers/theme_provider.dart` to customize colors:
```dart
// Light Theme Colors
static const Color lightPrimary = Color(0xFF2196F3);
static const Color lightBackground = Color(0xFFF5F7FA);

// Dark Theme Colors
static const Color darkPrimary = Color(0xFF42A5F5);
static const Color darkBackground = Color(0xFF121212);
```

### Constants
Edit `lib/core/constants/app_constants.dart` for app-wide settings:
```dart
class AppConstants {
  static const String appName = 'OCR Scanner';
  static const double borderRadius = 16.0;
  // Add your custom constants
}
```

---

## 🐞 Known Issues & Roadmap

### Current Known Issues

#### 🔊 TTS Language Switching
- **Issue**: After translating to Arabic, TTS continues playing in Arabic even when English is selected
- **Cause**: TTS engine state not properly reset between language changes
- **Workaround**: Restart the app to reset TTS state
- **Fix Status**: 🔄 In Progress

#### 📍 Geo Location Parsing
- **Issue**: `geo:` URL format in QR codes not properly supported by ML Kit
- **Cause**: ML Kit limitation + missing custom parser
- **Workaround**: Code is commented out
- **Fix Status**: 📋 Planned

#### 🖼 Image Cropping
- **Issue**: `image_editor_plus` package dependency conflict
- **Cause**: Missing `reorderables` transitive dependency
- **Workaround**: Cropping feature temporarily disabled
- **Fix Status**: ✅ Alternative solution available (crop_your_image)

### Roadmap

#### Short Term (v1.1)
- [ ] Fix TTS language switching bug
- [ ] Implement image cropping with crop_your_image
- [ ] Add proper routing with named routes
- [ ] Improve error handling across all screens
- [ ] Add loading states for all async operations

#### Medium Term (v1.2)
- [ ] Add OCR history feature
- [ ] Implement batch processing
- [ ] Add document scanning mode (multi-page)
- [ ] Support for more barcode formats
- [ ] Custom geo-location parser for QR codes
- [ ] Add unit and widget tests

#### Long Term (v2.0)
- [ ] Cloud sync for OCR history
- [ ] Advanced image filters
- [ ] Handwriting recognition
- [ ] Receipt/Invoice parsing
- [ ] Multi-language UI support
- [ ] Offline translation support
- [ ] Custom ML model training

---

## 🧪 Testing

### Run tests:
```bash
flutter test
```

### Test coverage:
```bash
flutter test --coverage
```

### Integration tests:
```bash
flutter drive --target=test_driver/app.dart
```

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Contribution Guidelines
- Follow the existing code style
- Write clear commit messages
- Add tests for new features
- Update documentation as needed
- Ensure all tests pass before submitting

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

**Yosef Elsersy**
- GitHub: [@yosefelsersy](https://github.com/YosefElsersy)
- Project Link: [https://github.com/konynour/flutter_ocr](https://github.com/konynour/flutter_ocr)

<<<<<<< HEAD


**Nour kony**
=======
**Nour Kony**
>>>>>>> origin/main
- GitHub: [@konynour](https://github.com/konynour)
- Project Link: [https://github.com/konynour/flutter_ocr](https://github.com/konynour/flutter_ocr)

---

## 🙏 Acknowledgments

- [Google ML Kit](https://developers.google.com/ml-kit) - Machine Learning APIs
- [Flutter Team](https://flutter.dev) - Amazing framework
- [pub.dev](https://pub.dev) - Package repository
- All open-source contributors

---

## 📞 Support

If you encounter any issues or have questions:
1. Check the [Issues](https://github.com/konynour/flutter_ocr/issues) page
2. Create a new issue with detailed information
3. Include screenshots and error logs
4. Specify your Flutter version and device

---

## ⭐ Show Your Support

If you find this project useful, please consider:
- ⭐ Starring the repository
- 🐛 Reporting bugs
- 💡 Suggesting new features
- 🤝 Contributing to the code
- 📢 Sharing with others

---

**Made with ❤️ using Flutter**
