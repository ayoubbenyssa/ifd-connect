

import 'package:firebase_database/firebase_database.dart';
import 'package:ifdconnect/func/parsefunc.dart';

class Block {

  static ParseServer parse_s = new ParseServer();



  static insert_block(my_id, id_other,my_objectId,his_objectId)  async{


    parse_s.postparse('block', {
      "userS": my_id,
      "blockedS": id_other,
      "blockedd": {
        "__type": "Pointer",
        "className": "users",
        "objectId": my_objectId
      },
      "userd": {
        "__type": "Pointer",
        "className": "users",
        "objectId": his_objectId
      }
    });

    FirebaseDatabase.instance
        .reference()
        .child("room_medz")
        .child(my_id+"_"+id_other)
        .remove();

    FirebaseDatabase.instance
        .reference()
        .child("room_medz")
        .child(id_other+"_"+my_id)
        .remove();
  }


}