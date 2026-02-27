import 'package:flutter/material.dart';

abstract class AppTypography {
  // 1. Font Family (Using fonts from Google Fonts)
  static const String fontFamily = 'Roboto';

  // 2. Font Weights
  static const FontWeight thin = FontWeight.w100;
  static const FontWeight extraLight = FontWeight.w200;
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
  static const FontWeight black = FontWeight.w900;

  // 3. Font Sizes (Adjusted for Elderly - larger than standard)
  static const double _displayLarge = 36.0;
  static const double _displayMedium = 32.0;
  static const double _displaySmall = 28.0;

  static const double _headlineLarge = 24.0;
  static const double _headlineMedium = 22.0;
  static const double _headlineSmall = 20.0;

  static const double _titleLarge = 20.0;
  static const double _titleMedium = 18.0;
  static const double _titleSmall = 16.0;

  static const double _bodyLarge = 18.0;
  static const double _bodyMedium = 16.0;
  static const double _bodySmall = 14.0;

  static const double _labelLarge = 18.0;
  static const double _labelMedium = 16.0;
  static const double _labelSmall = 14.0;

  // 4. Text Styles (Pure style definitions)
  // Display (For large point numbers, levels, or hours)
  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: _displayLarge,
    fontWeight: bold,
  );
  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: _displayMedium,
    fontWeight: bold,
  );
  static const TextStyle displaySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: _displaySmall,
    fontWeight: semiBold,
  );

  // Headline (For Screens Titles)
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: _headlineLarge,
    fontWeight: bold,
  );
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: _headlineMedium,
    fontWeight: semiBold,
  );
  static const TextStyle headlineSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: _headlineSmall,
    fontWeight: semiBold,
  );

  // Title (For Card Titles / AppBar)
  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: _titleLarge,
    fontWeight: bold,
  );
  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: _titleMedium,
    fontWeight: semiBold,
  );
  static const TextStyle titleSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: _titleSmall,
    fontWeight: medium,
  );

  // Body (For long reading text / instructions)
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: _bodyLarge,
    fontWeight: regular,
  );
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: _bodyMedium,
    fontWeight: regular,
  );
  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: _bodySmall,
    fontWeight: regular,
  );

  // Label (For Buttons and Tags)
  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: _labelLarge,
    fontWeight: medium,
  );
  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: _labelMedium,
    fontWeight: medium,
  );
  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: _labelSmall,
    fontWeight: medium,
  );
}
