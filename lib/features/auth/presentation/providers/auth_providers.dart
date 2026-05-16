import 'package:feed_flix/core/api/api_endpoints.dart';
import 'package:feed_flix/core/network/api_services.dart';
import 'package:feed_flix/core/storage_services/storage_service.dart';
import 'package:feed_flix/core/toke_service.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  final ApiService apiService;
  final TokenService tokenService;
  String _errorMessage = '';

  AuthProvider({required this.apiService, required this.tokenService});

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<bool> login({required String number}) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      if (number.isEmpty) {
        _isLoading = false;
        _errorMessage = 'Please enter a phone number';
        notifyListeners();
        return false;
      }

      if (number.length != 10) {
        _isLoading = false;
        _errorMessage = 'Please enter a valid 10-digit phone number';
        notifyListeners();
        return false;
      }

      final response = await apiService.post(
        ApiEndpoints.otp,
        data: {'country_code': '+91', 'phone': number},
      );
      print('1');
      print(response);
      _isLoading = false;

      if (response != null && response['token']['access'] != '') {
        print('3');
        await tokenService.saveToken(response['token']['access']);

        notifyListeners();
        return true;
      } else {
        print('4');
        _errorMessage = 'Login failed: No access token received';
        notifyListeners();
        return false;
      }
    } catch (e) {
      print(e.toString());
      _isLoading = false;
      _errorMessage = 'Login failed: $e';

      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }
}
