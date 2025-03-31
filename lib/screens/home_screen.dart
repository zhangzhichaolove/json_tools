import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/top_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TopBar(
          title: '欢迎使用',
          onMenuPressed: () {},
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 32),
                _buildFeatureGrid(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 128,
          height: 128,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            // 替换网络图片为纯色背景和图标
            color: AppTheme.primary.withOpacity(0.1),
          ),
          // 添加一个图标代替网络图片
          child: const Icon(
            Icons.data_object,
            size: 64,
            color: AppTheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          '欢迎使用 JSON 工具箱',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          '强大的 JSON 处理工具，帮助开发者更高效地处理 JSON 数据',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureGrid() {
    final features = [
      {
        'title': '格式化与验证',
        'description': '美化、压缩JSON数据，并检查语法错误',
        'icon': Icons.storage,
        'color': AppTheme.primary,
      },
      {
        'title': '格式转换',
        'description': '在JSON、YAML、XML、CSV等格式间转换',
        'icon': Icons.swap_horiz,
        'color': AppTheme.secondary,
      },
      {
        'title': '可视化分析',
        'description': '树状结构展示，直观分析JSON数据',
        'icon': Icons.bar_chart,
        'color': AppTheme.success,
      },
      {
        'title': '高级工具',
        'description': '比较、查询、编辑等专业功能',
        'icon': Icons.settings,
        'color': AppTheme.warning,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 2.2,  // 从2.5减小到2.2，给每个项目更多垂直空间
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey[200]!),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (feature['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    feature['icon'] as IconData,
                    color: feature['color'] as Color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,  // 添加这一行以减少垂直空间占用
                    children: [
                      Text(
                        feature['title'] as String,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                        maxLines: 1,  // 限制为单行
                        overflow: TextOverflow.ellipsis,  // 文本溢出时显示省略号
                      ),
                      const SizedBox(height: 4),
                      Text(
                        feature['description'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                        maxLines: 2,  // 限制为两行
                        overflow: TextOverflow.ellipsis,  // 文本溢出时显示省略号
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}