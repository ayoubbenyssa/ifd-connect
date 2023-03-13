import 'package:flutter/material.dart';
class Matiers {
  var name;
  var id;

  Matiers({this.id, this.name});

  Matiers.fromMap(map)
      :
        name = map['name'].toString(),
        id = map['id'].toString();
}
