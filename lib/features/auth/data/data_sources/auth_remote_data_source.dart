import 'package:feed_flix/core/network/api_services.dart';
import 'package:feed_flix/features/auth/data/models/auth_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthModel> login(String countryCode, String phone);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService apiService;

  AuthRemoteDataSourceImpl(this.apiService);

  @override
  Future<AuthModel> login(String countryCode, String phone) async {
    final response = await apiService.post(
      'otp_verified/',
      data: {'country_code': countryCode, 'phone': phone},
    );

    return AuthModel.fromJson(response);
  }
}
