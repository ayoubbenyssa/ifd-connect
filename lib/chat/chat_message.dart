import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_3.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:ifdconnect/chat/audio.dart';
import 'package:ifdconnect/chat/list_images.dart';
import 'package:ifdconnect/services/app_services.dart';
import 'package:ifdconnect/user/details_user.dart';

import 'package:meta/meta.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:ifdconnect/services/Fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'message_data.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

class ChatMessage extends StatefulWidget {
  final DataSnapshot snapshot;
  final Animation animation;
  final Message msg1;
  final Message msg2;

  ChatMessage(
      {@required this.snapshot,
      @required this.msg1,
      @required this.msg2,
      this.animation});

  @override
  _ChatMessageState createState() => new _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  //RoutesFunctions routesFunctions = new RoutesFunctions();
  //PostFunctions postFunctions = new PostFunctions();

  bool iscolor = false;

  @override
  initState() {
    super.initState();
    getKey();
    print("---------------------------------------");
    print("widget.msg1.name");
    print(widget.msg1);
    print("widget.msg2");
    print(widget.msg2.name);
    print("animation");
    print(widget.animation);
    print("widget.snapshot.value[""lm""]");
    print(widget.snapshot.value["lm"]);  }

  String getKey() {
    return widget.msg1.idUser + "_" + widget.msg2.idUser;
  }

  Future<bool> deleteMessage() async {
    return await showDialog<String>(
          context: context,
          builder: (_) => new AlertDialog(
            title: const Text(''),
            content: const Text('Voulez vous supprimer ce message ?'),
            actions: <Widget>[
              new FlatButton(
                  child: const Text('Ok'),
                  onPressed: () {
                    try {
                      setState(() {
                        iscolor = false;
                      });
                    } catch (e) {}
                    FirebaseDatabase.instance
                        .reference()
                        .child("message_medz")
                        .child(getKey() + "/" + widget.snapshot.key)
                        .remove()
                        .then((_) {
                      var data = FirebaseDatabase.instance
                          .reference()
                          .child("message_medz")
                          .child(getKey());
                     //// FirebaseDatabase.instance.setPersistenceEnabled(true);
                     //// data.keepSynced(true);
                      data.onValue.forEach((val) {
                        if (val.snapshot.value == null) {
                          FirebaseDatabase.instance
                              .reference()
                              .child("room_medz")
                              .child(getKey())
                              .remove();
                        } else {
                          var data1 = FirebaseDatabase.instance
                              .reference()
                              .child("message_medz")
                              .child(getKey())
                              .limitToLast(1);
                          data1.onValue.forEach((x) {
                            var list = x.snapshot.value.keys.toList()..sort();

                            list.forEach((a) {
                              var key;

                              if (x.snapshot.value[a.toString()]["idUser"] !=
                                  widget.msg1.idUser) {
                                key = x.snapshot.value[a.toString()]["idUser"] +
                                    "_" +
                                    widget.msg1.idUser;
                              } else {
                                key = x.snapshot.value[a.toString()]["idUser"] +
                                    "_" +
                                    widget.msg2.idUser;
                              }

                              var lastmsg = "";

                              if (x.snapshot.value[a.toString()]["imageUrl"] !=
                                  null) {
                                lastmsg = "image";
                              }
                              if (x.snapshot.value[a.toString()]["audio"] !=
                                  null) {
                                lastmsg = "audio";
                              }
                              if (x.snapshot.value[a.toString()]
                                      ["messageText"] !=
                                  null) {
                                lastmsg = x.snapshot.value[a.toString()]
                                    ["messageText"];
                              }

                              FirebaseDatabase.instance
                                  .reference()
                                  .child("room_medz")
                                  .child(getKey())
                                  .update({
                                "timestamp": x.snapshot.value[a.toString()]
                                    ["timestamp"],
                                "lastmessage": lastmsg,
                                "key": key,
                                x.snapshot.value[a.toString()]["idUser"]: true
                              });
                            });
                          });
                        }
                      });
                    });

                    Navigator.of(context, rootNavigator: true).pop('dialog');
                  }),
              new FlatButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                },
              ),
            ],
          ),
        ) ??
        false;
  }

  Widget photoUrl() {
    Widget avatar;

    if ((widget.msg1.avatar == null ||
            widget.msg1.avatar == "" && widget.msg1.name != "") ||
        (widget.msg2.avatar == "" ||
            widget.msg2.avatar == null && widget.msg1.name != "")) {
      avatar = new ClipOval(
          child: new Container(
              color: Colors.blue[400],
              width: 40.0,
              height: 40.0,
              child: new Center(
                  child: new Text(
                (widget.snapshot.value["idUser"] == widget.msg1.idUser
                    ? widget.msg1.name[0].toUpperCase()
                    : widget.msg2.name[0].toUpperCase()),
                style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0,
                    color: Colors.white),
              ))));
    } else {
      avatar = new ClipOval(
          child: new Container(
        width: 40.0,
        height: 40.0,
        child: new Image.network(
          (widget.snapshot.value["idUser"] == widget.msg1.idUser
              ? widget.msg1.avatar
              : widget.msg2.avatar),
          fit: BoxFit.fill,
        ),
      ));
    }
    return avatar;
  }

  Future _launch(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  gotomap(lat, lng) {
    _launch('https://www.google.com/maps/@$lat,$lng,16z');
  }

  avatar() {
    return widget.msg1.idUser == ""
        ? SizedBox(
            width: 60.0,
            height: 60.0,
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              child: CircleAvatar(
                backgroundColor: Colors.grey[100],
                radius: 25.0,
              ),
            ))
        : new ClipOval(
            child: new Container(
            width: 40.0,
            height: 40.0,
            child: new Image.network(
              (widget.snapshot.value["idUser"] == widget.msg1.idUser
                  ? widget.msg1.avatar
                  : widget.msg2.avatar),
              fit: BoxFit.fill,
            ),
          ));
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
        onLongPress: () {
          try {
            setState(() {
              iscolor = true;
            });
          } catch (e) {}
          displaybottomsheet(widget.snapshot.value);
        },
        child: new SizeTransition(
            sizeFactor: new CurvedAnimation(
              parent: widget.animation,
              curve: Curves.elasticOut,
            ),
            axisAlignment: 0.0,
            child: new Column(children: <Widget>[
              new Container(
                // color : Colors.red,
                  padding: new EdgeInsets.only(left: 8.0, right: 8.0),
                  // color: iscolor == false ? Colors.transparent : Colors.white,
                  //margin: new EdgeInsets.symmetric(vertical: 3.0),
                  child: new Row(
                      /* crossAxisAlignment:
                          (widget.snapshot.value["idUser"] == widget.msg2.idUser
                              ? CrossAxisAlignment.start
                              : CrossAxisAlignment.end),*/
                      mainAxisAlignment:
                          (widget.snapshot.value["idUser"] == widget.msg2.idUser
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.end),
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        widget.snapshot.value["idUser"] == widget.msg2.idUser
                            ?
                        Column(
                              children: [
                                new Container(
                                    //  padding: new EdgeInsets.only(bottom: 16.0),
                                    child: avatar()),
                                SizedBox(height: 20,),
                              ],
                            )
                            : new Container(),
                        widget.snapshot.value["idUser"] == widget.msg2.idUser
                            ? new Container(
                                width: 8,
                              )
                            : new Container(),
                        new Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              //new Container(height: 16.0,),

                              ChatBubble(

                                elevation: 0.0,
                                shadowColor: Colors.white,

                                margin: EdgeInsets.only(top: 12),

                                clipper: ChatBubbleClipper3(type:widget.snapshot.value["idUser"] ==
                        widget.msg2.idUser? BubbleType.sendBubble  :BubbleType.receiverBubble ),

                                backGroundColor:
                                widget.snapshot.value["idUser"] == widget.msg2.idUser
                                    ? Fonts.col_app_green  : Fonts.col_grey ,

                                child: new
                                Column(
                                  crossAxisAlignment:
                                      (widget.snapshot.value["idUser"] ==
                                              widget.msg1.idUser
                                          ? CrossAxisAlignment.end
                                          : CrossAxisAlignment.end),
                                  children: <Widget>[
                                    (widget.snapshot.value['file']
                                                    .toString() !=
                                                "null" &&
                                            widget.snapshot.value['file']
                                                    .toString() !=
                                                "")
                                        ? InkWell(
                                            child: Container(
                                              color: Colors.grey[50],
                                              padding: EdgeInsets.all(4.0),
                                              child: Row(
                                                children: <Widget>[
                                                  Image.asset(
                                                    "images/document.png",
                                                    width: 30.0,
                                                    height: 30.0,
                                                    color: widget.snapshot.value["idUser"] == widget.msg2.idUser ?
                                                    Fonts.colors_container : Fonts.col_app_fon,                                                   ),
                                                  Container(
                                                    width: 8,
                                                  ),
                                                  Container(
                                                    width: 224.0,
                                                    child: Text(
                                                        widget.snapshot
                                                            .value['docname']
                                                            .toString()
                                                            .toString(),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: new TextStyle(
                                                          color: Colors
                                                              .blue[600],
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 12.0,
                                                        )),
                                                  )
                                                ],
                                              ),
                                            ),
                                            onTap: () {

                                              if (Platform.isIOS)
                                                Navigator.push(context,
                                                    new MaterialPageRoute<String>(
                                                        builder: (BuildContext context) {
                                                          return new WebviewScaffold(
                                                            url: widget
                                                                .snapshot.value['file'],
                                                            appBar: new AppBar(
                                                              title: new Text(""),
                                                            ),
                                                          );
                                                        }));
                                              else
                                              launch(widget
                                                  .snapshot.value['file']
                                                  .toString());



                                            },
                                          )
                                        : Container(),
                                    (widget.snapshot.value['audio']
                                                    .toString() !=
                                                "null" &&
                                            widget.snapshot.value['audio']
                                                    .toString() !=
                                                "")
                                        ? AudioApp(
                                            widget.snapshot.value['audio'])
                                        : Container(),
                                    (widget.snapshot.value["lat"]
                                                    .toString() !=
                                                "null" &&
                                            widget.snapshot
                                                    .value['messageText'] ==
                                                "")
                                        ? new InkWell(
                                            child: Row(
                                              children: <Widget>[
                                                new Image.asset(
                                                  "images/location.png",
                                                  width: 18.0,
                                                  height: 18.0,
                                                  color: widget.snapshot.value["idUser"] == widget.msg2.idUser ?
                                                  Fonts.colors_container : Fonts.col_app_fon,
                                                ),
                                                Container(
                                                  width: 2.0,
                                                ),
                                                Container(
                                                    width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width *
                                                        0.56,
                                                    padding: EdgeInsets.only(
                                                        top: 4.0),
                                                    child: Text(
                                                        "Ma position: " +
                                                            widget.snapshot
                                                                .value["lat"]
                                                                .toString() +
                                                            ";" +
                                                            widget.snapshot
                                                                .value["lng"]
                                                                .toString(),
                                                    style: TextStyle(color:  widget.snapshot.value["idUser"] == widget.msg2.idUser?
                                                        Colors.white : Colors.black
                                                    ),
                                                    ),
                                                )
                                              ],
                                            ),
                                            onTap: () {
                                              gotomap(
                                                  widget
                                                      .snapshot.value["lat"],
                                                  widget
                                                      .snapshot.value["lng"]);
                                            },
                                          )
                                        : Container(),
                                    widget.snapshot.value['call'].toString() != "null"
                                        ? Text("Appel vidéo")
                                        : Container(),
                                    (widget.snapshot.value['messageText'] ==
                                                "" &&
                                            widget.snapshot.value['imageUrl']
                                                    .toString() !=
                                                "null" &&
                                            widget.snapshot.value['imageUrl']
                                                    .toString() !=
                                                "")
                                        ? Container(
                                            height: 140,
                                            width: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        widget
                                                            .snapshot
                                                            .value['imageUrl']
                                                            .length *
                                                        0.24 >
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.7
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6
                                                : MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    widget
                                                        .snapshot
                                                        .value['imageUrl']
                                                        .length *
                                                    0.24,
                                            child: ListView(
                                              scrollDirection:
                                                  Axis.horizontal,
                                              children: widget
                                                  .snapshot.value['imageUrl']
                                                  .map<Widget>((var st) => InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      FullScreenWrapper(
                                                                        imageProvider:
                                                                            NetworkImage(st.toString()),
                                                                      ),
                                                            ));
                                                      },
                                                      child: new Container(
                                                          padding: new EdgeInsets.all(2.0),
                                                          width: 90,
                                                          height: 120,
                                                          child: new Material(
                                                              borderRadius: new BorderRadius.circular(22.0),
                                                              shadowColor: Colors.white,
                                                              elevation: 3.0,
                                                              child: Image.network(
                                                                st,
                                                                width: 90,
                                                                height: 120,
                                                                fit: BoxFit
                                                                    .cover,
                                                              )))))
                                                  .toList(),
                                            ),
                                          )
                                        : Container(),
                                    (widget.snapshot.value['messageText'] ==
                                                "" &&
                                            widget.snapshot.value['imageUrl']
                                                    .toString() !=
                                                "null" &&
                                            widget.snapshot.value['imageUrl']
                                                    .toString() !=
                                                "" &&
                                            widget.snapshot.value['imageUrl']
                                                    .length >
                                                2)
                                        ? RaisedButton(
                                            color: Colors.grey[200],
                                            child: Text(
                                              "Voir tous",
                                              style: TextStyle(
                                                color: Fonts.col_app,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  new MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          new ImageList(widget
                                                                  .snapshot
                                                                  .value[
                                                              'imageUrl'])));
                                            },
                                          )
                                        : Container(),
                                    widget.snapshot.value['messageText'] ==
                                                "" ||
                                            widget.snapshot
                                                    .value['messageText'] ==
                                                "file"
                                        ? Container()
                                        : new Container(
                                            margin: const EdgeInsets.only(
                                                top: 5.0),
                                            child: new Container(
                                                width: 160.0,
                                                child: new Linkify(
                                                  onOpen: (link) =>
                                                      AppServices
                                                          .go_webview(
                                                          link.url,
                                                          context),

                                                  //jiji
                                                  text: widget.snapshot
                                                      .value['messageText']
                                                      .toString(),
                                                  overflow:
                                                  TextOverflow.ellipsis,
                                                  maxLines: 140,
                                                  style: new TextStyle(
                                                    // fontWeight: FontWeight.w600,
                                                    fontSize: 15.0,
                                                    color: (widget.snapshot
                                                        .value[
                                                    "idUser"] !=
                                                        widget.msg2.idUser
                                                        ? Colors.black
                                                        : Colors.grey[50]),
                                                  ),

                                                ))),
                                  ],
                                ),
                              ),
                              new Container(height: 4.0),

                              /*
                                ScopedModelDescendant<AppModel1>(
                                    builder: (context, child, model) => new Text(
                                        ta.format(
                                            new DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                widget.snapshot
                                                    .value['timestamp']),
                                            locale: model.locale == "ar"
                                                ? "ar"
                                                : "fr"),
                               */
     new Text(
                                  timeago.format(
                                      new DateTime.fromMillisecondsSinceEpoch(
                                          widget.snapshot.value['timestamp']),locale:"fr"),
                                  style: (widget.snapshot.value["idUser"] ==
                                          widget.msg2.idUser
                                      ? new TextStyle(
                                          fontSize: 10.0,
                                          color: Colors.grey[600])
                                      : new TextStyle(
                                          fontSize: 10.0,
                                          color: Colors.grey[600]))),
                            ]),
                        widget.snapshot.value["idUser"] != widget.msg2.idUser
                            ? new Container(
                                width: 8,
                              )
                            : new Container(),
                        widget.snapshot.value["idUser"] != widget.msg2.idUser
                            ? new Container(
                                padding: new EdgeInsets.only(bottom: 16.0),
                                child: avatar())
                            : new Container(),
                      ])),
            ])));
  }

  displaybottomsheet(val) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return new Container(
              height: 60.0,
              child: new Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      val['messageText'] != null
                          ? new FlatButton(
                              onPressed: () {
                                Clipboard.setData(new ClipboardData(
                                    text: val['messageText']));
                                Navigator.of(context).pop(true);
                                try {
                                  setState(() {
                                    iscolor = false;
                                  });
                                } catch (e) {}
                                Scaffold.of(context).showSnackBar(new SnackBar(
                                  content: new Text("Live Clicked"),
                                ));
                              },
                              child: new Row(children: <Widget>[
                                new Icon(
                                  Icons.content_copy,
                                  color: Fonts.col_app_fonn,
                                ),
                                new Text("Copier",
                                    style: new TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Fonts.col_app_fonn))
                              ]))
                          : new Container(),
                      new FlatButton(
                          onPressed: () {
                            //ShareText
                            Navigator.of(context, rootNavigator: true)
                                .pop('dialog');
                            deleteMessage();
                          },
                          child: new Row(children: <Widget>[
                            new Icon(
                              Icons.delete_outline,
                              color: Fonts.col_app_fonn,
                            ),
                            new Text("Supprimer",
                                style: new TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Fonts.col_app_fonn))
                          ])),
                    ],
                  )));
        });
  }
}
