import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallrio/pages.dart';
import 'package:wallrio/provider/navigation.dart';

class NavigationPage extends StatelessWidget {
  const NavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Navigation>(builder: (context, provider, _) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        body: SafeArea(child: pages[provider.index]),
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
                        icon: Icon(Icons.favorite), label: 'Favourite')
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
