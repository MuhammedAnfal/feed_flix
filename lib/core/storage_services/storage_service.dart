import 'package:feed_flix/core/constants/string_constatnts/string_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  static late SharedPreferences _pref;

  static Future<void> inIt() async {
    _pref = await SharedPreferences.getInstance();
  }

  static Future<void> setToken({required String value}) async {
    await _pref.setString(AppStrings.tokenKey, value);
  }

  static String? getString() {
    return _pref.getString(AppStrings.tokenKey);
  }

  static Future<void> clearKey() async {
    await _pref.remove(AppStrings.tokenKey);
  }
}
