import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/menu_item.dart';
import '../providers/theme_provider.dart';

class Sidebar extends StatelessWidget {
  final List<MenuItem> menuItems;
  final String currentRoute;
  final Function(String) onRouteChanged;

  const Sidebar({
    Key? key,
    required this.menuItems,
    required this.currentRoute,
    required this.onRouteChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final primaryColor = themeProvider.primaryColor;
    
    return Container(
      width: 240,
      color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
      child: Column(
        children: [
          // 应用标题/Logo
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.code,
                  color: primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'JSON工具箱',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
          ),
          // 菜单项列表
          Expanded(
            child: ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                final isSelected = currentRoute == item.route;
                
                return ListTile(
                  leading: Icon(
                    item.icon,
                    color: isSelected 
                        ? primaryColor 
                        : (isDarkMode ? Colors.grey[400] : Colors.grey[700]),
                  ),
                  title: Text(
                    item.title,
                    style: TextStyle(
                      color: isSelected 
                          ? primaryColor 
                          : (isDarkMode ? Colors.grey[300] : Colors.grey[800]),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  selected: isSelected,
                  selectedTileColor: primaryColor.withOpacity(0.1),
                  onTap: () => onRouteChanged(item.route),
                );
              },
            ),
          ),
          // 底部版本信息
        ],
      ),
    );
  }
}
