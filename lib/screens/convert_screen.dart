import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../widgets/top_bar.dart';
import '../widgets/json_editor.dart';
import '../utils/json_utils.dart';

class ConvertScreen extends StatefulWidget {
  const ConvertScreen({Key? key}) : super(key: key);

  @override
  _ConvertScreenState createState() => _ConvertScreenState();
}

class _ConvertScreenState extends State<ConvertScreen> {
  String inputData = '';
  String outputData = '';
  String sourceFormat = 'JSON';
  String targetFormat = 'YAML';
  
  final List<String> formats = ['JSON', 'YAML', 'XML', 'CSV', 'URL 参数'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TopBar(
          title: 'JSON 转换',
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
              '输入数据',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
            Row(
              children: [
                _buildToolButton('清空', Icons.delete_outline),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildFormatSelector(),
        const SizedBox(height: 16),
        SizedBox(
          height: 250,
          child: JsonEditor(
            initialValue: inputData,
            onChanged: (value) {
              setState(() {
                inputData = value;
              });
            },
            placeholder: '在此输入${sourceFormat}数据',
          ),
        ),
      ],
    );
  }

  Widget _buildFormatSelector() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '源格式',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF4B5563),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: sourceFormat,
                    isExpanded: true,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    borderRadius: BorderRadius.circular(8),
                    items: formats.map((String format) {
                      return DropdownMenuItem<String>(
                        value: format,
                        child: Text(format),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          sourceFormat = newValue;
                        });
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.swap_horiz),
                onPressed: () {
                  setState(() {
                    final temp = sourceFormat;
                    sourceFormat = targetFormat;
                    targetFormat = temp;
                  });
                },
                color: Colors.grey[600],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '目标格式',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF4B5563),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: targetFormat,
                    isExpanded: true,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    borderRadius: BorderRadius.circular(8),
                    items: formats.map((String format) {
                      return DropdownMenuItem<String>(
                        value: format,
                        child: Text(format),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          targetFormat = newValue;
                        });
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Center(
      child: ElevatedButton.icon(
        icon: const Icon(Icons.swap_horiz),
        label: const Text('转换'),
        onPressed: () {
          setState(() {
            if (sourceFormat == 'JSON' && targetFormat == 'YAML') {
              outputData = JsonUtils.jsonToYaml(inputData);
            } else if (sourceFormat == 'YAML' && targetFormat == 'JSON') {
              outputData = JsonUtils.yamlToJson(inputData);
            } else {
              outputData = '暂不支持从 $sourceFormat 转换到 $targetFormat';
            }
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.secondary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
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
              '转换结果',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
            Row(
              children: [
                _buildToolButton('复制', Icons.content_copy, onPressed: () {
                  Clipboard.setData(ClipboardData(text: outputData));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('已复制到剪贴板')),
                  );
                }),
                const SizedBox(width: 8),
                _buildToolButton('下载', Icons.file_download),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 250,
          child: JsonEditor(
            initialValue: outputData,
            onChanged: (value) {
              setState(() {
                outputData = value;
              });
            },
            readOnly: true,
            placeholder: '转换后的${targetFormat}将显示在这里',
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
}