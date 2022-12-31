import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/favourite.dart';
import '../../provider/navigation.dart';
import '../../provider/wall_rio.dart';
import '../theme/theme_data.dart';
import '../widgets/image_bottom_sheet.dart';
import '../widgets/image_widget.dart';
import '../widgets/refresh_indicator_widget.dart';
import '../widgets/shimmer_widget.dart';
import '../widgets/sliver_app_bar_widget.dart';
import 'package:wallrio/model/wall_rio_model.dart';

import 'grid_page.dart';
import 'image_view_page.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  void _onLongPressHandler(context, model) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: whiteColor,
        enableDrag: true,
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
    return RefreshIndicatorWidget(
      child: CustomScrollView(
        controller: Provider.of<Navigation>(context).controller,
        slivers: [
          const SliverAppBarWidget(
              showLogo: false, showSearchBar: false, text: "Our\nCollections"),
          _buildCategoryUI()
        ],
      ),
    );
  }

  Widget _buildCategoryUI() {
    return Consumer<WallRio>(builder: (context, provider, _) {
      return provider.isLoading
          ? SliverPadding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
              sliver: _buildShimmerUI(),
            )
          : provider.error.isEmpty
              ? SliverList(
                  delegate: SliverChildBuilderDelegate(
                      childCount: provider.categories!.length,
                      (context, index) {
                  final categoryName =
                      provider.categories!.keys.elementAt(index);
                  final categoryWalls =
                      provider.categories!.values.elementAt(index);
                  return Column(children: [
                    _buildCategoryHeaderUI(
                        categoryName, categoryWalls, context),
                    _buildListViewUI(categoryWalls),
                    if (index == provider.categories!.length - 1)
                      const SizedBox(height: 20)
                  ]);
                }))
              : SliverFillRemaining(child: Center(child: Text(provider.error)));
    });
  }

  SliverList _buildShimmerUI() {
    return SliverList(
        delegate: SliverChildBuilderDelegate(childCount: 4, (context, index) {
      return Column(
        children: [
          const ShimmerWidget(height: 40, width: double.infinity),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(
                  6,
                  (index) => const Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child:
                            ShimmerWidget(height: 200, width: 120, radius: 25),
                      )),
            ),
          ),
          const SizedBox(height: 20)
        ],
      );
    }));
  }

  SizedBox _buildListViewUI(List<Walls?> categoryWalls) {
    return SizedBox(
      height: 200,
      child: Row(
        children: [
          const SizedBox(width: 20),
          Expanded(
            child: ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemCount: categoryWalls.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, i) {
                  return Hero(
                    tag: categoryWalls[i]!.url!,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: SizedBox(
                        width: 120,
                        child: Stack(fit: StackFit.expand, children: [
                          CNImage(imageUrl: categoryWalls[i]!.thumbnail),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () =>
                                  _onTapHandler(context, categoryWalls[i]),
                              onLongPress: () => _onLongPressHandler(
                                  context, categoryWalls[i]),
                              splashColor: blackColor.withOpacity(0.3),
                            ),
                          ),
                          Positioned(
                              right: 10,
                              bottom: 10,
                              child: Consumer<FavouriteProvider>(
                                  builder: (context, provider, _) {
                                final bool isFav = provider
                                    .isSelectedAsFav(categoryWalls[i]!.url!);
                                if (provider.isLoading) {
                                  return const FloatingActionButton.small(
                                      heroTag: null,
                                      backgroundColor: Colors.white,
                                      onPressed: null,
                                      child: Icon(Icons.favorite_border_rounded,
                                          size: 18, color: Colors.black));
                                }
                                return FloatingActionButton.small(
                                  heroTag: null,
                                  backgroundColor: Colors.white,
                                  onPressed: null,
                                  child: AnimatedIconButton(
                                    size: 18,
                                    initialIcon: isFav ? 1 : 0,
                                    onPressed: () => isFav
                                        ? provider.removeFromFav(
                                            categoryWalls[i]!.url!)
                                        : provider.addToFav(categoryWalls[i]!),
                                    icons: const [
                                      AnimatedIconItem(
                                        icon:
                                            Icon(Icons.favorite_border_rounded),
                                      ),
                                      AnimatedIconItem(
                                        icon: Icon(Icons.favorite_rounded),
                                      ),
                                    ],
                                  ),
                                );
                              }))
                        ]),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  ListTile _buildCategoryHeaderUI(
      String categoryName, List<Walls?> walls, BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 25),
      title: Text(categoryName, style: Theme.of(context).textTheme.bodyMedium),
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => GridPage(
                    categoryName: categoryName,
                    walls: walls,
                  ))),
      trailing: const Icon(
        Icons.navigate_next_rounded,
        color: blackColor,
        size: 30,
      ),
    );
  }
}
