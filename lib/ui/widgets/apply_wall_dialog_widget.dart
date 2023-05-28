import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/wall_action.dart';
import 'primary_btn_widget.dart';

class ApplyWallDialogWidget extends StatelessWidget {
  final String imgUrl;
  const ApplyWallDialogWidget({super.key, required this.imgUrl});

  void applyWall(context,
          {required String url,
          required int wallLocation,
          bool isNative = false}) =>
      Provider.of<WallActionProvider>(context, listen: false).applyWall(context,
          url: url, wallLocation: wallLocation, isNative: isNative);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text("Set Wallpaper"), CloseButton()],
      ),
      contentPadding: const EdgeInsets.all(20),
      children: [
        PrimaryBtnWidget(
          btnText: "Homescreen",
          onTap: () => applyWall(context,
              url: imgUrl, wallLocation: AsyncWallpaper.HOME_SCREEN),
        ),
        const SizedBox(height: 10),
        PrimaryBtnWidget(
          btnText: "Lockscreen",
          onTap: () => applyWall(context,
              url: imgUrl, wallLocation: AsyncWallpaper.LOCK_SCREEN),
        ),
        const SizedBox(height: 10),
        PrimaryBtnWidget(
          btnText: "Both",
          onTap: () => applyWall(context,
              url: imgUrl, wallLocation: AsyncWallpaper.BOTH_SCREENS),
        ),
        const SizedBox(height: 10),
        PrimaryBtnWidget(
            btnText: "Native",
            onTap: () => applyWall(context,
                url: imgUrl,
                wallLocation: AsyncWallpaper.BOTH_SCREENS,
                isNative: true))
      ],
    );
  }
}
