import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:ifdconnect/teeeeest.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/login/login_w.dart';
import 'package:ifdconnect/models/myview.dart';
import 'package:ifdconnect/models/shop.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/partners_list.dart';
import 'package:ifdconnect/swiper_new/swiper_widget.dart';
import 'package:flutter/services.dart';
import 'package:latlong/latlong.dart';
import 'package:ifdconnect/widgets/no_wifi.dart';
import 'package:ifdconnect/widgets/widgets.dart';


class HomePage extends StatefulWidget {
  HomePage(this.auth, this.onSignedIn, this.lat, this.lng, this.user,
    this.list_partner, this.load,this.analytics);

  var auth;
  var onSignedIn;
  double lat;
  double lng;
  User user;
  List list_partner;
  var load;
  var analytics;

  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<HomePage> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  bool _menuShown = false;


  List<User> users = new List<User>();
  Distance distance = new Distance();
  double dis;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ParseServer parse_s = new ParseServer();
  bool gps_none = true;
  Map<String, dynamic> map = new Map<String, dynamic>();
  List<String> list = new List<String>();
  List<String> list2 = new List<String>();

  //Position position;
  var subscription;
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = new Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  List<dynamic> lst = new List<dynamic>();
  int skip = 0;
  int j = 0;


  Future<List<User>> getUsers() async {

    List<User> posts = [];
  }

  var lat, lng;
  var count;




  get_users_data() async {
    String id = widget.user.auth_id;
    String my_id = widget.user.id;

    try {
    lat = widget.lat;
    lng = widget.lng;



      print("---------------------------------------------------------lat-----------------------------------------------------");
      print(lat);


     /* if(widget.list_partner.toString()== "null" && widget.list_partner.isNotEmpty) {

        widget.list_partner = await PartnersList.get_list_partners();

      }*/


      String url = //"medz":true,
          'where={"emi":true,"active":1,"id1":{"\$dontSelect":{"query":{"className":"block","where":{"userS":{"\$eq":"$id"}}},"key":"blockedS"}},'
          '"idblock":{"\$dontSelect":{"query":{"className":"block","where":{"blockedS":{"\$eq":"$id"}}},"key":"userS"}},'
          '"objectId":{"\$dontSelect":{"query":{"className":"connect","where":{"send_requ":{"\$eq":"$my_id"}}},"key":"receive_req"}},'
          '"location": {"\$nearSphere": {"__type": "GeoPoint","latitude": $lat,"longitude":$lng}}}&limit=20&skip=$skip';

      var res = await parse_s.getparse('users?$url');

      List sp = res["results"];

     /* count =
          res["count"] + (res["count"] % 20) ~/ 3 + (res["count"] ~/ 20) * 6;*/

      List<User> usrs =
          sp.map((var contactRaw) => new User.fromMap(contactRaw)).toList();


      for (int i = 0; i < usrs.length; i++) {
        setState(() {
          lst.add(usrs[i]);
        });

       /* if (i % 5 == 0) {
          if (j == widget.list_partner.length) {
            j = 0;
          }
          setState(() {
            lst.add(widget.list_partner[j]);
            j++;
          });
        }*/
      }

      if (res["results"].length < 20) {
        lst.add(new MyView("", ""));
      }
    } on PlatformException {

    }
  }

  click() {
    setState(() {
      lst = [];
      skip = skip + 20;
    });
    getUserss();
  }

  getUserss() async {
    get_users_data();
  }


  @override
  void dispose() {
    //_connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<Null> initConnectivity() async {
    String connectionStatus;
    // Platform messages may
    //
    // fail, so we use a try/catch PlatformException.
    try {
      connectionStatus = (await _connectivity.checkConnectivity()).toString();

      if (connectionStatus != "ConnectivityResult.none") {
      }
    } on PlatformException catch (e) {
      connectionStatus = 'Failed to get connectivity.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    setState(() {
      _connectionStatus = connectionStatus;
    });
  }

  editloc() async {
    var res = await parse_s.getparse('shops?limit=500&skip=0');
    List sp = res["results"];
    List<Shop> usrs =
        sp.map((var contactRaw) => new Shop.fromMap(contactRaw)).toList();

    for (int i = 0; i < usrs.length; i++) {
      if (usrs[i].latLng.toString() != "null" &&
          usrs[i].latLng.toString() != "") {
        var js = {
          "type": "shop",
          "latLng": usrs[i].latLng,
          "description": usrs[i].description,
          "pictures": usrs[i].pic,
          "name": usrs[i].name,
          ""
              "location": {
            "__type": "GeoPoint",
            "latitude": double.parse(usrs[i].latLng.toString().split(";")[0]),
            "longitude": double.parse(usrs[i].latLng.toString().split(";")[1])
          },
          "lat": double.parse(usrs[i].latLng.toString().split(";")[0]),
          "lng": double.parse(usrs[i].latLng.toString().split(";")[1])
        };


        var resp = await parse_s.postparse("offers/", js);
      }
    }
  }

  gett() async {

    var response = await parse_s.getparse('offers?limit=1000');


    for (var i in response["results"]) {


      var js = {
        "union": true
      };
      parse_s.putparse("offers/" +i["objectId"], js);
    }
  }


  display_slides() async {
    //Restez informés sur  tout ce qui se passe au sein de votre communauté à travers l’actualité et les événements.
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if(prefs.getString("homes") != "homes") {
      new Timer(new Duration(seconds: 1), () {
        setState(() {
          _menuShown = true;
        });

        prefs.setString("homes","homes");
      });
    }
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    display_slides();
    getUserss();
    initConnectivity();
  }

  Widget sizb(wid) => Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
        child: Container(
          margin: new EdgeInsets.only(bottom: 7.0, top: 8.0),
          color: Colors.grey[100],
          height: 8.0,
          width: wid,
        ),
      );


  onp(){
    setState(() {
      _menuShown = false;
    });
  }

  @override
  Widget build(BuildContext context) {



    Animation opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(animationController);
    if (_menuShown)
      animationController.forward();
    else
      animationController.reverse();



    return Stack(
        overflow: Overflow.visible,
        children: <Widget>[


          Positioned.fill(child:_connectionStatus == "ConnectivityResult.none"
        ? NoWifi(initConnectivity,false)
        : new Container(
            decoration: new BoxDecoration(
                color: Colors.grey[50],
              ),
            child: new Stack(fit: StackFit.expand, children: <Widget>[

              new Container(
                  padding: new EdgeInsets.only(top: 8.0),
                  child: lst.isEmpty
                      ? new Center(
                          child: new Container(
                          color: Colors.grey[200],
                          padding: new EdgeInsets.only(
                              left: 12.0, right: 12.0, bottom: 12.0),
                          child: new Card(
                            elevation: 18.0,
                            child: new Center(
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  new Container(
                                    height: 16.0,
                                  ),
                                  SizedBox(
                                      width: 90.0,
                                      height: 90.0,
                                      child: Shimmer.fromColors(
                                        baseColor: Colors.grey[300],
                                        highlightColor: Colors.grey[100],
                                        child: CircleAvatar(
                                          backgroundColor: Colors.grey[100],
                                          radius: 48.0,
                                        ),
                                      )),
                                  new Container(
                                    height: 8.0,
                                  ),
                                  sizb(150.0),
                                  sizb(190.0),
                                  sizb(150.0),
                                  new Divider(
                                    color: Colors.grey[500],
                                  ),
                                  new Container(
                                    height: 8.0,
                                  ),
                                  new Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      new Container(
                                        width: 16.0,
                                      ),
                                      sizb(100.0),
                                      new Expanded(child: new Container()),
                                      sizb(100.0),
                                      new Container(
                                        width: 16.0,
                                      )
                                    ],
                                  ),
                                  new Container(
                                    height: 8.0,
                                  ),
                                  new Divider(
                                    color: Colors.grey[500],
                                  ),
                                  new Container(
                                    height: 8.0,
                                  ),
                                  sizb(100.0),
                                  sizb(190.0),
                                  sizb(190.0),
                                  new Container(
                                    height: 8.0,
                                  ),
                                  new Divider(
                                    color: Colors.grey[500],
                                  ),
                                  new Container(
                                    height: 8.0,
                                  ),
                                  sizb(100.0),
                                  sizb(190.0),
                                  sizb(190.0),
                                  new Container(
                                    height: 8.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ))
                      : new UserWid(
                          lst,
                          widget.user.auth_id,
                          lat,
                          lng,
                          widget.user.id,
                          widget.user,
                          click,
                          widget.auth,
                          widget.onSignedIn,
                          widget.list_partner,
                          count,
                          widget.load,
                          widget.analytics))
            ]),

          )),
       _menuShown== false?Container():  Positioned(
            child: FadeTransition(
              opacity: opacityAnimation,
              child: ShapedWidget("Bienvenu(e) dans votre communauté. Vous pouvez dès maintenant faire défiler les profils vers la gauche ou vers la droite, pour les liker cliquez sur Se connecter. Lorsque vous avez un match,"
                  " vous aurez alors la possibilité de dialoguer avec votre match..",onp,190.0),
            ),
            right: 12.0,
            top: 86.0,
          ),


        ]);
  }
}
