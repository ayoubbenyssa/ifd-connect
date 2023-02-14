import 'package:flutter/material.dart';
import 'package:ifdconnect/models/offers.dart';

class Category {
  final String name;
  final IconData icon;

  Category(this.name, this.icon);

  @override
  String toString() {
    return 'Category{name: $name, icon: $icon}';
  }
}

class CategoryVideos {
  final String name;
  bool load;
  String name_ar;
  String objectId;
  List<Offers> videos;

  CategoryVideos(
      this.name, this.load, this.videos, this.objectId, this.name_ar);

  @override
  String toString() {
    return 'Category{name: $name}';
  }

  CategoryVideos.fromMap(map)
      : name = "${map['name']}",
        load = false,
        name_ar = map["name_ar"],
        objectId = "${map['objectId']}",
        videos = [];
}

class CategoryPreview {
  final String name;
  bool load;
  String name_ar;
  String objectId;
  List<dynamic> list;
  String type;

  CategoryPreview(this.name);

  @override
  String toString() {
    return 'Category{name: $name}';
  }

  CategoryPreview.fromMap(map)
      : name = "${map['name']}",
        load = false,
        type = map["type"],
        list = [];
}
