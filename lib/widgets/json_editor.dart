import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class JsonEditor extends StatelessWidget {
  final String initialValue;
  final Function(String) onChanged;
  final String placeholder;
  final bool readOnly;

  const JsonEditor({
    Key? key,
    this.initialValue = '',
    required this.onChanged,
    this.placeholder = '在此输入JSON',
    this.readOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.light,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 12, 12, 12),
            child: TextField(
              controller: TextEditingController(text: initialValue),
              onChanged: onChanged,
              maxLines: null,
              readOnly: readOnly,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 14,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: placeholder,
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontFamily: 'monospace',
                  fontSize: 14,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 30,
            child: Container(
              color: Colors.grey[100],
              padding: const EdgeInsets.only(top: 12, right: 8),
              alignment: Alignment.topRight,
              child: Text(
                '1',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}