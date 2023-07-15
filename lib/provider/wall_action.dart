import 'package:flutter/material.dart';
import 'package:wallrio/services/packages/export.dart';
import 'package:wallrio/ui/widgets/export.dart';
import 'package:android_download_manager/android_download_manager.dart';

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
    try {
      final String downloadDir = await AndroidPathProvider.downloadsPath;
      final PermissionStatus permissionStatus =
          await Permission.storage.request();
      if (permissionStatus == PermissionStatus.granted) {
        await AndroidDownloadManager.enqueue(
          downloadUrl: url,
          downloadPath: downloadDir,
          fileName: "$name.png",
        );
        ToastWidget.showToast("Wallpaper Downloaded successfully");
      } else {
        throw Exception("Permission denied");
      }
    } catch (error) {
      logger.e(error);
      ToastWidget.showToast("Failed to download wallpaper");
    }

    setIsDownloading = false;
  }

  void setWall(url, context) => showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ApplyWallDialogWidget(imgUrl: url));

  ToastDetails _getToast(String msg) => ToastDetails(
      message: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0);

  void applyWall(context,
      {required String url,
      required int wallLocation,
      required bool isNative}) async {
    setIsApplying = true;
    Navigator.pop(context);
    ToastWidget.showToast("Applying wallpaper");
    var file = await DefaultCacheManager().getSingleFile(url);
    try {
      isNative
          ? await AsyncWallpaper.setWallpaperNative(
              url: url,
              goToHome: true,
              errorToastDetails: _getToast("Failed to apply wallpaper"),
              toastDetails: _getToast("Wallpaper applied successfully"),
            )
          : await AsyncWallpaper.setWallpaperFromFile(
              filePath: file.path,
              wallpaperLocation: wallLocation,
              goToHome: true,
              errorToastDetails: _getToast("Failed to apply wallpaper"),
              toastDetails: _getToast("Wallpaper applied successfully"),
            );
    } catch (error) {
      logger.e(error);
    } finally {
      setIsApplying = false;
    }
  }
}
