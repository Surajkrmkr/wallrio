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
        enableDrag: true,
        isScrollControlled: true,
        isDismissible: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
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
                  childAspectRatio: 0.6,
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
                                  childAspectRatio: 0.6),
                          delegate: SliverChildBuilderDelegate(
                              childCount: isActionGrid
                                  ? provider.actionWallList.length
                                  : provider.originalWallList.length,
                              (context, index) {
                            final Walls wall = isActionGrid
                                ? provider.actionWallList[index]
                                : provider.originalWallList[index];
                            return _buildImgUI(wall, context);
                          })),
                    )
              : SliverFillRemaining(child: Center(child: Text(provider.error)));
    });
  }

  Hero _buildImgUI(Walls wall, BuildContext context) {
    return Hero(
      tag: wall.url,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Stack(fit: StackFit.expand, children: [
          CNImage(imageUrl: wall.thumbnail),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _onTapHandler(context, wall),
              onLongPress: () => _onLongPressHandler(context, wall),
              splashColor: blackColor.withOpacity(0.3),
            ),
          ),
          _buildImgDetailsUI(context, wall),
        ]),
      ),
    );
  }

  Align _buildImgDetailsUI(BuildContext context, Walls wall) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          // color: wall.colorList.last,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black54],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
          padding: const EdgeInsets.only(left: 15, right: 5),
          height: 65,
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      wall.name,
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: whiteColor, fontSize: 12),
                    ),
                    Text(
                      "Designed by ${wall.author}",
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: whiteColor, fontSize: 10),
                    ),
                  ],
                ),
              ),
              _buildFavIcon(wall)
            ],
          ),
        ));
  }

  Consumer<FavouriteProvider> _buildFavIcon(Walls wall) {
    return Consumer<FavouriteProvider>(builder: (context, provider, _) {
      final bool isFav = provider.isSelectedAsFav(wall.url);
      if (provider.isLoading) {
        return _buildFavBtn(
            color: Colors.white,
            iconData: Icons.favorite_border_rounded,
            onTap: () {});
      }
      return _buildFavBtn(
        color: isFav ? Colors.redAccent : Colors.white,
        iconData:
            isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
        onTap: () => isFav
            ? provider.removeFromFav(id: wall.id)
            : provider.addToFav(wall: wall),
      );
    });
  }

  IconButton _buildFavBtn(
      {required Function() onTap,
      required IconData iconData,
      required Color color}) {
    return IconButton(onPressed: onTap, icon: Icon(iconData, color: color));
  }
}
