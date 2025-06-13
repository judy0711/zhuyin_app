import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:googleapis/vision/v1.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'auth_service.dart';

class VisionService {
  final AuthService _authService;
  ImageAnnotatorApi? _visionApi;

  VisionService(this._authService);

  Future<void> _initializeApi() async {
    if (_visionApi != null) return;

    final client = await _authService.getClient();
    if (client == null) {
      throw Exception('Not authenticated. Please sign in first.');
    }

    _visionApi = ImageAnnotatorApi(client);
    debugPrint('Vision API initialized');
  }

  Future<String> detectText(File imageFile) async {
    try {
      debugPrint('Starting image processing...');
      
      if (!await imageFile.exists()) {
        throw Exception('Image file does not exist: ${imageFile.path}');
      }

      // Read the image file as bytes
      final List<int> imageBytes = await imageFile.readAsBytes();
      if (imageBytes.isEmpty) {
        throw Exception('Image file is empty');
      }
      
      debugPrint('Image loaded, size: ${imageBytes.length} bytes');

      // Initialize the API if needed
      await _initializeApi();
      if (_visionApi == null) {
        throw Exception('Failed to initialize Vision API');
      }

      // Create the request
      final request = BatchAnnotateImagesRequest(requests: [
        AnnotateImageRequest(
          image: Image(content: base64Encode(imageBytes)),
          features: [Feature(type: 'TEXT_DETECTION', maxResults: 1)],
          imageContext: ImageContext(
            languageHints: ['zh-Hant', 'zh'],
          ),
        ),
      ]);

      debugPrint('Sending request to Vision API...');
      
      // Make the API request
      final response = await _visionApi!.images.annotate(request);
      
      if (response.responses == null || response.responses!.isEmpty) {
        throw Exception('Empty response from Vision API');
      }

      final firstResponse = response.responses!.first;
      
      if (firstResponse.error != null) {
        throw Exception('API Error: ${firstResponse.error!.message}');
      }

      if (firstResponse.textAnnotations == null || 
          firstResponse.textAnnotations!.isEmpty) {
        throw Exception('No text detected in image');
      }

      final text = firstResponse.textAnnotations!.first.description;
      if (text == null || text.isEmpty) {
        throw Exception('Empty text result');
      }

      debugPrint('Successfully extracted text: $text');
      return text;
    } catch (e) {
      debugPrint('Error in Vision API: $e');
      rethrow;
    }
  }
} 