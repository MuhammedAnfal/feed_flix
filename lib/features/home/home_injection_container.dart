import 'package:feed_flix/core/network/api_services.dart';
import 'package:feed_flix/features/home/domain/respositories/category_repository.dart';
import 'package:feed_flix/features/home/domain/respositories/feed_repository.dart';
import 'package:feed_flix/injection_container.dart' as di;
import 'package:feed_flix/features/home/data/datasources/category_remote_data_source.dart';
import 'package:feed_flix/features/home/data/datasources/feed_remote_data_source.dart';
import 'package:feed_flix/features/home/data/repositories/category_repository_impl.dart';
import 'package:feed_flix/features/home/data/repositories/feed_repository_impl.dart';
import 'package:feed_flix/features/home/domain/use_cases/get_categories_use_case.dart';
import 'package:feed_flix/features/home/domain/use_cases/get_feeds_use_case.dart';
import 'package:feed_flix/features/home/presentation/providers/category_provider.dart';
import 'package:feed_flix/features/home/presentation/providers/feed_provider.dart';
import 'package:feed_flix/features/home/presentation/providers/video_provider.dart';

Future<void> homeInjectionContainer() async {
  // Data Sources
  di.sl.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSourceImpl(di.sl()),
  );

  di.sl.registerLazySingleton<FeedRemoteDataSource>(() => FeedRemoteDataSourceImpl(di.sl()));

  // Repositories
  di.sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(remoteDataSource: di.sl(), networkInfo: di.sl()),
  );

  di.sl.registerLazySingleton<FeedRepository>(
    () => FeedRepositoryImpl(remoteDataSource: di.sl(), networkInfo: di.sl()),
  );

  // Use Cases
  di.sl.registerLazySingleton(() => GetCategoriesUseCase(di.sl()));
  di.sl.registerLazySingleton(() => GetFeedsUseCase(di.sl()));

  // Providers
  di.sl.registerFactory(() => CategoryProvider(di.sl()));
  di.sl.registerFactory(() => FeedProvider(di.sl()));
  di.sl.registerFactory(() => VideoProvider());
}
