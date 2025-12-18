// lib/core/utils/helpers.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

class ExportHelper {
  /// Export image as PDF
  static Future<void> exportImageAsPdf(
      File image, BuildContext context) async {
    try {
      final pdf = pw.Document();
      final imageBytes = await image.readAsBytes();
      final pdfImage = pw.MemoryImage(imageBytes);

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(pdfImage),
            );
          },
        ),
      );

      final dir = await getTemporaryDirectory();
      final filePath =
          '${dir.path}/ocr_export_image_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      await Share.shareXFiles([XFile(file.path)],
          text: 'OCR image PDF export');
    } catch (e) {
      if (context.mounted) {
        _showErrorSnackBar(context, 'Export failed: $e');
      }
    }
  }

  /// Export recognized text as TXT
  static Future<void> exportTextAsTxt(File image, BuildContext context) async {
    try {
      final textRecognizer =
          TextRecognizer(script: TextRecognitionScript.latin);
      final inputImage = InputImage.fromFile(image);
      final recognizedText = await textRecognizer.processImage(inputImage);
      await textRecognizer.close();

      final dir = await getTemporaryDirectory();
      final filePath =
          '${dir.path}/ocr_export_${DateTime.now().millisecondsSinceEpoch}.txt';
      final file = File(filePath);
      await file.writeAsString(recognizedText.text);

      await Share.shareXFiles([XFile(file.path)],
          text: 'OCR text TXT export');
    } catch (e) {
      if (context.mounted) {
        _showErrorSnackBar(context, 'Export failed: $e');
      }
    }
  }

  /// Export recognized text as PDF
  static Future<void> exportTextAsPdf(File image, BuildContext context) async {
    try {
      final textRecognizer =
          TextRecognizer(script: TextRecognitionScript.latin);
      final inputImage = InputImage.fromFile(image);
      final recognizedText = await textRecognizer.processImage(inputImage);
      await textRecognizer.close();

      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Padding(
              padding: const pw.EdgeInsets.all(24),
              child: pw.Text(
                recognizedText.text.isEmpty
                    ? 'No text recognized.'
                    : recognizedText.text,
                style: const pw.TextStyle(fontSize: 12),
              ),
            );
          },
        ),
      );

      final dir = await getTemporaryDirectory();
      final filePath =
          '${dir.path}/ocr_export_text_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      await Share.shareXFiles([XFile(file.path)],
          text: 'OCR text PDF export');
    } catch (e) {
      if (context.mounted) {
        _showErrorSnackBar(context, 'Export failed: $e');
      }
    }
  }

  static void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class SnackBarHelper {
  /// Show success snackbar
  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  /// Show error snackbar
  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  /// Show info snackbar
  static void showInfo(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info, color: Colors.white),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

class ColorHelper {
  /// Get primary color based on theme
  static Color getPrimaryColor(bool isDark) {
    return isDark ? const Color(0xFF42A5F5) : Colors.blueAccent;
  }

  /// Get card color based on theme
  static Color getCardColor(bool isDark) {
    return isDark ? const Color(0xFF2C2C2C) : Colors.white;
  }

  /// Get background color based on theme
  static Color getBackgroundColor(bool isDark) {
    return isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA);
  }

  /// Get text color based on theme
  static Color getTextColor(bool isDark) {
    return isDark ? Colors.white : Colors.black87;
  }

  /// Get secondary text color based on theme
  static Color getSecondaryTextColor(bool isDark) {
    return isDark ? Colors.grey.shade400 : Colors.grey.shade600;
  }
}