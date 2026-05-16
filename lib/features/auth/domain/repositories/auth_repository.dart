import 'package:feed_flix/features/auth/domain/entities/auth_entity.dart';

abstract class AuthRepository {
  Future<AuthEntity> login(String countryCode, String phone);
  Future<void> logout();
  Future<bool> isLoggedIn();
  String? getToken();
}
