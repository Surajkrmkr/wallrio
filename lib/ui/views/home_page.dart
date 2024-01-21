import 'package:flutter/material.dart';
import 'package:wallrio/provider/export.dart';
import 'package:wallrio/ui/widgets/export.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicatorWidget(
      child: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              controller: Provider.of<Navigation>(context).controller,
              primary: false,
              slivers: [
                const SliverAppBarWidget(
                    showLogo: true,
                    showSearchBtn: true,
                    text: "WallRio",
                    userProfileIconRight: false,
                    showUserProfileIcon: true),
                const SliverToBoxAdapter(child: BannerWidget()),
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 20, bottom: 20, left: 25),
                    child: Text(
                      "Trending Wallpapers",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
                const TrendingWallGridWidget()
              ],
            ),
          ),
          const SizedBox(height: 10),
          const AdsWidget()
        ],
      ),
    );
  }
}
