import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // --- Primary ---
  static const green = Color(0xFF2D6A4F);
  static const greenD = Color(0xFF40916C);
  static const greenSoft = Color(0xFFE7F0EB);
  static const greenOnDark = Color(0xFF74C69D);

  // --- Accent ---
  static const saffron = Color(0xFFF4A261);
  static const saffronSoft = Color(0xFFFCEEDF);

  // --- Background / Surface ---
  static const bg = Color(0xFFF8F9FA);
  static const card = Color(0xFFFFFFFF);

  // --- Text ---
  static const ink = Color(0xFF1A1A2E);
  static const ink2 = Color(0xFF5B5F6B);
  static const ink3 = Color(0xFF9094A0);

  // --- Semantic ---
  static const success = Color(0xFF52B788);
  static const successSoft = Color(0xFFE4F4EC);
  static const error = Color(0xFFE76F51);
  static const errorSoft = Color(0xFFFBE9E3);

  // --- Lines ---
  static const line = Color(0xFFECEEF1);
  static const line2 = Color(0xFFE1E4E8);

  // --- Dark mode ---
  static const darkBg = Color(0xFF121A17);
  static const darkSurface = Color(0xFF1A241F);
  static const darkText = Color(0xFFE9ECEF);
  static const darkPrimary = Color(0xFF40916C);
  static const darkSaffron = Color(0xFFF6B179);
  static const darkSuccess = Color(0xFF74C69D);
  static const darkError = Color(0xFFF08A6E);

  // --- Shadows ---
  static const List<BoxShadow> shadowCard = [
    BoxShadow(color: Color(0x0A1A1A2E), blurRadius: 2, offset: Offset(0, 1)),
    BoxShadow(color: Color(0x0D1A1A2E), blurRadius: 14, offset: Offset(0, 4)),
  ];

  static const List<BoxShadow> shadowGreen = [
    BoxShadow(color: Color(0x422D6A4F), blurRadius: 26, offset: Offset(0, 10)),
  ];

  static const List<BoxShadow> shadowSaffron = [
    BoxShadow(color: Color(0x61F4A261), blurRadius: 24, offset: Offset(0, 10)),
  ];
}
