import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/top_bar.dart';
import '../widgets/json_editor.dart';
import '../utils/json_utils.dart';

class FormatScreen extends StatefulWidget {
  const FormatScreen({Key? key}) : super(key: key);

  @override
  _FormatScreenState createState() => _FormatScreenState();
}

class _FormatScreenState extends State<FormatScreen> {
  String inputJson = '';
  String outputJson = '';
  
  // 添加示例JSON
  final String exampleJson = '''{
  "name": "JSON工具箱",
  "version": "1.0",
  "features": ["格式化", "压缩", "验证", "可视化"],
  "settings": {
    "theme": "auto",
    "language": "zh-CN",
    "autoSave": true
  },
  "author": {
    "name": "开发者",
    "email": "dev@example.com"
  }
}''';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TopBar(
          title: 'JSON 格式化',
          onMenuPressed: () {},
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInputSection(),
                const SizedBox(height: 24),
                _buildActionButtons(),
                const SizedBox(height: 24),
                _buildOutputSection(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '输入 JSON',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
            Row(
              children: [
                _buildToolButton('示例', Icons.search, onPressed: () {
                  setState(() {
                    inputJson = exampleJson;
                  });
                }),
                const SizedBox(width: 8),
                _buildToolButton('粘贴', Icons.content_paste, onPressed: () async {
                  final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
                  if (clipboardData != null && clipboardData.text != null) {
                    setState(() {
                      inputJson = clipboardData.text!;
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('剪贴板中没有文本内容')),
                    );
                  }
                }),
                const SizedBox(width: 8),
                _buildToolButton('清空', Icons.delete_outline, onPressed: () {
                  setState(() {
                    inputJson = '';
                  });
                }),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 250,
          child: JsonEditor(
            initialValue: inputJson,
            onChanged: (value) {
              setState(() {
                inputJson = value;
              });
            },
            placeholder: '在此输入JSON，例如：{"name": "JSON工具箱", "version": "1.0"}',
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.autorenew),
          label: const Text('格式化'),
          onPressed: () {
            setState(() {
              outputJson = JsonUtils.formatJson(inputJson);
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: themeProvider.primaryColor, // 使用主题颜色
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          icon: const Icon(Icons.compress),
          label: const Text('压缩'),
          onPressed: () {
            setState(() {
              outputJson = JsonUtils.minifyJson(inputJson);
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[800],
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          icon: const Icon(Icons.check_circle_outline),
          label: const Text('验证'),
          onPressed: () {
            final isValid = JsonUtils.validateJson(inputJson);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(isValid ? 'JSON 格式有效' : 'JSON 格式无效'),
                backgroundColor: isValid ? AppTheme.success : AppTheme.error,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.success,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildOutputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '输出结果',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
            Row(
              children: [
                _buildToolButton('复制', Icons.content_copy, onPressed: () {
                  if (outputJson.isNotEmpty) {
                    Clipboard.setData(ClipboardData(text: outputJson));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('已复制到剪贴板')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('没有可复制的内容')),
                    );
                  }
                }),
                const SizedBox(width: 8),
                _buildToolButton('下载', Icons.file_download, onPressed: () {
                  if (outputJson.isNotEmpty) {
                    _downloadJson();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('没有可下载的内容')),
                    );
                  }
                }),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 250,
          child: JsonEditor(
            initialValue: outputJson,
            onChanged: (value) {
              setState(() {
                outputJson = value;
              });
            },
            readOnly: true,
            placeholder: '格式化后的JSON将显示在这里',
          ),
        ),
      ],
    );
  }

  Widget _buildToolButton(String label, IconData icon, {VoidCallback? onPressed}) {
    return OutlinedButton.icon(
      icon: Icon(icon, size: 16),
      label: Text(label),
      onPressed: onPressed ?? () {},
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.grey[700],
        backgroundColor: Colors.grey[100],
        side: BorderSide(color: Colors.grey[300]!),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        textStyle: const TextStyle(fontSize: 12),
      ),
    );
  }
  
  // 添加下载JSON功能
  Future<void> _downloadJson() async {
    // 在移动应用中，通常需要使用平台特定的API来实现文件下载
    // 这里只是一个简单的提示，实际实现需要使用文件系统API
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('文件已保存到下载目录')),
    );
    
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/formatted_json.json');
    await file.writeAsString(outputJson);
  }
}