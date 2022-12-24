import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallrio/provider/wall_rio.dart';
import 'package:wallrio/ui/theme/theme_data.dart';
import 'package:wallrio/ui/widgets/image_bottom_sheet.dart';
import 'package:wallrio/ui/widgets/image_widget.dart';

import '../../model/wall_rio_model.dart';
import '../views/image_view_page.dart';
import 'shimmer_widget.dart';

class TrendingWallGridWidget extends StatelessWidget {
  final bool isShuffled;
  final bool isActionGrid;
  const TrendingWallGridWidget(
      {super.key, this.isShuffled = false, this.isActionGrid = false});

  void _onLongPressHandler(context, model) {
    showModalBottomSheet(
        context: context,
        backgroundColor: whiteColor,
        enableDrag: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        barrierColor: Colors.black12,
        builder: (context) => ImageBottomSheet(wallModel: model));
  }

  void _onTapHandler(context, model) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ImageViewPage(wallModel: model)));
  }

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
                children: List.generate(
                    8,
                    (index) => const ShimmerWidget(
                          height: 100,
                          width: double.infinity,
                        )),
              ),
            )
          : provider.error.isEmpty
              ? isActionGrid && provider.actionWallList.isEmpty
                  ? SliverFillRemaining(
                      child: Center(
                          child: Text(
                      "No Wallpapers Found",
                      style: TextStyle(color: blackColor.withOpacity(0.5)),
                    )))
                  : SliverPadding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 20),
                      sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 15,
                                  crossAxisSpacing: 15,
                                  childAspectRatio: 0.7),
                          delegate: SliverChildBuilderDelegate(
                              childCount: isActionGrid
                                  ? provider.actionWallList.length
                                  : provider.originalWallList.length,
                              (context, index) {
                            final Walls wall = isActionGrid
                                ? provider.actionWallList[index]
                                : provider.originalWallList[index];
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: Stack(fit: StackFit.expand, children: [
                                CNImage(imageUrl: wall.thumbnail),
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => _onTapHandler(context, wall),
                                    onLongPress: () =>
                                        _onLongPressHandler(context, wall),
                                    splashColor: blackColor.withOpacity(0.3),
                                  ),
                                ),
                              ]),
                            );
                          })),
                    )
              : SliverFillRemaining(child: Center(child: Text(provider.error)));
    });
  }
}
