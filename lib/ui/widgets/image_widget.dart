import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wallrio/ui/theme/theme_data.dart';

class CNImage extends StatelessWidget {
  const CNImage({Key? key, @required this.imageUrl}) : super(key: key);
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      filterQuality: FilterQuality.high,
      // errorWidget: (context, url, error) => errorWidget(),
      fit: BoxFit.cover,
      memCacheHeight: 400,
      imageUrl: imageUrl!,
      placeholder: (context, url) {
        return buildShimmer();
      },
    );
  }

  static Widget buildShimmer() {
    return Shimmer.fromColors(
        baseColor: blackColor.withOpacity(0.2),
        highlightColor: blackColor.withOpacity(0.5),
        child: Container(
          height: 100,
          decoration: BoxDecoration(
              color: blackColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(25)),
        ));
  }
}
