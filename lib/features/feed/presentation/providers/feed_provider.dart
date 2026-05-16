import 'package:feed_flix/core/api/api_exception.dart';
import 'package:feed_flix/features/feed/domain/use_cases/get_my_feeds_use_case.dart';
import 'package:feed_flix/features/feed/domain/use_cases/upload_feed_use_case.dart';
import 'package:feed_flix/features/home/data/models/feed_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyFeedProvider with ChangeNotifier {
  final GetMyFeedsUseCase getMyFeedsUseCase;
  final UploadFeedUseCase uploadFeedUseCase;

  MyFeedProvider({required this.getMyFeedsUseCase, required this.uploadFeedUseCase});

  List<FeedModel> _myFeeds = [];
  bool _isLoading = false;
  bool _isUploading = false;
  String _errorMessage = '';
  double _uploadProgress = 0.0;
  XFile? _selectedVideo;
  XFile? _selectedThumbnail;
  String _description = '';
  List<int> _selectedCategories = [];


  List<FeedModel> get myFeeds => _myFeeds;
  bool get isLoading => _isLoading;
  bool get isUploading => _isUploading;
  String get errorMessage => _errorMessage;
  double get uploadProgress => _uploadProgress;
  XFile? get selectedVideo => _selectedVideo;
  XFile? get selectedThumbnail => _selectedThumbnail;
  String get description => _description;
  List<int> get selectedCategories => _selectedCategories;

  bool get isFormValid {
    return _selectedVideo != null &&
        _selectedThumbnail != null &&
        _description.isNotEmpty &&
        _selectedCategories.isNotEmpty;
  }

  void setVideo(XFile? video) {
    _selectedVideo = video;
    notifyListeners();
  }

  void setThumbnail(XFile? thumbnail) {
    _selectedThumbnail = thumbnail;
    notifyListeners();
  }

  void setDescription(String description) {
    _description = description;
    print(_description);
    print('object');
    notifyListeners();
  }

  void toggleCategory(int categoryId) {
    if (_selectedCategories.contains(categoryId)) {
      _selectedCategories.remove(categoryId);
    } else {
      _selectedCategories.add(categoryId);
    }
    notifyListeners();
  }

  Future<bool> uploadCurrentFeed() async {
    if (!isFormValid) {
      _errorMessage = 'Please fill all required fields';
      notifyListeners();
      return false;
    }

    _isUploading = true;
    _uploadProgress = 0.0;
    _errorMessage = '';
    notifyListeners();

    try {
      await uploadFeedUseCase.execute(
        videoFile: _selectedVideo!,
        imageFile: _selectedThumbnail!,
        description: _description,
        categories: _selectedCategories,
        onSendProgress: (sent, total) {
          if (total != -1) {
            _uploadProgress = sent / total;
            notifyListeners();
          }
        },
      );

      _isUploading = false;
      _uploadProgress = 1.0;
      notifyListeners();

      resetForm();
      return true;
    } catch (e) {
      _isUploading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void resetForm() {
    _selectedVideo = null;
    _selectedThumbnail = null;
    _description = '';
    _selectedCategories = [];
    _uploadProgress = 0.0;
    _errorMessage = '';
    notifyListeners();
  }

  void updateProgress(double progress) {
    _uploadProgress = progress;
    notifyListeners();
  }

  void addCategory(int categoryId) {
    if (!_selectedCategories.contains(categoryId)) {
      _selectedCategories.add(categoryId);
      notifyListeners();
    }
  }

  void removeCategory(int categoryId) {
    _selectedCategories.remove(categoryId);
    notifyListeners();
  }

  void clearCategories() {
    _selectedCategories.clear();
    notifyListeners();
  }

  String? validateForm() {
    if (_selectedVideo == null) {
      return 'Please select a video';
    }
    if (_selectedThumbnail == null) {
      return 'Please select a thumbnail image';
    }
    if (_description.trim().isEmpty) {
      return 'Please add a description';
    }
    if (_selectedCategories.isEmpty) {
      return 'Please select at least one category';
    }
    return null;
  }

  // Clear all form data
  void clearForm() {
    _selectedVideo = null;
    _selectedThumbnail = null;
    _description = '';
    _selectedCategories.clear();
    _uploadProgress = 0.0;
    _errorMessage = '';
    notifyListeners();
  }

  void resetUploadState() {
    _isUploading = false;
    _uploadProgress = 0.0;
    _errorMessage = '';
    notifyListeners();
  }

  Future<void> getMyFeeds() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _myFeeds = await getMyFeedsUseCase();
      _isLoading = false;
      notifyListeners();
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load feeds: $e';
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<bool> uploadFeed({
    required XFile videoFile,
    required XFile imageFile,
    required String description,
    required List<int> categories,
  }) async {
    _isUploading = true;
    _uploadProgress = 0.0;
    _errorMessage = '';
    notifyListeners();

    try {
      await uploadFeedUseCase.execute(
        videoFile: videoFile,
        imageFile: imageFile,
        description: description,
        categories: categories,
        onSendProgress: (sent, total) {
          if (total != -1) {
            _uploadProgress = sent / total;
            notifyListeners();
          }
        },
      );

      _isUploading = false;
      _uploadProgress = 1.0;


      await Future.delayed(const Duration(milliseconds: 500));

      _uploadProgress = 0.0;
      await getMyFeeds();
      clearForm();
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isUploading = false;
      _uploadProgress = 0.0;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Unexpected error: $e';
      _isUploading = false;
      _uploadProgress = 0.0;
      notifyListeners();
      return false;
    }
  }

  Future<void> refreshFeeds() async {
    await getMyFeeds();
  }

  void clearError() {
    if (_errorMessage.isNotEmpty) {
      _errorMessage = '';
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
