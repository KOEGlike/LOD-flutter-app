import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS ||
        (kIsWeb &&
            (defaultTargetPlatform == TargetPlatform.iOS ||
                defaultTargetPlatform == TargetPlatform.android))) {
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
    appBar: PreferredSize(
      preferredSize: const Size.fromHeight(100),
      child: FloatingAppBar(),
    ),
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
  late int currentIndex;
  Color base(BuildContext context) {
    return Theme.of(context).colorScheme.onBackground;
  }

  Color hover(BuildContext context) {
    return Theme.of(context).colorScheme.secondary;
  }

  Color current(BuildContext context) {
    return Theme.of(context).colorScheme.primary;
  }

  late List<Color> _colors;

  @override
  void didChangeDependencies() {
    _colors = [for (int i = 0; i < navBarItems.length; i++) base(context)];
    currentIndex = _calculateSelectedIndex(context);
    _colors[currentIndex] = current(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 800,
      surfaceTintColor: Colors.transparent,
      foregroundColor: Colors.transparent,
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: SizedBox(
        height: 300,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                width: widget.appBarWidth,
                height: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(
                    20,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    for (int i = 0; i < navBarItems.length; i++)
                      SizedBox(
                          height: 45,
                          width:
                              widget.appBarWidth / (navBarItems.length + 0.1),
                          child: ElevatedButton.icon(
                            onHover: (bool isHovering) {
                              setState(() {
                                if (isHovering) {
                                  _colors[i] = hover(context);
                                } else if (_calculateSelectedIndex(context) ==
                                    i) {
                                  _colors[i] = current(context);
                                } else {
                                  _colors[i] = base(context);
                                }
                              });
                            },
                            onPressed: () {
                              context.go(navBarItems[i].route);
                              setState(() {
                                currentIndex - _calculateSelectedIndex(context);
                              });
                            },
                            icon: navBarItems[i].icon,
                            label: Text(
                              navBarItems[i].label,
                              style: TextStyle(
                                color: _colors[i],
                              ),
                            ),
                            style: ButtonStyle(
                              iconColor: MaterialStateProperty.all(_colors[i]),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              shadowColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              surfaceTintColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(1),
                                    side: const BorderSide(
                                        color: Colors.transparent)),
                              ),
                            ),
                          ))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
