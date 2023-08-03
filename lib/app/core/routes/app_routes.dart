import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:rockers_admin/app/core/routes/routes.dart';
import 'package:rockers_admin/app/features/dashboard/dashboard.dart';

GoRouter get appRoutes {
  final rootNavigatorKey = GlobalKey<NavigatorState>();
  final shellNavigatorKey = GlobalKey<NavigatorState>();

  return GoRouter(
    initialLocation: Routes.songsBoard,
    navigatorKey: rootNavigatorKey,
    routes: [
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (_, __, child) => DashboardPage(child: child),
        routes: [
          GoRoute(
            path: Routes.songsBoard,
            builder: (context, state) => const SongsBoard(),
          ),
          GoRoute(
            path: Routes.trendingBoard,
            builder: (context, state) => const TrendingBoard(),
          ),
          GoRoute(
            path: Routes.playlistsBoard,
            builder: (context, state) => const PlaylistsBoard(),
            routes: [
              GoRoute(
                path: Routes.playlistEditingBoard,
                name: 'playlistEditing',
                builder: (context, state) => PlaylistEditingBoard(
                  playlistId: state.pathParameters['playlistId'],
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
