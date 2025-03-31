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
      // 这里需要一个更复杂的实现来正确转换为YAML
      // 简化版本
      return jsonObj.toString();
    } catch (e) {
      return 'Error: $e';
    }
  }

  // YAML转JSON
  static String yamlToJson(String yamlStr) {
    try {
      var yamlDoc = loadYaml(yamlStr);
      // 需要将YAML对象转换为Dart对象，然后再转为JSON
      return json.encode(yamlDoc);
    } catch (e) {
      return 'Error: $e';
    }
  }

  // JSON转XML
  static String jsonToXml(String jsonStr) {
    try {
      var jsonObj = json.decode(jsonStr);
      // 需要一个复杂的实现来正确转换为XML
      // 简化版本
      return jsonObj.toString();
    } catch (e) {
      return 'Error: $e';
    }
  }

  // 比较两个JSON
  static Map<String, dynamic> compareJson(String json1, String json2) {
    try {
      var obj1 = json.decode(json1);
      var obj2 = json.decode(json2);
      
      // 这里需要一个复杂的实现来比较两个JSON对象
      // 返回差异
      return {
        'differences': [],
        'added': [],
        'removed': [],
        'modified': []
      };
    } catch (e) {
      return {'error': e.toString()};
    }
  }
}