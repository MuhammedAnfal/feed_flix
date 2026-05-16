import 'package:feed_flix/core/api/api_exception.dart';
import 'package:feed_flix/core/network/api_services.dart';
import 'package:feed_flix/features/feed/data/models/feed_model.dart';

abstract class FeedRemoteDataSource {
  Future<List<FeedModel>> getFeeds();
}

class FeedRemoteDataSourceImpl implements FeedRemoteDataSource {
  final ApiService apiService;

  FeedRemoteDataSourceImpl(this.apiService);

  @override
  Future<List<FeedModel>> getFeeds() async {
    final response = await apiService.get('home/');

    if (response is List) {
      return response.map((item) => FeedModel.fromJson(item)).toList();
    }

    throw ServerException('Invalid response format');
  }
}
