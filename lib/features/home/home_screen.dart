// HomeScreen.dart (Fixed Version)
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import '../text_to_speech/tts_screen.dart';
import '../qr_scanner/scan_qr.dart';
import '../card_scanner/card_scanner.dart';
import '../image_enhancement/enhance_screen.dart';
import '../text_recognition/recognizer_screen.dart';
import '../../core/providers/theme_provider.dart';
import '../../shared/widgets/image_cropper_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ImagePicker imagePicker;
  late List<CameraDescription> _cameras;
  late CameraController controller;
  bool isInit = false;
  int _selectedCameraIndex = 0;

  // Last captured or picked image (used for export)
  File? _lastImage;

  // To avoid multiple export actions at the same time
  bool _isExporting = false;

  bool cardScan = false;
  bool recognize = true;
  bool enhance = false;
  bool scanQR = false;

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
    initalizeCamera();
  }

  Future<void> initalizeCamera() async {
    _cameras = await availableCameras();

    controller = CameraController(
      _cameras[_selectedCameraIndex],
      ResolutionPreset.max,
    );

    await controller.initialize();
    if (mounted) {
      setState(() => isInit = true);
    }
  }

  void _openTtsScreen() {
    if (_lastImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Capture or pick an image first")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TtsScreen(image: _lastImage!),
      ),
    );
  }

  Future<void> flipCamera() async {
    if (_cameras.length < 2) return;

    _selectedCameraIndex = (_selectedCameraIndex == 0) ? 1 : 0;

    controller = CameraController(
      _cameras[_selectedCameraIndex],
      ResolutionPreset.max,
    );

    await controller.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    if (isInit) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildHeader(context, themeProvider, isDark),
              const SizedBox(height: 20),
              _buildModeSelector(isDark, theme),
              const SizedBox(height: 20),
              Expanded(child: _buildCameraPreview(isDark, theme)),
              const SizedBox(height: 20),
              _buildActionButtons(isDark, theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, ThemeProvider themeProvider, bool isDark) {
    return Row(
      children: [
        // Left Side (Title)
        Image.asset(
          "images/icon.png",
          height: 70,
          width: 70,
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'OCR Scanner',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            Text(
              'Scan, Recognize & Enhance',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
        const Spacer(),

        // Dark / Light Button
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: themeProvider.toggleTheme,
          ),
        ),
      ],
    );
  }

  Widget _buildModeSelector(bool isDark, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          _buildModeButton(
            icon: Icons.credit_card,
            label: 'Card',
            isSelected: cardScan,
            onTap: () => setState(() {
              cardScan = true;
              recognize = false;
              enhance = false;
              scanQR = false;
            }),
            isDark: isDark,
            theme: theme,
          ),
          _buildModeButton(
            icon: Icons.text_fields,
            label: 'Text',
            isSelected: recognize,
            onTap: () => setState(() {
              cardScan = false;
              recognize = true;
              enhance = false;
              scanQR = false;
            }),
            isDark: isDark,
            theme: theme,
          ),
          _buildModeButton(
            icon: Icons.qr_code_scanner,
            label: 'QR',
            isSelected: scanQR,
            onTap: () => setState(() {
              cardScan = false;
              recognize = false;
              enhance = false;
              scanQR = true;
            }),
            isDark: isDark,
            theme: theme,
          ),
          _buildModeButton(
            icon: Icons.auto_fix_high,
            label: 'Enhance',
            isSelected: enhance,
            onTap: () => setState(() {
              cardScan = false;
              recognize = false;
              enhance = true;
              scanQR = false;
            }),
            isDark: isDark,
            theme: theme,
          ),
        ],
      ),
    );
  }

  Widget _buildModeButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
    required ThemeData theme,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? theme.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 28,
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.grey : Colors.grey.shade600),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? Colors.grey : Colors.grey.shade600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCameraPreview(bool isDark, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: isInit
                  ? AspectRatio(
                      aspectRatio: controller.value.aspectRatio,
                      child: CameraPreview(controller),
                    )
                  : Container(
                      color: isDark ? Colors.black : Colors.grey.shade200,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: theme.primaryColor,
                        ),
                      ),
                    ),
            ),
            Container(
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Image.asset(
                "images/f1.png",
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
              top: 30,
              left: 0,
              right: 0,
              child: Container(
                color: theme.primaryColor.withValues(alpha: 0.9),
                height: 3,
                margin: const EdgeInsets.symmetric(horizontal: 30),
              ).animate(onPlay: (controller) => controller.repeat()).moveY(
                    begin: 0,
                    end: MediaQuery.of(context).size.height * 0.5,
                    duration: 2000.ms,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(bool isDark, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildActionButton(
            icon: Icons.record_voice_over,
            label: 'TTS',
            onTap: _openTtsScreen,
            isDark: isDark,
            theme: theme,
          ),
          _buildActionButton(
            icon: Icons.flip_camera_ios,
            label: 'Flip',
            onTap: flipCamera,
            isDark: isDark,
            theme: theme,
          ),
          _buildCaptureButton(isDark, theme),
          _buildActionButton(
            icon: Icons.photo_library,
            label: 'Gallery',
            onTap: () async {
              XFile? xfile =
                  await imagePicker.pickImage(source: ImageSource.gallery);
              if (xfile != null) {
                File image = File(xfile.path);
                processImage(image);
              }
            },
            isDark: isDark,
            theme: theme,
          ),
          _buildActionButton(
            icon: Icons.picture_as_pdf,
            label: 'Export',
            onTap: _showExportOptions,
            isDark: isDark,
            theme: theme,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDark,
    required ThemeData theme,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.grey.shade800.withValues(alpha: 0.3)
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, size: 28, color: theme.primaryColor),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.grey : Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaptureButton(bool isDark, ThemeData theme) {
    return InkWell(
      onTap: () async {
        if (!isInit) return;
        await controller.takePicture().then((value) {
          File image = File(value.path);
          processImage(image);
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.primaryColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: theme.primaryColor.withValues(alpha: 0.35),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(
              Icons.camera_alt,
              size: 32,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Capture",
            style: TextStyle(
              fontSize: 11,
              color: isDark ? Colors.grey : Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  // This is called after picking or capturing an image
  Future<void> processImage(File image) async {
    _lastImage = image;

    // Navigate to crop screen
    final croppedData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageCropperWidget(imageFile: image),
      ),
    );

    // If user cancels cropping, return
    if (croppedData == null) return;

    // Save cropped image
    await image.writeAsBytes(croppedData);
    _lastImage = image;

    // Navigate to appropriate screen based on mode
    if (!mounted) return;

    if (recognize) {
      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
        return RecognizerScreen(image);
      }));
    } else if (cardScan) {
      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
        return CardScanner(image);
      }));
    } else if (scanQR) {
      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
        return ScanQR(image);
      }));
    } else if (enhance) {
      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
        return EnhanceScreen(image);
      }));
    }
  }

  // ===================== Export Logic =====================

  void _showExportOptions() {
    if (_lastImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please capture or pick an image first.'),
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Export options',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.picture_as_pdf),
                title: const Text('Export as PDF (image)'),
                onTap: () {
                  Navigator.pop(ctx);
                  _exportAsPdfWithImage();
                },
              ),
              ListTile(
                leading: const Icon(Icons.description),
                title: const Text('Export as PDF (recognized text)'),
                onTap: () {
                  Navigator.pop(ctx);
                  _exportRecognizedTextAsPdf();
                },
              ),
              ListTile(
                leading: const Icon(Icons.text_snippet),
                title: const Text('Export as TXT (recognized text)'),
                onTap: () {
                  Navigator.pop(ctx);
                  _exportRecognizedTextAsTxt();
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Future<void> _exportAsPdfWithImage() async {
    if (_lastImage == null || _isExporting) return;

    try {
      setState(() => _isExporting = true);

      final pdf = pw.Document();
      final imageBytes = await _lastImage!.readAsBytes();
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  Future<void> _exportRecognizedTextAsTxt() async {
    if (_lastImage == null || _isExporting) return;

    try {
      setState(() => _isExporting = true);

      final textRecognizer =
          TextRecognizer(script: TextRecognitionScript.latin);
      final inputImage = InputImage.fromFile(_lastImage!);
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  Future<void> _exportRecognizedTextAsPdf() async {
    if (_lastImage == null || _isExporting) return;

    try {
      setState(() => _isExporting = true);

      final textRecognizer =
          TextRecognizer(script: TextRecognitionScript.latin);
      final inputImage = InputImage.fromFile(_lastImage!);
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }
}