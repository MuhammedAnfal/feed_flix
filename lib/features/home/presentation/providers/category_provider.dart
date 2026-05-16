import 'package:feed_flix/core/api/api_endpoints.dart';
import 'package:feed_flix/core/network/api_services.dart';
import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  final ApiService apiService;

  List<dynamic> _categories = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<dynamic> get categories => _categories;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  CategoryProvider(this.apiService);

  Future<void> getCategories() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Call category_list API to get categories
      final response = await apiService.get(ApiEndpoints.category);

      _isLoading = false;

      if (response != null && response['categories'] != null) {
        _categories = response['categories'];
      } else {
        _errorMessage = 'No categories available';
        _categories = [];
      }

      notifyListeners();
    } catch (e) {
      print('Category API Error: ${e.toString()}');
      _isLoading = false;
      _errorMessage = 'Failed to load categories: ${e.toString()}';
      _categories = [];
      notifyListeners();
    }
  }
}
