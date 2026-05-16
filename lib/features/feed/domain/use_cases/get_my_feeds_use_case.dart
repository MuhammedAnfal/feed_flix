// features/feed/domain/use_cases/get_my_feeds_use_case.dart
import 'package:feed_flix/features/feed/domain/repositories/feed_repository.dart';
import 'package:feed_flix/features/home/data/models/feed_model.dart';

class GetMyFeedsUseCase {
  final FeedRepository repository;

  GetMyFeedsUseCase(this.repository);

  Future<List<FeedModel>> call() async {
    return await repository.getMyFeeds();
  }
}
