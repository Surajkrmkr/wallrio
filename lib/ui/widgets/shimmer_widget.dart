import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../theme/theme_data.dart';

class ShimmerWidget extends StatelessWidget {
  final double height;
  final double width;
  final double radius;
  const ShimmerWidget(
      {super.key, required this.height, required this.width, this.radius = 15});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: blackColor.withOpacity(0.2),
        highlightColor: blackColor.withOpacity(0.5),
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
              color: blackColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15)),
        ));
  }
}
