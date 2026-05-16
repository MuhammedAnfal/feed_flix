import 'package:feed_flix/core/network/api_services.dart';
import 'package:feed_flix/core/storage_services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  final SharedPreferences sharedPreferences;
  final ApiService apiService;

  TokenService({required this.sharedPreferences, required this.apiService});

  static const String _tokenKey = 'access_token';

  Future<void> saveToken(String tokenData) async {
    await sharedPreferences.setString(_tokenKey, tokenData);

    print(token);
    token = tokenData;
  }

  Future<void> clearToken() async {
    await sharedPreferences.remove(_tokenKey);
    token = null;
  }

  Future<bool> hasToken() async {
    final tokenData = sharedPreferences.getString(_tokenKey);
    if (tokenData != null) {
      token = tokenData;
      return true;
    }
    return false;
  }

  String? getToken() {
    return sharedPreferences.getString(_tokenKey);
  }
}
