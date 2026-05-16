import 'package:feed_flix/core/storage_services/storage_service.dart';
import 'package:feed_flix/features/auth/presentation/pages/login_screen.dart';
import 'package:feed_flix/features/feed/presentation/pages/add_feed_screen.dart';
import 'package:feed_flix/features/home/presentation/pages/home_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(

  initialLocation: '/login',

  redirect: (context, state) {

    final bool loggedIn =
        token != null && token!.isNotEmpty;

    final bool goingToLogin =
        state.matchedLocation == '/login';

    if (!loggedIn && !goingToLogin) {
      return '/login';
    }

    if (loggedIn && goingToLogin) {
      return '/home';
    }

    return null;
  },

  routes: [

    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
    ),

    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeFeedScreen(),
    ),

    GoRoute(
      path: '/addFeed',
      builder: (context, state) => const AddFeedScreen(),
    ),
  ],
);
