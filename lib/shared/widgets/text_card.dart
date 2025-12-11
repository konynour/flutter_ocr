import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextCard extends StatelessWidget {
  final bool isDark;
  final String title;
  final String text;
  final IconData icon;
  final VoidCallback? onCopy;
  final bool showLineCount;

  const TextCard({
    super.key,
    required this.isDark,
    required this.title,
    required this.text,
    required this.icon,
    this.onCopy,
    this.showLineCount = false,
  });

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text('$title copied!'),
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

  @override
  Widget build(BuildContext context) {
    if (text.trim().isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [
                        const Color(0xFF42A5F5),
                        const Color(0xFF42A5F5).withValues(alpha: 0.8),
                      ]
                    : [
                        Colors.blueAccent,
                        Colors.blueAccent.withValues(alpha: 0.8),
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon, color: Colors.white, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    if (onCopy != null) {
                      onCopy!();
                    } else {
                      _copyToClipboard(context);
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.content_copy,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showLineCount && text != "No text found")
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.text_fields,
                          color: isDark
                              ? const Color(0xFF42A5F5)
                              : Colors.blueAccent,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${text.split('\n').length} lines detected',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark
                                ? const Color(0xFF42A5F5)
                                : Colors.blueAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: isDark ? Colors.white : Colors.black87,
                    letterSpacing: 0.2,
                  ),
                ),
                if (text == "No text found")
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      "💡 Make sure the image is clear and try again",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.orange,
                        fontStyle: FontStyle.italic,
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
}