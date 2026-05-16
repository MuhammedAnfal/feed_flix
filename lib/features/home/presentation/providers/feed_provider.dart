import 'package:feed_flix/core/api/api_endpoints.dart';
import 'package:feed_flix/core/network/api_services.dart' show ApiService;
import 'package:feed_flix/features/home/data/models/feed_model.dart';
import 'package:flutter/material.dart';

class FeedProvider with ChangeNotifier {
  final ApiService apiService;

  List<Results> _feeds = [];
  List<Results> _filteredFeeds = [];
  bool _isLoading = false;
  String _errorMessage = '';
  int? _selectedCategoryId; // Change to int
  String? _selectedCategoryTitle;

  List<Results> get feeds => _selectedCategoryId != null ? _filteredFeeds : _feeds;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  int? get selectedCategoryId => _selectedCategoryId; // Change to int
  String? get selectedCategoryTitle => _selectedCategoryTitle;

  FeedProvider(this.apiService);

  Future<void> getFeeds() async {
    _isLoading = true;
    _errorMessage = '';
    _selectedCategoryId = null;
    _selectedCategoryTitle = null;
    notifyListeners();

    try {
      final response = await apiService.get(ApiEndpoints.category);
      print('API Response: $response');

      _isLoading = false;

      final feedModel = FeedModel.fromJson(response);
      print('feedModel: $feedModel');

      if (feedModel.results != null && feedModel.results!.isNotEmpty) {
        _feeds = feedModel.results!;
        _filteredFeeds = []; // Reset filtered feeds
        print('Feeds loaded: ${_feeds.length}');
      } else {
        _errorMessage = 'No feeds available';
        _feeds = [];
        _filteredFeeds = [];
      }

      notifyListeners();
    } catch (e) {
      print(e.toString());
      _isLoading = false;
      _errorMessage = 'Failed to load feeds: ${e.toString()}';
      _feeds = [];
      _filteredFeeds = [];
      notifyListeners();
    }
  }

  Future<void> getFeedsByCategory(int categoryId, String categoryTitle) async {
    // Change to int
    _isLoading = true;
    _errorMessage = '';
    _selectedCategoryId = categoryId;
    _selectedCategoryTitle = categoryTitle;
    notifyListeners();

    try {
      // If you have a specific endpoint for category feeds
      final response = await apiService.get('${ApiEndpoints.category}?category=$categoryId');

      _isLoading = false;

      final feedModel = FeedModel.fromJson(response);

      if (feedModel.results != null && feedModel.results!.isNotEmpty) {
        _filteredFeeds = feedModel.results!;
      } else {
        _errorMessage = 'No feeds available for this category';
        _filteredFeeds = [];
      }

      notifyListeners();
    } catch (e) {
      print('Error loading category feeds: ${e.toString()}');
      _isLoading = false;
      _errorMessage = 'Failed to load category feeds: ${e.toString()}';
      _filteredFeeds = [];
      notifyListeners();
    }
  }

  // Alternative: Local filtering if API doesn't support category filtering
  void filterFeedsByCategory(int categoryId, String categoryTitle) {
    // Change to int
    _selectedCategoryId = categoryId;
    _selectedCategoryTitle = categoryTitle;

    if (categoryId == -1) {
      // Use -1 or null for "all feeds"
      // Show all feeds
      _filteredFeeds = _feeds;
    } else {
      // Filter feeds locally based on category
      // Note: You'll need to modify your Results model to include category information
      // For now, this is a placeholder - adjust based on your actual data structure
      _filteredFeeds = _feeds.where((feed) {
        // Check if feed has category information that matches
        // This depends on how categories are stored in your feed data
        return feed.category?.id == categoryId;
      }).toList();
    }

    notifyListeners();
  }

  void clearCategoryFilter() {
    _selectedCategoryId = null;
    _selectedCategoryTitle = null;
    _filteredFeeds = [];
    notifyListeners();
  }

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }
}
