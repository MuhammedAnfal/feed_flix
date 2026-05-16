import 'package:feed_flix/features/home/domain/entities/category_entity.dart';
import 'package:feed_flix/features/home/domain/entities/feed_entity.dart';

class FeedModel extends FeedEntity {
  FeedModel({
    required super.id,
    required super.video,
    required super.image,
    required super.description,
    required super.user,
    required super.categories,
  });

  factory FeedModel.fromJson(Map<String, dynamic> json) {
    return FeedModel(
      id: json['id'] ?? 0,
      video: json['video'] ?? '',
      image: json['image'] ?? '',
      description: json['description'] ?? '',
      user: UserModel.fromJson(json['user']),
      categories: json['categories']
          .map((category) => CategoryModel.fromJson(category))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'video': video,
      'image': image,
      'description': description,
      'user': (user as UserModel).toJson(),
      'categories': categories
          .map((category) => (category as CategoryModel).toJson())
          .toList(),
    };
  }
}

class UserModel extends UserEntity {
  UserModel({required super.id, required super.name, super.profilePicture});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      profilePicture: json['profile_picture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'profile_picture': profilePicture};
  }
}

class CategoryModel extends CategoryEntity {
  CategoryModel({required super.id, required super.name, super.image});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(id: json['id'] ?? 0, name: json['name'] ?? '', image: json['image']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'image': image};
  }
}
