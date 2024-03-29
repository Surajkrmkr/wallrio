import 'package:flutter/material.dart';
import 'package:wallrio/services/packages/export.dart';

class ToastWidget {
  static void showToast(String msg) => Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0);
}
