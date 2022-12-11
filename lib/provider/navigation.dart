import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Navigation extends ChangeNotifier {
  int index = 0;
  final ScrollController controller = ScrollController();
  bool visible = true;

  set setIndex(int val) {
    index = val;
    notifyListeners();
  }

  set setVisible(bool val) {
    visible = val;
    notifyListeners();
  }

  Navigation() {
    hideNavbar();
  }

  void hideNavbar() {
    setVisible = true;
    controller.addListener(
      () {
        if (controller.position.userScrollDirection ==
            ScrollDirection.reverse) {
          if (visible) {
            setVisible = false;
          }
        }

        if (controller.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (!visible) {
            setVisible = true;
          }
        }
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
