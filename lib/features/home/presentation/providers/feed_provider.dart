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

      _isLoading = false;
      print(response);
      print('on response');

      final feedModel = FeedModel.fromJson(response);

      print(feedModel);
      print(feedModel.results);
      print("on feed model");

      if (feedModel.results != null && feedModel.results!.isNotEmpty) {
        _feeds = feedModel.results!;
        _filteredFeeds = [];
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

  void filterFeedsByCategory(int categoryId, String categoryTitle) {

    _selectedCategoryId = categoryId;
    _selectedCategoryTitle = categoryTitle;
    print(categoryTitle);
    print("categoryTitle");
    if (categoryTitle == "Explore") {
      _filteredFeeds = _feeds;
    } else {
      _filteredFeeds = _feeds.where((feed) {
        print(feed.category);
        print('on category');
        return feed.category == categoryTitle;
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
