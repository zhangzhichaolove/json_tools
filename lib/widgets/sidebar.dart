import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../theme/app_theme.dart';

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
    return Container(
      width: 250,
      color: AppTheme.dark,
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _buildMenuItems(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          Icon(
            Icons.code,
            color: AppTheme.primary,
            size: 32,
          ),
          SizedBox(width: 8),
          Text(
            'JSON工具箱',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final item = menuItems[index];
        final isSelected = item.route == currentRoute;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primary.withOpacity(0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            leading: Icon(
              item.icon,
              color: isSelected ? AppTheme.primary : Colors.white70,
            ),
            title: Text(
              item.title,
              style: TextStyle(
                color: isSelected ? AppTheme.primary : Colors.white70,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            onTap: () => onRouteChanged(item.route),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      },
    );
  }
}
