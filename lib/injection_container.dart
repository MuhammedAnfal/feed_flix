import 'package:feed_flix/core/network/api_services.dart';
import 'package:feed_flix/core/toke_service.dart';
import 'package:feed_flix/features/auth/auth_injection_container.dart';
import 'package:feed_flix/features/feed/feeds_injection_container.dart';
import 'package:feed_flix/features/feed/presentation/providers/feed_provider.dart';
import 'package:feed_flix/features/home/home_injection_container.dart';
import 'package:feed_flix/injection_container.dart' as di;
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:feed_flix/core/network/network_info.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Connectivity());

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => ApiService());

  // Services
  sl.registerLazySingleton(() => TokenService(sharedPreferences: sl(), apiService: sl()));

  // Features - Auth
  await authInjectionContainer();

  // Features - Home
  await homeInjectionContainer();

  // Features - Feeds
  await feedsInjectionContainer();

  di.sl.registerFactory(
    () => MyFeedProvider(getMyFeedsUseCase: di.sl(), uploadFeedUseCase: di.sl()),
  );
}
