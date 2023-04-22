import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider;
import 'package:animations/animations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wallrio/pages.dart';
import 'package:wallrio/provider/navigation.dart';

import '../../provider/auth.dart';
import '../../provider/wall_rio.dart';
import '../oauth/login_page.dart';
import '../widgets/change_log.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  late final StreamSubscription<AuthState> _authStateSubscription;
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      provider.Provider.of<AuthProvider>(context, listen: false)
          .setUserProfileData();
      provider.Provider.of<WallRio>(context, listen: false)
          .getListFromAPI(context);
    });
    _authStateSubscription =
        provider.Provider.of<AuthProvider>(context, listen: false)
            .supabase
            .auth
            .onAuthStateChange
            .listen((data) {
      final session = data.session;
      if (session == null && mounted) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginPage()));
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _authStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return provider.Consumer<Navigation>(builder: (context, provider, _) {
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
