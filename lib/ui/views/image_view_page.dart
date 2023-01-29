import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../model/wall_rio_model.dart';
import '../../provider/favourite.dart';
import '../../provider/wall_action.dart';
import '../../provider/wall_details.dart';
import '../widgets/back_btn_widget.dart';
import '../widgets/image_widget.dart';
import '../widgets/primary_btn_widget.dart';
import '../widgets/shimmer_widget.dart';
import '../widgets/toast_widget.dart';

// ignore: must_be_immutable
class ImageViewPage extends StatelessWidget {
  final Walls wallModel;
  ImageViewPage({super.key, required this.wallModel});

  bool _isInitialized = false;

  void copyColor(Color color) async {
    String code = "#ff${color.toString().substring(10, 16)}";
    await Clipboard.setData(ClipboardData(text: code));
    ToastWidget.showToast("$code Color copied");
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      Future.delayed(Duration.zero, () {
        Provider.of<WallDetails>(context, listen: false)
            .getColorPalette(wallModel.thumbnail!);
        Provider.of<WallDetails>(context, listen: false)
            .getWallDetails(wallModel.url!);
      });
      _isInitialized = false;
    }
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BackBtnWidget(color: Theme.of(context).primaryColorLight),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Hero(
                tag: wallModel.url!,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.40,
                      width: MediaQuery.of(context).size.width,
                      child: CNImage(
                        imageUrl: wallModel.url,
                        isOriginalImg: true,
                      )),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderUI(context),
                    const SizedBox(height: 20),
                    _buildActionBtnUI(context),
                    const SizedBox(height: 20),
                    _buildDetailsUI(context),
                    const SizedBox(height: 20),
                    _buildColorsUI(context)
                  ]),
            )
          ],
        ),
      ),
    ));
    //     Stack(children: [
    //   Hero(
    //     tag: wallModel.url!,
    //     child: SizedBox(
    //         height: MediaQuery.of(context).size.height,
    //         width: MediaQuery.of(context).size.width,
    //         child: CNImage(
    //           imageUrl: wallModel.url,
    //           isOriginalImg: true,
    //         )),
    //   ),
    //   const Padding(
    //       padding: EdgeInsets.only(left: 8.0),
    //       child: BackBtnWidget(color: Colors.white)),
    //   DraggableScrollableSheet(
    //       snap: true,
    //       snapSizes: const [0.1, 0.5],
    //       initialChildSize: 0.2,
    //       minChildSize: 0.1,
    //       maxChildSize: 0.5,
    //       builder: (BuildContext context, ScrollController scrollController) {
    //         return SingleChildScrollView(
    //           controller: scrollController,
    //           child: Container(
    //             padding: const EdgeInsets.all(20),
    //             decoration: const BoxDecoration(
    //                 borderRadius: BorderRadius.only(
    //                     topLeft: Radius.circular(25),
    //                     topRight: Radius.circular(25)),
    //                 color: Colors.white),
    //             child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   _buildHeaderUI(context),
    //                   const SizedBox(height: 20),
    //                   _buildActionBtnUI(context),
    //                   const SizedBox(height: 20),
    //                   _buildDetailsUI(context),
    //                   const SizedBox(height: 20),
    //                   _buildColorsUI(context)
    //                 ]),
    //           ),
    //         );
    //       })
    // ]));
  }

  Column _buildColorsUI(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Colors", style: Theme.of(context).textTheme.displayMedium),
        const SizedBox(height: 10),
        Text("Tap swatches to copy",
            style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 10),
        Consumer<WallDetails>(
            builder: (context, provider, _) => provider.isColorPaletteLoading
                ? const ShimmerWidget(
                    height: 60,
                    width: double.infinity,
                    radius: 15,
                  )
                : SizedBox(
                    height: 60,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: provider.colorSwatch
                          .map((color) => Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: InkWell(
                                    onTap: () => copyColor(color),
                                    borderRadius: BorderRadius.circular(15),
                                    child: Ink(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                          color: color,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                    )),
                              ))
                          .toList(),
                    ),
                  ))
      ],
    );
  }

  Widget _buildDetailsUI(BuildContext context) {
    return Consumer<WallDetails>(builder: (context, provider, _) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Details", style: Theme.of(context).textTheme.displayMedium),
          const SizedBox(height: 10),
          Row(
            children: [
              Text("Category : ",
                  style: Theme.of(context).textTheme.titleSmall),
              Text(wallModel.category!,
                  style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
          Row(
            children: [
              Text("Size : ", style: Theme.of(context).textTheme.titleSmall),
              provider.isImageDetailsLoading
                  ? const ShimmerWidget(height: 13, width: 70)
                  : Text(provider.size,
                      style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
          Row(
            children: [
              Text("Dimension : ",
                  style: Theme.of(context).textTheme.titleSmall),
              provider.isImageDetailsLoading
                  ? const ShimmerWidget(height: 13, width: 70)
                  : Text("${provider.width} * ${provider.height}",
                      style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ],
      );
    });
  }

  Row _buildActionBtnUI(context) {
    final provider = Provider.of<WallActionProvider>(context, listen: false);
    return Row(children: [
      Expanded(
          child: PrimaryBtnWidget(
              btnText: "Download",
              onTap: () => provider.downloadImg(
                  wallModel.url, wallModel.name! + wallModel.id.toString()))),
      const SizedBox(width: 10),
      Expanded(
          child: PrimaryBtnWidget(
              btnText: "Apply",
              onTap: () => provider.setWall(wallModel.url, context)))
    ]);
  }

  Row _buildHeaderUI(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(wallModel.name!, style: Theme.of(context).textTheme.displayMedium),
        const SizedBox(height: 5),
        Text("Designed By ${wallModel.author!}",
            style: Theme.of(context).textTheme.titleSmall)
      ]),
      Consumer<FavouriteProvider>(builder: (context, provider, _) {
        final bool isFav = provider.isSelectedAsFav(wallModel.url!);
        if (provider.isLoading) {
          return _buildFavBtn(
              color: Theme.of(context).primaryColorLight,
              iconData: Icons.favorite_border_rounded,
              onTap: () {});
        }
        return _buildFavBtn(
          color: isFav ? Colors.redAccent : Theme.of(context).primaryColorLight,
          iconData:
              isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          onTap: () => isFav
              ? provider.removeFromFav(wallModel.url!)
              : provider.addToFav(wallModel),
        );
      })
    ]);
  }

  IconButton _buildFavBtn(
      {required Function() onTap,
      required IconData iconData,
      required Color color}) {
    return IconButton(onPressed: onTap, icon: Icon(iconData, color: color));
  }
}
