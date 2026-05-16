import 'package:feed_flix/features/home/domain/entities/category_entity.dart';

class FeedEntity {
  final int id;
  final String video;
  final String image;
  final String description;
  final UserEntity user;
  final List<CategoryEntity> categories;

  FeedEntity({
    required this.id,
    required this.video,
    required this.image,
    required this.description,
    required this.user,
    required this.categories,
  });
}

class UserEntity {
  final int id;
  final String name;
  final String? profilePicture;

  UserEntity({required this.id, required this.name, this.profilePicture});
}
