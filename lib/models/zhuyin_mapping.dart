import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class ZhuyinMapping {
  static final Map<String, String> _zhuyinMap = {};
  static bool _isInitialized = false;

  static Future<void> loadDictionary() async {
    if (_isInitialized) return;

    try {
      debugPrint("Attempting to load zhuyin_dict.json...");
      final jsonString = await rootBundle.loadString('lib/zhuyin_transform/zhuyin_dict.json');
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      jsonMap.forEach((key, value) {
        _zhuyinMap[key] = value.toString();
      });
      _isInitialized = true;
      debugPrint("Dictionary loaded successfully with \\${_zhuyinMap.length} entries.");
    } catch (e) {
      debugPrint("!!!!!!!!!! FAILED TO LOAD ZHUYIN DICTIONARY !!!!!!!!!!");
      debugPrint("Error type: \\${e.runtimeType}");
      debugPrint("Error details: $e");
      _isInitialized = true; // Mark as initialized to prevent repeated failures.
    }
  }

  static String? getZhuyin(String char) {
    if (!_isInitialized) {
      print("Warning: Zhuyin dictionary accessed before it was loaded.");
      return null;
    }
    return _zhuyinMap[char];
  }

  static bool isZhuyin(String char) {
    return _zhuyinMap.containsValue(char);
  }

  static String? getZhuyinForWord(String word) {
    if (!_isInitialized) {
      print("Warning: Zhuyin dictionary accessed before it was loaded.");
      return null;
    }
    return _zhuyinMap[word];
  }
} 