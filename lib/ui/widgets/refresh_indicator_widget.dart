import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallrio/provider/wall_rio.dart';

import '../theme/theme_data.dart';

class RefreshIndicatorWidget extends StatelessWidget {
  final Widget child;
  const RefreshIndicatorWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        Provider.of<WallRio>(context, listen: false).getListFromAPI();
        await Future.delayed(const Duration(seconds: 1));
      },
      backgroundColor: whiteColor,
      color: blackColor,
      edgeOffset: 80,
      child: child,
    );
  }
}
