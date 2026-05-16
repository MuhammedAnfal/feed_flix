import 'package:feed_flix/features/auth/domain/entities/auth_entity.dart';
import 'package:feed_flix/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<AuthEntity> call(String countryCode, String phone) async {
    return await repository.login(countryCode, phone);
  }
}
