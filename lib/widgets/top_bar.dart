import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TopBar extends StatelessWidget {
  final String title;
  final VoidCallback? onMenuPressed;
  final bool showHelpIcon;
  final bool showNotificationIcon;
  final VoidCallback? onHelpPressed;
  final VoidCallback? onNotificationPressed;

  const TopBar({
    Key? key,
    required this.title,
    this.onMenuPressed,
    this.showHelpIcon = true,
    this.showNotificationIcon = true,
    this.onHelpPressed,
    this.onNotificationPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: onMenuPressed,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1F2937),
            ),
          ),
          const Spacer(),
          // 根据参数控制是否显示帮助图标
          if (showHelpIcon)
            IconButton(
              icon: const Icon(Icons.help_outline),
              onPressed: onHelpPressed ?? () {},
              color: Colors.grey[600],
            ),
          // 根据参数控制是否显示通知图标
          if (showNotificationIcon)
            IconButton(
              icon: const Icon(Icons.notifications_none),
              onPressed: onNotificationPressed ?? () {},
              color: Colors.grey[600],
            ),
        ],
      ),
    );
  }
}