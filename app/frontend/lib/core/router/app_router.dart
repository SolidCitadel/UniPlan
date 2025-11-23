import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/app_shell/app_shell.dart';
import '../../presentation/auth/login_screen.dart';
import '../../presentation/auth/signup_screen.dart';
import '../../presentation/courses/course_list_screen.dart';
import '../../presentation/help/help_screen.dart';
import '../../presentation/planner/timetable_screen.dart';
import '../../presentation/planner/timetable_edit_screen.dart';
import '../../presentation/registration/course_registration_screen.dart';
import '../../presentation/scenario/scenario_screen.dart';
import '../../presentation/wishlist/wishlist_screen.dart';
import '../auth/session_provider.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  final authStatus = ref.watch(authStatusProvider);
  final authValue = authStatus.when(
    data: (v) => v,
    loading: () => AuthStatus.unknown,
    error: (_, __) => AuthStatus.unauthenticated,
  );

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/app/courses',
            builder: (context, state) => const CourseListScreen(),
          ),
          GoRoute(
            path: '/app/wishlist',
            builder: (context, state) => const WishlistScreen(),
          ),
          GoRoute(
            path: '/app/timetables',
            builder: (context, state) => const TimetableScreen(),
          ),
          GoRoute(
            path: '/app/timetables/:id',
            builder: (context, state) {
              final id = int.tryParse(state.pathParameters['id'] ?? '');
              return id == null ? const TimetableScreen() : TimetableEditScreen(timetableId: id);
            },
          ),
          GoRoute(
            path: '/app/scenario',
            builder: (context, state) => const ScenarioScreen(),
          ),
          GoRoute(
            path: '/app/course-registration',
            builder: (context, state) => const CourseRegistrationScreen(),
          ),
          GoRoute(
            path: '/app/help',
            builder: (context, state) => const HelpScreen(),
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final isAuth = authValue == AuthStatus.authenticated;
      final loggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/signup';
      final atProtected = state.matchedLocation.startsWith('/app');

      if (!isAuth && atProtected) return '/login';
      if (isAuth && loggingIn) return '/app/courses';
      return null;
    },
  );
});
