import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wallrio/log.dart';

import '../model/user_profile_model.dart';
import '../model/wall_rio_model.dart';
import '../ui/widgets/toast_widget.dart';

class FavouriteProvider extends ChangeNotifier {
  // Map<String, dynamic> favJson = {"walls": []};
  List<Walls> wallList = [];
  final String favouriteFirebasePath = "favourite";
  final String favouriteItemsFirebasePath = "favouriteItems";

  bool isLoading = false;

  set setIsLoading(bool val) {
    isLoading = val;
    notifyListeners();
  }

  set setWallToList(List<Walls> walls) {
    wallList = walls;
    notifyListeners();
  }

  set addWallToList(Walls wall) {
    wallList.add(wall);
    notifyListeners();
  }

  set removeWallFromList(int id) {
    wallList.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  void addToFav({required Walls wall}) async {
    final bool isAdded = await saveToFirebase(wall: wall);
    if (isAdded) {
      addWallToList = wall;
      ToastWidget.showToast("Added to Favourite");
    } else {
      ToastWidget.showToast("Some error occured!");
    }
  }

  void removeFromFav({required int id}) async {
    final bool isRemoved = await removeFromFirebase(id: id);
    if (isRemoved) {
      removeWallFromList = id;
      ToastWidget.showToast("Removed from Favourite");
    } else {
      ToastWidget.showToast("Some error occured!");
    }
  }

  bool isSelectedAsFav(String url) {
    final bool isFav = wallList.where((wall) => wall.url == url).isNotEmpty;
    return isFav;
  }

  void getDir() async {
    setIsLoading = true;
    final DocumentReference<Map<String, dynamic>> favourite = FirebaseFirestore
        .instance
        .collection(favouriteFirebasePath)
        .doc(UserProfile.email);
    final QuerySnapshot<Map<String, dynamic>> querySnapshot = await favourite
        .collection(favouriteItemsFirebasePath)
        .orderBy('createdAt', descending: false)
        .get();
    final List<QueryDocumentSnapshot<Map<String, dynamic>>> list =
        querySnapshot.docs;
    final Map<String, dynamic> favJson = {
      "walls": list.map((e) => e.data()).toList()
    };

    setWallToList = WallRioModel.fromJson(favJson).walls;
    setIsLoading = false;
  }

  Future<bool> saveToFirebase({required Walls wall}) async {
    bool isSuccessfullyAdded = false;
    try {
      final DocumentReference<Map<String, dynamic>> favouriteDocument =
          FirebaseFirestore.instance
              .collection(favouriteFirebasePath)
              .doc(UserProfile.email);
      await favouriteDocument
          .collection(favouriteItemsFirebasePath)
          .doc(wall.id.toString())
          .set({...Walls.toJson(wall), "createdAt": Timestamp.now()});
      isSuccessfullyAdded = true;
    } catch (error) {
      logger.e(error);
    }
    return isSuccessfullyAdded;
  }

  Future<bool> removeFromFirebase({required int id}) async {
    bool isSuccessfullyRemoved = false;
    try {
      final DocumentReference<Map<String, dynamic>> favouriteDocument =
          FirebaseFirestore.instance
              .collection(favouriteFirebasePath)
              .doc(UserProfile.email);
      await favouriteDocument
          .collection(favouriteItemsFirebasePath)
          .doc(id.toString())
          .delete();
      isSuccessfullyRemoved = true;
    } catch (error) {
      logger.e(error);
    }
    return isSuccessfullyRemoved;
  }
}
