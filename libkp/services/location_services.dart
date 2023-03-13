import 'dart:async';

//import 'package:geolocation/geolocation.dart' as lo;
import 'package:location/location.dart';





class Location_service {

 static LocationData currentLocation ;
  static var location = new Location();


  static verify_location() async {
    //lo.GeolocationResult result = await lo.Geolocation.isLocationOperational();
    //if (result.isSuccessful) {
      return true;

  }


  static getLocation() async {

    currentLocation = await location.getLocation();
     var lat = currentLocation.latitude;
     var lng = currentLocation.longitude;

     return {
       "latitude":lat,
       "longitude":lng
     };
  }



}
