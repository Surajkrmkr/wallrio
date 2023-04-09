import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

import '../model/wall_rio_model.dart';
import '../ui/widgets/toast_widget.dart';

class FavouriteProvider extends ChangeNotifier {
  Map<String, dynamic> favJson = {"walls": []};
  List<Walls> wallList = [];
  String jsonPath = "";

  bool isLoading = false;

  set setIsLoading(bool val) {
    isLoading = val;
    notifyListeners();
  }

  FavouriteProvider() {
    getDir();
  }

  set setWallList(List<Walls> list) {
    wallList = list;
    notifyListeners();
  }

  void addToFav(Walls wall) {
    final obj = Walls.toJson(wall);
    favJson["walls"]!.add(obj);
    saveJson();
    setWallList = WallRioModel.fromJson(favJson).walls;
    ToastWidget.showToast("Added to Favourite");
  }

  void removeFromFav(String url) {
    favJson["walls"]!.removeWhere((wall) => wall["url"] == url);
    saveJson();
    setWallList = WallRioModel.fromJson(favJson).walls;
    ToastWidget.showToast("Removed from Favourite");
  }

  bool isSelectedAsFav(String url) {
    final bool isFav = wallList.where((wall) => wall.url == url).isNotEmpty;
    return isFav;
  }

  void getDir() async {
    setIsLoading = true;
    final Directory downloadDir = await getTemporaryDirectory();
    jsonPath = downloadDir.path;
    final file = File("$jsonPath//fav.json");
    final bool isExist = await file.exists();
    if (!isExist) {
      await file.create();
      await file.writeAsString('{"walls": []}');
    }
    final jsonText = await file.readAsString();
    favJson = json.decode(jsonText);
    setWallList = WallRioModel.fromJson(favJson).walls;
    setIsLoading = false;
  }

  void saveJson() async {
    final Directory downloadDir = await getTemporaryDirectory();
    jsonPath = downloadDir.path;
    final file = File("$jsonPath//fav.json");
    await file.writeAsString(json.encode(favJson));
  }
}
