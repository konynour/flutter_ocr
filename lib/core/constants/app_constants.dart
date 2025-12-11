import 'package:flutter/material.dart';

class AppConstants {
  // App Info
  static const String appName = 'OCR Scanner';
  static const String appTagline = 'Scan, Recognize & Enhance';

  // Dimensions
  static const double borderRadius = 16.0;
  static const double borderRadiusLarge = 20.0;
  static const double borderRadiusSmall = 12.0;
  
  static const double spacing = 16.0;
  static const double spacingSmall = 8.0;
  static const double spacingLarge = 24.0;
  
  static const double iconSize = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeSmall = 20.0;

  // Padding
  static const EdgeInsets paddingAll = EdgeInsets.all(16.0);
  static const EdgeInsets paddingAllLarge = EdgeInsets.all(20.0);
  static const EdgeInsets paddingHorizontal = EdgeInsets.symmetric(horizontal: 16.0);
  static const EdgeInsets paddingVertical = EdgeInsets.symmetric(vertical: 16.0);

  // Animation Durations
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration animationDurationFast = Duration(milliseconds: 200);
  static const Duration animationDurationSlow = Duration(milliseconds: 500);

  // Text Styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    height: 1.5,
  );

  static const TextStyle captionStyle = TextStyle(
    fontSize: 12,
  );

  // Snackbar Messages
  static const String copiedMessage = 'Copied to clipboard!';
  static const String savedMessage = 'Image saved to gallery!';
  static const String exportSuccessMessage = 'Export successful!';
  static const String exportFailedMessage = 'Export failed';
  static const String noTextFoundMessage = 'No text found';
  static const String captureImageFirstMessage = 'Capture or pick an image first';

  // Scanner Messages
  static const String scanningMessage = 'Scanning...';
  static const String analyzingMessage = 'Analyzing...';
  static const String translatingMessage = 'Translating...';
  static const String noEntitiesFoundMessage = 'No entities found';
  static const String noBarcodeFoundMessage = 'No QR or Barcode found';
  static const String tryDifferentImageMessage = 'Try scanning a different image';

  // Mode Labels
  static const String cardModeLabel = 'Card';
  static const String textModeLabel = 'Text';
  static const String qrModeLabel = 'QR';
  static const String enhanceModeLabel = 'Enhance';

  // Button Labels
  static const String captureLabel = 'Capture';
  static const String galleryLabel = 'Gallery';
  static const String flipLabel = 'Flip';
  static const String exportLabel = 'Export';
  static const String ttsLabel = 'TTS';
  static const String retryLabel = 'Retry';
  static const String translateLabel = 'Translate';
  static const String playLabel = 'Play';
  static const String stopLabel = 'Stop';
  static const String resetLabel = 'Reset to Default';

  // Translation Languages
  static const Map translationLanguages = {
    "Arabic": "ar",
    "English": "en",
    "French": "fr",
    "Spanish": "es",
    "German": "de",
    "Italian": "it",
    "Portuguese": "pt",
    "Russian": "ru",
    "Chinese": "zh",
    "Japanese": "ja",
  };

  // TTS Languages
  static const Map ttsLanguages = {
    "English": "en-US",
    "Arabic": "ar-SA",
    "French": "fr-FR",
    "Spanish": "es-ES",
    "German": "de-DE",
  };

  // Image Enhancement Defaults
  static const double defaultContrast = 150.0;
  static const double minContrast = 80.0;
  static const double maxContrast = 200.0;
  static const int contrastDivisions = 12;

  static const double defaultBrightness = 1.0;
  static const double minBrightness = 1.0;
  static const double maxBrightness = 10.0;
  static const int brightnessDivisions = 10;
}

class AppColors {
  // Light Theme Colors
  static const Color lightPrimary = Color(0xFF2196F3);
  static const Color lightPrimaryVariant = Color(0xFF1976D2);
  static const Color lightSecondary = Color(0xFF03DAC6);
  static const Color lightBackground = Color(0xFFF5F7FA);
  static const Color lightSurface = Colors.white;
  static const Color lightCardColor = Color(0xFFFFFFFF);

  // Dark Theme Colors
  static const Color darkPrimary = Color(0xFF42A5F5);
  static const Color darkPrimaryVariant = Color(0xFF1E88E5);
  static const Color darkSecondary = Color(0xFF00BFA5);
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCardColor = Color(0xFF2C2C2C);

  // Status Colors
  static const Color success = Colors.green;
  static const Color error = Colors.red;
  static const Color warning = Colors.orange;
  static const Color info = Colors.blue;
}