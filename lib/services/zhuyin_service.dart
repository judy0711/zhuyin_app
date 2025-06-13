import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import '../models/zhuyin_mapping.dart';
import 'vision_service.dart';

class ZhuyinService extends ChangeNotifier {
  final ImagePicker _imagePicker = ImagePicker();
  final VisionService _visionService;
  bool _isWindowsPlatform = false;
  
  String _originalText = '';
  String _zhuyinText = '';
  File? _selectedImage;
  bool _isProcessing = false;
  String? _errorMessage;

  ZhuyinService(this._visionService) {
    _isWindowsPlatform = Platform.isWindows;
  }

  String get originalText => _originalText;
  String get zhuyinText => _zhuyinText;
  File? get selectedImage => _selectedImage;
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
      
      // For Windows, skip cropping
      if (!_isWindowsPlatform) {
        File? cropped = await _cropImage(File(image.path));
        if (cropped != null) {
          _selectedImage = cropped;
        } else {
          debugPrint('Image cropping cancelled');
          return;
        }
      } else {
        _selectedImage = File(image.path);
      }
      
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
      
      // For Windows, skip cropping
      if (!_isWindowsPlatform) {
        File? cropped = await _cropImage(File(image.path));
        if (cropped != null) {
          _selectedImage = cropped;
        } else {
          debugPrint('Image cropping cancelled');
          return;
        }
      } else {
        _selectedImage = File(image.path);
      }
      
      notifyListeners();
      await processImage();
    } catch (e) {
      debugPrint('Error taking photo: $e');
      _errorMessage = 'Error taking photo: $e';
      notifyListeners();
    }
  }

  Future<File?> _cropImage(File imageFile) async {
    try {
      if (_isWindowsPlatform) {
        return imageFile; // Skip cropping on Windows
      }
      
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        compressQuality: 85,
        aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
        ],
      );
      
      if (croppedFile != null) {
        debugPrint('Image cropped successfully: ${croppedFile.path}');
        return File(croppedFile.path!);
      }
      return null;
    } catch (e) {
      debugPrint('Error cropping image: $e');
      if (_isWindowsPlatform) {
        return imageFile; // Return original file on Windows if cropping fails
      }
      _errorMessage = 'Error cropping image: $e';
      notifyListeners();
      return null;
    }
  }

  Future<void> processImage() async {
    if (_selectedImage == null) return;

    _isProcessing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final String recognizedText = await _visionService.detectText(_selectedImage!);
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
    final List<String> result = [];
    
    for (int i = 0; i < text.length; i++) {
      final String char = text[i];
      final String? zhuyin = ZhuyinMapping.getZhuyin(char);
      
      if (zhuyin != null) {
        result.add('$char($zhuyin)');
      } else {
        result.add(char);
      }
    }
    
    return result.join(' ');
  }

  @override
  void dispose() {
    super.dispose();
  }
} 