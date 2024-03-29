import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wallrio/model/export.dart';
import 'package:wallrio/services/packages/export.dart';

class ApiServices {
  static Future<WallRioModel> getData() async {
    final client = Dio();
    const url =
        'https://gitlab.com/teamshadowsupp/wallriojson/-/raw/main/rio.Json';

    try {
      final response = await client.get(url);

      if (response.statusCode == 200) {
        return WallRioModel.fromJson(json.decode(response.data));
      } else {
        return WallRioModel(walls: [])..error = "Something went wrong";
      }
    } catch (error) {
      debugPrint(error.toString());
      return WallRioModel(walls: [])..error = "Something went wrong";
    }
  }
}
