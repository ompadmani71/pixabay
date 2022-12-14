import 'dart:convert';

List<Images> imagesFromJson(String str) => List<Images>.from(json.decode(str).map((x) => Images.fromJson(x)));
List<Images> imagesFromJsonDB(String str) => List<Images>.from(json.decode(str).map((x) => Images.fromJsonDB(x)));
String imagesToJson(List<Images> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


class Images {
  Images({
    this.id,
    this.pageUrl,
    this.type,
    this.tags,
    this.image,
    this.views,
    this.likes,
    this.comments,
    this.user,
  });

  int? id;
  String? pageUrl;
  String? type;
  String? tags;
  String? image;
  int? views;
  int? likes;
  int? comments;
  String? user;

  factory Images.fromJson(Map<String, dynamic> json) => Images(
    id: json["id"],
    pageUrl: json["pageURL"],
    type: json["type"],
    tags: json["tags"],
    image: json["largeImageURL"],
    views: json["views"],
    likes: json["likes"],
    comments: json["comments"],
    user: json["user"],
  );
  factory Images.fromJsonDB(Map<String, dynamic> json) => Images(
    id: json["id"],
    pageUrl: json["pageURL"],
    type: json["type"],
    tags: json["tags"],
    image: json["image"],
    views: json["views"],
    likes: json["likes"],
    comments: json["comments"],
    user: json["user"],
  );
  Map<String, dynamic> toJson() => {
    "id": id,
    "pageURL": pageUrl,
    "type": type,
    "tags": tags,
    "image": image,
    "views": views,
    "likes": likes,
    "comments": comments,
    "user": user,
  };
}

