import 'package:first_test/views/results.dart';
import 'package:first_test/views/vote.dart';
import 'package:flutter/material.dart';
import 'views/home.dart';
import 'views/account.dart';
import 'views/create.dart';
import 'package:go_router/go_router.dart';

//https://stackoverflow.com/questions/71011598/how-to-work-with-navigationbar-in-go-router-flutter

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final _router = GoRouter(
  initialLocation: '/home',
  navigatorKey: _rootNavigatorKey,
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return Skeleton(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
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
        return NoTransitionPage(
            key: UniqueKey(),
            child: Vote(
              id: int.parse(state.queryParameters['filter'] ?? "113"),
            ));
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/results',
      pageBuilder: (context, state) {
        return NoTransitionPage(
            key: UniqueKey(),
            child: ResultsPage(
                id: int.parse(state.queryParameters['filter'] ?? "113")));
      },
    ),
  ],
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const Color accentcolor = Colors.blue;
  static const String _title = '👍or👎';

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData(
      useMaterial3: true,
      dividerColor: Colors.transparent,
      colorScheme: const ColorScheme.dark(
        primary: accentcolor,
        secondary: accentcolor,
        onSecondary: accentcolor,
      ),
    );

    return MaterialApp.router(
      title: _title,
      routerConfig: _router,
      theme: theme,
    );
  }
}

class Skeleton extends StatefulWidget {
  final Widget child;
  const Skeleton({super.key, required this.child});

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton> {
  int _calculateSelectedIndex(BuildContext context) {
    final GoRouter route = GoRouter.of(context);
    final String location = route.location;
    if (location.startsWith('/home')) {
      return 0;
    }
    if (location.startsWith('/create')) {
      return 1;
    }
    if (location.startsWith('/account')) {
      return 2;
    }
    return 0;
  }

  void onTap(int value) {
    switch (value) {
      case 0:
        return context.go('/home');
      case 1:
        return context.go('/create');
      case 2:
        return context.go('/account');
      default:
        return context.go('/home');
    }
  }

  final List<BottomNavigationBarItem> navBarItems = <BottomNavigationBarItem>[
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.add_circle_outline_outlined),
      label: 'Create',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.account_circle_outlined),
      label: 'Account',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: navBarItems,
        currentIndex: _calculateSelectedIndex(context),
        onTap: onTap,
      ),
      body: widget.child,
    );
  }
}
