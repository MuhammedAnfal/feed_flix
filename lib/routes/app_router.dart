import 'package:feed_flix/data/auth/screens/login_screen.dart';
import 'package:feed_flix/data/home/screens/add_feed_screen.dart';
import 'package:feed_flix/data/home/screens/home_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', name: 'login', builder: (context, state) => LoginScreen()),
    GoRoute(path: '/home', name: 'home', builder: (context, state) => const HomeFeedScreen()),
    GoRoute(
      path: '/addFeed',
      name: 'addFeed',
      builder: (context, state) => const AddFeedScreen(),
    ),
  ],
);
