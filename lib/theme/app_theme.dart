import 'package:flutter/material.dart';

class ThemeOption {
  final String name;
  final Color color;

  const ThemeOption({required this.name, required this.color});
}

class AppTheme {
  static const Color primary = Color(0xFF3B82F6);
  static const Color secondary = Color(0xFF6366F1);
  static const Color dark = Color(0xFF1E293B);
  static const Color light = Color(0xFFF8FAFC);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color background = Color(0xFFF3F4F6);

  // 预设20种主题色
  static final List<ThemeOption> predefinedThemes = [
    ThemeOption(name: '默认蓝', color: Color(0xFF3B82F6)),
    ThemeOption(name: '靛蓝', color: Color(0xFF6366F1)),
    ThemeOption(name: '紫色', color: Color(0xFF8B5CF6)),
    ThemeOption(name: '粉红', color: Color(0xFFEC4899)),
    ThemeOption(name: '红色', color: Color(0xFFEF4444)),
    ThemeOption(name: '橙色', color: Color(0xFFF97316)),
    ThemeOption(name: '琥珀', color: Color(0xFFF59E0B)),
    ThemeOption(name: '黄色', color: Color(0xFFEAB308)),
    ThemeOption(name: '酸橙', color: Color(0xFF84CC16)),
    ThemeOption(name: '绿色', color: Color(0xFF22C55E)),
    ThemeOption(name: '翡翠', color: Color(0xFF10B981)),
    ThemeOption(name: '青色', color: Color(0xFF14B8A6)),
    ThemeOption(name: '天蓝', color: Color(0xFF06B6D4)),
    ThemeOption(name: '深蓝', color: Color(0xFF0284C7)),
    ThemeOption(name: '宝蓝', color: Color(0xFF2563EB)),
    ThemeOption(name: '深紫', color: Color(0xFF7C3AED)),
    ThemeOption(name: '紫罗兰', color: Color(0xFF9333EA)),
    ThemeOption(name: '洋红', color: Color(0xFFC026D3)),
    ThemeOption(name: '玫瑰', color: Color(0xFFE11D48)),
    ThemeOption(name: '棕色', color: Color(0xFF78350F)),
  ];

  static ThemeData lightTheme = ThemeData(
    primaryColor: primary,
    scaffoldBackgroundColor: background,
    fontFamily: 'Inter',
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: dark),
      titleTextStyle: TextStyle(
        color: dark,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primary,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: dark,
        side: const BorderSide(color: Color(0xFFE2E8F0)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: light,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primary),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    cardTheme: CardTheme(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}