import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wallrio/ui/theme/theme_data.dart';
import 'package:wallrio/ui/widgets/shimmer_widget.dart';

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
        return const ShimmerWidget(
          height: 100,
          width: double.infinity,
        );
      },
    );
  }
}
