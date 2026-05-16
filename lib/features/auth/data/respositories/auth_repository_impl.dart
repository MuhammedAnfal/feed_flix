import 'package:feed_flix/core/api/api_exception.dart';
import 'package:feed_flix/core/network/network_info.dart';
import 'package:feed_flix/core/toke_service.dart';
import 'package:feed_flix/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:feed_flix/features/auth/domain/entities/auth_entity.dart';
import 'package:feed_flix/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final TokenService tokenService;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.tokenService,
  });

  @override
  Future<AuthEntity> login(String countryCode, String phone) async {
    if (!await networkInfo.isConnected) {
      throw NetworkException('No internet connection');
    }

    try {
      final authModel = await remoteDataSource.login(countryCode, phone);

      //-- Store token using TokenService
      await tokenService.saveToken(authModel.access);
      print(authModel.access);
      print('object');

      return authModel;
    } on ServerException {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    await tokenService.clearToken();
  }

  @override
  Future<bool> isLoggedIn() async {
    return await tokenService.hasToken();
  }

  @override
  String? getToken() {
    return tokenService.getToken();
  }
}
