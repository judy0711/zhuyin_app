class ZhuyinMapping {
  static const Map<String, String> _zhuyinMap = {
    // Basic consonants
    'ㄅ': 'b', 'ㄆ': 'p', 'ㄇ': 'm', 'ㄈ': 'f',
    'ㄉ': 'd', 'ㄊ': 't', 'ㄋ': 'n', 'ㄌ': 'l',
    'ㄍ': 'g', 'ㄎ': 'k', 'ㄏ': 'h',
    'ㄐ': 'j', 'ㄑ': 'q', 'ㄒ': 'x',
    'ㄓ': 'zh', 'ㄔ': 'ch', 'ㄕ': 'sh', 'ㄖ': 'r',
    'ㄗ': 'z', 'ㄘ': 'c', 'ㄙ': 's',
    
    // Vowels
    'ㄚ': 'a', 'ㄛ': 'o', 'ㄜ': 'e', 'ㄝ': 'ê',
    'ㄞ': 'ai', 'ㄟ': 'ei', 'ㄠ': 'ao', 'ㄡ': 'ou',
    'ㄢ': 'an', 'ㄣ': 'en', 'ㄤ': 'ang', 'ㄥ': 'eng',
    'ㄦ': 'er',
    
    // Medials
    'ㄧ': 'i', 'ㄨ': 'u', 'ㄩ': 'ü',
    
    // Tones
    'ˊ': '2', 'ˇ': '3', 'ˋ': '4', '˙': '5'
  };

  static String? getZhuyin(String character) {
    return _zhuyinMap[character];
  }

  static bool isZhuyin(String character) {
    return _zhuyinMap.containsKey(character);
  }
} 