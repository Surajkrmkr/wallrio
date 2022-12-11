import 'package:flutter/material.dart';
import 'package:wallrio/model/wall_rio_model.dart';
import 'package:wallrio/services/api_services.dart';

class WallRio extends ChangeNotifier {
  List<Walls> wallList = [];
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

  getListFromAPI() async {
    setIsLoading = true;
    WallRioModel model = await ApiServices.getData();
    model.error.isEmpty ? setWallList = model.walls! : setError = model.error;
    setIsLoading = false;
  }
}
