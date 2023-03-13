
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:ifdconnect/models/community.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/services/location_services.dart';
import 'package:ifdconnect/user/edit_my_profile.dart';
/*
class InactiveWidget extends StatefulWidget {
  InactiveWidget(
      this.com, this.auth, this.sign, this.list_partner, this.analytics);

  Community com;


  var auth;
  var sign;
  List list_partner;
  User user;
  var analytics;


  @override
  _InactiveWidgetState createState() => new _InactiveWidgetState();
}

class _InactiveWidgetState extends State<InactiveWidget> {
  bool loading = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Distance distance = new Distance();

  submit() {
    setState(() {
      loading = true;
    });
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  var pos;

  getLocation() async {


      pos = await Location_service.getLocation();


  }


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var style = new TextStyle(
        color: const Color(0xffeff2f7),
        fontSize: 20.0,
        fontWeight: FontWeight.w500);

    var style2 = new TextStyle(
        color: Colors.grey[700], fontSize: 20.0, fontWeight: FontWeight.w500);

    Widget ess = new Padding(
        padding: new EdgeInsets.only(left: 36.0, right: 36.0, top: 36.0),
        child: new Material(
            elevation: 4.0,
            shadowColor: Colors.grey[700],
            borderRadius: new BorderRadius.circular(8.0),
            color: Fonts.col_app,
            child: new MaterialButton(
                onPressed: () {
                  submit();
                  getLocation();
                  //nearDistance();
                },
                child: new Text("Réessayer", style: style))));


    Widget btn_log = new Padding(
        padding: new EdgeInsets.only(left: 36.0, right: 36.0, top: 36.0),
        child: new Material(
            elevation: 16.0,
            shadowColor: Colors.grey[700],
            borderRadius: new BorderRadius.circular(18.0),
            color: Fonts.col_app,
            child: new MaterialButton(
                onPressed: () {
                  // _handleSubmitted();
                  Navigator.pop(context);
                },
                child: new Text("Revenir en arrière", style: style))));

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
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // new Container(height:8.0),
              new Center(
                  child: new Image.asset(
                "images/logo.png",
                width: 200.0,
                height: 200.0,
              )),
              new Center(
                  child: new Text(
                "  Nous avons besoin de vérifier votre compte. "
                    "   " ,
                textAlign: TextAlign.center,
                style: new TextStyle(
                    color: Colors.grey[800], height: 1.2, fontSize: 16.0),
              )),
              new Container(height: 50.0),
              !loading
                  ? new Container()
                  : new SpinKitChasingDots(
                color: Fonts.col_gr,
                    ),
              btn_log
             // new Padding(
              //  padding: new EdgeInsets.all(32.0),
              ///  child: new Text("Ou"),
              //)
           //   ,
             // new Center(child: chng),
            ],
          ),
        ));
  }
}
//Revenir en arrière
*/