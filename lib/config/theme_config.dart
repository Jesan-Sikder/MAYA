import 'package:flutter/material.dart';
import '../utils/constants.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.darkGradient4,
    colorScheme: const ColorScheme. dark(
      primary: AppColors.primary,
      secondary: AppColors.accent,
      error: AppColors.error,
    ),
    textTheme: _textTheme(true),
    elevatedButtonTheme: _elevatedButtonTheme(true),
  );

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors. primary,
    scaffoldBackgroundColor: AppColors.lightGradient1,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.accent,
      error: AppColors.error,
    ),
    textTheme: _textTheme(false),
    elevatedButtonTheme: _elevatedButtonTheme(false),
  );

  static TextTheme _textTheme(bool isDark) {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 56,
        fontWeight: FontWeight.w700,
        color: isDark ? AppColors.accent : AppColors.darkGradient4,
        letterSpacing: 6,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: isDark ?  Colors.white : AppColors.darkGradient4,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: isDark ? Colors.white70 : Colors.black87,
      ),
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme(bool isDark) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}