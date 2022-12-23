import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wallrio/ui/theme/theme_data.dart';

import '../../model/wall_rio_model.dart';
import '../widgets/back_btn_widget.dart';
import '../widgets/image_widget.dart';
import '../widgets/primary_btn_widget.dart';

class ImageViewPage extends StatelessWidget {
  final Walls wallModel;
  const ImageViewPage({super.key, required this.wallModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: CNImage(
            imageUrl: wallModel.url,
            isOriginalImg: true,
          )),
      const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: BackBtnWidget(color: Colors.white)),
      DraggableScrollableSheet(
          snap: true,
          snapSizes: const [0.1, 0.5],
          initialChildSize: 0.2,
          minChildSize: 0.1,
          maxChildSize: 0.5,
          builder: (BuildContext context, ScrollController scrollController) {
            return SingleChildScrollView(
                controller: scrollController,
                child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25)),
                        color: Colors.white),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeaderUI(context),
                          const SizedBox(height: 20),
                          _buildActionBtnUI(),
                          const SizedBox(height: 20),
                          _buildDetailsUI(context),
                          const SizedBox(height: 20),
                          _buildColorsUI(context)
                        ])));
          })
    ]));
  }

  Column _buildColorsUI(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Colors", style: Theme.of(context).textTheme.headline2),
        const SizedBox(height: 10),
        Text("Tap swatches to copy",
            style: Theme.of(context).textTheme.bodyText1),
        const SizedBox(height: 10),
        Shimmer.fromColors(
            baseColor: blackColor.withOpacity(0.2),
            highlightColor: blackColor.withOpacity(0.7),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                  color: blackColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15)),
            ))
      ],
    );
  }

  Column _buildDetailsUI(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Details", style: Theme.of(context).textTheme.headline2),
        const SizedBox(height: 10),
        Text("Category : ${wallModel.category!}",
            style: Theme.of(context).textTheme.bodyText1),
        Text("Size : ", style: Theme.of(context).textTheme.bodyText1),
        Text("Dimension : ", style: Theme.of(context).textTheme.bodyText1),
      ],
    );
  }

  Row _buildActionBtnUI() {
    return Row(children: [
      Expanded(child: PrimaryBtnWidget(btnText: "Download", onTap: () {})),
      const SizedBox(width: 10),
      Expanded(child: PrimaryBtnWidget(btnText: "Apply", onTap: () {}))
    ]);
  }

  Row _buildHeaderUI(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(wallModel.name!, style: Theme.of(context).textTheme.headline2),
        const SizedBox(height: 5),
        Text("Designed By ${wallModel.author!}",
            style: Theme.of(context).textTheme.bodySmall)
      ]),
      FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {},
          child: const Icon(
            Icons.favorite_outlined,
            color: Colors.black,
          ))
    ]);
  }
}
