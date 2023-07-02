import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';
import 'package:wallrio/pages.dart';
import 'package:wallrio/provider/navigation.dart';
import 'package:wallrio/provider/wall_rio.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<WallRio>(context, listen: false).getListFromAPI(context);
    });

    // FirebaseAuth.instance.userChanges().listen((event) {
    //   if (FirebaseAuth.instance.currentUser == null) {
    //     Provider.of<AuthProvider>(context, listen: false).signOut(context);
    //   }
    // }, onError: (error) {
    //   logger.e(error.toString());
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Navigation>(builder: (context, provider, _) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        body: SafeArea(
          child: PageTransitionSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (
              Widget child,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) =>
                FadeThroughTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            ),
            child: pages[provider.index],
          ),
        ),
        bottomNavigationBar: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutCubic,
          height: provider.visible ? 80 : 0.0,
          child: Wrap(
            children: [
              NavigationBar(
                  destinations: const [
                    NavigationDestination(
                        icon: Icon(Icons.home_rounded), label: 'Home'),
                    NavigationDestination(
                        icon: Icon(Icons.grid_view_rounded), label: 'Category'),
                    NavigationDestination(
                        icon: Icon(Icons.favorite_rounded), label: 'Favourite')
                  ],
                  selectedIndex: provider.index,
                  onDestinationSelected: (value) => provider.setIndex = value),
            ],
          ),
        ),
      );
    });
  }
}
