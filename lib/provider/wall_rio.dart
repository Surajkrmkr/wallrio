import 'package:flutter/material.dart';
import 'package:wallrio/model/wall_rio_model.dart';
import 'package:wallrio/services/api_services.dart';

class WallRio extends ChangeNotifier {
  List<Walls> wallList = [];
  Map<String, List<Walls?>>? categories = <String, List<Walls?>>{};

  String error = "";
  bool isLoading = false;

  set setIsLoading(bool val) {
    isLoading = val;
    notifyListeners();
  }

  set setWallList(List<Walls> list) {
    wallList = list;
    notifyListeners();
  }

  set setError(String msg) {
    error = msg;
    notifyListeners();
  }

  WallRio() {
    getListFromAPI();
  }

  void getListFromAPI() async {
    setIsLoading = true;
    setWallList = [];
    WallRioModel model = await ApiServices.getData();
    if (model.error.isEmpty) {
      setWallList = model.walls!;
      _buildCategoryWalls();
    } else {
      setError = model.error;
    }
    await Future.delayed(const Duration(seconds: 2));
    setIsLoading = false;
  }

  void _buildCategoryWalls() {
    categories!.clear();
    for (Walls? wall in wallList) {
      if (!categories!.containsKey(wall!.category!)) {
        categories![wall.category!] = [];
      }
      categories![wall.category!]!.add(wall);
    }
    notifyListeners();
  }
}
