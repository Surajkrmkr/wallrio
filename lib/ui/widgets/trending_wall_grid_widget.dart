import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:wallrio/provider/wall_rio.dart';
import 'package:wallrio/ui/theme/theme_data.dart';
import 'package:wallrio/ui/widgets/image_bottom_sheet.dart';
import 'package:wallrio/ui/widgets/image_widget.dart';

import '../../model/wall_rio_model.dart';
import '../../provider/favourite.dart';
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
        isScrollControlled: true,
        isDismissible: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
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
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
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
                            radius: 25,
                          ))))
          : provider.error.isEmpty
              ? isActionGrid && provider.actionWallList.isEmpty
                  ? SliverFillRemaining(
                      child: Center(
                      child: Lottie.asset('assets/lottie/empty.json',
                          width: MediaQuery.of(context).size.width * 0.7),
                    ))
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
                            return Hero(
                              tag: wall.url!,
                              child: ClipRRect(
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
                                  Positioned(
                                      right: 15,
                                      bottom: 15,
                                      child: Consumer<FavouriteProvider>(
                                          builder: (context, provider, _) {
                                        final bool isFav =
                                            provider.isSelectedAsFav(wall.url!);
                                        if (provider.isLoading) {
                                          return const SizedBox(
                                            height: 50,
                                            width: 50,
                                            child: FloatingActionButton(
                                              heroTag: null,
                                              backgroundColor: Colors.white,
                                              onPressed: null,
                                              child: Icon(
                                                  Icons.favorite_border_rounded,
                                                  color: Colors.black),
                                            ),
                                          );
                                        }
                                        return SizedBox(
                                          height: 50,
                                          width: 50,
                                          child: FloatingActionButton(
                                            heroTag: null,
                                            backgroundColor: Colors.white,
                                            onPressed: null,
                                            child: AnimatedIconButton(
                                              size: 24,
                                              initialIcon: isFav ? 1 : 0,
                                              onPressed: () => isFav
                                                  ? provider
                                                      .removeFromFav(wall.url!)
                                                  : provider.addToFav(wall),
                                              icons: const [
                                                AnimatedIconItem(
                                                  icon: Icon(Icons
                                                      .favorite_border_rounded),
                                                ),
                                                AnimatedIconItem(
                                                  icon: Icon(
                                                      Icons.favorite_rounded),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }))
                                ]),
                              ),
                            );
                          })),
                    )
              : SliverFillRemaining(child: Center(child: Text(provider.error)));
    });
  }
}
