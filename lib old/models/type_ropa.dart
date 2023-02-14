


import 'package:cloud_firestore/cloud_firestore.dart';

class Type_repas{

  var price;
  var id ;
  String name;
  bool check ;


  Type_repas({
    this.price,
    this.name,
    this.id,
    this.check
  }
  );



  factory Type_repas.fromDoc(Map<String,dynamic> document) {
    return new  Type_repas(
      price: document["price"],
      name: document["name"],
      id: document["id"],
      check : false ,

    );
  }

}