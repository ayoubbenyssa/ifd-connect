import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/login/login.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/services/routes.dart';
import 'package:ifdconnect/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActiveWidget extends StatefulWidget {
  ActiveWidget();



  @override
  _InactiveWidgetState createState() => new _InactiveWidgetState();
}

class _InactiveWidgetState extends State<ActiveWidget> {
  bool loading = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  submit() {
    setState(() {
      loading = true;
    });
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  @override
  void initState() {
    super.initState();
  }

  ParseServer parse_s = new ParseServer();



  @override
  Widget build(BuildContext context) {
    var style = new TextStyle(
        color: const Color(0xffeff2f7),
        fontSize: 20.0,
        fontWeight: FontWeight.w500);

    var style2 = new TextStyle(
        color: Colors.grey[700], fontSize: 20.0, fontWeight: FontWeight.w500);



    return new Scaffold(
        key: _scaffoldKey,
        body: new Container(
          decoration: new BoxDecoration(
              color: Colors.grey[300],
              image: new DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter: new ColorFilter.mode(
                      Colors.grey.withOpacity(0.2), BlendMode.dstATop),
                  image: new AssetImage("images/bac.jpg"))),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // new Container(height:8.0),
              new Center(
                  child: new Image.asset(
                    "images/logo_last.png",
                    width: 100.0,
                    height: 100.0,
                  )),
              Container(
                height: 48.0,
              ),
              new Padding(
                  padding: EdgeInsets.all(12.0),
                  child: new Text(
                    "Votre compte a été désactivé ! ",
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                        color: Colors.grey[700], height: 1.2, fontSize: 18.0),
                  )),
              new Container(height: 50.0),
              !loading ? new Container() : Widgets.load(),


              //  new Center(child: ess),
            ],
          ),
        ));
  }
}
//Revenir en arrière
