import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoProvider with ChangeNotifier {
  VideoPlayerController? _currentController;
  int _currentPlayingIndex = -1;
  bool _isFullScreen = false;

  VideoPlayerController? get currentController => _currentController;
  int get currentPlayingIndex => _currentPlayingIndex;
  bool get isFullScreen => _isFullScreen;

  void playVideo(int index, String videoUrl) {
    if (_currentPlayingIndex == index) return;

    // Dispose previous controller
    if (_currentController != null) {
      _currentController!.dispose();
    }

    _currentPlayingIndex = index;
    _currentController = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
      ..initialize().then((_) {
        _currentController!.play();
        notifyListeners();
      })
      ..addListener(() {
        notifyListeners();
      });
  }

  void pauseVideo() {
    if (_currentController != null && _currentController!.value.isPlaying) {
      _currentController!.pause();
      notifyListeners();
    }
  }

  void resumeVideo() {
    if (_currentController != null && !_currentController!.value.isPlaying) {
      _currentController!.play();
      notifyListeners();
    }
  }

  void toggleFullScreen() {
    _isFullScreen = !_isFullScreen;
    notifyListeners();
  }

  void disposeController() {
    if (_currentController != null) {
      _currentController!.dispose();
      _currentController = null;
      _currentPlayingIndex = -1;
    }
  }

  @override
  void dispose() {
    disposeController();
    super.dispose();
  }
}
