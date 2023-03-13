import 'package:ifdconnect/models/offers.dart';

class Favorite {


  String id;
  Offers offer;

  Favorite({this.id, this.offer});

  Favorite.fromMap(Map<String, dynamic> map)
      : id = map["objectId"],
        offer = Offers.fromMap(map["post"]);
}
