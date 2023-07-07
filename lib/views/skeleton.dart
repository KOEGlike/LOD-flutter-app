import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
//import '../custom_error.dart';

class NavIcon {
  final Icon icon;
  final String route;
  final String label;
  const NavIcon({
    Key? key,
    required this.icon,
    required this.route,
    required this.label,
  });
}

int _calculateSelectedIndex(BuildContext context, List<NavIcon> navIcons) {
  final String location = GoRouterState.of(context).location;
  debugPrint(location);

  for (int i = 0; i < navIcons.length; i++) {
    if (location == navBarItems[i].route) {
      return i;
    }
  }
  return 0;
}

const List<NavIcon> navBarItems = <NavIcon>[
  NavIcon(
    icon: Icon(Icons.home),
    label: 'Home',
    route: '/',
  ),
  NavIcon(
    icon: Icon(Icons.add_circle_outline_outlined),
    label: 'Create',
    route: '/create',
  ),
  NavIcon(
    icon: Icon(Icons.account_circle_outlined),
    label: 'Account',
    route: '/account',
  ),
];

void onTap(int value, BuildContext context, List<NavIcon> navIcons) {
  context.go(navIcons[value].route);
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
        (kIsWeb && MediaQuery.of(context).size.width < 600)) {
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
      currentIndex: _calculateSelectedIndex(context, navBarItems),
      onTap: (int i) {
        onTap(i, context, navBarItems);
      },
    ),
    body: child,
  );
}

Scaffold desktop(BuildContext context, Widget child) {
  return Scaffold(
    extendBodyBehindAppBar: true,
    appBar: const FloatingAppBar(),
    body: Center(child: child),
  );
}

class FloatingAppBar extends StatefulWidget implements PreferredSizeWidget {
  const FloatingAppBar({super.key});
  final double appBarWidth = 400;

  @override
  State<FloatingAppBar> createState() => _FloatingAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(100);
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
    return Theme.of(context).colorScheme.primaryContainer;
  }

  late List<Color> _colors;

  @override
  void didChangeDependencies() {
    _colors = [for (int i = 0; i < navBarItems.length; i++) base(context)];
    currentIndex = _calculateSelectedIndex(context, navBarItems);
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
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(
                      20,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(
                                Theme.of(context).brightness == Brightness.dark
                                    ? 0.05
                                    : 0.7),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 0),
                      )
                    ]),
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
                                } else if (_calculateSelectedIndex(
                                        context, navBarItems) ==
                                    i) {
                                  _colors[i] = current(context);
                                } else {
                                  _colors[i] = base(context);
                                }
                              });
                            },
                            onPressed: () {
                              onTap(i, context, navBarItems);
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
