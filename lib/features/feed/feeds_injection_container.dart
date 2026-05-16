// feeds_injection_container.dart
import 'package:feed_flix/core/api/api_client.dart';
import 'package:feed_flix/core/storage_services/storage_service.dart';
import 'package:feed_flix/features/feed/data/datasources/feed_remote_data_source.dart';
import 'package:feed_flix/features/feed/data/repositories/feed_repository_impl.dart';
import 'package:feed_flix/features/feed/domain/repositories/feed_repository.dart';
import 'package:feed_flix/features/feed/domain/use_cases/get_my_feeds_use_case.dart';
import 'package:feed_flix/features/feed/domain/use_cases/upload_feed_use_case.dart';
import 'package:feed_flix/features/feed/presentation/providers/feed_provider.dart';
import 'package:feed_flix/injection_container.dart' as di;

Future<void> feedsInjectionContainer() async {
  // Data Sources
  di.sl.registerLazySingleton<FeedRemoteDataSource>(
    () => FeedRemoteDataSourceImpl(apiClient: ApiClient(localStorage: StorageService())),
  );

  // Repository
  di.sl.registerLazySingleton<FeedRepository>(
    () => FeedRepositoryImpl(remoteDataSource: di.sl(), networkInfo: di.sl()),
  );

  // Use Cases
  di.sl.registerLazySingleton(() => GetMyFeedsUseCase(di.sl()));
  di.sl.registerLazySingleton(() => UploadFeedUseCase(repository: di.sl()));
}
