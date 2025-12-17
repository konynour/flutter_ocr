// lib/shared/widgets/image_cropper_widget.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:provider/provider.dart';
import '../../core/providers/theme_provider.dart';

class ImageCropperWidget extends StatefulWidget {
  final File imageFile;

  const ImageCropperWidget({
    super.key,
    required this.imageFile,
  });

  @override
  State<ImageCropperWidget> createState() => _ImageCropperWidgetState();
}

class _ImageCropperWidgetState extends State<ImageCropperWidget> {
  final _cropController = CropController();
  late Uint8List _imageBytes;
  bool _isLoading = true;
  double? _aspectRatio;
  int _rotationTurns = 0; // Track rotation manually

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    _imageBytes = await widget.imageFile.readAsBytes();
    setState(() {
      _isLoading = false;
    });
  }

  void _rotateImage(bool clockwise) {
    setState(() {
      if (clockwise) {
        _rotationTurns = (_rotationTurns + 1) % 4;
      } else {
        _rotationTurns = (_rotationTurns - 1) % 4;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.blueAccent,
        title: const Text(
          'Crop Image',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.white),
            onPressed: () {
              _cropController.crop();
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: isDark ? const Color(0xFF42A5F5) : Colors.blueAccent,
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: RotatedBox(
                      quarterTurns: _rotationTurns,
                      child: Crop(
                        image: _imageBytes,
                        controller: _cropController,
                        onCropped: (croppedData) {
                          // Return cropped image data
                          Navigator.of(context).pop(croppedData);
                        },
                        aspectRatio: _aspectRatio,
                        withCircleUi: false,
                        baseColor: Colors.black.withValues(alpha: 0.5),
                        maskColor: Colors.black.withValues(alpha: 0.5),
                        radius: 0,
                        cornerDotBuilder: (size, edgeAlignment) => DotControl(
                          color: isDark
                              ? const Color(0xFF42A5F5)
                              : Colors.blueAccent,
                        ),
                        interactive: true,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildToolButton(
                            icon: Icons.rotate_left,
                            label: 'Rotate Left',
                            onTap: () => _rotateImage(false),
                            isDark: isDark,
                          ),
                          _buildToolButton(
                            icon: Icons.rotate_right,
                            label: 'Rotate Right',
                            onTap: () => _rotateImage(true),
                            isDark: isDark,
                          ),
                          _buildToolButton(
                            icon: Icons.aspect_ratio,
                            label: 'Square',
                            onTap: () {
                              setState(() {
                                _aspectRatio = 1.0;
                              });
                            },
                            isDark: isDark,
                          ),
                          _buildToolButton(
                            icon: Icons.crop_free,
                            label: 'Free',
                            onTap: () {
                              setState(() {
                                _aspectRatio = null;
                              });
                            },
                            isDark: isDark,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _cropController.crop();
                          },
                          icon: const Icon(Icons.crop, size: 24),
                          label: const Text(
                            'Crop & Continue',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark
                                ? const Color(0xFF42A5F5)
                                : Colors.blueAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildToolButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.grey.shade800.withValues(alpha: 0.5)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isDark ? const Color(0xFF42A5F5) : Colors.blueAccent,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // CropController doesn't have dispose method in crop_your_image
    super.dispose();
  }
}