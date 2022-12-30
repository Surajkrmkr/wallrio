class WallRioModel {
  List<Banners>? banners;
  List<Walls>? walls;
  String error = "";

  WallRioModel({this.banners, this.walls});

  WallRioModel.fromJson(Map<String, dynamic> json) {
    if (json['banners'] != null) {
      banners = <Banners>[];
      json['banners'].forEach((v) {
        banners!.add(Banners.fromJson(v));
      });
    }
    if (json['walls'] != null) {
      walls = <Walls>[];
      json['walls'].forEach((v) {
        walls!.add(Walls.fromJson(v));
      });
    }
  }
}

class Banners {
  int? id;
  String? url;
  String? category;
  String? link;

  Banners({this.id, this.url, this.category, this.link});

  Banners.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    category = json['category'];
    link = json['link'];
  }
}

class Walls {
  int? id;
  String? name;
  String? author;
  String? url;
  String? thumbnail;
  List<String>? tags;
  String? category;
  List<String>? color;

  Walls(
      {this.id,
      this.name,
      this.author,
      this.url,
      this.thumbnail,
      this.tags,
      this.category,
      this.color});

  Walls.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    author = json['author'];
    url = json['url'];
    thumbnail = json['thumbnail'];
    tags = json['tags'].cast<String>();
    category = json['category'];
    color = json['color'].cast<String>();
  }
}
