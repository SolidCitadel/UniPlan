import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../presentation/auth/login_screen.dart';
import '../../presentation/auth/signup_screen.dart';
import '../../presentation/main_layout/home_screen.dart';
import '../../presentation/main_layout/main_layout.dart';
import '../../presentation/course_list/course_list_screen.dart';
import '../../presentation/wishlist/wishlist_screen.dart';
import '../../presentation/timetable/timetable_planner_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
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
      builder: (context, state, child) {
        return MainLayout(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/courses',
          builder: (context, state) => const CourseListScreen(),
        ),
        GoRoute(
          path: '/wishlist',
          builder: (context, state) => const WishlistScreen(),
        ),
        GoRoute(
          path: '/planner',
          builder: (context, state) => const TimetablePlannerScreen(),
        ),
      ],
    ),
  ],
);
