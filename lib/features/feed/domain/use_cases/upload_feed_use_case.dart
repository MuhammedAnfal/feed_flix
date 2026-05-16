// features/feed/domain/use_cases/upload_feed_use_case.dart
import 'package:feed_flix/features/feed/domain/repositories/feed_repository.dart';
import 'package:feed_flix/features/home/data/models/feed_model.dart';
import 'package:image_picker/image_picker.dart';

class UploadFeedUseCase {
  final FeedRepository repository;

  UploadFeedUseCase({required this.repository});

  Future<FeedModel> execute({
    required XFile videoFile,
    required XFile imageFile,
    required String description,
    required List<int> categories,
    void Function(int sent, int total)? onSendProgress,
  }) async {
    return await repository.uploadFeed(
      videoFile: videoFile,
      imageFile: imageFile,
      description: description,
      categories: categories,
      onSendProgress: onSendProgress,
    );
  }
}
