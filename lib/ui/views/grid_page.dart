import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallrio/ui/theme/theme_data.dart';
import 'package:wallrio/ui/views/image_view_page.dart';
import 'package:wallrio/ui/widgets/image_bottom_sheet.dart';

import '../../model/wall_rio_model.dart';
import '../../provider/favourite.dart';
import '../widgets/image_widget.dart';
import '../widgets/sliver_app_bar_widget.dart';

class GridPage extends StatelessWidget {
  final String categoryName;
  final List<Walls?> walls;
  const GridPage({super.key, required this.categoryName, required this.walls});

  void _onLongPressHandler(context, model) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: true,
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
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBarWidget(
                showLogo: false,
                showSearchBtn: false,
                text: categoryName,
                showBackBtn: true),
            _buildListUI(context)
          ],
        ),
      ),
    );
  }

  Widget _buildListUI(context) {
    return SliverPadding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 0.7),
            delegate: SliverChildBuilderDelegate(
                childCount: walls.length,
                (context, index) => Hero(
                      tag: walls[index]!.url,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Stack(fit: StackFit.expand, children: [
                          CNImage(imageUrl: walls[index]!.thumbnail),
                          Material(
                              color: Colors.transparent,
                              child: InkWell(
                                  onTap: () =>
                                      _onTapHandler(context, walls[index]),
                                  onLongPress: () => _onLongPressHandler(
                                      context, walls[index]),
                                  splashColor: blackColor.withOpacity(0.3))),
                          _buildImgDetailsUI(context, walls[index]!),
                        ]),
                      ),
                    ))));
  }

  Align _buildImgDetailsUI(BuildContext context, Walls wall) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          color: wall.colorList.last,
          padding: const EdgeInsets.only(left: 15, right: 5),
          height: 45,
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Material(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.20,
                  child: Text(
                    wall.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: whiteColor),
                  ),
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
        onTap: () =>
            isFav ? provider.removeFromFav(wall.url) : provider.addToFav(wall),
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
