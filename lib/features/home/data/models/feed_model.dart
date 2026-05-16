// class FeedModel {
//   List<User>? user;
//   List<BannerModel>? banners;
//   List<CategoryDict>? categoryDict;
//   List<Results>? results;
//   bool?status;
//   bool? next;
//
//   FeedModel({
//     this.user,
//     this.banners,
//     this.categoryDict,
//     this.results,
//     this.status,
//     this.next,
//   });
//
//   factory FeedModel.fromJson(Map<String, dynamic> json) {
//     return FeedModel(
//       user: json['user'] != null
//           ? (json['user'] as List).map((e) => User.fromJson(e)).toList()
//           : null,
//       banners: json['banners'] != null
//           ? (json['banners'] as List).map((e) => BannerModel.fromJson(e)).toList()
//           : null,
//       categoryDict: json['category_dict'] != null
//           ? (json['category_dict'] as List).map((e) => CategoryDict.fromJson(e)).toList()
//           : null,
//       results: json['results'] != null
//           ? (json['results'] as List).map((e) => Results.fromJson(e)).toList()
//           : null,
//       status: json['status'],
//       next: json['next'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'user': user?.map((e) => e.toJson()).toList(),
//       'banners': banners?.map((e) => e.toJson()).toList(),
//       'category_dict': categoryDict?.map((e) => e.toJson()).toList(),
//       'results': results?.map((e) => e.toJson()).toList(),
//       'status': status,
//       'next': next,
//     };
//   }
// }
//
// class CategoryDict {
//   String? id;
//   String? title;
//
//   CategoryDict({this.id, this.title});
//
//   factory CategoryDict.fromJson(Map<String, dynamic> json) {
//     return CategoryDict(id: json['id'], title: json['title']);
//   }
//
//   Map<String, dynamic> toJson() {
//     return {'id': id, 'title': title};
//   }
// }
//
// class Results {
//   int? id;
//   String? description;
//   String? image;
//   String? video;
//   List<int>? likes;
//   List<int>? dislikes;
//   List<int>? bookmarks;
//   List<int>? hide;
//   String? createdAt;
//   bool? follow;
//   User? user;
//
//   Results({
//     this.id,
//     this.description,
//     this.image,
//     this.video,
//     this.likes,
//     this.dislikes,
//     this.bookmarks,
//     this.hide,
//     this.createdAt,
//     this.follow,
//     this.user,
//   });
//
//   factory Results.fromJson(Map<String, dynamic> json) {
//     return Results(
//       id: json['id'],
//       description: json['description'],
//       image: json['image'],
//       video: json['video'],
//       likes: (json['likes'] as List<dynamic>?)?.map((e) => e as int).toList(),
//       dislikes: (json['dislikes'] as List<dynamic>?)?.map((e) => e as int).toList(),
//       bookmarks: (json['bookmarks'] as List<dynamic>?)?.map((e) => e as int).toList(),
//       hide: (json['hide'] as List<dynamic>?)?.map((e) => e as int).toList(),
//       createdAt: json['created_at'],
//       follow: json['follow'],
//       user: json['user'] != null ? User.fromJson(json['user']) : null,
//     );
//   }
//
//   get category => null;
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'description': description,
//       'image': image,
//       'video': video,
//       'likes': likes,
//       'dislikes': dislikes,
//       'bookmarks': bookmarks,
//       'hide': hide,
//       'created_at': createdAt,
//       'follow': follow,
//       'user': user?.toJson(),
//     };
//   }
// }
//
// class User {
//   int? id;
//   String? name;
//   String? image;
//
//   User({this.id, this.name, this.image});
//
//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(id: json['id'], name: json['name'], image: json['image']);
//   }
//
//   Map<String, dynamic> toJson() {
//     return {'id': id, 'name': name, 'image': image};
//   }
// }
//
// class BannerModel {
//   int? id;
//   String? image;
//
//   BannerModel({this.id, this.image});
//
//   factory BannerModel.fromJson(Map<String, dynamic> json) {
//     return BannerModel(id: json['id'], image: json['image']);
//   }
//
//   Map<String, dynamic> toJson() {
//     return {'id': id, 'image': image};
//   }
// }

class FeedModel {
  final List<User> user;
  final List<BannerModel> banners;
  final List<CategoryDict> categoryDict;
  final List<Results> results;
  final bool status;
  final bool next;

  FeedModel({
    required this.user,
    required this.banners,
    required this.categoryDict,
    required this.results,
    required this.status,
    required this.next,
  });

  factory FeedModel.fromJson(Map<String, dynamic> json) {
    return FeedModel(
      user: (json['user'] as List<dynamic>?)
          ?.map((e) => User.fromJson(e))
          .toList() ??
          [],
      banners: (json['banners'] as List<dynamic>?)
          ?.map((e) => BannerModel.fromJson(e))
          .toList() ??
          [],
      categoryDict: (json['category_dict'] as List<dynamic>?)
          ?.map((e) => CategoryDict.fromJson(e))
          .toList() ??
          [],
      results: (json['results'] as List<dynamic>?)
          ?.map((e) => Results.fromJson(e))
          .toList() ??
          [],
      status: json['status'] ?? false,
      next: json['next'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.map((e) => e.toJson()).toList(),
      'banners': banners.map((e) => e.toJson()).toList(),
      'category_dict': categoryDict.map((e) => e.toJson()).toList(),
      'results': results.map((e) => e.toJson()).toList(),
      'status': status,
      'next': next,
    };
  }
}

class CategoryDict {
  final String id;
  final String title;

  CategoryDict({
    required this.id,
    required this.title,
  });

  factory CategoryDict.fromJson(Map<String, dynamic> json) {
    return CategoryDict(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }
}

class Results {
  final int id;
  final String description;
  final String image;
  final String video;
  final List<int> likes;
  final List<int> dislikes;
  final List<int> bookmarks;
  final List<int> hide;
  final String createdAt;
  final bool follow;
  final User user;

  Results({
    required this.id,
    required this.description,
    required this.image,
    required this.video,
    required this.likes,
    required this.dislikes,
    required this.bookmarks,
    required this.hide,
    required this.createdAt,
    required this.follow,
    required this.user,
  });

  get category => null;
  factory Results.fromJson(Map<String, dynamic> json) {
    return Results(
      id: json['id'] ?? 0,
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      video: json['video'] ?? '',
      likes: (json['likes'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList() ??
          [],
      dislikes: (json['dislikes'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList() ??
          [],
      bookmarks: (json['bookmarks'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList() ??
          [],
      hide: (json['hide'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList() ??
          [],
      createdAt: json['created_at'] ?? '',
      follow: json['follow'] ?? false,
      user: json['user'] != null
          ? User.fromJson(json['user'])
          : User.empty(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'image': image,
      'video': video,
      'likes': likes,
      'dislikes': dislikes,
      'bookmarks': bookmarks,
      'hide': hide,
      'created_at': createdAt,
      'follow': follow,
      'user': user.toJson(),
    };
  }
}

class User {
  final int id;
  final String name;
  final String image;

  User({
    required this.id,
    required this.name,
    required this.image,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }

  factory User.empty() {
    return User(
      id: 0,
      name: '',
      image: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }
}

class BannerModel {
  final int id;
  final String image;

  BannerModel({
    required this.id,
    required this.image,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] ?? 0,
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
    };
  }
}