import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  Color _primaryColor = AppTheme.primary;
  String _currentThemeName = '默认蓝';
  bool _isInitialized = false;

  bool get isDarkMode => _isDarkMode;
  Color get primaryColor => _primaryColor;
  String get currentThemeName => _currentThemeName;
  bool get isInitialized => _isInitialized;

  ThemeProvider() {
    // 构造函数不再自动加载主题
  }

  // 添加初始化方法
  Future<void> initialize() async {
    if (!_isInitialized) {
      await _loadThemeFromPrefs();
      _isInitialized = true;
    }
  }

  Future<void> _loadThemeFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      final savedColorValue = prefs.getInt('primaryColor');
      if (savedColorValue != null) {
        _primaryColor = Color(savedColorValue);
      }
      _currentThemeName = prefs.getString('themeName') ?? '默认蓝';
      notifyListeners();
    } catch (e) {
      print('加载主题设置失败: $e');
      // 使用默认设置
    }
  }

  Future<void> _saveThemeToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    await prefs.setInt('primaryColor', _primaryColor.value);
    await prefs.setString('themeName', _currentThemeName);
  }

  void changeTheme({required String name, required Color primaryColor, required bool isDark}) {
    _currentThemeName = name;
    _primaryColor = primaryColor;
    _isDarkMode = isDark;
    _saveThemeToPrefs(); // 保存到本地存储
    notifyListeners(); // 通知监听者（包括 MaterialApp）
  }

  ThemeData get themeData {
    return _isDarkMode ? _darkTheme : _lightTheme;
  }

  ThemeData get _lightTheme {
    return ThemeData(
      primaryColor: _primaryColor,
      colorScheme: ColorScheme.light(
        primary: _primaryColor,
        secondary: _primaryColor,
        onPrimary: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: _primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      scaffoldBackgroundColor: Colors.white,
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _primaryColor,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.dark,
          side: const BorderSide(color: Color(0xFFE2E8F0)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  ThemeData get _darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: _primaryColor,
      colorScheme: ColorScheme.dark(
        primary: _primaryColor,
        secondary: _primaryColor,
        surface: const Color(0xFF1E1E1E),
        background: const Color(0xFF121212),
        onBackground: const Color(0xFFE0E0E0),
        onSurface: const Color(0xFFE0E0E0),
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      // 添加按钮主题
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: _primaryColor,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFE0E0E0),
          backgroundColor: const Color(0xFF2C2C2C),
          side: BorderSide(color: const Color(0xFF424242)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _primaryColor,
        ),
      ),
      iconTheme: const IconThemeData(
        color: Color(0xFFBDBDBD),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF1E1E1E),
        iconTheme: const IconThemeData(color: Color(0xFFE0E0E0)),
        titleTextStyle: const TextStyle(
          color: Color(0xFFE0E0E0), 
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardTheme(
        color: const Color(0xFF1E1E1E),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Color(0xFFE0E0E0)),
        bodyMedium: TextStyle(color: Color(0xFFBDBDBD)),
        titleLarge: TextStyle(color: Color(0xFFE0E0E0)),
        titleMedium: TextStyle(color: Color(0xFFE0E0E0)),
        titleSmall: TextStyle(color: Color(0xFFBDBDBD)),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF424242),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return _primaryColor;
          }
          return const Color(0xFF9E9E9E);
        }),
        trackColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return _primaryColor.withOpacity(0.5);
          }
          return const Color(0xFF616161);
        }),
      ),
    );
  }
}