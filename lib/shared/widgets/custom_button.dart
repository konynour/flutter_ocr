import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDark;
  final bool isPrimary;
  final bool isLoading;
  final Color? customColor;

  const CustomButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isDark,
    this.isPrimary = false,
    this.isLoading = false,
    this.customColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isPrimary) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: isLoading ? null : onTap,
          icon: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Icon(icon, size: 22),
          label: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: customColor ??
                (isDark ? const Color(0xFF42A5F5) : Colors.blueAccent),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      );
    }

    // Secondary button (for bottom action buttons)
    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: customColor ??
                  (isDark
                      ? Colors.grey.shade800.withValues(alpha: 0.3)
                      : Colors.grey.shade100),
              borderRadius: BorderRadius.circular(16),
            ),
            child: isLoading
                ? SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.primaryColor,
                    ),
                  )
                : Icon(
                    icon,
                    size: 28,
                    color: customColor ?? theme.primaryColor,
                  ),
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
}

class CaptureButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isDark;
  final ThemeData theme;

  const CaptureButton({
    super.key,
    required this.onTap,
    required this.isDark,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
}