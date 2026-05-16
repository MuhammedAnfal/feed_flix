// features/feed/data/datasources/feed_remote_data_source.dart
import 'package:dio/dio.dart';
import 'package:feed_flix/core/api/api_client.dart';
import 'package:feed_flix/core/api/api_endpoints.dart';
import 'package:feed_flix/core/api/api_exception.dart';
import 'package:feed_flix/features/home/data/models/feed_model.dart';
import 'package:image_picker/image_picker.dart';

abstract class FeedRemoteDataSource {
  Future<List<FeedModel>> getMyFeeds();
  Future<FeedModel> uploadFeed({
    required XFile videoFile,
    required XFile imageFile,
    required String description,
    required List<int> categories,
    void Function(int sent, int total)? onSendProgress,
  });
}

class FeedRemoteDataSourceImpl implements FeedRemoteDataSource {
  final ApiClient apiClient;

  FeedRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<FeedModel>> getMyFeeds() async {
    final response = await apiClient.get<List<dynamic>>(endpoint: ApiEndpoints.myFeed);

    if (response is List) {
      return response.map((item) => FeedModel.fromJson(item)).toList();
    }

    throw ServerException('Invalid response format');
  }

  @override
  Future<FeedModel> uploadFeed({
    required XFile videoFile,
    required XFile imageFile,
    required String description,
    required List<int> categories,
    void Function(int sent, int total)? onSendProgress,
  }) async {
    try {
      // Create FormData
      final formData = {
        'video': await MultipartFile.fromFile(videoFile.path, filename: 'video.mp4'),
        'image': await MultipartFile.fromFile(imageFile.path, filename: 'thumbnail.jpg'),
      };

      // Prepare fields
      final fields = {
        'description': description,
        'categories': categories.map((id) => id.toString()).toList(),
      };

      final response = await apiClient.uploadFeed<Map<String, dynamic>>(
        endpoint: ApiEndpoints.myFeed,
        formData: formData,
        fields: fields,
        onSendProgress: onSendProgress,
      );

      return FeedModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to upload feed: $e');
    }
  }
}
