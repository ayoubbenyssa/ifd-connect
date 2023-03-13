


import 'package:cloud_firestore/cloud_firestore.dart';

class Objectif{

  String id;
  String name;
  String img;
  bool isselected = false;



  Objectif({
    this.id,
    this.name,
    this.img

  });



  factory Objectif.fromDoc(Map<String,dynamic> document) {
    return new Objectif(
      //id: document.documentID,
      name: document["name"],
      img: document["picture"],



    );
  }

}