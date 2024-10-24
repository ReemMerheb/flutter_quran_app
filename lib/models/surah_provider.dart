import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SurahProvider with ChangeNotifier {
  List<String> _arabicAyahTexts = [];
  List<String> _englishAyahTexts = [];
  bool _isLoading = true;

  List<String> get arabicAyahTexts => _arabicAyahTexts;
  List<String> get englishAyahTexts => _englishAyahTexts;
  bool get isLoading => _isLoading;

  Future<void> fetchSurahText(int surahNumber) async {
    _isLoading = true;
    notifyListeners(); 

    final responseArabic = await http.get(
      Uri.parse('https://api.alquran.cloud/v1/surah/$surahNumber'),
    );

    final responseEnglish = await http.get(
      Uri.parse('https://api.alquran.cloud/v1/surah/$surahNumber/en.asad'),
    );

    if (responseArabic.statusCode == 200 && responseEnglish.statusCode == 200) {
      final arabicData = json.decode(responseArabic.body);
      final englishData = json.decode(responseEnglish.body);

      _arabicAyahTexts = List<String>.from(
          arabicData['data']['ayahs'].map((ayah) => ayah['text']));
      _englishAyahTexts = List<String>.from(
          englishData['data']['ayahs'].map((ayah) => ayah['text']));
      _isLoading = false;
      notifyListeners(); 
    } else {
      _isLoading = false;
      notifyListeners(); 
      throw Exception('Failed to load surah text');
    }
  }
}
