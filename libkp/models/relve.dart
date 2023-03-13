


import 'package:cloud_firestore/cloud_firestore.dart';

class Relve{

  var price;
  String day ;
  String operation_date;
  String mean ;
  String operation ;
  var amount ;
  bool check ;





  void fromDoc(Map<String,dynamic> document) {

      price =  document["price"] ;
      operation_date = document["operation_date"];
      day = document["day"];
      mean =  document["mean"];
      operation = document["operation"];
      check  = false ;
      amount = document["amount"];


  }

}