import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class VisionService {
  // TODO: Replace with your actual Google Cloud API Key
  final String _apiKey = 'AIzaSyDqJWrP6kG0Xss5Z5cvLcdN9MDrGV4GAms';

  Future<String> detectText(Uint8List imageBytes) async {
    final url = Uri.parse(
        'https://vision.googleapis.com/v1/images:annotate?key=$_apiKey');

    final body = {
      'requests': [
        {
          'image': {'content': base64Encode(imageBytes)},
          'features': [
            {'type': 'TEXT_DETECTION'}
          ],
          'imageContext': {
            'languageHints': ['zh-Hant', 'zh']
          }
        }
      ]
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to call Vision API: ${response.body}');
    }

    final responseJson = jsonDecode(response.body);
    final allResponses = responseJson['responses'];

    if (allResponses == null || allResponses.isEmpty) {
      throw Exception('Empty response from Vision API');
    }

    final firstResponse = allResponses[0];
    if (firstResponse['error'] != null) {
      throw Exception('API Error: ${firstResponse['error']['message']}');
    }

    if (firstResponse['fullTextAnnotation'] == null ||
        firstResponse['fullTextAnnotation']['text'] == null) {
      return 'No text detected.';
    }

    return firstResponse['fullTextAnnotation']['text'];
  }
} 