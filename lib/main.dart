import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:desktop_window/desktop_window.dart';
import 'package:json_tools/screens/compare_screen.dart';
import 'package:json_tools/screens/convert_screen.dart';
import 'package:json_tools/screens/format_screen.dart';
import 'package:json_tools/screens/home_screen.dart';
import 'package:json_tools/screens/visualize_screen.dart';
import 'package:json_tools/screens/settings_screen.dart';
import 'package:json_tools/theme/app_theme.dart';
import 'package:json_tools/widgets/sidebar.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'models/menu_item.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 设置窗口大小（仅适用于桌面平台）
  if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
    await DesktopWindow.setWindowSize(const Size(1400, 1000));
    await DesktopWindow.setMinWindowSize(const Size(800, 600));
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // 初始化主题
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ThemeProvider>(context, listen: false).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return MaterialApp(
      title: 'JSON工具箱',
      theme: themeProvider.themeData, // 使用主题提供者的主题数据
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String currentRoute = '/home';
  bool isSidebarCollapsed = false;

  final List<MenuItem> menuItems = [
    MenuItem(title: '首页', icon: Icons.home, route: '/home'),
    MenuItem(title: '格式化', icon: Icons.autorenew, route: '/format'),
    MenuItem(title: '转换', icon: Icons.swap_horiz, route: '/convert'),
    MenuItem(title: '比较', icon: Icons.compare, route: '/compare'),
    MenuItem(title: '可视化', icon: Icons.pie_chart, route: '/visualize'),
    MenuItem(title: '设置', icon: Icons.settings, route: '/settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          if (!isSidebarCollapsed)
            Sidebar(
              menuItems: menuItems,
              currentRoute: currentRoute,
              onRouteChanged: (route) {
                setState(() {
                  currentRoute = route;
                });
              },
            ),
          Expanded(
            child: _buildCurrentScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (currentRoute) {
      case '/home':
        return const HomeScreen();
      case '/format':
        return const FormatScreen();
      case '/convert':
        return const ConvertScreen();
      case '/compare':
        return const CompareScreen();
      case '/visualize':
        return const VisualizeScreen();
      case '/settings':
        return const SettingsScreen();
      default:
        return const HomeScreen();
    }
  }
}
