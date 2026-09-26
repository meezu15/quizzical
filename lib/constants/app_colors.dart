import 'package:flutter/material.dart';

class AppColors {
  // Primary brand colors (Teal theme from Figma)
  static const Color primary = Color(0xFF005F56);
  static const Color primaryDark = Color(0xFF004D46);
  static const Color primaryLight = Color(0xFFE0F2F1);
  static const Color accent = Color(0xFF007A6E);

  // Background and surfaces
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBg = Color(0xFFF1F3F5);

  // Text colors
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);

  // Quiz feedback colors
  static const Color correctGreen = Color(0xFFA7D7C5);
  static const Color correctDark = Color(0xFF2E7D32);
  static const Color incorrectRed = Color(0xFFFCA5A5);
  static const Color incorrectDark = Color(0xFFC62828);
  static const Color timerOrange = Color(0xFFFF9800);
  static const Color timerRed = Color(0xFFE53935);

  // Pastel category card backgrounds matching Figma
  static const List<Color> pastelPalette = [
    Color(0xFFD6E4FF), // Blue (General Knowledge)
    Color(0xFFD4F4DD), // Green (Books)
    Color(0xFFFFF0D4), // Yellow/Tan (History)
    Color(0xFFF0D6FF), // Purple (Science & Nature)
    Color(0xFFFFE4DE), // Peach/Coral (Art)
    Color(0xFFCFE8FF), // Sky Blue (Vehicles)
    Color(0xFFFFDFDF), // Soft Red
    Color(0xFFE2F0D9), // Light Mint
    Color(0xFFFFF3CD), // Pale Amber
    Color(0xFFE8DAEF), // Lilac
  ];

  static Color getPastelForIndex(int index) {
    return pastelPalette[index % pastelPalette.length];
  }
}
