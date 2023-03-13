


import 'package:cloud_firestore/cloud_firestore.dart';

import 'composants.dart';

class Type_composant{

  var id;
  String name;

  List<Composants> composants ;
  String composant_choisi ;
  static int i=0;


  Type_composant({
    this.id,
    this.name,
    this.composants,
    this.composant_choisi

  });

  factory Type_composant.fromDoc(Map<String,dynamic> document) {
    if(document["composants"] == null) {
      document["composant"][0]["id"]=i;
      i++;
    }
    return new  Type_composant(
        id: document["id"],
        name: document["name"],
        composant_choisi: document["composants"] == null? document["composant"][0]['id'].toString(): document["composants"][0]['id'].toString(),
        composants : document["composants"] == null
            ?(document["composant"] as List)
            .map((var element) => Composants.fromDoc(element))
            .toList()
            :(document["composants"] as List)
        .map((var element) => Composants.fromDoc(element))
        .toList(),
    );
  }

}