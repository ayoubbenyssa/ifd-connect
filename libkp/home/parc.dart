import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/parc_events_stream/parc_events_stream.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/teeeeest.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Parc extends StatefulWidget {
  Parc(this.lat, this.lng, this.user, this.list_partner, this.auth,this.analytics);
  var lat, lng;
  User user;
  List list_partner;
  var auth;
  var analytics;


  @override
  _ParcState createState() => _ParcState();
}

class _ParcState extends State<Parc> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  bool _menuShown = false;

  display_slides() async {
    //Restez informés sur  tout ce qui se passe au sein de votre communauté à travers l’actualité et les événements.
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString("par") != "par") {
      new Timer(new Duration(seconds: 1), () {
        setState(() {
          _menuShown = true;
        });

        prefs.setString("par", "par");
      });
    }
  }

  @override
  void initState() {
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    // TODO: implement initState
    super.initState();
    display_slides();
  }

  onp() {
    setState(() {
      _menuShown = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Animation opacityAnimation =
        Tween(begin: 0.0, end: 1.0).animate(animationController);
    if (_menuShown)
      animationController.forward();
    else
      animationController.reverse();

    return Stack(
      children: <Widget>[
        DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                bottom: TabBar(
                  // isScrollable: true,
                  labelStyle: new TextStyle(color: Colors.blue),
                  indicatorPadding: new EdgeInsets.all(0.0),
                  tabs: [
                    new Tab(text: "Evénements"),
                    Tab(text: "Actualités"),
                  ],
                ),
                title: Text('Votre parc'),
              ),
              body: TabBarView(
                children: [
                  new StreamParcPub(
                    new Container(),
                    widget.lat,
                    widget.lng,
                    widget.user,
                    "1",
                    widget.list_partner,
                    widget.analytics,
                    category: "event",
                    cat: "Parc",
                    favorite: false,
                    boutique: false,
                    auth: widget.auth,
                  ),
                  new StreamParcPub(
                    new Container(),
                    widget.lat,
                    widget.lng,
                    widget.user,
                    "0",
                    widget.list_partner,
                    widget.analytics,
                    category: "news",
                    cat: "Parc",
                    favorite: false,
                    auth: widget.auth,
                    boutique: false,
                  )
                ],
              ),
            )),

      ],
    );
  }
}
