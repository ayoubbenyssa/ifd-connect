import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/teeeeest.dart';
import 'package:ifdconnect/widgets/custom_widgets/buttons_appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ifdconnect/annonces/add_annonces.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/parc_events_stream/parc_events_stream.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class AnnoncesTabs extends StatefulWidget {
  AnnoncesTabs(this.user, this.auth, this.sign, this.lat, this.lng,
      this.list_partner, this.index, this.analytics);

  User user;
  var auth;
  var sign;
  var lat;
  var lng;
  int index;
  var analytics;

  List list_partner;

  @override
  _AnnoncesTabsState createState() => _AnnoncesTabsState();
}

class _AnnoncesTabsState extends State<AnnoncesTabs>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  TabController tabController;

  bool _menuShown = false;
  int indx = 0;
  List _list = [];
  String selectedValue = "Offres Stages/Emplois";



  st(i) {
    setState(() {
      indx = i;
    });
    ld(i);
  }

  ld(i) {
    setState(() {
      selectedValue = _list[i]["name"];
    });
    //com = value;
    // Reload();
  }
  display_slides() async {
    //Restez informés sur  tout ce qui se passe au sein de votre communauté à travers l’actualité et les événements.
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString("an") != "an") {
      new Timer(new Duration(seconds: 1), () {
        setState(() {
          _menuShown = true;
        });

        prefs.setString("an", "an");
      });
    }
  }

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    // TODO: implement initState
    _list = [
      {"name": "Offres Stages/Emplois"},
      {"name": "Objets perdus"},
    ];
    // tabController = TabController(length: 2, vsync: this);
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


    return DefaultTabController(
        initialIndex: widget.index,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            titleSpacing: 0.0,
            toolbarHeight: 120.h ,
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
                    "images/appointment.png",
                    color: Colors.white,
                    width: 23.5.w,
                    height: 25.5.h,
                  ),              Container(width: 7.w,),
                  Padding(
                    padding: const EdgeInsets.only(top: 10,bottom:10),
                    child: Text(
                      "Annonces",
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
            bottom: PreferredSize(
                child: Container(
                    color: Fonts.col_app,
                    padding: EdgeInsets.all(0),
                    margin: EdgeInsets.all(0),
                    child :  ClipRRect(
                      borderRadius: BorderRadius.only(topRight : Radius.circular(39.r)),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 1.w,
                        color: Colors.white,
                        child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 15.w,vertical: 5.h ),
                            height: 50.0.h,
                            child: ButtonsTabBar(
                              backgroundColor: Fonts.col_app,
                              radius: 42.r,
                              contentPadding: EdgeInsets.all(6.w),
                              borderWidth: 1.0,
                              // controller: animationController,
                              borderColor: Fonts.col_app,
                              unselectedBorderColor: Fonts.col_app_fon,
                              unselectedBackgroundColor: Colors.white,
                              unselectedLabelStyle:
                              TextStyle(color: Fonts.col_app_fon, fontSize: 16.sp),
                              labelStyle: TextStyle(
                                  fontSize: 16.0.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              onPressed: st,
                              tabs: _list.map((a) => new
                              Tab(text: a["name"])).toList(),
                            )),
                      ),
                    )
                ))
            // TabBar(
            //   isScrollable: true,
            //   labelStyle: new TextStyle(color: Fonts.col_app_green),
            //   indicatorPadding: new EdgeInsets.all(0.0),
            //   tabs: [
            //     new Tab(text: "Offres Stages/Emplois"),
            //   //  Tab(text: "Achat / Vente"),
            //     Tab(text: "Objets perdus"),
            //   ],
            // ),
          ),
          body: Stack(
            children: <Widget>[
              TabBarView(
                children: [
                  new StreamParcPub(
                    new Container(),
                    widget.lat,
                    widget.lng,
                    widget.user,
                    "1",
                    widget.list_partner,
                    widget.analytics,
                    type: "Offres Stages/Emplois_emi",
                    favorite: false,
                    boutique: false,
                  ),

               /*   new StreamParcPub(
                    new Container(),
                    widget.lat,
                    widget.lng,
                    widget.user,
                    "1",
                    widget.list_partner,
                    widget.analytics,
                    type: "Achat / Vente_emi",
                    favorite: false,
                    boutique: false,
                  ),*/
                  new StreamParcPub(
                    new Container(),
                    widget.lat,
                    widget.lng,
                    widget.user,
                    "0",
                    widget.list_partner,
                    widget.analytics,
                    type: "Objets perdus_emi",
                    favorite: false,
                    boutique: false,
                  )
                ],
              ),

            ],
          ),

        ));
  }
}
