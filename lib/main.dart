import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:movieit/models/scheduled_event.dart';
import 'package:movieit/models/user_preferences.dart';
import 'package:movieit/models/user_stats.dart';
import 'package:movieit/models/watchlist_item.dart';

import 'package:movieit/providers/movie_provider.dart';
import 'package:movieit/theme/movieit_theme.dart';
import 'package:movieit/screens/home_screen.dart';
import 'package:movieit/screens/search_screen.dart';
import 'package:movieit/screens/planner_screen.dart';
import 'package:movieit/screens/movie_detail_screen.dart';
import 'package:movieit/screens/authentication_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:movieit/utils/main_app_shell.dart';
import 'package:provider/provider.dart';

import 'package:movieit/providers/auth_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

late final GoRouter _router;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: "app.env");
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    publishableKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  final authProvider = AuthProvider();
  _router = createRouter(authProvider);
  
  await Hive.initFlutter();

  Hive.registerAdapter(ScheduledEventAdapter());
  Hive.registerAdapter(UserPreferencesAdapter());
  Hive.registerAdapter(UserStatsAdapter());
  Hive.registerAdapter(WatchlistItemAdapter());

  await Hive.openBox<ScheduledEvent>('scheduled_event');
  await Hive.openBox<UserPreferences>('user_preferences');
  await Hive.openBox<UserStats>('user_stats');
  await Hive.openBox<WatchlistItem>('watchlist');

 runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider(create: (_) => MovieProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

GoRouter createRouter(AuthProvider authProvider) {
  const protectedRoutes = ['/planner', '/watchlist'];
  const authRoute = '/auth';

  return GoRouter(
    initialLocation: '/',
    refreshListenable: authProvider,
    redirect: (context, state) {
      final loggedIn = authProvider.isAuthenticated;
      final path = state.matchedLocation;

      if (!loggedIn && protectedRoutes.any((r) => path.startsWith(r))) {
        return authRoute;
      }
      if (loggedIn && path == authRoute) {
        return '/planner';
      }
      return null;
    },
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          final path = state.matchedLocation;
          String activeCategory = 'Home';

          if (path.startsWith('/search')) {
            activeCategory = 'Search';
          } else if (path.startsWith('/planner')) {
            activeCategory = 'Planner';
          } else if (path.startsWith('/movie')) {
            activeCategory = '';
          }

          return MainAppShell(
            activeCategory: activeCategory,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/search',
            builder: (context, state) => const SearchScreen(),
          ),
          GoRoute(
            path: '/planner',
            builder: (context, state) => const PlannerScreen(),
          ),
          GoRoute(
            path: '/movie/:id',
            builder: (context, state) => MovieDetailScreen(
              movieId: state.pathParameters['id']!,
            ),
          ),
        ],
      ),
      GoRoute(
        path: authRoute,
        builder: (context, state) => const AuthenticationScreen(),
      ),
    ],
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'MovieIT',
      debugShowCheckedModeBanner: false,
      theme: MovieItTheme.dark(),
    );
  }
}
