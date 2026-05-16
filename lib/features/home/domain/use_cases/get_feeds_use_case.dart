import 'package:feed_flix/features/home/domain/entities/feed_entity.dart';
import 'package:feed_flix/features/home/domain/respositories/feed_repository.dart';

class GetFeedsUseCase {
  final FeedRepository repository;

  GetFeedsUseCase(this.repository);

  Future<List<FeedEntity>> call() async {
    return await repository.getFeeds();
  }
}
