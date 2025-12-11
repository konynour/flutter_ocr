// ScanQR.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ocr/core/providers/theme_provider.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:provider/provider.dart';

class ScanQR extends StatefulWidget {
  final File image;
  const ScanQR(this.image, {super.key});

  @override
  State<ScanQR> createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  late BarcodeScanner barcodeScanner;
  List<BarcodeData> barcodesList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    barcodeScanner = BarcodeScanner();
    scanBarcodes();
  }

  Future<void> scanBarcodes() async {
    setState(() {
      isLoading = true;
    });

    InputImage inputImage = InputImage.fromFile(widget.image);
    final List<Barcode> barcodes =
        await barcodeScanner.processImage(inputImage);

    barcodesList.clear();
    for (final barcode in barcodes) {
      barcodesList.add(BarcodeData(barcode));
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    barcodeScanner.close();
    super.dispose();
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text("$label copied!"),
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

  // Future<void> _launchUrl(String url) async {
  //   final uri = Uri.parse(url);
  //   if (await canLaunchUrl(uri)) {
  //     await launchUrl(uri, mode: LaunchMode.externalApplication);
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Cannot open this URL")),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.blueAccent,
        title: const Text(
          'QR & Barcode Scanner',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: themeProvider.toggleTheme,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Image Display
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(widget.image),
                ),
              ),
              const SizedBox(height: 24),

              // Info Header
              if (!isLoading && barcodesList.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        (isDark ? const Color(0xFF42A5F5) : Colors.blueAccent)
                            .withValues(alpha: 0.15),
                        (isDark ? const Color(0xFF42A5F5) : Colors.blueAccent)
                            .withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: isDark
                            ? const Color(0xFF42A5F5)
                            : Colors.blueAccent,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${barcodesList.length} barcode${barcodesList.length > 1 ? 's' : ''} detected',
                        style: TextStyle(
                          color: isDark
                              ? const Color(0xFF42A5F5)
                              : Colors.blueAccent,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              if (!isLoading && barcodesList.isNotEmpty)
                const SizedBox(height: 16),

              // Loading or Barcode List
              if (isLoading)
                Container(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isDark ? const Color(0xFF42A5F5) : Colors.blueAccent,
                        ),
                        strokeWidth: 3,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Scanning QR & Barcodes...',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              else if (barcodesList.isEmpty)
                Container(
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color:
                        isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.qr_code_scanner_outlined,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No QR or Barcode found',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? Colors.grey.shade300
                              : Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Try scanning a different image',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ListView.builder(
                  itemBuilder: (context, position) {
                    final barcodeData = barcodesList[position];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withValues(alpha: isDark ? 0.3 : 0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            _copyToClipboard(
                                barcodeData.displayValue, barcodeData.type);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: isDark
                                              ? [
                                                  const Color(0xFF42A5F5),
                                                  const Color(0xFF42A5F5)
                                                      .withValues(alpha: 0.7),
                                                ]
                                              : [
                                                  Colors.blueAccent,
                                                  Colors.blueAccent
                                                      .withValues(alpha: 0.7),
                                                ],
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        barcodeData.icon,
                                        size: 24,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            barcodeData.type.toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: isDark
                                                  ? const Color(0xFF42A5F5)
                                                  : Colors.blueAccent,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            barcodeData.displayValue,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.black87,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? Colors.grey.shade800
                                                .withValues(alpha: 0.5)
                                            : Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        Icons.content_copy,
                                        size: 18,
                                        color: isDark
                                            ? const Color(0xFF42A5F5)
                                            : Colors.blueAccent,
                                      ),
                                    ),
                                  ],
                                ),
                                // If it's a URL, show open button
                                if (barcodeData.isUrl)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: SizedBox(
                                      width: double.infinity,
                                      // child: ElevatedButton.icon(
                                      //   onPressed: () => _launchUrl(
                                      //       barcodeData.displayValue),
                                      //   icon: const Icon(Icons.open_in_browser,
                                      //       size: 18),
                                      //   label: const Text(
                                      //     'Open URL',
                                      //     style: TextStyle(
                                      //       fontSize: 14,
                                      //       fontWeight: FontWeight.w600,
                                      //     ),
                                      //   ),
                                      //   style: ElevatedButton.styleFrom(
                                      //     backgroundColor: isDark
                                      //         ? const Color(0xFF42A5F5)
                                      //         : Colors.blueAccent,
                                      //     foregroundColor: Colors.white,
                                      //     padding: const EdgeInsets.symmetric(
                                      //         vertical: 12),
                                      //     elevation: 0,
                                      //     shape: RoundedRectangleBorder(
                                      //       borderRadius:
                                      //           BorderRadius.circular(10),
                                      //     ),
                                      //   ),
                                      // ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: barcodesList.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class BarcodeData {
  final String type;
  final String displayValue;
  final IconData icon;
  final bool isUrl;

  BarcodeData(Barcode barcode)
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
      // case BarcodeType.geo:
      //   return 'Location';
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
      // case BarcodeType.geo:
      //   return Icons.location_on;
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
