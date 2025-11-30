```markdown
# Flutter OCR App

A simple and lightweight Flutter application for extracting text from images using **Google ML Kit Text Recognition**.  
The app allows users to pick an image, scan it, and display the recognized text with high accuracy.  
Supports multiple languages depending on the ML Kit packages used.

---

## 🚀 Features

- Capture image from camera or choose from gallery  
- Extract text using Google ML Kit  
- Multilingual text recognition (Chinese, Japanese, Korean, Devanagari… etc.)  
- Clean and minimal UI  
- Ability to copy extracted text  
- Works on Android (iOS can be supported with additional setup)

---

## 📦 Technologies Used

- **Flutter**
- **Dart**
- **Google ML Kit – Text Recognition**
- **image_picker** for selecting images
- **extended_image** for image handling

---

## 📱 Screenshots

> *(Add screenshots here when available)*  
Example:
```

/assets/screenshots/home.png
/assets/screenshots/result.png

```

---

## 🧩 Project Structure

```

lib/
├── main.dart
├── screens/
│    ├── home_screen.dart
│    └── result_screen.dart
├── services/
│    └── text_recognizer.dart
└── widgets/
└── image_picker_widget.dart

````

---

## 🔧 Installation & Setup

### 1. Clone the repository
```bash
git clone https://github.com/konynour/flutter_ocr.git
cd flutter_ocr
````

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Android Setup

Open `android/app/build.gradle` and add the ML Kit text recognition packages you need:

```gradle
dependencies {
    implementation 'com.google.mlkit:text-recognition-chinese:16.0.0'
    implementation 'com.google.mlkit:text-recognition-devanagari:16.0.0'
    implementation 'com.google.mlkit:text-recognition-japanese:16.0.0'
    implementation 'com.google.mlkit:text-recognition-korean:16.0.0'
}
```

> For Latin languages, no extra dependencies are required.

---

## ▶️ Run the App

### Debug mode:

```bash
flutter run
```

### Release mode:

```bash
flutter run --release
```

---

## 🛠 Build APK

```bash
flutter build apk --release
```

APK output:

```
build/app/outputs/flutter-apk/app-release.apk
```

---

## 🎯 TODO / Roadmap

* Add PDF export
* Add offline caching
* Add theme switching (light/dark)
* Add Zoom
* Add Text-to-Speech
* Add Share
* Add Text Translation

---

## 🤝 Contributions

Contributions, issues, and pull requests are welcome.
Feel free to fork the repo and submit improvements.

---

## 📄 License

This project is licensed under the **MIT License**.
You are free to use, modify, and distribute.

```

