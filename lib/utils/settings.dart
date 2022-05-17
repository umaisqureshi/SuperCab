import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ValueNotifier<Locale> mobileLanguage = new ValueNotifier(Locale('en', ''));

Future<String> getLanguage() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

/*  mobileLanguage.value = Locale(
      preferences.containsKey('language')
          ? preferences.getString('language')
          : "en",
      '');
  mobileLanguage.notifyListeners();*/
  return preferences.containsKey('language')
      ? preferences.getString('language')
      : "en";
}

Future<String> setLangauge(lang) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString('language', lang);
  return lang;
}
