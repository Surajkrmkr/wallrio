import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallrio/provider/wall_rio.dart';
import 'package:wallrio/ui/widgets/image_widget.dart';

class TrendingWallGridWidget extends StatelessWidget {
  const TrendingWallGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WallRio>(builder: (context, provider, _) {
      return provider.isLoading
          ? SliverPadding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
              sliver: SliverGrid.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.7,
                children: List.generate(8, (index) => CNImage.buildShimmer()),
              ),
            )
          : provider.error.isEmpty
              ? SliverPadding(
                  padding:
                      const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                  sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 15,
                              crossAxisSpacing: 15,
                              childAspectRatio: 0.7),
                      delegate: SliverChildBuilderDelegate(
                          childCount: provider.wallList.length,
                          (context, index) => ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: CNImage(
                                    imageUrl:
                                        provider.wallList[index].thumbnail),
                              ))),
                )
              : SliverFillRemaining(child: Center(child: Text(provider.error)));
    });
  }
}
