import 'package:ifdconnect/models/user.dart';

class Option {


  String id;
  String title;
  bool check = false;
  bool disactive = false;
  List<dynamic> users = [];

  var txt;

  Option(this.id, this.title);

  Option.fromMap(Map<String, dynamic> map)
      : id = map["objectId"],
        users = map["users"].toString() == "null"
            ? []
            : map["users"].map((val) => new User.fromMap(val)).toList(),
        title = map["title"];
}
