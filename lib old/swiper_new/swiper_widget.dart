import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:latlong/latlong.dart';
import 'package:ifdconnect/cards/like_partner_button.dart';
import 'package:ifdconnect/cards/partner_card.dart';
import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/notifications/invite_view_user.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/services/connect.dart';
import 'package:ifdconnect/swiper_new/user_widget.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';

//jiji

class UserWid extends StatefulWidget {
  UserWid(
      this.images,
      this.id,
      this.lat,
      this.lng,
      this.my_id,
      this.user_me,
      this.click,
      this.auth,
      this.sign,
      this.list_partners,
      this.count,
      this.load,
      this.analytics,

      );

  List<dynamic> images;
  var id;
  var lat;
  var lng;
  User user_me;
  var my_id;
  var click;

  var auth;
  var list_partners;
  var sign;
  var count;
  var load;
  var analytics;

  var onLocaleChange;

  @override
  State<StatefulWidget> createState() {
    return new _ExampleCustomState();
  }
}

class _ExampleCustomState extends State<UserWid> {
  //properties whant to custom
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  int _itemCount;
  bool _loop;
  bool _autoplay;
  int _autoplayDely;
  Axis _axis;
  double _padding;
  bool _outer;
  double _radius;
  double _viewportFraction;
  SwiperLayout _layout;
  int _currentIndex;
  double _scale;
  Curve _curve;
  CustomLayoutOption customLayoutOption;
  Distance distance = new Distance();

  remove_item() {}

  bool show = true;
  var number = 23;

  Widget _buildItem(BuildContext context, int index) {
    if (index % number == 0 && index != 0) {
      return new Card(
        elevation: 8.0,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Text(
              "?",
              style: new TextStyle(
                  color: Colors.grey[800],
                  fontSize: 46.0,
                  fontWeight: FontWeight.bold),
            ),
            new Image.asset(
              "ons/visitor.png",
              width: 150.0,
              height: 150.0,
              fit: BoxFit.cover,
            ),
            SizedBox(
                width: 350.0,
                child: new FlatButton(
                    onPressed: () {
                      widget.click("all");
                    },
                    child: new Center(
                      child: new Padding(
                          padding: new EdgeInsets.only(top: 42.0),
                          child: ColorizeAnimatedTextKit(
                            text: [
                              "Cliquez ici pour voir d'autres utilisateurs",
                            ],
                            textStyle: TextStyle(
                                fontSize: 24.0, fontFamily: "Helvetica"),
                            colors: [
                              Colors.blue[900],
                              Colors.blue[700],
                              Colors.blue[50],
                              Colors.blue[400],
                            ],
                          )),
                    )))
          ],
        ),
      );
    }
    if (widget.images[index].runtimeType.toString() != "User") {
    } else {
      widget.images[index].block = false;
      widget.images[index].online = false;

      if(widget.lat == null ||  widget.images[index].lat == null  || widget.images[index].lat == "" )
        {
          widget.images[index].dis = "-.- Kms";

        }
      else {
        widget.images[index].dis = distance
            .as(
            LengthUnit.Kilometer,
            new LatLng(double.parse(widget.images[index].lat),
                double.parse(widget.images[index].lng)),
            new LatLng(widget.lat, widget.lng))
            .toString() +
            " Kms" ;
      }

    }

    return widget.images[index].runtimeType.toString() == "MyView"
            ? new Card(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                    new Text(
                      "Pas d'autres utilisateurs",
                      style: TextStyle(fontSize: 16.0),
                    ),
                    new Container(
                      height: 32.0,
                    ),
                    new Image.asset(
                      "images/uss.png",
                      width: 80.0,
                      height: 80.0,
                    )
                  ]))
            : widget.images[index].runtimeType.toString() == "User"
                ? new UserWidget(
                    widget.images[index],
                    widget.id,
                    widget.lat,
                    widget.lng,
                    _controller,
                    widget.my_id,
                    widget.user_me,
                    widget.list_partners,
                    widget.analytics,
                 )
                : new PartnerCard(
                    widget.images[index],
                    widget.lat,
                    widget.lng,
                   /* widget.user_me,*/
    ) /*new Image.asset(
        images[index % images.length],
        fit: BoxFit.fill,
      ),*/
        ;
  }

  @override
  void didUpdateWidget(UserWid oldWidget) {
    customLayoutOption = new CustomLayoutOption(startIndex: -1, stateCount: 3)
        .addRotate([-45.0 / 180, 0.0, 45.0 / 180]).addTranslate([
      new Offset(-370.0, -40.0),
      new Offset(0.0, 0.0),
      new Offset(370.0, -40.0)
    ]);
    super.didUpdateWidget(oldWidget);
  }

  connectedorno(index) async {
    setState(() {
      widget.images[index].cnt = "Se connecter";
    });
    var id = widget.images[index].id;
    String my_id = widget.user_me.id;

    var response = await parse_s.getparse(
        'connect?where={"receive_req":"$my_id","send_requ":"$id","accepted":false}');
    if (!this.mounted) return;

    setState(() {
      widget.images[index].wait = true;
    });

    if (response["results"].length > 0) {
      setState(() {
        widget.images[index].cnt = "Confimer";
      });
    } else {
      setState(() {
        widget.images[index].cnt = "Se connecter";
      });
    }
  }

  /*
      Navigator.push(context,
                        new MaterialPageRoute(builder: (BuildContext context) {
                      return new Invite_view(
                          widget.user.auth_id,
                          null,
                          widget.user_me.auth_id,
                          widget.user_me,
                          true,
                          false,
                          widget.auth,
                          widget.sign,
                          widget.list_partners,
                          widget.user,
                          widget.load);
                    }));
   */

  confirm() {
    Navigator.push(context,
        new MaterialPageRoute(builder: (BuildContext context) {
      return new Invite_view(
          widget.images[_currentIndex].auth_id,
          null,
          widget.user_me.auth_id,
          widget.user_me,
          true,
          false,
          widget.auth,
          widget.sign,
          widget.list_partners,
          widget.images[_currentIndex],
          widget.load,
          widget.analytics,
          );
    }));
  }

  @override
  void initState() {
    customLayoutOption = new CustomLayoutOption(startIndex: -1, stateCount: 3)
        .addRotate([-25.0 / 180, 0.0, 25.0 / 180]).addTranslate([
      new Offset(-350.0, 0.0),
      new Offset(0.0, 0.0),
      new Offset(350.0, 0.0)
    ]);
    _currentIndex = 0;
    _curve = Curves.ease;
    _scale = 1.8;
    _controller = new SwiperController();
    _layout = SwiperLayout.TINDER;
    _radius = 10.0;
    _padding = 0.0;
    _loop = true;
    _itemCount = widget.images.length;
    _autoplay = false;
    _autoplayDely = 1000;
    _axis = Axis.horizontal;
    _viewportFraction = 0.8;
    _outer = false;

    new Timer(new Duration(milliseconds: 1200), () {
        connectedorno(0);

    });

    super.initState();
  }

// maintain the index

  Widget buildSwiper(width, height) {
    //Navigator;
    return new Swiper(
      onTap: (int index) {},
      customLayoutOption: customLayoutOption,
      index: _currentIndex,
      onIndexChanged: (int index) {
        if (widget.images[index].runtimeType.toString() == "MyView") {}
        if (widget.images[index].runtimeType.toString() == "User") {
          if (!widget.images[index].wait) connectedorno(index);
        } else {}

        setState(() {
          _currentIndex = index;
        });
      },
      curve: _curve,
      scale: _scale,
      itemWidth: width,
      controller: _controller,
      layout: _layout,
      outer: _outer,
      itemHeight: MediaQuery.of(context).size.height * 0.66,
      viewportFraction: _viewportFraction,
      autoplayDelay: _autoplayDely,
      loop: false,
      autoplay: _autoplay,
      itemBuilder: _buildItem,
      itemCount: _itemCount,
      scrollDirection: _axis,
      //  pagination: new SwiperPagination(),
    );
  }

  SwiperController _controller;

  show_connect() async {
    setState(() {
      widget.images[_currentIndex].activate = false;
    });

    await Connect.inser_request(
        widget.user_me.id, widget.images[_currentIndex].id, false);
    String token = await _firebaseMessaging.getToken();

    await Firestore.instance
        .collection('user_notifications')
        .document(widget.images[_currentIndex].auth_id)
        .setData({"notif": true});

    await Firestore.instance
        .collection('user_notifications')
        .document(widget.images[_currentIndex].auth_id)
        .collection("Notifications")
        .add({
      "id_user": widget.id,
      "other_user": widget.images[_currentIndex].auth_id,
      "time": new DateTime.now().millisecondsSinceEpoch,
      "accept": false,
      "read": false,
      "type": "connect"
    });

    //("notif_new/" + my_id)
    var gMessagesDbRef3 =
        FirebaseDatabase.instance.reference().child("notif_new");
    gMessagesDbRef3.update({widget.images[_currentIndex].auth_id: true});
    setState(() {
      widget.images[_currentIndex].show = false;
      if (widget.images.contains(widget.images[_currentIndex])) {
        widget.images.remove(widget.images[_currentIndex]);
        _itemCount = _itemCount - 1;
        number = number - 1;
      } else {}
    });
    connectedorno(_currentIndex);
  }

  ParseServer parse_s = new ParseServer();

  @override
  Widget build(BuildContext context) {



    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    Color loginGradientStart = Colors.blue[100];
    Color loginGradientEnd = Fonts.col_app;

    Widget passer = Container(
      height: 44.0,
      width: MediaQuery.of(context).size.width*0.42,


      child: RaisedButton(
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.all(
                Radius.circular(4.0),
              )),
          color: Colors.grey[100],
          highlightColor: Colors.grey[50],
          elevation: 1,
          highlightElevation: 4,


          //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 4.0),
            child:Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Icon(Icons.arrow_back_ios,size: 20,),
                Container(width: 8,),
                Text(
                  "Passer",
                  style: TextStyle(
                      color: Fonts.col_app,
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil().setSp(28)),
                ),
              ],
            )
          ),
          onPressed: () {
            _controller.next(animation: true);
          }),
    );

    Widget lgn = Container(
      width: MediaQuery.of(context).size.width*0.42,
      height: 44.0,


      child: MaterialButton(
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.all(
                Radius.circular(4.0),
              )),
          color: !widget.images[_currentIndex].wait
              ? Colors.grey[400]
              : Fonts.col_app_green,
          elevation: 1,

          splashColor: !widget.images[_currentIndex].wait
              ? Colors.grey[400]
              : Colors.grey[300],
          //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 4.0),
            child: Text(
              widget.images[_currentIndex].cnt,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: ScreenUtil().setSp(18)),
            ),
          ),
          onPressed: () {
            if (widget.images[_currentIndex].cnt == "Demande envoyée")
              return null;
            if (widget.images[_currentIndex].activate != false &&
                widget.images[_currentIndex].wait != false) {
              if (widget.images[_currentIndex].cnt ==
                 "Se connecter")
                show_connect();
              else
                confirm();
            }
          }),
    );

    return new Stack(fit: StackFit.expand, children: <Widget>[
      new Padding(
          padding: new EdgeInsets.only(top: 0.0),
          child: Column(
            children: <Widget>[
              Container(
                height: 24.0,
              ),
              buildSwiper(width, height),
            ],
          )),
      widget.images[_currentIndex].runtimeType.toString() == "MyView"
          ? Container()
          : _currentIndex % number == 0 && _currentIndex != 0
              ? new Container()
              : new Positioned(
                  bottom: 16.0,
                  left: 8.0,
                  right: 8.0,
                  child: new Center(
                      //alignment: Alignment.center,
                      child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      passer,
                      new Container(width: 12.0),
                      widget.images[_currentIndex].runtimeType.toString() !=
                                  "User" &&
                              widget.images[_currentIndex].runtimeType
                                      .toString() !=
                                  "MyView"
                          ? new LikePartnerButton(widget.images[_currentIndex],
                              widget.user_me,)
                          : lgn
                    ],
                  )), /*new RaisedButton(child: new Text("jdjdjd"),
        onPressed: (){
          print(_currentIndex);
        },)*/
                )
    ]);
  }
}
