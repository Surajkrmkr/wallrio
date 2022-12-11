// class WallRioModel {
//   List<Walls> walls = <Walls>[];
//   String error = "";

//   WallRioModel({required this.walls});

//   WallRioModel.fromJson(Map<String, dynamic> json) {
//     if (json['walls'] != null) {
//       json['walls'].forEach((v) {
//         walls.add(Walls.fromJson(v));
//       });
//     }
//   }
// }

// class Walls {
//   int? id;
//   String? name;
//   String? author;
//   String? url;
//   String? thumbnail;
//   List<String>? tags;
//   String? category;
//   List<String>? color;

//   Walls(
//       {this.id,
//       this.name,
//       this.author,
//       this.url,
//       this.thumbnail,
//       this.tags,
//       this.category,
//       this.color});

//   Walls.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     author = json['author'];
//     url = json['url'];
//     thumbnail = json['thumbnail'];
//     tags = json['tags'].cast<String>();
//     category = json['category'];
//     color = json['color'].cast<String>();
//   }
// }


class WallRioModel {
  List<Walls>? walls;
  String error = "";

  WallRioModel({this.walls});

  WallRioModel.fromJson(Map<String, dynamic> json) {
    if (json['walls'] != null) {
      walls = <Walls>[];
      json['walls'].forEach((v) {
        walls!.add(Walls.fromJson(v));
      });
    }
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
