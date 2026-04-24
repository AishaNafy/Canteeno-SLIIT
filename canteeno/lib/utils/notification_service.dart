import 'package:flutter/material.dart';

class NotificationService {
  static void showSuccess(BuildContext context, String message) {
    _showSnackBar(context, message, Colors.green, Icons.check_circle);
  }

  static void showError(BuildContext context, String message) {
    _showSnackBar(context, message, Colors.red, Icons.error);
  }

  static void showInfo(BuildContext context, String message) {
    _showSnackBar(context, message, const Color(0xFF1565C0), Icons.info);
  }

  static void showWarning(BuildContext context, String message) {
    _showSnackBar(context, message, Colors.orange, Icons.warning);
  }

  static void _showSnackBar(
    BuildContext context,
    String message,
    Color color,
    IconData icon,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  static Future<void> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    required String yesButtonText,
    required String noButtonText,
    required VoidCallback onYes,
    Color? buttonColor,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(noButtonText),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor ?? const Color(0xFF9B1C1C),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                onYes.call();
              },
              child: Text(yesButtonText,
                  style: const TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
