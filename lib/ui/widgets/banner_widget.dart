import 'package:flutter/material.dart';
import 'package:wallrio/model/export.dart';
import 'package:wallrio/provider/export.dart';
import 'package:wallrio/services/export.dart';
import 'package:wallrio/ui/views/export.dart';
import 'package:wallrio/ui/widgets/export.dart';

class BannerWidget extends StatelessWidget {
  const BannerWidget({super.key});

  void _onTapHandler(context, Banners banner) => banner.category.isEmpty
      ? LaunchUrlWidget.launch(banner.link)
      : Navigator.push(context, MaterialPageRoute(builder: (context) {
          final categoryWalls =
              Provider.of<WallRio>(context).categories![banner.category];
          return GridPage(
            categoryName: banner.category,
            walls: categoryWalls!,
          );
        }));

  @override
  Widget build(BuildContext context) {
    return Consumer<WallRio>(builder: (context, provider, _) {
      if (provider.isLoading) {
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: ShimmerWidget(
            height: 150,
            width: double.infinity,
            radius: 25,
          ),
        );
      }
      final list = provider.bannerList;
      return SizedBox(
        height: 150,
        child: PageView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: provider.bannerList.length,
          itemBuilder: (context, itemIndex) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Stack(fit: StackFit.expand, children: [
                CNImage(imageUrl: list[itemIndex].url),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _onTapHandler(context, list[itemIndex]),
                    splashColor: blackColor.withOpacity(0.3),
                  ),
                ),
              ]),
            ),
          ),
        ),
      );
    });
  }
}
