


import 'package:ifdconnect/models/user.dart';

class Cov {
  String id;
  String from_place;
  String to_place;
  String price;
  String date_cov;
  String nb_places;
  User user;
  var lat;
  var lng;
  var rate;
  var dis;




  Cov({
    this.id,
    this.from_place,
    this.to_place,
    this.price,
    this.date_cov,
    this.nb_places,
    this.user,
    this.lat,
    this.lng
  });



  Cov.fromMap(Map<String, dynamic> document)
      :
        id = document["objectId"].toString(),
        from_place = document["from_place"].toString(),
        to_place = document["to_place"].toString(),
        price = document["price"].toString(),
        nb_places = document["nb_places"].toString(),
        user = new User.fromMap(document["author"].toString()),
        date_cov = document["date_cov"].toString(),
        lat = document["lat"].toString(),
        rate = document["rate"].toString(),

      lng = document["lng"].toString();





}