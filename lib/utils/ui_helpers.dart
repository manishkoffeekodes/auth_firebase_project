import 'package:flutter/material.dart';
import 'app_theme.dart';

/// Shows a floating snackbar with consistent styling across all screens.
///
/// Usage:
/// ```dart
/// showAppSnackBar(context, 'Something went wrong', isError: true);
/// showAppSnackBar(context, 'Success! 🎉', isError: false);
/// ```
void showAppSnackBar(
  BuildContext context,
  String message, {
  required bool isError,
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: isError ? Colors.redAccent : AppColors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: Duration(
          milliseconds: isError ? 2000 : 1500,
        ),
      ),
    );
}
