import 'package:feed_flix/core/network/api_services.dart';
import 'package:feed_flix/core/storage_services/storage_service.dart';
import 'package:feed_flix/features/auth/presentation/providers/auth_providers.dart';
import 'package:feed_flix/features/feed/presentation/providers/feed_provider.dart';
import 'package:feed_flix/features/feed/presentation/providers/feed_provider.dart'
    as feeds_provider;
import 'package:feed_flix/features/home/presentation/providers/category_provider.dart';
import 'package:feed_flix/features/home/presentation/providers/feed_provider.dart';
import 'package:feed_flix/features/home/presentation/providers/video_provider.dart';
import 'package:feed_flix/injection_container.dart' as di;
import 'package:feed_flix/routes/app_router.dart';
import 'package:feed_flix/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  final dio = Dio();
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  final apiService = StorageService();
  await apiService.loadToken();
  runApp(const MyApp());
}

class Dio {}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print(token);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.sl<AuthProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<CategoryProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<FeedProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<VideoProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<MyFeedProvider>()),
        // ChangeNotifierProvider(create: (_) => di.sl<AuthProvider>()),
      ],
      child: MaterialApp.router(
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          scaffoldBackgroundColor: AppColors.primaryColor,
        ),
      ),
    );
  }
}
