import 'package:intl/intl.dart';


class Album {

  String name;
  String objectId;

  Album({
    this.name, this.objectId
  });

  factory Album.fromMap(Map<String, dynamic> map){
    return new Album(
        name: map["name"],
        objectId: map["objectId"]
    );
  }

}

class Gallery {
  String id;
  List<String> pic;
  String title;
  String date;

  Gallery({this.id, this.pic, this.date, this.title});

  factory Gallery.fromDoc(Map<String, dynamic> document) {
    return new Gallery(
        id: document["objectId"],
        pic: List<String>.from(document["pics"]),
        title: document["title"],
        date: document["date"]);
  }
}
