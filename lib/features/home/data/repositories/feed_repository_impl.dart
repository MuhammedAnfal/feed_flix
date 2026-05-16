import 'package:feed_flix/core/api/api_exception.dart';
import 'package:feed_flix/core/network/network_info.dart';
import 'package:feed_flix/features/home/data/datasources/feed_remote_data_source.dart';
import 'package:feed_flix/features/home/domain/entities/feed_entity.dart';
import 'package:feed_flix/features/home/domain/respositories/feed_repository.dart';

class FeedRepositoryImpl implements FeedRepository {
  final FeedRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  FeedRepositoryImpl({required this.remoteDataSource, required this.networkInfo});

  @override
  Future<List<FeedEntity>> getFeeds() async {
    if (!await networkInfo.isConnected) {
      throw NetworkException('No internet connection');
    }

    try {
      final feeds = await remoteDataSource.getFeeds();
      return feeds;
    } on ServerException {
      rethrow;
    }
  }
}
