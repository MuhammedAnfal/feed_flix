import 'package:feed_flix/features/auth/domain/entities/auth_entity.dart';

class AuthModel extends AuthEntity {
  AuthModel({required super.access, required super.refresh});

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(access: json['access'] ?? '', refresh: json['refresh'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'access': access, 'refresh': refresh};
  }
}
