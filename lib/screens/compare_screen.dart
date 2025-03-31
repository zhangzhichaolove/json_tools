import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../widgets/top_bar.dart';
import '../widgets/json_editor.dart';
import '../utils/json_utils.dart';

class CompareScreen extends StatefulWidget {
  const CompareScreen({Key? key}) : super(key: key);

  @override
  _CompareScreenState createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  String leftJson = '';
  String rightJson = '';
  Map<String, dynamic> compareResult = {};
  bool hasCompared = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TopBar(
          title: 'JSON 比较',
          onMenuPressed: () {},
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCompareInputs(),
                const SizedBox(height: 24),
                _buildActionButtons(),
                const SizedBox(height: 24),
                if (hasCompared) _buildCompareResults(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompareInputs() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '原始 JSON',
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
              SizedBox(
                height: 300,
                child: JsonEditor(
                  initialValue: leftJson,
                  onChanged: (value) {
                    setState(() {
                      leftJson = value;
                      hasCompared = false;
                    });
                  },
                  placeholder: '在此输入原始 JSON',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '目标 JSON',
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
              SizedBox(
                height: 300,
                child: JsonEditor(
                  initialValue: rightJson,
                  onChanged: (value) {
                    setState(() {
                      rightJson = value;
                      hasCompared = false;
                    });
                  },
                  placeholder: '在此输入目标 JSON',
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
        icon: const Icon(Icons.compare_arrows),
        label: const Text('比较'),
        onPressed: () {
          if (leftJson.isEmpty || rightJson.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('请输入两侧的 JSON 数据')),
            );
            return;
          }

          setState(() {
            compareResult = JsonUtils.compareJson(leftJson, rightJson);
            hasCompared = true;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.dark,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildCompareResults() {
    if (compareResult.containsKey('error')) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.error.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: AppTheme.error),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '错误: ${compareResult['error']}',
                style: TextStyle(color: AppTheme.error),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '比较结果',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 16),
        _buildResultSection('差异', compareResult['differences'] ?? [], Colors.amber),
        const SizedBox(height: 12),
        _buildResultSection('新增', compareResult['added'] ?? [], Colors.green),
        const SizedBox(height: 12),
        _buildResultSection('删除', compareResult['removed'] ?? [], Colors.red),
        const SizedBox(height: 12),
        _buildResultSection('修改', compareResult['modified'] ?? [], Colors.blue),
      ],
    );
  }

  Widget _buildResultSection(String title, List items, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '$title (${items.length})',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF4B5563),
              ),
            ),
          ],
        ),
        if (items.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 8, left: 20),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    item.toString(),
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 14,
                    ),
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