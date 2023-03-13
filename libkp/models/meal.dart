


import 'package:cloud_firestore/cloud_firestore.dart';

class Meal{

  var id;
  String name;
  bool isselected = false;



  Meal({
    this.id,
    this.name,

  });



  factory Meal.fromDoc(Map<String,dynamic> document) {
    return new Meal(
      id: document["meal"]["id"],
      name: document["meal"]["name"],



    );
  }

}