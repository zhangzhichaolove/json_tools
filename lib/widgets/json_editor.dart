import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class JsonEditor extends StatelessWidget {
  final String initialValue;
  final Function(String) onChanged;
  final bool readOnly;
  final String placeholder;

  const JsonEditor({
    Key? key,
    required this.initialValue,
    required this.onChanged,
    this.readOnly = false,
    this.placeholder = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final primaryColor = themeProvider.primaryColor;

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2C2C2C) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDarkMode ? const Color(0xFF444444) : const Color(0xFFE2E8F0),
        ),
      ),
      child: TextField(
        controller: TextEditingController(text: initialValue),
        onChanged: onChanged,
        readOnly: readOnly,
        maxLines: null,
        expands: true,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 14,
          color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
        ),
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: TextStyle(
            color: isDarkMode ? Colors.grey[500] : Colors.grey[400],
            fontFamily: 'monospace',
            fontSize: 14,
          ),
          contentPadding: const EdgeInsets.all(16),
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: primaryColor,
              width: 1.5,
            ),
          ),
          enabledBorder: InputBorder.none,
        ),
      ),
    );
  }
}