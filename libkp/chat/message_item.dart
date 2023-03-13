import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:ifdconnect/services/location_services.dart';
import 'package:timeago/timeago.dart' as ta;
import 'dart:async';
import 'package:ifdconnect/chat/chatscreen.dart';
import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ifdconnect/services/block.dart';
import 'package:ifdconnect/user/details_user.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageItem extends StatefulWidget {
  MessageItem(this.snapshot, this.id, this.searchText, this.reload, this.me,
      this.list_partners, this.auth, this.analytics,
      {Key key})
      : super(key: key);
  DataSnapshot snapshot;
  String id;
  String searchText;
  var reload;
  User me;
  var list_partners;
  var auth;
  var analytics;

  @override
  _MessageItemState createState() => new _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  String name = "", idOther = "";
  String titre = "";
  DatabaseReference gMessagesDbRef3;

  TextStyle style = new TextStyle(
    fontSize: 10.5,
    color: Colors.grey,
  );

  ParseServer parse_s = new ParseServer();

  String photoURL = "";
  var sp;
  String idLast = "";

  bool vu = false;
  bool vumoi = false;
  User userme;
  User user_other = new User();

  /*getOnlineUser() async {

    DocumentSnapshot a = await Firestore.instance
        .collection('users')
        .document(user_other.auth_id)
        .get();
    if (!this.mounted) return;

    if (a.data["online"].toString() == "true") {

      setState(() {
        user_other.online = true;
      });
    } else
      setState(() {
        user_other.online = false ;
      });

  }*/

  Future<User> GetUserInfo(id) async {
    // DocumentSnapshot snap =
    //  await Firestore.instance.collection('users').document(id).get();
    //return new User.fromDoc(snap)
    var response = await parse_s
        .getparse('users?where={"id1":"$id"}&include=user_formations,role');
    user_other = new User.fromMap(response["results"][0]);
    //  user_other.online = false;
    // getOnlineUser();
    return new User.fromMap(response["results"][0]);
  }

  viewMessageMoi(key, idOther) async {
    FirebaseDatabase.instance
        .reference()
        .child("lastm_medz/" + key + "/vu_" + idOther)
        .onValue
        .listen((val) {
      var d;
      try {
        setState(() {
          d = val.snapshot.value;
        });
      } catch (e) {}

      if (d != null) {
        //Message lu
        if (d == "0") {
          try {
            setState(() {
              vumoi = true;
            });
          } catch (e) {}
        }
        //Message non lu
        else {
          try {
            setState(() {
              vumoi = false;
            });
          } catch (e) {}
        }
      }
      //FirebaseDatabase.instance.goOffline();
    });
  }

  viewMessage(key, idOther) async {
    FirebaseDatabase.instance
        .reference()
        .child("lastm_medz/" + key + "/vu_" + idOther)
        .onValue
        .listen((val) {
      var d;

      try {
        setState(() {
          d = val.snapshot.value;
        });
      } catch (e) {}

      if (d != null) {
        //Message lu
        if (d == "0") {
          try {
            setState(() {
              vu = true;
            });
          } catch (e) {}
        }
        //Message non lu
        else {
          try {
            setState(() {
              vu = false;
            });
          } catch (e) {}
        }
      }
      //FirebaseDatabase.instance.goOffline();
    });
  }

  Future<bool> deleteConversation() async {
    return await showDialog<bool>(
          context: context,
          builder: (_) => new AlertDialog(
            title: const Text(''),
            content: new Text("Supprimer"),
            actions: <Widget>[
              new FlatButton(
                  child: new Text("Ok"),
                  onPressed: () {
                    FirebaseDatabase.instance
                        .reference()
                        .child("message_medz")
                        .child(widget.snapshot.value['key'])
                        .remove();
                    FirebaseDatabase.instance
                        .reference()
                        .child("lastm_medz")
                        .child(widget.snapshot.value['key'])
                        .remove();
                    FirebaseDatabase.instance
                        .reference()
                        .child("room_medz")
                        .child(widget.snapshot.value['key'])
                        .update({
                      "lastmessage": "Aucun message",
                    });

                    Navigator.of(context).pop(false);
                  }),
              new FlatButton(
                child: new Text("Annuler"),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          ),
        ) ??
        false;
  }

  getKey1(key) {
    var sp = key.split("_");
    return sp[1] - sp[0];
  }

  block_user() async {
    await Block.insert_block(
        userme.auth_id, user_other.auth_id, userme.id, user_other.id);
  }

  Distance distance = new Distance();
  var currentLocation = <String, double>{};
  var location = new Location();
  var lat, lng;

  getLOcation() async {
    currentLocation = await Location_service.getLocation();

    lat = currentLocation["latitude"];
    lng = currentLocation["longitude"];

    user_other.dis = distance
            .as(
                LengthUnit.Kilometer,
                new LatLng(
                    double.parse(user_other.lat), double.parse(user_other.lng)),
                new LatLng(lat, lng))
            .toString() +
        " Km(s)";
  }

  void showMenuSelection(String value) async {
    if (value == "Delete") {
      deleteConversation();
    } else {
      await getLOcation();

      Navigator.push(context,
          new MaterialPageRoute(builder: (BuildContext context) {
        return new Details_user(user_other, widget.me, block_user(), true,
            widget.list_partners, widget.analytics,
            reload: widget.reload);
      }));
      /*else if (value == "Block") {
        confirmblock();
      }*/
    }
  }

  getidLast(key) async {
    FirebaseDatabase.instance
        .reference()
        .child("lastm_medz")
        .child(key + "/id_last")
        .onValue
        .listen((val) {
      if (val.snapshot.value != null) {
        try {
          setState(() {
            idLast = val.snapshot.value;
          });
        } catch (e) {}
      }
    });
  }

  @override
  initState() {
    super.initState();

    /*getUser(widget.id).then((user) {
      try {
        setState(() {
         userme = user;
        });
      } catch (e) {}
    });*/

    photoURL =
        "https://res.cloudinary.com/dgxctjlpx/image/upload/v1591701242/Capture_d_e%CC%81cran_2020-06-09_a%CC%80_10.30.25_ncvtv6.png";
    name = "";

    sp = widget.snapshot.value['key'].split("_");

    for (int i = 0; i < sp.length; i++) {
      if (sp[i] != widget.id) {
        idOther = sp[i];
        getidLast(widget.snapshot.value['key']);
        viewMessage(widget.snapshot.value['key'], idOther);
        // ViewMessage(widget.snapshot.value['key'],widget.id,vumoi);

        //hna info dial other user
        GetUserInfo(idOther).then((na) {
          try {
            setState(() {
              userme = na;
              name = na.fullname + " " + na.firstname;
              photoURL = na.image;
              titre = na.titre;
            });
          } catch (e) {}
        });
      } else {
        viewMessageMoi(widget.snapshot.value['key'], widget.id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget menusubscribe = new Container(
        width: 28.0,
        height: 28.0,
        child: new PopupMenuButton<String>(
            padding: new EdgeInsets.all(2.0),
            onSelected: showMenuSelection,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  /* new PopupMenuItem<String>(
                  value: "Block",
                  child: new ListTile(
                      title: new Text(
                          isBlock ? "Unblock this user" : "Block this user")*/
                  new PopupMenuItem<String>(
                      value: "Voir profil",
                      child: new ListTile(title: new Text("Voir profil"))),
                  new PopupMenuItem<String>(
                      value: "Delete",
                      child: new ListTile(
                          title: new Text("Supprimer la conversation"))),
                ]));

    Widget avatarw() {
      if (photoURL ==
              "https://res.cloudinary.com/dgxctjlpx/image/upload/v1591701242/Capture_d_e%CC%81cran_2020-06-09_a%CC%80_10.30.25_ncvtv6.png" ||
          photoURL == null && name != "") {
        return SizedBox(
          width: 60.0,
          height: 60.0,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100],
            child: CircleAvatar(
              backgroundColor: Colors.grey[100],
              radius: 25.0,
            ),
          ),
        );
      } else {
        return Stack(children: <Widget>[
          new ClipOval(
              child: new Container(
                  width: 56.0,
                  height: 56.0,
                  child: new Image.network(
                    photoURL,
                    fit: BoxFit.cover,
                  ))),
          Positioned(
            bottom: 0.0,
            right: 0.0,
            child: user_other.online == true
                ? new CircleAvatar(backgroundColor: Colors.green, radius: 0.0)
                : new Container(),
          )
        ]);
      }
    }

    Widget namew() {
      return name == ""
          ? Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              child: Container(
                margin: new EdgeInsets.only(bottom: 7.0, top: 8.0),
                color: Colors.grey[100],
                height: 8.0,
                width: 120.0,
              ),
            )
          : new Text(name,
              style: new TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 15.0,
              ));
    }

    Widget titrew() {
      return titre == ""
          ? Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              child: Container(
                margin: new EdgeInsets.only(bottom: 7.0),
                color: Colors.grey[100],
                height: 8.0,
                width: 120.0,
              ),
            )
          : Container(
              width: 140.0,
              child: new Text(titre,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: new TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500,
                    fontSize: 12.0,
                  )));
    }

    return (!name.toLowerCase().contains(widget.searchText.toLowerCase()) &&
            widget.searchText.isNotEmpty)
        ? new Container()
        : Container(
            padding: EdgeInsets.all(12.0.w),

            // key: new ValueKey<String>(widget.snapshot.key),
            child: Row(children: [
              avatarw(),
              Container(width: 8.w),
              Expanded(
                child: new Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color:
                          (vumoi == true ? Colors.grey[100] : Colors.blue[50]),
                      borderRadius: new BorderRadius.circular(24.0.r),
                    ),
                    //width: MediaQuery.of(context).size.width*0.8,

                    //  elevation: 0.0,
                    //
                    //color: Colors.grey[50],

                    child: new FlatButton(
                        // padding: new EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                        onPressed: () {
                          Navigator.push(
                            context,
                            new PageRouteBuilder(
                              pageBuilder: (BuildContext context,
                                  Animation<double> _, Animation<double> __) {
                                return new ChatScreen(
                                    widget.id,
                                    idOther,
                                    widget.list_partners,
                                    false,
                                    widget.auth,
                                    widget.analytics,
                                    user: widget.me,
                                    reload: widget.reload);
                              },
                            ),
                          );
                        },
                        child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Container(height: 8.0),
                              new Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  new Container(width: 8.0),
                                  new Container(
                                    //padding: new EdgeInsets.all(4.0),
                                    child: new Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        new Container(
                                            width: MediaQuery.of(context).size.width*0.60,
                                            // padding: new EdgeInsets.only(bottom: 2.0),
                                            child: namew()),
                                        new Container(height: 2.0),
                                        //  titrew(),
                                        new Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              new Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.42,
                                                  padding: new EdgeInsets.only(
                                                      top: 2.0), //error
                                                  child: new Text(
                                                      widget.snapshot.value['lastmessage']
                                                                  .toString() ==
                                                              "null"
                                                          ? "image"
                                                          : widget.snapshot.value['lastmessage']
                                                              .toString(),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: new TextStyle(
                                                          fontSize: 13.0,
                                                          color: (idLast != widget.id.toString()
                                                              ? (vumoi == true
                                                                  ? Colors
                                                                      .grey[400]
                                                                  : Colors.blue)
                                                              : Colors.deepPurple[300]),
                                                          fontStyle: FontStyle.italic,
                                                          fontWeight: (idLast != widget.id.toString() ? (vumoi == true ? FontWeight.w500 : FontWeight.w500) : FontWeight.w400)))),
                                              new Container(width: 8.0),
                                              (idLast == widget.id.toString()
                                                  ? (vu == true
                                                      ? new Text(
                                                          "Vu",
                                                          style: new TextStyle(
                                                              color:
                                                                  Colors.green),
                                                        )
                                                      : new Text(""))
                                                  : new Container()),
                                            ]),
                                      ],
                                    ),
                                  ),
                                  //  new Expanded(child: new Container()),
                                ],
                              ),
                              new Container(
                                height: 4.0,
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 6.w),
                                child: new Text(
                                    ta.format(
                                        new DateTime.fromMillisecondsSinceEpoch(
                                            widget
                                                .snapshot.value['timestamp'])),
                                    style: new TextStyle(
                                        color: Colors.grey, fontSize: 11.0)),
                              ),
                            ]))),
              )
            ]));
  }
}
