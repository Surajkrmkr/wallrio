import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:wallrio/model/wall_rio_model.dart';
import 'package:wallrio/services/api_services.dart';

import '../model/tag_model.dart';
import '../ui/widgets/user_bottom_sheet.dart';

class WallRio extends ChangeNotifier {
  List<Walls> originalWallList = [];
  List<Walls> actionWallList = [];
  List<Banners> bannerList = [];
  AppDetails details = const AppDetails();

  Map<String, List<Walls?>>? categories = <String, List<Walls?>>{};
  Tag tag = Tag(selectedTags: [], unSelectedTags: []);

  String error = "";
  String currentVersion = "1.0.0";
  bool isLoading = false;
  bool isUpdateAvailable = false;

  set setIsLoading(bool val) {
    isLoading = val;
    notifyListeners();
  }

  set setIsUpdateAvailable(bool val) {
    isUpdateAvailable = val;
    notifyListeners();
  }

  set setCurrentVersion(String version) {
    currentVersion = version;
    notifyListeners();
  }

  set setWallList(List<Walls> list) {
    originalWallList = list;
    notifyListeners();
  }

  set setBannerList(List<Banners> list) {
    bannerList = list;
    notifyListeners();
  }

  set setActionWallList(List<Walls> list) {
    actionWallList = list;
    notifyListeners();
  }

  set setAppDetails(AppDetails appDetails) {
    details = appDetails;
    notifyListeners();
  }

  set setError(String msg) {
    error = msg;
    notifyListeners();
  }

  void clearSelectedTags() {
    for (String eachTag in tag.selectedTags) {
      tag.unSelectedTags.insert(0, eachTag);
    }
    tag.selectedTags.clear();
    notifyListeners();
  }

  WallRio() {
    // getListFromAPI();
  }

  Future<void> getCurrentVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final String version = packageInfo.version;
    setCurrentVersion = version;
  }

  void checkUpdate(context) {
    final int currentVersionInInt =
        int.parse(currentVersion.replaceAll(".", ""));
    final int latestVersionInInt =
        int.parse(details.version.replaceAll(".", ""));
    if (currentVersionInInt < latestVersionInInt) {
      setIsUpdateAvailable = true;
    }
    if (isUpdateAvailable) {
      UserBottomSheet.changeLog(context);
    }
  }

  void getListFromAPI(context) async {
    setIsLoading = true;
    await getCurrentVersion();
    setWallList = [];
    setActionWallList = [];
    setBannerList = [];
    WallRioModel model = await ApiServices.getData();
    if (model.error.isEmpty) {
      setWallList = model.walls;
      setActionWallList = model.walls;
      setBannerList = model.banners;
      setAppDetails = model.appDetails;
      checkUpdate(context);
      _buildCategoryAndTags();
    } else {
      setError = model.error;
    }
    await Future.delayed(const Duration(seconds: 2));
    setIsLoading = false;
  }

  void _buildCategoryAndTags() {
    categories!.clear();
    tag.selectedTags.clear();
    tag.unSelectedTags.clear();
    for (Walls? wall in originalWallList) {
      if (!categories!.containsKey(wall!.category)) {
        categories![wall.category] =
            []; // Initiating a Empty list of a category
      }
      for (String? eachTag in wall.tags) {
        if (!tag.unSelectedTags.contains(eachTag)) {
          tag.unSelectedTags.add(eachTag!); // Adding a tag to TagList
        }
      }
      categories![wall.category]!.add(wall); // Adding a Wall to CategoryList
    }
    notifyListeners();
  }

  bool getTagIsSelected(String tagName) {
    return tag.unSelectedTags.contains(tagName) ? false : true;
  }

  void onSelectedTag(String selectedTag) {
    if (tag.unSelectedTags.contains(selectedTag)) {
      tag.unSelectedTags.remove(selectedTag);
      tag.selectedTags.add(selectedTag);
    } else {
      tag.selectedTags.remove(selectedTag);
      tag.unSelectedTags.insert(0, selectedTag);
    }

    setActionWallList = getFilteredWallList();
    notifyListeners();
  }

  List<Walls> getFilteredWallList() {
    List<Walls> wall = [];
    if (tag.selectedTags.isEmpty) {
      return originalWallList;
    }
    for (String tag in tag.selectedTags) {
      final eachTagwall =
          originalWallList.where((wall) => wall.tags.contains(tag)).toList();
      wall.insertAll(0, eachTagwall);
    }
    return wall;
  }

  void onSearchTap(String query) {
    if (query.isNotEmpty) {
      setActionWallList = originalWallList
          .where(
              (wall) => wall.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      setActionWallList = originalWallList;
    }
  }

  void resetToDefault() {
    setActionWallList = originalWallList;
    clearSelectedTags();
  }
}
