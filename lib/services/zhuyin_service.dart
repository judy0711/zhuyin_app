import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/zhuyin_mapping.dart';
import 'vision_service.dart';

class ZhuyinService extends ChangeNotifier {
  final ImagePicker _imagePicker = ImagePicker();
  final VisionService _visionService;
  
  String _originalText = '';
  String _zhuyinText = '';
  XFile? _selectedImage;
  bool _isProcessing = false;
  String? _errorMessage;

  ZhuyinService(this._visionService);

  String get originalText => _originalText;
  String get zhuyinText => _zhuyinText;
  XFile? get selectedImage => _selectedImage;
  bool get isProcessing => _isProcessing;
  String? get errorMessage => _errorMessage;

  Future<void> pickImage() async {
    try {
      _errorMessage = null;
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );
      
      if (image == null) {
        debugPrint('No image selected');
        return;
      }

      debugPrint('Image picked: ${image.path}');
      _selectedImage = image;
      
      notifyListeners();
      await processImage();
    } catch (e) {
      debugPrint('Error picking image: $e');
      _errorMessage = 'Error picking image: $e';
      notifyListeners();
    }
  }

  Future<void> takePhoto() async {
    try {
      _errorMessage = null;
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );
      
      if (image == null) {
        debugPrint('No image captured');
        return;
      }

      debugPrint('Photo taken: ${image.path}');
      _selectedImage = image;
      
      notifyListeners();
      await processImage();
    } catch (e) {
      debugPrint('Error taking photo: $e');
      _errorMessage = 'Error taking photo: $e';
      notifyListeners();
    }
  }

  Future<void> processImage() async {
    if (_selectedImage == null) return;

    _isProcessing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final imageBytes = await _selectedImage!.readAsBytes();
      final String recognizedText = await _visionService.detectText(imageBytes);
      _originalText = recognizedText;
      _zhuyinText = await convertToZhuyin(_originalText);
      
      debugPrint('Recognized text: $_originalText');
    } catch (e) {
      debugPrint('Error processing image: $e');
      _originalText = 'Error processing image';
      _zhuyinText = '';
      _errorMessage = e.toString();
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  Future<String> convertToZhuyin(String text) async {
    final cleanText = text.trim();
    debugPrint("Converting text: '$cleanText'");
    final List<String> result = [];

    // First, try to match the whole cleaned text as a single word
    debugPrint("Attempting to find word in dictionary: '$cleanText'");
    final wordZhuyin = ZhuyinMapping.getZhuyin(cleanText);
    if (wordZhuyin != null) {
      debugPrint("Found word '$cleanText' with zhuyin '$wordZhuyin'");
      result.add('$cleanText($wordZhuyin)');
    } else {
      debugPrint("Word '$cleanText' not found. Checking character by character.");
      // If no exact match, process character by character
      for (int i = 0; i < cleanText.length; i++) {
        final String char = cleanText[i];
        if (char.trim().isEmpty) continue;

        debugPrint("Attempting to find character in dictionary: '$char'");
        final String? zhuyin = ZhuyinMapping.getZhuyin(char);

        if (zhuyin != null) {
          debugPrint("Found character '$char' with zhuyin '$zhuyin'");
          result.add('$char($zhuyin)');
        } else {
          debugPrint("Character '$char' not found.");
          result.add('$char(?)'); // Mark unmatched characters
        }
      }
    }
    final finalResult = result.join(' ');
    debugPrint("Conversion result: '$finalResult'");
    return finalResult;
  }

  @override
  void dispose() {
    super.dispose();
  }
} 