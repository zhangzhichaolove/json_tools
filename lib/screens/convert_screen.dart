import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
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

  // 添加示例数据
  final Map<String, String> exampleData = {
    'JSON': '''{
  "name": "JSON工具箱",
  "version": "1.0",
  "features": ["格式化", "转换", "验证"],
  "settings": {
    "theme": "auto",
    "language": "zh-CN"
  }
}''',
    'YAML': '''name: JSON工具箱
version: 1.0
features:
  - 格式化
  - 转换
  - 验证
settings:
  theme: auto
  language: zh-CN''',
    'XML': '''<root>
  <name>JSON工具箱</name>
  <version>1.0</version>
  <features>
    <item>格式化</item>
    <item>转换</item>
    <item>验证</item>
  </features>
  <settings>
    <theme>auto</theme>
    <language>zh-CN</language>
  </settings>
</root>''',
    'CSV': '''name,version,feature1,feature2,feature3
JSON工具箱,1.0,格式化,转换,验证''',
    'URL 参数': '''name=JSON工具箱&version=1.0&features[]=格式化&features[]=转换&features[]=验证&settings[theme]=auto&settings[language]=zh-CN'''
  };

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
                _buildToolButton('示例', Icons.search, onPressed: () {
                  setState(() {
                    inputData = exampleData[sourceFormat] ?? '';
                  });
                }),
                const SizedBox(width: 8),
                _buildToolButton('粘贴', Icons.content_paste, onPressed: () async {
                  final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
                  if (clipboardData != null && clipboardData.text != null) {
                    setState(() {
                      inputData = clipboardData.text!;
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
                    inputData = '';
                  });
                }),
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
            try {
              if (inputData.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('请输入需要转换的数据')),
                );
                return;
              }
              
              if (sourceFormat == targetFormat) {
                outputData = inputData;
                return;
              }
              
              if (sourceFormat == 'JSON' && targetFormat == 'YAML') {
                outputData = JsonUtils.jsonToYaml(inputData);
              } else if (sourceFormat == 'YAML' && targetFormat == 'JSON') {
                outputData = JsonUtils.yamlToJson(inputData);
              } else if (sourceFormat == 'JSON' && targetFormat == 'XML') {
                outputData = JsonUtils.jsonToXml(inputData);
              } else if (sourceFormat == 'XML' && targetFormat == 'JSON') {
                outputData = JsonUtils.xmlToJson(inputData);
              } else if (sourceFormat == 'JSON' && targetFormat == 'CSV') {
                outputData = JsonUtils.jsonToCsv(inputData);
              } else if (sourceFormat == 'CSV' && targetFormat == 'JSON') {
                outputData = JsonUtils.csvToJson(inputData);
              } else if (sourceFormat == 'JSON' && targetFormat == 'URL 参数') {
                outputData = JsonUtils.jsonToUrlParams(inputData);
              } else if (sourceFormat == 'URL 参数' && targetFormat == 'JSON') {
                outputData = JsonUtils.urlParamsToJson(inputData);
              } else {
                outputData = '暂不支持从 $sourceFormat 转换到 $targetFormat';
              }
            } catch (e) {
              outputData = '转换失败: ${e.toString()}';
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('转换失败: ${e.toString()}')),
              );
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
                  if (outputData.isNotEmpty) {
                    Clipboard.setData(ClipboardData(text: outputData));
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
                  if (outputData.isNotEmpty) {
                    _downloadOutput();
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

  // 添加下载功能
  Future<void> _downloadOutput() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      String fileName;
      
      switch (targetFormat) {
        case 'JSON':
          fileName = 'converted_data.json';
          break;
        case 'YAML':
          fileName = 'converted_data.yaml';
          break;
        case 'XML':
          fileName = 'converted_data.xml';
          break;
        case 'CSV':
          fileName = 'converted_data.csv';
          break;
        case 'URL 参数':
          fileName = 'converted_data.txt';
          break;
        default:
          fileName = 'converted_data.txt';
      }
      
      final file = File('${directory.path}/$fileName');
      await file.writeAsString(outputData);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('文件已保存到: ${file.path}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('保存文件失败: ${e.toString()}')),
      );
    }
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