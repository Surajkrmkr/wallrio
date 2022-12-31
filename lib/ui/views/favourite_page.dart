import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:wallrio/provider/navigation.dart';
import 'package:wallrio/ui/widgets/sliver_app_bar_widget.dart';

import '../../provider/favourite.dart';
import '../theme/theme_data.dart';
import '../widgets/image_bottom_sheet.dart';
import '../widgets/image_widget.dart';
import '../widgets/refresh_indicator_widget.dart';
import '../widgets/shimmer_widget.dart';
import 'image_view_page.dart';

class FavouritePage extends StatelessWidget {
  const FavouritePage({super.key});

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
    return RefreshIndicatorWidget(
      child: CustomScrollView(
        controller: Provider.of<Navigation>(context).controller,
        slivers: [
          const SliverAppBarWidget(
              showLogo: false, showSearchBar: false, text: "Your\nChoice"),
          _buildListUI(context)
        ],
      ),
    );
  }

  Widget _buildListUI(context) {
    return Consumer<FavouriteProvider>(builder: (context, provider, _) {
      if (provider.isLoading) {
        return SliverPadding(
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
                        ))));
      }
      final walls = provider.wallList;
      if (walls.isEmpty) {
        return SliverFillRemaining(
          child: Center(
            child: Lottie.asset('assets/lottie/empty.json',
                width: MediaQuery.of(context).size.width * 0.7),
          ),
        );
      }
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
                        tag: walls[index].url!,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Stack(fit: StackFit.expand, children: [
                            CNImage(imageUrl: walls[index].thumbnail),
                            Material(
                                color: Colors.transparent,
                                child: InkWell(
                                    onTap: () =>
                                        _onTapHandler(context, walls[index]),
                                    onLongPress: () => _onLongPressHandler(
                                        context, walls[index]),
                                    splashColor: blackColor.withOpacity(0.3)))
                          ]),
                        ),
                      ))));
    });
  }
}
