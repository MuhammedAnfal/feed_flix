class FeedModel {
  List<User>? user;
  List<BannerModel>? banners;
  List<CategoryDict>? categoryDict;
  List<Results>? results;
  bool? status;
  bool? next;

  FeedModel({
    this.user,
    this.banners,
    this.categoryDict,
    this.results,
    this.status,
    this.next,
  });

  factory FeedModel.fromJson(Map<String, dynamic> json) {
    return FeedModel(
      user: json['user'] != null
          ? (json['user'] as List).map((e) => User.fromJson(e)).toList()
          : null,
      banners: json['banners'] != null
          ? (json['banners'] as List).map((e) => BannerModel.fromJson(e)).toList()
          : null,
      categoryDict: json['category_dict'] != null
          ? (json['category_dict'] as List).map((e) => CategoryDict.fromJson(e)).toList()
          : null,
      results: json['results'] != null
          ? (json['results'] as List).map((e) => Results.fromJson(e)).toList()
          : null,
      status: json['status'],
      next: json['next'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user?.map((e) => e.toJson()).toList(),
      'banners': banners?.map((e) => e.toJson()).toList(),
      'category_dict': categoryDict?.map((e) => e.toJson()).toList(),
      'results': results?.map((e) => e.toJson()).toList(),
      'status': status,
      'next': next,
    };
  }
}

class CategoryDict {
  String? id;
  String? title;

  CategoryDict({this.id, this.title});

  factory CategoryDict.fromJson(Map<String, dynamic> json) {
    return CategoryDict(id: json['id'], title: json['title']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title};
  }
}

class Results {
  int? id;
  String? description;
  String? image;
  String? video;
  List<int>? likes;
  List<int>? dislikes;
  List<int>? bookmarks;
  List<int>? hide;
  String? createdAt;
  bool? follow;
  User? user;

  Results({
    this.id,
    this.description,
    this.image,
    this.video,
    this.likes,
    this.dislikes,
    this.bookmarks,
    this.hide,
    this.createdAt,
    this.follow,
    this.user,
  });

  factory Results.fromJson(Map<String, dynamic> json) {
    return Results(
      id: json['id'],
      description: json['description'],
      image: json['image'],
      video: json['video'],
      likes: (json['likes'] as List<dynamic>?)?.map((e) => e as int).toList(),
      dislikes: (json['dislikes'] as List<dynamic>?)?.map((e) => e as int).toList(),
      bookmarks: (json['bookmarks'] as List<dynamic>?)?.map((e) => e as int).toList(),
      hide: (json['hide'] as List<dynamic>?)?.map((e) => e as int).toList(),
      createdAt: json['created_at'],
      follow: json['follow'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  get category => null;

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
      'user': user?.toJson(),
    };
  }
}

class User {
  int? id;
  String? name;
  String? image;

  User({this.id, this.name, this.image});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(id: json['id'], name: json['name'], image: json['image']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'image': image};
  }
}

class BannerModel {
  int? id;
  String? image;

  BannerModel({this.id, this.image});

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(id: json['id'], image: json['image']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'image': image};
  }
}
