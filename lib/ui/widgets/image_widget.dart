import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wallrio/ui/widgets/shimmer_widget.dart';

class CNImage extends StatelessWidget {
  const CNImage({Key? key, @required this.imageUrl, this.isOriginalImg = false})
      : super(key: key);
  final String? imageUrl;
  final bool isOriginalImg;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      filterQuality: FilterQuality.high,
      // errorWidget: (context, url, error) => errorWidget(),
      fit: BoxFit.cover,
      memCacheHeight:
          isOriginalImg ? 1080 : 800,
      imageUrl: imageUrl!,
      placeholder: (context, url) {
        return const ShimmerWidget(
          height: 100,
          width: double.infinity,
        );
      },
    );
  }
}
