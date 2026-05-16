// features/feed/domain/repositories/feed_repository.dart
import 'package:feed_flix/features/home/data/models/feed_model.dart';
import 'package:image_picker/image_picker.dart';

abstract class FeedRepository {
  Future<List<FeedModel>> getMyFeeds();
  Future<FeedModel> uploadFeed({
    required XFile videoFile,
    required XFile imageFile,
    required String description,
    required List<int> categories,
    void Function(int sent, int total)? onSendProgress,
  });
}
