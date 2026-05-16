// features/feed/data/repositories/feed_repository_impl.dart
import 'package:feed_flix/core/api/api_exception.dart';
import 'package:feed_flix/core/network/network_info.dart';
import 'package:feed_flix/features/feed/data/datasources/feed_remote_data_source.dart';
import 'package:feed_flix/features/feed/domain/repositories/feed_repository.dart';
import 'package:feed_flix/features/home/data/models/feed_model.dart';
import 'package:image_picker/image_picker.dart';

class FeedRepositoryImpl implements FeedRepository {
  final FeedRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  FeedRepositoryImpl({required this.remoteDataSource, required this.networkInfo});

  @override
  Future<List<FeedModel>> getMyFeeds() async {
    if (!await networkInfo.isConnected) {
      throw NetworkException('No internet connection');
    }

    try {
      final feeds = await remoteDataSource.getMyFeeds();
      return feeds;
    } on ServerException {
      rethrow;
    }
  }

  @override
  Future<FeedModel> uploadFeed({
    required XFile videoFile,
    required XFile imageFile,
    required String description,
    required List<int> categories,
    void Function(int sent, int total)? onSendProgress,
  }) async {
    if (!await networkInfo.isConnected) {
      throw NetworkException('No internet connection');
    }

    try {
      final feed = await remoteDataSource.uploadFeed(
        videoFile: videoFile,
        imageFile: imageFile,
        description: description,
        categories: categories,
        onSendProgress: onSendProgress,
      );
      return feed;
    } on ServerException {
      rethrow;
    }
  }
}
