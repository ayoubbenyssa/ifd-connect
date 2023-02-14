import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:ifdconnect/app/filters_users_bloc/filter_bloc.dart';
import 'package:ifdconnect/app/filters_users_bloc/filter_event.dart';
import 'package:ifdconnect/app/filters_users_bloc/filter_state.dart';

import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/networking/user_item.dart';
import 'package:ifdconnect/services/Fonts.dart';

class FilterUsersByNearest extends StatefulWidget {
  FilterUsersByNearest(this.user);

  User user;

  @override
  _FilterUsersByNearesState createState() => _FilterUsersByNearesState();
}

class _FilterUsersByNearesState extends State<FilterUsersByNearest> {
  Position _currentPosition;
  String text_location = "";
  bool service_gps = false;
  bool show_button = false;
  var dialogOpen;
  bool show = false;
  double lat;
  double lng;

  //UserDataRepository userr_repos = UserDataRepository();
  FilterUsersBloc _filteBloc;
  Distance distance = new Distance();

  @override
  void initState() {
    super.initState();
    _checkGeolocationPermission();
  }

  // this also checks for location permission.
  Future<void> _initCurrentLocation() async {
    Position currentPosition;
    try {
      /* currentPosition = await Geolocator()
    .getCurrentPosition();*/

      Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low)
          .then((Position position) {
        currentPosition = position;

        setState(() => currentPosition = position);
        setState(() {
          lat = currentPosition.latitude;
          lng = currentPosition.longitude;

          show_button = false;
        });

        widget.user.lat = lat;
        widget.user.lng = lng;
        // userr_repos.update_locations(lat, lng);
        setState(() {
          show = false;
        });

        _filteBloc = BlocProvider.of<FilterUsersBloc>(context);
        _filteBloc.add(FilterUsersquested(type: "near", user: widget.user));
        //  d("position = $currentPosition");
      });
    } on PlatformException catch (e) {
      print(e.message);
      currentPosition = null;
    }

    if (!mounted) return;

    setState(() => _currentPosition = currentPosition);
  }

  Future _checkGeolocationPermission() async {
    bool service = await Geolocator.isLocationServiceEnabled();

    if (service == false) {
      setState(() {
        service_gps = false;

        text_location =
            "Pour identifier des membres prés de vous, veuillez autoriser l’accès à votre GPS";
      });
    } else {
      setState(() {
        service_gps = true;
      });

      LocationPermission geolocationStatus = await Geolocator.checkPermission();

      print("-kdkkdkd");
      print(geolocationStatus);
      if (geolocationStatus == LocationPermission.denied ||
          geolocationStatus == LocationPermission.deniedForever) {
        setState(() {
          show_button = true;
        });

        Geolocator.requestPermission();
      } else if (geolocationStatus == LocationPermission.whileInUse ||
          geolocationStatus == LocationPermission.always) {
        _initCurrentLocation();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0.0,
          title: Text(
            "Près de vous",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: service_gps == false
            ? Container(
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Autorisez l'accès aux services de localisation pour cette application à l'aide des paramètres de l'appareil.",
                      style: TextStyle(
                          color: Fonts.col_app_fon,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),
                  ],
                ))
            : show_button == true
                ? Container(
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.all(12),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              child: Text(
                            "Acceptez les permissions de localisation pour "
                            "cette application.",
                            style: TextStyle(
                                color: Fonts.col_app_fon,
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          )),
                          Container(
                            height: 16,
                          ),
                          RaisedButton(
                            color: Fonts.col_app_fon,
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.all(
                              Radius.circular(8.0),
                            )),
                            splashColor: Colors.grey,
                            elevation: 2,
                            child: Text(
                              "CONFIRMER",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            onPressed: () async {
                              await Geolocator.requestPermission();
                              // if( Geolocator.isLocationServiceEnabled()){
                              _initCurrentLocation();
                              // }
                            },
                          )
                        ]))
                : Container(
                    child: BlocBuilder<FilterUsersBloc, FilterUsersState>(
                        builder: (context, homeState) {
                      if (homeState is FilterUsersLoadInProgress) {
                        return Center(
                          child: Padding(
                              padding: EdgeInsets.only(top: 64),
                              child: CupertinoActivityIndicator()),
                        );
                      } else if (homeState is FilterUsersLoadSuccess) {
                        final users = homeState.calResponse.user;

                        print(users);
                        return (users.isEmpty)
                            ? Center(
                                child: Padding(
                                    padding: EdgeInsets.only(top: 64),
                                    child: Text("Aucun utilisateur trouvé !")),
                              )
                            : ListView(
                                children: users.map((e) {
                                if (e.lat == "0.0" ||
                                    e.lat.toString() == "null" ||
                                    e.lat.toString() == "")
                                  e.dis = "-.- Kms";
                                else {
                                  print("dugdudud");
                                  print(e.lat);
                                  print(e.lng);

                                  if (e.lat.toString() == "null" ||
                                      e.lat == "" ||
                                      lat == null|| e.lat.toString() == "0")
                                    e.dis = "-.- kms";
                                  else
                                    e.dis = distance
                                            .as(
                                                LengthUnit.Kilometer,
                                                new LatLng(double.parse(e.lat),
                                                    double.parse(e.lng)),
                                                new LatLng(lat, lng))
                                            .toString() +
                                        " Km(s)";
                                }
                                return UserItem(e, widget.user, "near");
                              }
                              ).toList());
                      } else {
                        return Container();
                      }
                    }),
                  ));
  }
}
