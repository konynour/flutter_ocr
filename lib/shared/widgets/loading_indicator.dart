import 'dart:ui';

import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final bool isDark;
  final String message;

  const LoadingIndicator({
    super.key,
    required this.isDark,
    this.message = 'Loading...',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(
              isDark ? const Color(0xFF42A5F5) : Colors.blueAccent,
            ),
            strokeWidth: 3,
          ),
          const SizedBox(height: 20),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}