import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:ifdconnect/chat/chatscreen.dart';
import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/login/login_w.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/services/connect.dart';
import 'package:ifdconnect/swiper_new/user_widget.dart';
import 'package:ifdconnect/widgets/bottom_menu.dart';
import 'package:ifdconnect/widgets/widgets.dart';
import 'package:flutter/services.dart';

class Invite_view extends StatefulWidget {
  Invite_view(
      this.id,
      this.id_notification,
      this.my_id,
      this.user_me,
      this.go,
      this.delete,
      this.auth,
      this.sign,
      this.list_partner,
      this.user_other,
      this.load_func,
      this.analytics,
      );

  String id;
  bool go;
  String id_notification;
  String my_id;
  User user_me;
  var delete;
  var auth;
  var sign;
  var list_partner;
  User user_other;
  var analytics;

  //load partner list again
  var load_func;

  @override
  _Invite_viewState createState() => _Invite_viewState();
}

class _Invite_viewState extends State<Invite_view> {
  bool loading = true;
  User user = new User();
  ParseServer parse_s = new ParseServer();
  bool stop = false;

  Distance distance = new Distance();

  var _controller = new SwiperController();
  var lat = 0.0;
  var lng = 0.0;
  bool show_page = false;
  var currentLocation = <String, double>{};
  var location = new Location();

  String id_connect = "";

  User aa = new User();

  getUserInfo() async {



    if (widget.id_notification.toString() == "null") {
      QuerySnapshot res = await Firestore.instance
          .collection('user_notifications')
          .document(widget.my_id)
          .collection("Notifications")
          .where("id_user", isEqualTo: widget.user_other.auth_id)
          .getDocuments();

      widget.id_notification = res.documents[0].documentID;


    }
    Firestore.instance
        .collection('user_notifications')
        .document(widget.my_id)
        .collection("Notifications")
        .document(widget.id_notification)
        .updateData({"read": true});

    String id = widget.id;

    /* currentLocation = await location.getLocation();

      lat = currentLocation["latitude"];
      lng = currentLocation["longitude"];*/


    if (widget.user_other.toString() != "null") {
      if (widget.go) {
        var response1 = await Connect.get_request_user(
            widget.user_me.id, widget.user_other.id);

        id_connect = response1[0].objectId;
      } else {
        var response1 = await Connect.get_request_user2(
            widget.user_me.id, widget.user_other.id);

        id_connect = response1[0].objectId;
      }
      setState(() {

        user = widget.user_other;
        user.block = false;


        if(user.lat.toString()== "")
        {
          user.dis = "-.- Kms";
        }
        else
        {
          user.dis = distance
              .as(
              LengthUnit.Kilometer,
              new LatLng(double.parse(user.lat), double.parse(user.lng)),
              new LatLng(lat, lng))
              .toString() +
              " Kms";
        }


        loading = false;
      });
    } else {
      var response = await parse_s.getparse('users?where={"id1":"$id"}&include=user_formations,role');
      aa = new User.fromMap(response["results"][0]);


      /*var response1 =
            await Connect.get_request_user(widget.user_me.id, aa.id);*/
      //  print(response1);

      //pour modifier accepted=true
      // id_connect = aa.id;



      if (!this.mounted) return;

      setState(() {
        user = new User.fromMap(response["results"][0]);
        user.block = false;
        user.dis = distance
            .as(
            LengthUnit.Kilometer,
            new LatLng(double.parse(user.lat), double.parse(user.lng)),
            new LatLng(lat, lng))
            .toString() +
            " Kms" ;

        loading = false;
      });
    }
  }

  @override
  void initState() {
    getUserInfo();

    super.initState();
  }

  String getKey() => widget.my_id + "_" + widget.id;

  String getKey1() => widget.id + "_" + widget.my_id;

  void onLoading(context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => new Dialog(
          child: new Container(
            padding: new EdgeInsets.all(16.0),
            width: 40.0,
            color: Colors.transparent,
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                new RefreshProgressIndicator(),
                new Container(height: 8.0),
                new Text(
                  "En cours ..",
                  style: new TextStyle(color: Fonts.col_app_fon),
                ),
              ],
            ),
          ),
        ));
  }

  confirmer() async {


    if (widget.user_other.toString() == "null") {
      var response1 = await Connect.get_request_user(widget.user_me.id, aa.id);
      id_connect = response1[0].objectId;

    }

    onLoading(context);

    Firestore.instance
        .collection('user_notifications')
        .document(widget.my_id)
        .collection("Notifications")
        .document(widget.id_notification)
        .updateData({"accept": true});

    DatabaseReference gMessagesDbRef2 = FirebaseDatabase.instance
        .reference()
        .child("room_medz")
        .child(getKey());
    gMessagesDbRef2.set({
      "token": widget.user_me.token,
      "name": widget.user_me.firstname + " " + widget.user_me.fullname,
      widget.my_id: true,
      "lastmessage": "Aucun message",
      "me":false,
      "key": getKey(),
      "timestamp": ServerValue.timestamp /*new DateTime.now().toString()*/,
    });

    FirebaseDatabase.instance
        .reference()
        .child("room_medz")
        .child(getKey1())
        .set({
      "token": user.token,
      "me":false,

      widget.id: true,
      "lastmessage": "Aucun message",
      "key": getKey1(),
      "timestamp": ServerValue.timestamp /*new DateTime.now().toString()*/,
    });

    await Firestore.instance
        .collection('user_notifications')
        .document(widget.my_id)
        .collection("Notifications")
        .document(widget.id_notification)
        .delete();

    await Firestore.instance
        .collection('user_notifications')
        .document(user.auth_id)
        .collection("Notifications")
        .add({
      "id_user": widget.my_id,
      "other_user": user.auth_id,
      "time": new DateTime.now().millisecondsSinceEpoch,
      "read": false,
      "type": "accept"
    });
    await Connect.update_request(id_connect);
    await Connect.inser_request(widget.user_me.id, user.id, true);

    /* Routes.goto_home(context, widget.auth, widget.sign, widget.user_me,
        widget.analytics, widget.observer, widget.list_partner);*/

    Navigator.pop(context);

    setState(() {
      show_page = true;
    });
  }

  rel() {}

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: new AppBar(
          iconTheme: IconThemeData(color: Fonts.col_app),
          backgroundColor: Colors.white,
          title: new Text(""),
          elevation: 0.0,
        ),
        body: Container(
          child: new Stack(fit: StackFit.expand, children: <Widget>[
            Column(children: <Widget>[
              new AppBar(
                backgroundColor: Colors.white,
                title: new Text(""),
                elevation: 0.0,
              ),
            ]),
            new Container(
                child: loading
                    ?
                Widgets.load()
                    : new Stack(fit: StackFit.expand, children: <Widget>[
                  new Container(
                      padding: new EdgeInsets.only(
                          top: 0.0,
                          left: 16.0,
                          right: 16.0,
                          bottom: 64.0),
                      child: new Card(
                          child: new UserWidget(
                              user,
                              widget.my_id,
                              lat,
                              lng,
                              _controller,
                              widget.my_id,
                              widget.user_me,
                              widget.list_partner,
                              widget.analytics,
                              ))),
                  new Positioned(
                    bottom: 12.0,
                    left: 8.0,
                    right: 8.0,
                    child: new Center(
                      //alignment: Alignment.center,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new FlatButton(
                                padding: new EdgeInsets.all(0.0),
                                onPressed: () {
                                  Navigator.of(context).pop(true);

                                  /* setState(() {
                                  show_page = true;
                                });*/
                                },
                                child: new Container(
                                  height: 40.0,
                                  width: 130.0,
                                  alignment: Alignment.center,
                                  decoration: new BoxDecoration(
                                    boxShadow: [
                                      new BoxShadow(
                                        color: Colors.grey[200],
                                        offset: new Offset(0.0, 0.0),
                                        blurRadius: 9.0,
                                      ),
                                    ],
                                    border: new Border.all(
                                        color: Fonts.col_app, width: 1.5),
                                    color: Colors.redAccent[50],
                                    borderRadius:
                                    new BorderRadius.circular(8.0),
                                  ),
                                  child: new Text(
                                    "RETOURNER",
                                    style: new TextStyle(
                                        color: Fonts.col_app,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15.0),
                                  ),
                                )),
                            new Container(width: 12.0),
                            new FlatButton(
                                padding: new EdgeInsets.all(0.0),
                                onPressed: () {
                                  if (widget.go) {

                                    if (widget.load_func.toString() !=
                                        "null") {
                                      widget.load_func();
                                    }

                                    confirmer();
                                    var gMessagesDbRef3 = FirebaseDatabase
                                        .instance
                                        .reference()
                                        .child("notif_new");
                                    gMessagesDbRef3.update({widget.id: true});
                                  } else {
                                    //widget.load_func();

                                    Navigator.push(context,
                                        new MaterialPageRoute(
                                            builder: (BuildContext context) {
                                              return new ChatScreen(
                                                widget.user_me.auth_id,
                                                user.auth_id,
                                                widget.list_partner,
                                                true,
                                                widget.auth,
                                                widget.analytics,

                                                user: widget.user_me,
                                                reload: rel(),
                                              );
                                            }));
                                  }
                                },
                                child: new Container(
                                  height: 40.0,
                                  width: 130.0,
                                  alignment: Alignment.center,
                                  decoration: new BoxDecoration(
                                    boxShadow: [
                                      new BoxShadow(
                                        color: Colors.grey[200],
                                        offset: new Offset(0.0, 0.0),
                                        blurRadius: 4.0,
                                      ),
                                    ],
                                    color: const Color(0xff00cc00),
                                    border: new Border.all(
                                        color: Colors.pink[50], width: 1.5),
                                    borderRadius:
                                    new BorderRadius.circular(8.0),
                                  ),
                                  child: new Text(
                                    widget.go
                                        ? "ACCEPTER"
                                        : "MESSAGE",
                                    style: new TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ))
                          ],
                        )), /*new RaisedButton(child: new Text("jdjdjd"),
        onPressed: (){
          print(_currentIndex);
        },)*/
                  )
                ])),
            show_page == false
                ? new Container()
                : new Container(
                child: new BackdropFilter(
                  filter: new ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                  child: new Container(
                      decoration: new BoxDecoration(
                          color: Fonts.col_app_fon.withOpacity(0.5)),
                      width: width,
                      height: height,
                      child: new Column(
                        children: <Widget>[
                          new Container(
                            height: 42.0,
                          ),
                          new Center(
                              child: new Container(
                                  child: new Text(
                                    "Nouveau contact",
                                    style: new TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 26.0,
                                        fontWeight: FontWeight.w900),
                                  ))),
                          new Container(height: 24.0),
                          new Center(
                              child: new Container(
                                  padding: new EdgeInsets.all(12.0),
                                  child: new Text(
                                    user.firstname +
                                        "  " +
                                        user.fullname +
                                        "  " +
                                        "voudrait se connecter a vous",
                                    style: new TextStyle(
                                        color: Colors.white, fontSize: 19.0),
                                  ))),
                          new Container(height: 36.0),
                          new Expanded(
                              child: new Stack(
                                children: <Widget>[
                                  new Positioned(
                                      left: width / 4,
                                      child: new ClipOval(
                                          child: new Container(
                                              color: Fonts.col_app,
                                              width: 100.0,
                                              height: 100.0,
                                              child: new Center(
                                                  child: Image.network(
                                                    user.image,
                                                    fit: BoxFit.cover,
                                                    width: 100.0,
                                                    height: 100.0,
                                                  ))))),
                                  new Positioned(
                                      right: width / 4,
                                      child: new ClipOval(
                                          child: new Container(
                                              color: Fonts.col_app,
                                              width: 100.0,
                                              height: 100.0,
                                              child: new Center(
                                                  child: Image.network(
                                                    widget.user_me.image,
                                                    fit: BoxFit.cover,
                                                    width: 100.0,
                                                    height: 100.0,
                                                  ))))),
                                  new Center(
                                      child: new Container(
                                          padding: new EdgeInsets.only(
                                              top: 0.0, bottom: 24.0),
                                          child: new Text(
                                            "Est ce que vous voulez Communiquer ?",
                                            style: new TextStyle(
                                                color: Colors.white,
                                                fontSize: 20.0),
                                          ))),
                                  new Center(
                                      child: new Container(
                                          alignment: Alignment.center,
                                          padding: new EdgeInsets.only(top: 92.0),
                                          child: new Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: <Widget>[
                                              new FlatButton(
                                                  padding:
                                                  new EdgeInsets.all(0.0),
                                                  onPressed: () {
                                                    setState(() {
                                                      show_page = false;
                                                    });

                                                    Navigator.push(context,
                                                        new MaterialPageRoute(
                                                            builder: (BuildContext
                                                            context) {
                                                              return new ChatScreen(
                                                                  widget.user_me.auth_id,
                                                                  widget.id,
                                                                  widget.list_partner,
                                                                  true,
                                                                  widget.auth,
                                                                  widget.analytics,
                                                                  user: widget.user_me);
                                                            }));
                                                  },
                                                  child: new Container(
                                                    height: 40.0,
                                                    width: 130.0,
                                                    alignment: Alignment.center,
                                                    decoration: new BoxDecoration(
                                                      boxShadow: [
                                                        new BoxShadow(
                                                          color: Colors.grey[200],
                                                          offset: new Offset(
                                                              0.0, 0.0),
                                                          blurRadius: 4.0,
                                                        ),
                                                      ],
                                                      color: Colors.yellow[700],
                                                      border: new Border.all(
                                                          color: Colors.pink[50],
                                                          width: 1.5),
                                                      borderRadius:
                                                      new BorderRadius
                                                          .circular(8.0),
                                                    ),
                                                    child: new Text(
                                                      "OUI",
                                                      style: new TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                          FontWeight.w800),
                                                    ),
                                                  )),
                                              new Container(
                                                width: 16.0,
                                              ),
                                              new FlatButton(
                                                  padding:
                                                  new EdgeInsets.all(0.0),
                                                  onPressed: () {
                                                    setState(() {
                                                      show_page = false;
                                                    });

                                                    Navigator.pushReplacement(
                                                        context,
                                                        new MaterialPageRoute(
                                                            builder: (BuildContext
                                                            context) =>
                                                            new BottomNavigation(
                                                                widget.auth,
                                                                null,
                                                                widget
                                                                    .user_me,
                                                                widget
                                                                    .list_partner,
                                                                false,
                                                                widget
                                                                    .analytics,

                                                                animate:
                                                                true)));
                                                  },
                                                  child: new Container(
                                                    height: 40.0,
                                                    width: 130.0,
                                                    alignment: Alignment.center,
                                                    decoration: new BoxDecoration(
                                                      boxShadow: [
                                                        new BoxShadow(
                                                          color: Colors.grey[200],
                                                          offset: new Offset(
                                                              0.0, 0.0),
                                                          blurRadius: 4.0,
                                                        ),
                                                      ],
                                                      color: Colors.yellow[700],
                                                      border: new Border.all(
                                                          color: Colors.pink[50],
                                                          width: 1.5),
                                                      borderRadius:
                                                      new BorderRadius
                                                          .circular(8.0),
                                                    ),
                                                    child: new Text(
                                                      "NON",
                                                      style: new TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                          FontWeight.w800),
                                                    ),
                                                  ))
                                            ],
                                          )))
                                ],
                              )),
                          new Container(height: 36.0),
                        ],
                      )),
                )),
          ]),
        ));
  }
}
/*
    new BackdropFilter(
                filter: new ImageFilter.blur(sigmaX: 6.0, sigmaY: 10.0),
                child: new Container(
                  width: 200.0,
                  height: 200.0,
                  decoration: new BoxDecoration(
                      color: Colors.grey.shade200.withOpacity(0.01)
 */
