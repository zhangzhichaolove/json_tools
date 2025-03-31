import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class TopBar extends StatelessWidget {
  final String title;
  final VoidCallback? onMenuPressed;
  final List<Widget>? actions;

  const TopBar({
    Key? key,
    required this.title,
    this.onMenuPressed,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final primaryColor = themeProvider.primaryColor;

    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border(
          bottom: BorderSide(
            color: isDarkMode ? const Color(0xFF333333) : const Color(0xFFE0E0E0),
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          if (onMenuPressed != null)
            IconButton(
              icon: Icon(
                Icons.menu,
                color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
              ),
              onPressed: onMenuPressed,
            ),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
            ),
          ),
          const Spacer(),
          if (actions != null) ...actions!,
        ],
      ),
    );
  }
}