import 'package:first_test/views/results.dart';
import 'package:first_test/views/vote.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'views/home.dart';
import 'views/account.dart';
import 'views/create.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart';

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

class NavIcon {
  final Icon icon;
  final String route;
  final String label;
  NavIcon({
    Key? key,
    required this.icon,
    required this.route,
    required this.label,
  });
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
  final List<NavIcon> navBarItems = <NavIcon>[
    NavIcon(
      icon: const Icon(Icons.home),
      label: 'Home',
      route: '/home',
    ),
    NavIcon(
      icon: const Icon(Icons.add_circle_outline_outlined),
      label: 'Create',
      route: '/create',
    ),
    NavIcon(
      icon: const Icon(Icons.account_circle_outlined),
      label: 'Account',
      route: '/account',
    ),
  ];

  int _calculateSelectedIndex(BuildContext context) {
    final GoRouter route = GoRouter.of(context);
    final String location = route.location;
    if (location.startsWith(navBarItems[0].route)) {
      return 0;
    }
    if (location.startsWith(navBarItems[1].route)) {
      return 1;
    }
    if (location.startsWith(navBarItems[2].route)) {
      return 2;
    }
    return 0;
  }

  void onTap(int value) {
    switch (value) {
      case 0:
        return context.go(navBarItems[0].route);
      case 1:
        return context.go(navBarItems[1].route);
      case 2:
        return context.go(navBarItems[2].route);
      default:
        return context.go(navBarItems[0].route);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: [
            for (int i = 0; i < navBarItems.length; i++)
              BottomNavigationBarItem(
                icon: navBarItems[i].icon,
                label: navBarItems[i].label,
              )
          ],
          currentIndex: _calculateSelectedIndex(context),
          onTap: onTap,
        ),
        body: widget.child,
      );
    } else {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          toolbarHeight: 100,
          surfaceTintColor: Colors.transparent,
          foregroundColor: Colors.transparent,
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                //padding: const EdgeInsets.only(bottom: 10),
                width: 400,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(
                    20,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    for (int i = 0; i < navBarItems.length; i++)
                      ElevatedButton.icon(
                        onPressed: () {
                          context.go(navBarItems[i].route);
                        },
                        icon: navBarItems[i].icon,
                        label: Text(navBarItems[i].label),
                      )
                  ],
                ),
              )
            ],
          ),
        ),
        body: Center(child: widget.child),
      );
    }
  }
}
