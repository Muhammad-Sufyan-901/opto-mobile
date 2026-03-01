import 'package:flutter/material.dart';

abstract class AppColors {
  // ==========================================
  // ☀️ LIGHT THEME PALETTE
  // ==========================================

  // Brand Colors
  static const Color lightPrimary = Color(0xFF136DAF);
  static const Color lightSecondary = Color(0xFF0F5A92);
  static const Color lightTertiary = Color(0xFF0D4D7A);

  // Background & Text
  static const Color lightBackground = Color(0xFFF8F9FA);
  static const Color lightText = Color(0xFF111827);

  // Semantic Colors
  static const Color lightError = Color(0xFFEF4444);
  static const Color lightWarning = Color(0xFFF59E0B);
  static const Color lightSuccess = Color(0xFF22C55E);
  static const Color lightInfo = Color(0xFF3B82F6);

  // On Semantic Colors
  static const Color lightOnError = Color(0xFFFFFFFF);
  static const Color lightOnWarning = Color(0xFFFFFFFF);
  static const Color lightOnSuccess = Color(0xFFFFFFFF);
  static const Color lightOnInfo = Color(0xFFFFFFFF);

  // ==========================================
  // 🌙 DARK THEME PALETTE
  // ==========================================

  // Brand Colors
  static const Color darkPrimary = Color(0xFF0F5A92);
  static const Color darkSecondary = Color(0xFF0D4D7A);
  static const Color darkTertiary = Color(0xFF093656);

  // Background & Text
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkText = Color(0xFFF9FAFB);

  // Semantic Colors
  static const Color darkError = Color(0xFFDC2626);
  static const Color darkWarning = Color(0xFFD97706);
  static const Color darkSuccess = Color(0xFF16A34A);
  static const Color darkInfo = Color(0xFF2563EB);

  // On Semantic Colors
  static const Color darkOnError = Color(0xFFFFFFFF);
  static const Color darkOnWarning = Color(0xFFFFFFFF);
  static const Color darkOnSuccess = Color(0xFFFFFFFF);
  static const Color darkOnInfo = Color(0xFFFFFFFF);
}
