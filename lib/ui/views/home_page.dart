import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallrio/provider/navigation.dart';
import 'package:wallrio/ui/widgets/banner_widget.dart';
import 'package:wallrio/ui/widgets/sliver_app_bar_widget.dart';
import 'package:wallrio/ui/widgets/trending_wall_grid_widget.dart';

import '../../provider/wall_rio.dart';
import '../widgets/refresh_indicator_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicatorWidget(
      child: CustomScrollView(
        controller: Provider.of<Navigation>(context).controller,
        slivers: [
          const SliverAppBarWidget(
              showLogo: true, showSearchBar: true, text: "Wallpapers"),
          const SliverToBoxAdapter(child: BannerWidget()),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20, left: 25),
              child: Text(
                "Trending Wallpapers",
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
          ),
          const TrendingWallGridWidget()
        ],
      ),
    );
  }
}
