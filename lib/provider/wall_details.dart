import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wallrio/services/packages/export.dart';

class WallDetails extends ChangeNotifier {
  List<Color> colorSwatch = [];
  bool isColorPaletteLoading = false;
  bool isImageDetailsLoading = false;
  String size = "0 MB";
  int height = 0;
  int width = 0;

  set setIsColorPaletteLoading(bool val) {
    isColorPaletteLoading = val;
    notifyListeners();
  }

  set setIsImageDetailsLoading(bool val) {
    isImageDetailsLoading = val;
    notifyListeners();
  }

  set setColorSwatches(List<Color> colors) {
    colorSwatch = colors;
    notifyListeners();
  }

  set setImgSize(String newSize) {
    size = newSize;
    notifyListeners();
  }

  void setImageResolution(int newHeight, int newWidth) {
    height = newHeight;
    width = newWidth;
    notifyListeners();
  }

  void getColorPalette(String url) async {
    setIsColorPaletteLoading = true;
    await Future.delayed(const Duration(seconds: 2));
    PaletteGenerator? paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      CachedNetworkImageProvider(url),
      maximumColorCount: 10,
    );
    setColorSwatches = paletteGenerator.colors.toList();
    setIsColorPaletteLoading = false;
  }

  void getWallDetails(String url) async {
    setIsImageDetailsLoading = true;
    setImgSize = "0 MB";
    setImageResolution(0, 0);
    await getImgDetails(url);
    setIsImageDetailsLoading = false;
  }

  Future getImgDetails(String url) async {
    final cache = DefaultCacheManager();
    final file = await cache.getSingleFile(url);
    final fileBytes = file.readAsBytesSync();
    setImgSize = formatBytes(fileBytes.lengthInBytes);

    var decodedImage = await decodeImageFromList(fileBytes);
    setImageResolution(decodedImage.height, decodedImage.width);
  }

  static String formatBytes(int bytes) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(2)} ${suffixes[i]}';
  }
}
