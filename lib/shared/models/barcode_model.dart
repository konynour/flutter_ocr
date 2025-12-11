import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

class BarcodeModel {
  final String type;
  final String displayValue;
  final IconData icon;
  final bool isUrl;

  BarcodeModel(Barcode barcode)
      : type = _getTypeString(barcode.type),
        displayValue = barcode.displayValue ?? 'No data',
        icon = _getIcon(barcode.type),
        isUrl = _isUrl(barcode.displayValue);

  static String _getTypeString(BarcodeType type) {
    switch (type) {
      case BarcodeType.wifi:
        return 'WiFi';
      case BarcodeType.url:
        return 'URL';
      case BarcodeType.email:
        return 'Email';
      case BarcodeType.phone:
        return 'Phone';
      case BarcodeType.sms:
        return 'SMS';
      case BarcodeType.contactInfo:
        return 'Contact';
      case BarcodeType.calendarEvent:
        return 'Calendar';
      case BarcodeType.text:
        return 'Text';
      case BarcodeType.product:
        return 'Product';
      default:
        return 'Barcode';
    }
  }

  static IconData _getIcon(BarcodeType type) {
    switch (type) {
      case BarcodeType.wifi:
        return Icons.wifi;
      case BarcodeType.url:
        return Icons.link;
      case BarcodeType.email:
        return Icons.email;
      case BarcodeType.phone:
        return Icons.phone;
      case BarcodeType.sms:
        return Icons.message;
      case BarcodeType.contactInfo:
        return Icons.contact_page;
      case BarcodeType.calendarEvent:
        return Icons.calendar_today;
      case BarcodeType.product:
        return Icons.shopping_cart;
      default:
        return Icons.qr_code;
    }
  }

  static bool _isUrl(String? value) {
    if (value == null) return false;
    return value.startsWith('http://') || value.startsWith('https://');
  }
}