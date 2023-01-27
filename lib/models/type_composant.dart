


import 'package:cloud_firestore/cloud_firestore.dart';

import 'composants.dart';

class Type_composant{

  var id;
  String name;

  List<Composants> composants ;



  Type_composant({
    this.id,
    this.name,
    this.composants

  });

  factory Type_composant.fromDoc(Map<String,dynamic> document) {
    return new  Type_composant(
        id: document["id"],
        name: document["name"],
        composants : document["composants"] == null?[]:(document["composants"] as List)
        .map((var element) => Composants.fromDoc(element))
        .toList()
    );
  }

}