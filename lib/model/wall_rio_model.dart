import 'package:flutter/material.dart';
import 'package:wallrio/services/export.dart';

class WallRioModel {
  final List<Banners> banners;
  final List<Walls> walls;
  String error = "";

  WallRioModel({this.banners = const [], this.walls = const []});

  factory WallRioModel.fromJson(Map<String, dynamic> json) => WallRioModel(
      banners: json['banners'] == null
          ? []
          : (json['banners'] as List<dynamic>)
              .map((v) => Banners.fromJson(v))
              .toList(),
      walls: json['walls'] == null
          ? []
          : (json['walls'] as List<dynamic>)
              .map((v) => Walls.fromJson(v))
              .toList());
}

class Banners {
  final int id;
  final String url;
  final String category;
  final String link;

  Banners(
      {required this.id,
      required this.url,
      required this.category,
      required this.link});

  factory Banners.fromJson(Map<String, dynamic> json) => Banners(
        id: json['id'] ?? 0,
        url: json['url'] ?? "",
        category: json['category'] ?? "",
        link: json['link'] ?? "",
      );
}

class Walls {
  final int id;
  final String name;
  final String author;
  final String url;
  final String thumbnail;
  final List<String> tags;
  final String category;
  final List<String> colorsString;
  final List<Color> colorList;

  Walls(
      {required this.id,
      required this.name,
      required this.author,
      required this.url,
      required this.thumbnail,
      required this.tags,
      required this.category,
      required this.colorsString,
      required this.colorList});

  factory Walls.fromJson(Map<String, dynamic> json) => Walls(
        id: json['id'] ?? 0,
        name: json['name'] ?? "",
        author: json['author'] ?? "",
        url: json['url'] ?? "",
        thumbnail: json['thumbnail'] ?? "",
        tags: json['tags'] != null ? json['tags'].cast<String>() : [],
        category: json['category'] ?? "",
        colorsString: json['color'] != null ? json['color'].cast<String>() : [],
        colorList: json['color'] != null
            ? (json['color'] as List<dynamic>)
                .map((color) => color.toString().toLowerCase().toColor())
                .toList()
            : [Colors.black],
      );

  static Map<String, dynamic> toJson(Walls wall) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = wall.id;
    data['name'] = wall.name;
    data['author'] = wall.author;
    data['url'] = wall.url;
    data['thumbnail'] = wall.thumbnail;
    data['tags'] = wall.tags;
    data['category'] = wall.category;
    data['color'] = wall.colorsString;
    return data;
  }
}
