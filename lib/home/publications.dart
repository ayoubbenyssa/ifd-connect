import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/parc_events_stream/parc_events_stream.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/teeeeest.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Publications extends StatefulWidget {
  Publications(
      this.lat, this.lng, this.user, this.list_partner,this.auth,this.index,this.analytics);

  var lat, lng;
  User user;
  List list_partner;
 var auth;
 var index;
 var analytics;


  @override
  _ParcState createState() => _ParcState();
}

class _ParcState extends State<Publications> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  bool _menuShown = false;



  display_slides() async {
    //Restez informés sur  tout ce qui se passe au sein de votre communauté à travers l’actualité et les événements.
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString("pub") != "pub") {
      new Timer(new Duration(seconds: 1), () {
        setState(() {
          _menuShown = true;
        });

        prefs.setString("pub", "pub");
      });
    }
  }

  @override void initState() {
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
        children: <Widget>[DefaultTabController(
          initialIndex: widget.index,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),

            elevation: 0.0,
            titleSpacing: 0.0,
            toolbarHeight: 60.h ,
            leading: Container(
              color: Fonts.col_app,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            title: Container(
              padding: const EdgeInsets.only(top: 10,bottom:10),
              color: Fonts.col_app,
              child: Row(
                children: [
                  Image.asset(
                    "images/pp.png",
                    color: Colors.white,
                    width: 23.5.w,
                    height: 25.5.h,
                  ),              Container(width: 7.w,),
                  Padding(
                    padding: const EdgeInsets.only(top: 10,bottom:10),
                    child: Text(
                      "Publications",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w100,
                          fontSize: 18.0.sp),
                    ),
                  ),

                  Expanded(child: Container()),
                  Padding(
                      padding: EdgeInsets.all(8.w),
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10.r)),
                          child: Container(
                              height: 44.w,
                              width: 44.w,
                              color: Colors.white.withOpacity(0.9),
                              padding: EdgeInsets.all(0.w),
                              child: Image.asset(
                                "images/launcher_icon_ifd.png",
                              )))),
                  SizedBox(width: 22.w,),
                ],

              ),
            ),
          ),
            backgroundColor: Colors.white,
            body:
            new StreamParcPub(
              PreferredSize(
                     child: Container(
                       height: 20,
                         color: Fonts.col_app,
                         padding: EdgeInsets.all(0),
                         margin: EdgeInsets.all(0),
                         child :  ClipRRect(
                           borderRadius: BorderRadius.only(topRight : Radius.circular(39.r)),
                           child: Container(color: Colors.white,height: 20,),
              ))),
              widget.lat,
              widget.lng,
              widget.user,
              "0",
              widget.list_partner,
              widget.analytics,
              category: "news",
              cat: "Général",
              favorite: false,
              boutique: false,
              auth:widget.auth,
              context: context,

            )


        )),
        _menuShown== false?Container(): Positioned(
          child: FadeTransition(
            opacity: opacityAnimation,
            child: ShapedWidget(
                "Actualités et informations en continu selon vos centres d’intérêts",
                onp,120.0),
          ),
          right: 12.0,
          top: 86.0,
        ),

    ]);
  }
}
