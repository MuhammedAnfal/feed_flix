import 'package:feed_flix/routes/app_router.dart';
import 'package:feed_flix/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  final dio = Dio();
  // final dataSource = MyFeedRemoteDataSource(dio);
  // final repository = MyFeedRepositoryImpl(dataSource);
  // final getMyFeed = GetMyFeed(repository);
  runApp(const MyApp());
}

class Dio {}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (_) => MyFeedProvider(getMyFeed)..fetchFeeds()),
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
