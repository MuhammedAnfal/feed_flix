import 'package:feed_flix/features/home/domain/entities/feed_entity.dart';

abstract class FeedRepository {
  Future<List<FeedEntity>> getFeeds();
}
