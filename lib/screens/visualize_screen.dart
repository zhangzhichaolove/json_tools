import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../theme/app_theme.dart';
import '../widgets/top_bar.dart';
import '../widgets/json_editor.dart';

class VisualizeScreen extends StatefulWidget {
  const VisualizeScreen({Key? key}) : super(key: key);

  @override
  _VisualizeScreenState createState() => _VisualizeScreenState();
}

class _VisualizeScreenState extends State<VisualizeScreen> {
  String inputJson = '';
  dynamic parsedJson;
  bool isValidJson = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TopBar(
          title: 'JSON 可视化',
          onMenuPressed: () {},
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildInputSection(),
              ),
              Expanded(
                flex: 3,
                child: _buildVisualizationSection(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInputSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '输入 JSON',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
              Row(
                children: [
                  _buildToolButton('导入', Icons.file_download, size: 'small'),
                  const SizedBox(width: 4),
                  _buildToolButton('清空', Icons.delete_outline, size: 'small'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: JsonEditor(
              initialValue: inputJson,
              onChanged: (value) {
                setState(() {
                  inputJson = value;
                  _parseJson();
                });
              },
              placeholder: '在此输入JSON数据',
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.visibility),
              label: const Text('可视化'),
              onPressed: () {
                _parseJson();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _parseJson() {
    if (inputJson.trim().isEmpty) {
      setState(() {
        isValidJson = false;
        errorMessage = '请输入JSON数据';
        parsedJson = null;
      });
      return;
    }

    try {
      final decoded = json.decode(inputJson);
      setState(() {
        parsedJson = decoded;
        isValidJson = true;
        errorMessage = '';
      });
    } catch (e) {
      setState(() {
        isValidJson = false;
        errorMessage = '无效的JSON: ${e.toString()}';
        parsedJson = null;
      });
    }
  }

  Widget _buildVisualizationSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'JSON 树视图',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
              if (isValidJson)
                _buildToolButton('展开全部', Icons.unfold_more, size: 'small'),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              padding: const EdgeInsets.all(16),
              child: isValidJson
                  ? SingleChildScrollView(
                      child: _buildJsonTree(parsedJson, 0),
                    )
                  : Center(
                      child: Text(
                        errorMessage.isEmpty ? '请输入有效的JSON数据' : errorMessage,
                        style: TextStyle(
                          color: AppTheme.error,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJsonTree(dynamic json, int depth) {
    if (json == null) {
      return const Text(
        'null',
        style: TextStyle(
          color: Colors.purple,
          fontFamily: 'monospace',
        ),
      );
    }

    if (json is String) {
      return Text(
        '"$json"',
        style: const TextStyle(
          color: Colors.green,
          fontFamily: 'monospace',
        ),
      );
    }

    if (json is num) {
      return Text(
        json.toString(),
        style: const TextStyle(
          color: Colors.blue,
          fontFamily: 'monospace',
        ),
      );
    }

    if (json is bool) {
      return Text(
        json.toString(),
        style: const TextStyle(
          color: Colors.orange,
          fontFamily: 'monospace',
        ),
      );
    }

    if (json is List) {
      return _buildListNode(json, depth);
    }

    if (json is Map) {
      return _buildMapNode(json, depth);
    }

    return Text(json.toString());
  }

  Widget _buildListNode(List list, int depth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.arrow_drop_down,
              size: 20,
              color: Colors.grey[600],
            ),
            Text(
              '数组 [${list.length}]',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: list.asMap().entries.map((entry) {
              final index = entry.key;
              final value = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$index: ',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontFamily: 'monospace',
                      ),
                    ),
                    Expanded(child: _buildJsonTree(value, depth + 1)),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildMapNode(Map map, int depth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.arrow_drop_down,
              size: 20,
              color: Colors.grey[600],
            ),
            Text(
              '对象 {${map.length}}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: map.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '"${entry.key}": ',
                      style: TextStyle(
                        color: Colors.red[700],
                        fontFamily: 'monospace',
                      ),
                    ),
                    Expanded(child: _buildJsonTree(entry.value, depth + 1)),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildToolButton(String label, IconData icon, {String size = 'normal', VoidCallback? onPressed}) {
    return OutlinedButton.icon(
      icon: Icon(icon, size: size == 'small' ? 14 : 16),
      label: Text(label),
      onPressed: onPressed ?? () {},
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.grey[700],
        backgroundColor: Colors.grey[100],
        side: BorderSide(color: Colors.grey[300]!),
        padding: size == 'small'
            ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
            : const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        textStyle: TextStyle(fontSize: size == 'small' ? 10 : 12),
      ),
    );
  }
}