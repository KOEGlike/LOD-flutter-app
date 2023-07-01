import 'package:first_test/views/results.dart';
import 'package:first_test/views/vote.dart';
import 'package:flutter/material.dart';
import 'views/home.dart';
import 'views/account.dart';
import 'views/create/select.dart';
import 'views/create/links.dart';
import 'package:go_router/go_router.dart';
import 'views/skeleton.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final _router = GoRouter(
  initialLocation: '/',
  navigatorKey: _rootNavigatorKey,
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return Skeleton(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) {
            return HomePage(
              key: UniqueKey(),
            );
          },
        ),
        GoRoute(
          path: '/create',
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) {
            return CreatePage(
              key: UniqueKey(),
            );
          },
        ),
        GoRoute(
            parentNavigatorKey: _shellNavigatorKey,
            path: '/account',
            builder: (context, state) {
              return AccountPage(
                key: UniqueKey(),
              );
            }),
      ],
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/vote',
      pageBuilder: (context, state) {
        debugPrint(state.queryParameters['id']);
        return NoTransitionPage(
          key: UniqueKey(),
          child: Vote(
            id: int.tryParse(state.queryParameters['id'] ?? ''),
          ),
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/results',
      pageBuilder: (context, state) {
        return NoTransitionPage(
          key: UniqueKey(),
          child: ResultsPage(
            id: int.tryParse(state.queryParameters['id'] ?? ''),
          ),
        );
      },
    ),
    GoRoute(
      path: '/create/links',
      pageBuilder: (context, state) {
        return NoTransitionPage(
          key: UniqueKey(),
          child: Links(
            id: int.tryParse(state.queryParameters['id'] ?? ''),
          ),
        );
      },
    ),
  ],
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  final Color primaryColor = const Color.fromARGB(255, 145, 206, 255);
  final Color accentColor = const Color.fromARGB(255, 255, 231, 152);
  final String _title = '👍or👎';

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: accentColor,
        // onSecondary: accentcolor,
      ),
    );

    return MaterialApp.router(
      title: _title,
      routerConfig: _router,
      theme: theme,
    );
  }
}
