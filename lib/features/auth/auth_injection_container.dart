import 'package:feed_flix/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:feed_flix/features/auth/data/respositories/auth_repository_impl.dart';
import 'package:feed_flix/features/auth/domain/user_cases/login_use_case.dart';
import 'package:feed_flix/features/auth/presentation/providers/auth_providers.dart';
import 'package:feed_flix/injection_container.dart' as di;
import 'package:feed_flix/features/auth/domain/repositories/auth_repository.dart';

Future<void> authInjectionContainer() async {

  di.sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(di.sl()));

  di.sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: di.sl(),
      networkInfo: di.sl(),
      tokenService: di.sl(), // Use TokenService
    ),
  );

  di.sl.registerLazySingleton(() => LoginUseCase(di.sl()));


  di.sl.registerFactory(() => AuthProvider(apiService: di.sl(), tokenService: di.sl()));
}
