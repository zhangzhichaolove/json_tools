import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/top_bar.dart';
import '../widgets/theme_color_item.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Column(
      children: [
        TopBar(
          title: '设置',
          onMenuPressed: () {},
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDarkModeSection(themeProvider),
                const SizedBox(height: 24),
                _buildThemeSection(themeProvider),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThemeSection(ThemeProvider themeProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '主题颜色',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '当前主题: ${themeProvider.currentThemeName}',
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            childAspectRatio: 1,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: AppTheme.predefinedThemes.length,
          itemBuilder: (context, index) {
            final theme = AppTheme.predefinedThemes[index];
            return ThemeColorItem(
              color: theme.color,
              name: theme.name,
              isSelected: themeProvider.currentThemeName == theme.name,
              onTap: () {
                themeProvider.changeTheme(
                  name: theme.name,
                  primaryColor: theme.color,
                  isDark: themeProvider.isDarkMode,
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildDarkModeSection(ThemeProvider themeProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '外观模式',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text('深色模式'),
          value: themeProvider.isDarkMode,
          onChanged: (value) {
            themeProvider.changeTheme(
              name: themeProvider.currentThemeName,
              primaryColor: themeProvider.primaryColor,
              isDark: value,
            );
          },
          activeColor: themeProvider.primaryColor,
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }
}
