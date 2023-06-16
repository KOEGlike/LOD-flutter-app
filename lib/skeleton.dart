import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;

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

void onTap(int value, BuildContext context) {
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

class Skeleton extends StatefulWidget {
  final Widget child;
  const Skeleton({super.key, required this.child});

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton> {
  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      return mobile(context, widget.child);
    } else {
      return desktop(context, widget.child);
    }
  }
}

Scaffold mobile(BuildContext context, Widget child) {
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
      onTap: (int i) {
        onTap(i, context);
      },
    ),
    body: child,
  );
}

Scaffold desktop(BuildContext context, Widget child) {
  return Scaffold(
    extendBodyBehindAppBar: true,
    appBar: FloatingAppBar(),
    body: Center(child: child),
  );
}

class FloatingAppBar extends AppBar {
  FloatingAppBar({super.key});
  final double appBarWidth = 400;

  @override
  State<FloatingAppBar> createState() => _FloatingAppBarState();
}

class _FloatingAppBarState extends State<FloatingAppBar> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 100,
      surfaceTintColor: Colors.transparent,
      foregroundColor: Colors.transparent,
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: widget.appBarWidth,
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
                  ButtonTheme(
                    minWidth: widget.appBarWidth / navBarItems.length,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.go(navBarItems[i].route);
                      },
                      icon: navBarItems[i].icon,
                      label: Text(navBarItems[i].label),
                      style: ButtonStyle(),
                    ),
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}
