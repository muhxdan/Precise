import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:precise/core/routes/app_routes.dart';
import 'package:precise/domain/entities/article.dart';
import 'package:precise/presentation/pages/bookmarks/bookmark_page.dart';
import 'package:precise/presentation/pages/detail/detail_page.dart';
import 'package:precise/presentation/pages/home/home_page.dart';
import 'package:precise/presentation/pages/search/search_page.dart';
import 'package:precise/presentation/pages/settings/settings_page.dart';
import 'package:precise/presentation/pages/themes/themes_page.dart';
import 'package:precise/presentation/widgets/bottom_navigation.dart';
import 'package:precise/presentation/widgets/custom_transition.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _parentNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _homeNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _bookmarkNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _settingsNavigatorKey =
      GlobalKey<NavigatorState>();

  static GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    navigatorKey: _parentNavigatorKey,
    initialLocation: AppRoutes.home,
    errorBuilder: (context, state) => const Scaffold(
      body: Center(
        child: Text('Page not found'),
      ),
    ),
    routes: [
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: _parentNavigatorKey,
        pageBuilder: (context, state, navigationShell) {
          // the UI shell
          return getPage(
            child: BottomNavigation(
              child: navigationShell,
            ),
            state: state,
          );
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _homeNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.home,
                pageBuilder: (context, state) =>
                    getPage(child: const HomePage(), state: state),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _bookmarkNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.bookmark,
                pageBuilder: (context, state) =>
                    getPage(child: const BookmarksPage(), state: state),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _settingsNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                pageBuilder: (context, state) =>
                    getPage(child: const SettingsPage(), state: state),
                routes: [
                  GoRoute(
                    path: AppRoutes.themes,
                    pageBuilder: (context, state) {
                      return getPage(child: const ThemesPage(), state: state);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: _parentNavigatorKey,
        path: AppRoutes.detail,
        pageBuilder: (context, state) {
          final article = state.extra as Article;
          return getPage(child: DetailPage(article: article), state: state);
        },
      ),
      GoRoute(
        parentNavigatorKey: _parentNavigatorKey,
        path: AppRoutes.search,
        pageBuilder: (context, state) =>
            getPage(child: const SearchPage(), state: state),
      ),
    ],
  );

  static Page getPage({
    required Widget child,
    required GoRouterState state,
  }) {
    if (state.path == AppRoutes.search || state.path == AppRoutes.detail) {
      return CustomTransition(
        key: state.pageKey,
        name: state.path!,
        child: child,
      );
    }

    return MaterialPage(
      key: state.pageKey,
      child: child,
    );
  }
}
