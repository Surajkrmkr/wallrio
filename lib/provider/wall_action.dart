import 'package:android_path_provider/android_path_provider.dart';
import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../ui/widgets/apply_wall_dialog_widget.dart';
import '../ui/widgets/toast_widget.dart';

class WallActionProvider extends ChangeNotifier {
  bool isDownloading = false;
  bool isApplying = false;

  set setIsDownloading(bool val) {
    isDownloading = val;
    notifyListeners();
  }

  set setIsApplying(bool val) {
    isApplying = val;
    notifyListeners();
  }

  void downloadImg(url, name) async {
    ToastWidget.showToast("Downloading wallpaper");
    setIsDownloading = true;
    bool? isSuccessfullyDownloaded;
    try {
      final String downloadDir = await AndroidPathProvider.downloadsPath;
      final cache = DefaultCacheManager();
      final imgFile = await cache.getSingleFile(url);
      await imgFile.copy('$downloadDir/$name.png');
      isSuccessfullyDownloaded = true;
    } on Exception {
      isSuccessfullyDownloaded = false;
    }
    ToastWidget.showToast(isSuccessfullyDownloaded
        ? "Wallpaper Downloaded successfully"
        : "Failed to download wallpaper");
    setIsDownloading = false;
  }

  void setWall(url, context) => showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ApplyWallDialogWidget(imgUrl: url));

  void applyWall(context,
      {required String url,
      required int wallLocation,
      required bool isNative}) async {
    setIsApplying = true;
    Navigator.pop(context);
    ToastWidget.showToast("Applying wallpaper");
    bool? isSuccessfullyApplied;
    var file = await DefaultCacheManager().getSingleFile(url);
    try {
      isSuccessfullyApplied = isNative
          ? await AsyncWallpaper.setWallpaperNative(
              url: url,
              goToHome: false,
            )
          : await AsyncWallpaper.setWallpaperFromFile(
              filePath: file.path,
              wallpaperLocation: wallLocation,
              goToHome: false,
            );
    } on PlatformException {
      isSuccessfullyApplied = false;
    } finally {
      setIsApplying = false;

      ToastWidget.showToast(isSuccessfullyApplied!
          ? "Wallpaper applied successfully"
          : "Failed to apply wallpaper");
    }
  }
}
