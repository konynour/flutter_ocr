// HomeScreen.dart (Enhanced Version)
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter_ocr/CardScanner.dart';
import 'package:flutter_ocr/RecognizerScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'EnhanceScreen.dart';
import 'ThemeProvider.dart';

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

  bool scan = false;
  bool recognize = true;
  bool enhance = false;

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

  Widget _buildHeader(BuildContext context, ThemeProvider themeProvider, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'OCR Scanner',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            Text(
              'Scan, Recognize & Enhance',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
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
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          _buildModeButton(
            icon: Icons.qr_code_scanner,
            label: 'Scan',
            isSelected: scan,
            onTap: () => setState(() {
              scan = true;
              recognize = false;
              enhance = false;
            }),
            isDark: isDark,
            theme: theme,
          ),
          _buildModeButton(
            icon: Icons.document_scanner,
            label: 'Recognize',
            isSelected: recognize,
            onTap: () => setState(() {
              scan = false;
              recognize = true;
              enhance = false;
            }),
            isDark: isDark,
            theme: theme,
          ),
          _buildModeButton(
            icon: Icons.auto_fix_high,
            label: 'Enhance',
            isSelected: enhance,
            onTap: () => setState(() {
              scan = false;
              recognize = false;
              enhance = true;
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
                  fontSize: 13,
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
            color: Colors.black.withOpacity(0.15),
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
                color: theme.primaryColor.withOpacity(0.9),
                height: 3,
                margin: const EdgeInsets.symmetric(horizontal: 30),
              )
                  .animate(onPlay: (controller) => controller.repeat())
                  .moveY(
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
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
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
              XFile? xfile = await imagePicker.pickImage(source: ImageSource.gallery);
              if (xfile != null) {
                File image = File(xfile.path);
                processImage(image);
              }
            },
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
                  ? Colors.grey.shade800.withOpacity(0.3)
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
        await controller.takePicture().then((value) {
          File image = File(value.path);
          processImage(image);
        });
      },
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [theme.primaryColor, theme.primaryColor.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: theme.primaryColor.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Icon(Icons.camera_alt, color: Colors.white, size: 32),
      ),
    );
  }

  processImage(File image) async {
    final editedImage = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageCropper(
          image: image.readAsBytesSync(),
        ),
      ),
    );
    image.writeAsBytes(editedImage);
    if (recognize) {
      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
        return RecognizerScreen(image);
      }));
    } else if (scan) {
      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
        return CardScanner(image);
      }));
    } else if (enhance) {
      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
        return EnhanceScreen(image);
      }));
    }
  }
}
