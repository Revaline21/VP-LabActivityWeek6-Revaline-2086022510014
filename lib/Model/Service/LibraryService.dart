import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class LibraryService {
  final String _assetPath;

  LibraryService({String assetPath = 'assets/library_data.json'})
      : _assetPath = assetPath;
  Future<Map<String, dynamic>> fetchLibraryData() async {
    try {
      final String jsonString = await rootBundle.loadString(_assetPath);
      final Map<String, dynamic> data = json.decode(jsonString);
      return data;
    } catch (e) {
      debugPrint('Error saat membaca file JSON: $e');
      return {
        'books': [],
        'loans': [],
      };
    }
  }
}