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
          child: Center(
            child: Wrap(
              children: [
                BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    enableFeedback: true,
                    items: const [
                      BottomNavigationBarItem(
                          icon: Icon(Icons.home_rounded), label: 'Home'),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.grid_view_rounded),
                          label: 'Category'),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.favorite), label: 'Favourite')
                    ],
                    iconSize: 28,
                    showSelectedLabels: false,
                    showUnselectedLabels: false,
                    currentIndex: provider.index,
                    onTap: (value) => provider.setIndex = value),
              ],
            ),
          ),
        ),
      );
    });
  }
}
