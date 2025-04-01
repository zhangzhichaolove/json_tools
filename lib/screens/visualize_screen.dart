import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../theme/app_theme.dart';
import '../widgets/top_bar.dart';
import '../widgets/json_editor.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../utils/json_utils.dart';

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
  // 添加一个Map来跟踪每个节点的展开状态
  final Map<String, bool> _expandedNodes = {};
  bool _expandAll = false;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    
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
                child: _buildInputSection(isDarkMode),
              ),
              Expanded(
                flex: 3,
                child: _buildVisualizationSection(isDarkMode),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInputSection(bool isDarkMode) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final primaryColor = themeProvider.primaryColor;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: isDarkMode ? const Color(0xFF333333) : Colors.grey[200]!,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '输入 JSON',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
                ),
              ),
              Row(
                children: [
                  _buildToolButton('清空', Icons.delete_outline, size: 'small', isDarkMode: isDarkMode, 
                    onPressed: () {
                      setState(() {
                        inputJson = '';
                        parsedJson = null;
                        isValidJson = false;
                        errorMessage = '';
                        _expandedNodes.clear();
                      });
                    }
                  ),
                  const SizedBox(width: 4),
                  _buildToolButton('格式化', Icons.format_align_left, size: 'small', isDarkMode: isDarkMode,
                    onPressed: () {
                      if (inputJson.trim().isNotEmpty) {
                        try {
                          final formatted = JsonUtils.formatJson(inputJson);
                          setState(() {
                            inputJson = formatted;
                            _parseJson();
                          });
                        } catch (e) {
                          // 格式化失败，保持原样
                        }
                      }
                    }
                  ),
                  const SizedBox(width: 4),
                  Center(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.visibility),
                      label: const Text('可视化'),
                      onPressed: () {
                        _parseJson();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    ),
                  ),
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
                });
              },
              placeholder: '在此输入JSON数据',
            ),
          ),
          const SizedBox(height: 8),
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

  Widget _buildVisualizationSection(bool isDarkMode) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final primaryColor = themeProvider.primaryColor;
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'JSON 树视图',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
                ),
              ),
              if (isValidJson)
                Row(
                  children: [
                    _buildToolButton('展开全部', Icons.unfold_more, size: 'small', isDarkMode: isDarkMode,
                      onPressed: () {
                        setState(() {
                          _expandAll = true;
                          _expandedNodes.clear();
                        });
                      }
                    ),
                    const SizedBox(width: 4),
                    _buildToolButton('折叠全部', Icons.unfold_less, size: 'small', isDarkMode: isDarkMode,
                      onPressed: () {
                        setState(() {
                          _expandAll = false;
                          _expandedNodes.clear();
                        });
                      }
                    ),
                    const SizedBox(width: 4),
                    _buildToolButton('复制', Icons.copy, size: 'small', isDarkMode: isDarkMode,
                      onPressed: () {
                        if (isValidJson) {
                          Clipboard.setData(ClipboardData(text: JsonUtils.formatJson(inputJson)));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('已复制到剪贴板')),
                          );
                        }
                      }
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF2C2C2C) : Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDarkMode ? const Color(0xFF444444) : Colors.grey[200]!,
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: isValidJson
                  ? SingleChildScrollView(
                      child: _buildJsonTree(parsedJson, 0, isDarkMode, path: 'root'),
                    )
                  : Center(
                      child: Text(
                        errorMessage.isEmpty ? '请输入有效的JSON数据' : errorMessage,
                        style: TextStyle(
                          color: isDarkMode ? Colors.red[300] : AppTheme.error,
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

  // 获取节点的展开状态
  bool _isExpanded(String path) {
    return _expandAll || _expandedNodes[path] == true;
  }

  // 切换节点的展开状态
  void _toggleExpanded(String path) {
    setState(() {
      _expandedNodes[path] = !_isExpanded(path);
    });
  }

  Widget _buildJsonTree(dynamic json, int depth, bool isDarkMode, {required String path}) {
    if (json == null) {
      return Text(
        'null',
        style: TextStyle(
          color: isDarkMode ? Colors.purple[300] : Colors.purple,
          fontFamily: 'monospace',
        ),
      );
    }

    if (json is String) {
      return Text(
        '"$json"',
        style: TextStyle(
          color: isDarkMode ? Colors.green[300] : Colors.green,
          fontFamily: 'monospace',
        ),
      );
    }

    if (json is num) {
      return Text(
        json.toString(),
        style: TextStyle(
          color: isDarkMode ? Colors.blue[300] : Colors.blue,
          fontFamily: 'monospace',
        ),
      );
    }

    if (json is bool) {
      return Text(
        json.toString(),
        style: TextStyle(
          color: isDarkMode ? Colors.orange[300] : Colors.orange,
          fontFamily: 'monospace',
        ),
      );
    }

    if (json is List) {
      return _buildListNode(json, depth, isDarkMode, path: path);
    }

    if (json is Map) {
      return _buildMapNode(json, depth, isDarkMode, path: path);
    }

    return Text(json.toString());
  }

  Widget _buildListNode(List list, int depth, bool isDarkMode, {required String path}) {
    final isExpanded = _isExpanded(path);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => _toggleExpanded(path),
          child: Row(
            children: [
              Icon(
                isExpanded ? Icons.arrow_drop_down : Icons.arrow_right,
                size: 20,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
              Text(
                '数组 [${list.length}]',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
                ),
              ),
              if (!isExpanded && list.isNotEmpty)
                Text(
                  ' [...]',
                  style: TextStyle(
                    color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),
        ),
        if (isExpanded)
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
                          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                          fontFamily: 'monospace',
                        ),
                      ),
                      Expanded(child: _buildJsonTree(value, depth + 1, isDarkMode, path: '$path[$index]')),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildMapNode(Map map, int depth, bool isDarkMode, {required String path}) {
    final isExpanded = _isExpanded(path);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => _toggleExpanded(path),
          child: Row(
            children: [
              Icon(
                isExpanded ? Icons.arrow_drop_down : Icons.arrow_right,
                size: 20,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
              Text(
                '对象 {${map.length}}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
                ),
              ),
              if (!isExpanded && map.isNotEmpty)
                Text(
                  ' {...}',
                  style: TextStyle(
                    color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: map.entries.map((entry) {
                final key = entry.key.toString();
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '"$key": ',
                        style: TextStyle(
                          color: isDarkMode ? Colors.red[300] : Colors.red[700],
                          fontFamily: 'monospace',
                        ),
                      ),
                      Expanded(child: _buildJsonTree(entry.value, depth + 1, isDarkMode, path: '$path.$key')),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildToolButton(String label, IconData icon, {String size = 'normal', VoidCallback? onPressed, bool isDarkMode = false}) {
    return OutlinedButton.icon(
      icon: Icon(icon, size: size == 'small' ? 14 : 16),
      label: Text(label),
      onPressed: onPressed ?? () {},
      style: OutlinedButton.styleFrom(
        foregroundColor: isDarkMode ? Colors.grey[300] : Colors.grey[700],
        backgroundColor: isDarkMode ? const Color(0xFF333333) : Colors.grey[100],
        side: BorderSide(color: isDarkMode ? const Color(0xFF555555) : Colors.grey[300]!),
        padding: size == 'small'
            ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
            : const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        textStyle: TextStyle(fontSize: size == 'small' ? 10 : 12),
      ),
    );
  }
}