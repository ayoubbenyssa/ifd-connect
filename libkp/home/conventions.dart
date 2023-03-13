import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ifdconnect/models/sector.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/parc_events_stream/parc_events_stream.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/services/sector_services.dart';
import 'package:ifdconnect/teeeeest.dart';
import 'package:ifdconnect/widgets/fixdropdown.dart';
import 'package:ifdconnect/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Conventions extends StatefulWidget {
  Conventions(this.lat, this.lng, this.user, this.list_partner,this.analytics);

  var lat, lng;
  User user;
  List list_partner;
  var analytics;


  @override
  _ParcState createState() => _ParcState();
}

class _ParcState extends State<Conventions>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  bool _menuShown = false;

  List<Sector> _list = [];
  bool loading = false;

  String selectedValue = "";

  getSectors() async {
    List<Sector> sect = await SectorsServices.get_list_sectors();
    setState(() {
      _list = sect;
    });
  }

  @override
  initState() {
    super.initState();


    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    getSectors();
    display_slides();
  }

  Reload() {
    setState(() {
      loading = true;
    });
    new Timer(const Duration(seconds: 1), () {
      try {
        setState(() => loading = false);
      } catch (e) {
        e.toString();
      }
    });
  }



  Widget drop_down() => new Container(
      color: Fonts.col_app,
      width: 700.0,
      height: 60.0,
      child: Container(
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.only(left: 16.0, right: 8.0),
          decoration: new BoxDecoration(
            color: Fonts.col_app,
            border: new Border.all(color: Colors.white, width: 1.0),
            borderRadius: new BorderRadius.circular(2.0),
          ),
          child: new FixDropDown(
              iconSize: 32.0,
              isDense: false,
              items: _list.map((Sector value) {
                return new FixDropdownMenuItem(
                  value: value,
                  child: new Text(
                    value.name.toString(),
                    maxLines: 2,
                    softWrap: true,
                  ),
                );
              }).toList(),
              hint: new Text(
                selectedValue != "" ? selectedValue : "Secteur",
                maxLines: 1,
                softWrap: true,
                style: new TextStyle(color: Colors.white),
              ),
              onChanged: (Sector value) {
                setState(() {
                  selectedValue = value.nme;
                  Reload();
                });
              })));

  display_slides() async {
    //Restez informés sur  tout ce qui se passe au sein de votre communauté à travers l’actualité et les événements.
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString("con") != "con") {
      new Timer(new Duration(seconds: 1), () {
        setState(() {
          _menuShown = true;
        });

        prefs.setString("con", "con");
      });
    }
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

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Fonts.col_app,
          elevation: 0.0,
          title: Text('Conventions'),
        ),
        body: Stack(children: <Widget>[
          new Column(
            children: <Widget>[
              drop_down(),
              new Expanded(
                  child: loading
                      ? Center(
                      child:  Widgets.load())
                      : new StreamParcPub(
                          new Container(),
                          widget.lat,
                          widget.lng,
                          widget.user,
                          "1",
                          widget.list_partner,
                          widget.analytics,
                          sector: selectedValue,
                          category: "promotion",
                          favorite: false,
                          boutique: false,
                        ))
            ],
          ),

        ]));
  }
}
