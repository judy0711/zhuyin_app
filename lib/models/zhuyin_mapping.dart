import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:excel/excel.dart';

class ZhuyinMapping {
  static final Map<String, String> _zhuyinMap = {};
  static bool _isInitialized = false;

  static Future<void> loadDictionary() async {
    if (_isInitialized) return;

    try {
      debugPrint("Attempting to load dictionary...");
      final bytes = await rootBundle.load('lib/zhuyin_transform/dict_revised_2015_20250327.xlsx');
      debugPrint("Dictionary file loaded, decoding...");
      final excel = Excel.decodeBytes(bytes.buffer.asUint8List());
      debugPrint("Decoding complete, processing rows...");

      // Assuming the first sheet and correct columns (A=Character, I=Zhuyin)
      final sheet = excel.tables[excel.tables.keys.first];
      if (sheet == null) {
        debugPrint("Error: Could not find the first sheet in the Excel file.");
        return;
      }

      for (final row in sheet.rows) {
        if (row.length >= 9 && row[0] != null && row[8] != null) {
          final character = row[0]!.value.toString().trim();
          final zhuyin = row[8]!.value.toString().trim();
          if (character.isNotEmpty) {
            _zhuyinMap[character] = zhuyin;
          }
        }
      }
      _isInitialized = true;
      debugPrint("Dictionary loaded successfully with ${_zhuyinMap.length} entries.");
    } catch (e) {
      debugPrint("!!!!!!!!!! FAILED TO LOAD ZHUYIN DICTIONARY !!!!!!!!!!");
      debugPrint("Error type: ${e.runtimeType}");
      debugPrint("Error details: $e");
      // In a real app, you might want to show an error dialog.
      // For now, we allow the app to continue with an empty dictionary.
      _isInitialized = true; // Mark as initialized to prevent repeated failures.
    }
  }

  static String? getZhuyin(String char) {
    if (!_isInitialized) {
      // This is a fallback, but the dictionary should be loaded on startup.
      print("Warning: Zhuyin dictionary accessed before it was loaded.");
      return null;
    }
    return _zhuyinMap[char];
  }

  static bool isZhuyin(String char) {
    // This check may need to be updated depending on your dictionary content.
    return _zhuyinMap.containsValue(char);
  }
} 