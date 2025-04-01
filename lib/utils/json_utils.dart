import 'dart:convert';
import 'package:yaml/yaml.dart';
import 'package:xml/xml.dart';

class JsonUtils {
  // 格式化JSON
  static String formatJson(String jsonStr) {
    try {
      var jsonObj = json.decode(jsonStr);
      return const JsonEncoder.withIndent('  ').convert(jsonObj);
    } catch (e) {
      return 'Error: $e';
    }
  }

  // 压缩JSON
  static String minifyJson(String jsonStr) {
    try {
      var jsonObj = json.decode(jsonStr);
      return json.encode(jsonObj);
    } catch (e) {
      return 'Error: $e';
    }
  }

  // 验证JSON
  static bool validateJson(String jsonStr) {
    try {
      json.decode(jsonStr);
      return true;
    } catch (e) {
      return false;
    }
  }

  // JSON转YAML
  static String jsonToYaml(String jsonStr) {
    try {
      var jsonObj = json.decode(jsonStr);
      return _convertJsonToYaml(jsonObj);
    } catch (e) {
      return 'Error: $e';
    }
  }

  // 将JSON对象转换为YAML字符串
  static String _convertJsonToYaml(dynamic jsonObj, {int indent = 0}) {
    final indentStr = '  ' * indent;
    final buffer = StringBuffer();
    
    if (jsonObj == null) {
      buffer.write('${indentStr}null');
    } else if (jsonObj is String) {
      // 处理字符串，如果包含特殊字符则添加引号
      if (jsonObj.contains('\n') || jsonObj.contains(':') || 
          jsonObj.contains('{') || jsonObj.contains('}') || 
          jsonObj.contains('[') || jsonObj.contains(']') ||
          jsonObj.contains('#') || jsonObj.trim().isEmpty) {
        // 多行字符串使用 | 符号
        if (jsonObj.contains('\n')) {
          buffer.write('$indentStr|\n');
          final lines = jsonObj.split('\n');
          for (var line in lines) {
            buffer.write('$indentStr  $line\n');
          }
        } else {
          // 转义引号
          final escaped = jsonObj.replaceAll('"', '\\"');
          buffer.write('$indentStr"$escaped"');
        }
      } else {
        buffer.write('$indentStr$jsonObj');
      }
    } else if (jsonObj is num || jsonObj is bool) {
      buffer.write('$indentStr$jsonObj');
    } else if (jsonObj is List) {
      if (jsonObj.isEmpty) {
        buffer.write('$indentStr[]');
      } else {
        for (var item in jsonObj) {
          buffer.write('$indentStr- ');
          if (item is Map || item is List) {
            buffer.write('\n');
            buffer.write(_convertJsonToYaml(item, indent: indent + 1));
          } else {
            buffer.write(_convertJsonToYaml(item).trimLeft());
            buffer.write('\n');
          }
        }
      }
    } else if (jsonObj is Map) {
      if (jsonObj.isEmpty) {
        buffer.write('$indentStr{}');
      } else {
        jsonObj.forEach((key, value) {
          buffer.write('$indentStr$key: ');
          if (value is Map || value is List) {
            buffer.write('\n');
            buffer.write(_convertJsonToYaml(value, indent: indent + 1));
          } else {
            buffer.write(_convertJsonToYaml(value).trimLeft());
            buffer.write('\n');
          }
        });
      }
    }
    
    return buffer.toString();
  }

  // YAML转JSON
  static String yamlToJson(String yamlStr) {
    try {
      var yamlDoc = loadYaml(yamlStr);
      // 将YAML对象转换为Dart对象，然后再转为JSON
      return json.encode(_convertYamlToJson(yamlDoc));
    } catch (e) {
      return 'Error: $e';
    }
  }

  // 将YAML对象转换为JSON兼容的对象
  static dynamic _convertYamlToJson(dynamic yamlObj) {
    if (yamlObj is YamlMap) {
      final Map<String, dynamic> result = {};
      for (var entry in yamlObj.entries) {
        result[entry.key.toString()] = _convertYamlToJson(entry.value);
      }
      return result;
    } else if (yamlObj is YamlList) {
      return yamlObj.map((item) => _convertYamlToJson(item)).toList();
    } else {
      return yamlObj;
    }
  }

  // JSON转XML
  // XML 转换方法
  static String jsonToXml(String jsonStr) {
    try {
      final dynamic jsonData = json.decode(jsonStr);
      return _convertJsonToXml(jsonData, 'root');
    } catch (e) {
      throw '无法将 JSON 转换为 XML: ${e.toString()}';
    }
  }

  static String _convertJsonToXml(dynamic jsonData, String rootName, {int indent = 0}) {
    final indentStr = '  ' * indent;
    final buffer = StringBuffer();
    
    if (jsonData == null) {
      buffer.write('$indentStr<$rootName>null</$rootName>\n');
    } else if (jsonData is String) {
      final escaped = jsonData
          .replaceAll('&', '&amp;')
          .replaceAll('<', '&lt;')
          .replaceAll('>', '&gt;')
          .replaceAll('"', '&quot;')
          .replaceAll("'", '&apos;');
      buffer.write('$indentStr<$rootName>$escaped</$rootName>\n');
    } else if (jsonData is num || jsonData is bool) {
      buffer.write('$indentStr<$rootName>$jsonData</$rootName>\n');
    } else if (jsonData is List) {
      buffer.write('$indentStr<$rootName>\n');
      for (var item in jsonData) {
        buffer.write(_convertJsonToXml(item, 'item', indent: indent + 1));
      }
      buffer.write('$indentStr</$rootName>\n');
    } else if (jsonData is Map) {
      buffer.write('$indentStr<$rootName>\n');
      jsonData.forEach((key, value) {
        buffer.write(_convertJsonToXml(value, key.toString(), indent: indent + 1));
      });
      buffer.write('$indentStr</$rootName>\n');
    }
    
    return buffer.toString();
  }

  static String xmlToJson(String xmlStr) {
    try {
      // 简单的XML解析实现
      // 注意：这是一个简化版本，不处理所有XML特性
      final Map<String, dynamic> result = _parseXml(xmlStr);
      return json.encode(result);
    } catch (e) {
      throw '无法将 XML 转换为 JSON: ${e.toString()}';
    }
  }

  static Map<String, dynamic> _parseXml(String xmlStr) {
    // 移除XML声明
    xmlStr = xmlStr.replaceAll(RegExp(r'<\?xml.*?\?>'), '');
    
    // 查找根元素
    final rootMatch = RegExp(r'<([^\s>]+)[^>]*>([\s\S]*)<\/\1>').firstMatch(xmlStr.trim());
    if (rootMatch == null) {
      throw '无效的XML格式';
    }
    
    final rootName = rootMatch.group(1);
    final rootContent = rootMatch.group(2);
    
    return {rootName!: _parseXmlNode(rootContent!)};
  }

  static dynamic _parseXmlNode(String content) {
    content = content.trim();
    if (content.isEmpty) return '';
    
    // 检查是否有子元素
    if (!content.contains('<')) {
      // 纯文本节点
      return content
          .replaceAll('&amp;', '&')
          .replaceAll('&lt;', '<')
          .replaceAll('&gt;', '>')
          .replaceAll('&quot;', '"')
          .replaceAll('&apos;', "'");
    }
    
    // 查找所有子元素
    final Map<String, dynamic> result = {};
    final List<String> items = [];
    
    final elementRegex = RegExp(r'<([^\s>/]+)[^>]*>([\s\S]*?)<\/\1>');
    final matches = elementRegex.allMatches(content);
    
    for (final match in matches) {
      final tagName = match.group(1)!;
      final tagContent = match.group(2)!;
      
      if (tagName == 'item') {
        items.add(_parseXmlNode(tagContent));
      } else {
        if (result.containsKey(tagName)) {
          if (result[tagName] is List) {
            result[tagName].add(_parseXmlNode(tagContent));
          } else {
            result[tagName] = [result[tagName], _parseXmlNode(tagContent)];
          }
        } else {
          result[tagName] = _parseXmlNode(tagContent);
        }
      }
    }
    
    if (items.isNotEmpty) {
      return items;
    }
    
    return result;
  }

  // CSV 转换方法
  static String jsonToCsv(String jsonStr) {
    try {
      final dynamic jsonData = json.decode(jsonStr);
      
      // 处理不同类型的JSON输入
      if (jsonData is Map) {
        // 如果是单个对象，将其转换为只有一行的CSV
        final Map<String, dynamic> jsonMap = jsonData as Map<String, dynamic>;
        final Set<String> columns = jsonMap.keys.toSet();
        
        final buffer = StringBuffer();
        
        // 写入标题行
        buffer.writeln(columns.join(','));
        
        // 写入数据行
        final values = columns.map((col) {
          var value = jsonMap[col];
          if (value == null) return '';
          if (value is String) {
            // 处理CSV中的特殊字符
            if (value.contains(',') || value.contains('"') || value.contains('\n')) {
              return '"${value.replaceAll('"', '""')}"';
            }
            return value;
          }
          return value.toString();
        }).join(',');
        buffer.writeln(values);
        
        return buffer.toString();
      } else if (jsonData is List) {
        // 原有的数组处理逻辑
        if (jsonData.isEmpty) return '';
        
        // 确保数据是对象列表
        if (jsonData.first is! Map) {
          throw '只支持对象或对象数组转换为CSV';
        }
        
        // 获取所有可能的列
        final Set<String> columns = {};
        for (var item in jsonData) {
          if (item is Map) {
            columns.addAll(item.keys.map((k) => k.toString()));
          }
        }
        
        final buffer = StringBuffer();
        
        // 写入标题行
        buffer.writeln(columns.join(','));
        
        // 写入数据行
        for (var item in jsonData) {
          if (item is Map) {
            final values = columns.map((col) {
              var value = item[col];
              if (value == null) return '';
              if (value is String) {
                // 处理CSV中的特殊字符
                if (value.contains(',') || value.contains('"') || value.contains('\n')) {
                  return '"${value.replaceAll('"', '""')}"';
                }
                return value;
              }
              return value.toString();
            }).join(',');
            buffer.writeln(values);
          }
        }
        
        return buffer.toString();
      } else {
        throw '只支持对象或对象数组转换为CSV';
      }
    } catch (e) {
      throw '无法将 JSON 转换为 CSV: ${e.toString()}';
    }
  }

  static String csvToJson(String csvStr) {
    try {
      final lines = csvStr.split('\n').where((line) => line.trim().isNotEmpty).toList();
      if (lines.isEmpty) return '[]';
      
      // 解析标题行
      final headers = _parseCsvLine(lines.first);
      
      // 解析数据行
      final List<Map<String, dynamic>> result = [];
      for (var i = 1; i < lines.length; i++) {
        final values = _parseCsvLine(lines[i]);
        if (values.length != headers.length) continue;
        
        final Map<String, dynamic> row = {};
        for (var j = 0; j < headers.length; j++) {
          row[headers[j]] = values[j];
        }
        result.add(row);
      }
      
      return json.encode(result);
    } catch (e) {
      throw '无法将 CSV 转换为 JSON: ${e.toString()}';
    }
  }

  static List<String> _parseCsvLine(String line) {
    final List<String> result = [];
    bool inQuotes = false;
    StringBuffer currentValue = StringBuffer();
    
    for (var i = 0; i < line.length; i++) {
      final char = line[i];
      
      if (char == '"') {
        if (i + 1 < line.length && line[i + 1] == '"') {
          // 处理双引号转义
          currentValue.write('"');
          i++;
        } else {
          inQuotes = !inQuotes;
        }
      } else if (char == ',' && !inQuotes) {
        result.add(currentValue.toString());
        currentValue = StringBuffer();
      } else {
        currentValue.write(char);
      }
    }
    
    result.add(currentValue.toString());
    return result;
  }

  // URL 参数转换方法
  static String jsonToUrlParams(String jsonStr) {
    try {
      final dynamic jsonData = json.decode(jsonStr);
      if (jsonData is! Map<String, dynamic>) {
        throw '只支持对象转换为URL参数';
      }
      
      return _convertJsonToUrlParams(jsonData);
    } catch (e) {
      throw '无法将 JSON 转换为 URL 参数: ${e.toString()}';
    }
  }

  static String _convertJsonToUrlParams(Map<String, dynamic> json, {String prefix = ''}) {
    final List<String> params = [];
    
    json.forEach((key, value) {
      final String fullKey = prefix.isEmpty ? key : '$prefix[$key]';
      
      if (value == null) {
        params.add('$fullKey=');
      } else if (value is String || value is num || value is bool) {
        params.add('$fullKey=${Uri.encodeComponent(value.toString())}');
      } else if (value is List) {
        for (var i = 0; i < value.length; i++) {
          final item = value[i];
          if (item is Map) {
            params.add(_convertJsonToUrlParams(item as Map<String, dynamic>, prefix: '$fullKey[]'));
          } else {
            params.add('$fullKey[]=${Uri.encodeComponent(item.toString())}');
          }
        }
      } else if (value is Map) {
        params.add(_convertJsonToUrlParams(value as Map<String, dynamic>, prefix: fullKey));
      }
    });
    
    return params.join('&');
  }

  static String urlParamsToJson(String urlParams) {
    try {
      final Map<String, dynamic> result = {};
      
      if (urlParams.trim().isEmpty) return '{}';
      
      final params = urlParams.split('&');
      for (var param in params) {
        if (!param.contains('=')) continue;
        
        final parts = param.split('=');
        final key = parts[0];
        final value = parts.length > 1 ? Uri.decodeComponent(parts[1]) : '';
        
        _setNestedValue(result, key, value);
      }
      
      return json.encode(result);
    } catch (e) {
      throw '无法将 URL 参数转换为 JSON: ${e.toString()}';
    }
  }

  static void _setNestedValue(Map<String, dynamic> obj, String key, String value) {
    // 处理数组索引，如 key[] 或 key[0]
    final arrayMatch = RegExp(r'^(.*?)\[(.*?)\](.*)$').firstMatch(key);
    if (arrayMatch != null) {
      final baseKey = arrayMatch.group(1)!;
      final index = arrayMatch.group(2);
      final remainingKey = arrayMatch.group(3)!;
      
      if (!obj.containsKey(baseKey)) {
        obj[baseKey] = index!.isEmpty ? [] : {};
      }
      
      if (index!.isEmpty) {
        // 处理 key[] 形式
        if (obj[baseKey] is! List) {
          obj[baseKey] = [];
        }
        
        if (remainingKey.isEmpty) {
          (obj[baseKey] as List).add(value);
        } else {
          final Map<String, dynamic> newObj = {};
          (obj[baseKey] as List).add(newObj);
          _setNestedValue(newObj, remainingKey.substring(1), value);
        }
      } else {
        // 处理 key[index] 形式
        if (obj[baseKey] is! Map) {
          obj[baseKey] = <String, dynamic>{};
        }
        
        if (remainingKey.isEmpty) {
          (obj[baseKey] as Map)[index] = value;
        } else {
          if (!((obj[baseKey] as Map).containsKey(index))) {
            (obj[baseKey] as Map)[index] = <String, dynamic>{};
          }
          _setNestedValue((obj[baseKey] as Map)[index], remainingKey.substring(1), value);
        }
      }
    } else {
      // 简单键值对
      obj[key] = value;
    }
  }

  // 比较两个JSON
  static Map<String, dynamic> compareJson(String json1, String json2) {
    try {
      var obj1 = json.decode(json1);
      var obj2 = json.decode(json2);
      
      Map<String, dynamic> result = {
        'differences': <String>[],
        'added': <String>[],
        'removed': <String>[],
        'modified': <String>[]
      };
      
      // 比较两个对象
      _compareObjects(obj1, obj2, '', result);
      
      return result;
    } catch (e) {
      return {'error': e.toString()};
    }
  }
  
  // 递归比较两个对象
  static void _compareObjects(dynamic obj1, dynamic obj2, String path, Map<String, dynamic> result) {
    // 如果类型不同，直接标记为差异
    if (obj1.runtimeType != obj2.runtimeType) {
      result['differences'].add('$path: 类型不同 - ${obj1.runtimeType} vs ${obj2.runtimeType}');
      return;
    }
    
    // 根据类型进行比较
    if (obj1 is Map) {
      // 比较两个Map
      Set<String> keys1 = Set<String>.from(obj1.keys.map((k) => k.toString()));
      Set<String> keys2 = Set<String>.from(obj2.keys.map((k) => k.toString()));
      
      // 找出新增的键
      for (String key in keys2.difference(keys1)) {
        String currentPath = path.isEmpty ? key : '$path.$key';
        result['added'].add('$currentPath: ${_formatValue(obj2[key])}');
      }
      
      // 找出删除的键
      for (String key in keys1.difference(keys2)) {
        String currentPath = path.isEmpty ? key : '$path.$key';
        result['removed'].add('$currentPath: ${_formatValue(obj1[key])}');
      }
      
      // 比较共有的键
      for (String key in keys1.intersection(keys2)) {
        String currentPath = path.isEmpty ? key : '$path.$key';
        _compareObjects(obj1[key], obj2[key], currentPath, result);
      }
    } else if (obj1 is List) {
      // 比较两个List
      if (obj1.length != obj2.length) {
        result['differences'].add('$path: 数组长度不同 - ${obj1.length} vs ${obj2.length}');
      }
      
      // 比较数组元素（按索引）
      int minLength = obj1.length < obj2.length ? obj1.length : obj2.length;
      for (int i = 0; i < minLength; i++) {
        _compareObjects(obj1[i], obj2[i], '$path[$i]', result);
      }
      
      // 处理多余的元素
      if (obj1.length < obj2.length) {
        for (int i = obj1.length; i < obj2.length; i++) {
          result['added'].add('$path[$i]: ${_formatValue(obj2[i])}');
        }
      } else if (obj1.length > obj2.length) {
        for (int i = obj2.length; i < obj1.length; i++) {
          result['removed'].add('$path[$i]: ${_formatValue(obj1[i])}');
        }
      }
    } else {
      // 比较基本类型值
      if (obj1 != obj2) {
        result['modified'].add('$path: ${_formatValue(obj1)} => ${_formatValue(obj2)}');
      }
    }
  }
  
  // 格式化值以便显示
  static String _formatValue(dynamic value) {
    if (value == null) return 'null';
    if (value is String) return '"$value"';
    if (value is Map || value is List) {
      String jsonStr = json.encode(value);
      if (jsonStr.length > 50) {
        return '${jsonStr.substring(0, 47)}...';
      }
      return jsonStr;
    }
    return value.toString();
  }
}