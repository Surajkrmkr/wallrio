import 'package:flutter/material.dart';
import 'package:wallrio/provider/export.dart';
import 'package:wallrio/services/packages/export.dart';
import 'package:wallrio/ui/widgets/export.dart';

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
