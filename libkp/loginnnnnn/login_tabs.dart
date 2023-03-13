import 'package:ifdconnect/models/role.dart';
import 'package:flutter/material.dart';
import 'package:ifdconnect/login/login.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen(this.role);
  Role role;


  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int index = 0;

  setIndex() {
    setState(() {
      index = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(backgroundColor: Colors.white,elevation: 0),
            key: _scaffoldKey,
            body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

            ClipRRect(
                borderRadius: BorderRadius.circular(24.0),
                child:  Center(
                      child: Image.asset(
                        "assets/images/logo.png",
                    height: MediaQuery.of(context).size.height * 0.13,
                    fit: BoxFit.cover,
                  ))),
                  Container(
                    height: 18.h,
                  ),
                  Center(
                      child: Image.asset(
                        "assets/images/ifd.png",
                        width: 180.w,
                      )),
                  Expanded(child: Login1(_scaffoldKey,role: widget.role,))
                ])

            /*  Container(height: MediaQuery.of(context).size.height*0.08, child: TabBar(
           isScrollable: false,
           indicatorColor: Fonts.col_app_green,
           indicatorWeight: 5,
           unselectedLabelColor: Colors.grey,
           labelColor: Fonts.col_app,
           labelStyle: new TextStyle(color: Fonts.col_app,fontWeight: FontWeight.w700,fontSize: 15),
           indicatorPadding: new EdgeInsets.all(0.0),
           tabs: [
             new Tab(
                 text: "SE CONNECTER"),
             Tab(
                 text: "CRÉER UN COMPTE"),
           ],

         )),
     Expanded(child:  TabBarView(
        children: [

          Login1(_scaffoldKey),
          //,
       index==0?   CChooseRole(setIndex):Register(_scaffoldKey)

        ]))
        ],
      ),*/
            ));
  }
}
