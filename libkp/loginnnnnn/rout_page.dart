import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:ifdconnect/app/config/config_url.dart';
import 'package:ifdconnect/login/choose_role.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ifdconnect/login/disactive_widget.dart';
import 'package:ifdconnect/login/inactive.dart';
import 'package:ifdconnect/slides2/slides.dart';
import 'package:ifdconnect/widgets/splash_screen.dart';
import 'package:ifdconnect/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:ifdconnect/services/location_services.dart';

import 'package:ifdconnect/slides2/homeslides.dart';
import 'package:ifdconnect/widgets/no_gps.dart';
import 'package:ifdconnect/widgets/no_wifi.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ifdconnect/chat/chatscreen.dart';
import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/func/users_info.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/services/auth.dart';
import 'package:ifdconnect/notifications/invite_view_user.dart';
import 'package:ifdconnect/widgets/bottom_menu.dart';

class RootPage extends StatefulWidget {
  RootPage({this.sign, this.analytics, this.observer});

  var sign;
  var analytics;
  var observer;

  @override
  State<StatefulWidget> createState() => _RootPageState();
}

enum AuthStatus {
  notSignedIn,
  signedIn,
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.notSignedIn;
  BaseAuth auth = Auth();
  int actif = 0;
  String com_id = "";
  String com_name = "";
  Usernfo user_info = new Usernfo();
  User user_me = new User();
  ParseServer parse_s = new ParseServer();
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  //List list_partner;
  bool wait = true;
  int state = 0;
  List list_partners;
  final Connectivity _connectivity = new Connectivity();

  bool connect = true;
  bool reload = false;
  bool load = true;

  getUserInfo(id, show) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    print(
        "-----------------------------------------------------------------------------");
    print(prefs.getString("enter").toString());

    if (prefs.getString("enter").toString() == "null") {
      setState(() {
        wait = false;
        state = -1;
      });
    } else {
      var response = await parse_s
          .getparse('users?where={"id1":"$id"}&include=user_formations,role');



      if (!this.mounted) return;

      if (response == "No")
        setState(() {
          connect = false;
        });
      else
        print("@@@");
      setState(() {
        connect = true;
        user_me = new User.fromMap(response["results"][0]);

        if (user_me.active == 0) {
          setState(() {
            state = 5;
            wait = false;
          });
        } else if (user_me.active == -1) {
          setState(() {
            state = 7;
            wait = false;
          });
        } else if (show == true) {
          prefs.setString("user", json.encode(response["results"][0]));
          _firebaseMessaging.subscribeToTopic('publication');

          setState(() {
            wait = false;
            state = 1;
          });
        }
      });
    }
  }

  not() {}

  //    permissions();

  String _platformVersion;

  /* getvideos() async {
    var response = await http.get('http://51.38.33.9:8070/api/search');
    if (!this.mounted) return;


    print("000JJJJJJ");
    var a = json.decode(response.body);


    for(var i in a["results"] ){

      print(i["link"]);
      print(i["title"]);
      print(i["img"]);
      print(i["num_views"]);
      print(i["release_date"]);

      await parse_s.postparse("videos", i);

    }




  }*/

  receivenotification(message) async {
    String my_id = await auth.currentUser();
    await getUserInfo(my_id, false);

    if (message["keyy"] == "msg") {
      Navigator.push(context,
          new MaterialPageRoute(builder: (BuildContext context) {
            return new ChatScreen(
                message["my_key"].split("_")[1],
                message["my_key"].split("_")[0],
                list_partners,
                false,
                auth,
                widget.analytics,
                user: user_me);
          }));
    } else if (message["keyy"] == "connect") {
      //posts[index].auth_id, posts[index].notif_id,id,widget.user_me,
      Navigator.push(context,
          new MaterialPageRoute(builder: (BuildContext context) {
            return new Invite_view(
                message["sent_id"],
                message["id_notification"],
                my_id,
                user_me,
                true,
                not,
                auth,
                widget.sign,
                list_partners,
                null,
                null,
                widget.analytics);
          }));
    } else {
      Navigator.push(context,
          new MaterialPageRoute(builder: (BuildContext context) {
            return new Invite_view(
                message["sent_id"],
                message["id_notification"],
                my_id,
                user_me,
                false,
                not,
                auth,
                widget.sign,
                [],
                null,
                null,
                widget.analytics);
          }));
    }
    //});
  }

  Future<String> _fcmSetupAndGetToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await _firebaseMessaging.getToken().then((token) {
      prefs.setString("token", token);
    });
  }

  get_info(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      connect = true;
      list_partners = [];
      wait = false;
    });

    print("---------------JJJJJ-------------------------------------");
    print(prefs.getString('user'));

    /*if (prefs.getString("enter").toString() == "null") {
      setState(() {
        state = -1;
      });
    } else*/
    if (prefs.getString('user').toString() != "null") {
      setState(() {
        wait = true;
      });
      if (id != null) {
        await getUserInfo(id, true);
      }
    } else {
      if (prefs.getString('enter').toString() != "null") {
        setState(() {
          state = 3;
        });
      } else {
        setState(() {
          state = -1;
        });
      }
    }
  }

  bool gps_exist = true;

  verify_gps() async {
    //await  permissions();

    bool gps_op = await Location_service.verify_location();
    if (gps_op)
      setState(() {
        gps_exist = true;
      });
    else {
      setState(() {
        gps_exist = false;
      });
      /* Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (BuildContext context) => new NoGps(verify_gps, null),
          ));*/
    }
  }

  init() async {
    // initConnectivity();
    //getUsers();
    await verify_gps();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        //receivenotification(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        receivenotification(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        receivenotification(message);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });

    _fcmSetupAndGetToken();

    auth.currentUser().then((userId) {
      print("isjsijsijsisjsiodsjiodjihdio");
      print(userId);

      get_info(userId);

      if (userId == null) {
        setState(() {
          authStatus = AuthStatus.notSignedIn;
        });
      } else {
        setState(() {
          authStatus = AuthStatus.signedIn;
        });

        // conditions();
      }
    });
  }

  reload_page() {
    setState(() {
      load = false;
    });

    print(
        "-------------------------------------------------------------------------------------------");
    new Timer(new Duration(seconds: 3), () {
      setState(() {
        load = true;
      });
    });
  }

  int weekNumber(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

  get_connect() async {
    //print(DateTime.now().hour);

    var response =
    await parse_s.getparse('connect?where={"accepted":true}&limit=2000');

    for (var i in response["results"]) {
      DateTime dte = DateTime.parse(i["createdAt"]);

      print(dte.weekday);

      await parse_s.putparse("connect/" + i["objectId"], {
        "year": dte.year,
        "dte_a": dte.hour.toString() +
            "-" +
            weekNumber(dte).toString() +
            "-" +
            dte.day.toString() +
            "-" +
            dte.month.toString() +
            "-" +
            dte.year.toString()
      });
    }

    /*
       map["month"] = new DateTime.now().month;
    map["year"] = new DateTime.now().year;
     */
  }

  /* getusers_last() async {
    var response = await parse_s
        .getparse('users?limit=40000&include=role_user,user_formations');
    print("nooooooooo");

    print(response);
    for (var i in response["results"]) {
      print("nooooooooo");

      User user = new User.fromMap(i);
      print("yessssss");
      print(user);

      var js = {
        "objectId": user.id,
        "firstname": user.firstname,
        "fullname": user.fullname,
        "email": user.email,
        "phone": user.phone,
        "organisme": user.organisme,
        "titre": user.titre,
        "cmpetences": user.cmpetences,
        "community": user.community
      };

      String basicAuth =
          'Basic ' + base64Encode(utf8.encode("admin_emi" + ':' + "Emi2021"));

      print(
          "---------------------------------------------------------------------------------");
      print(i["objectId"].toString());
      var a = await clientHttp.put(
          "https://search.emiconnect.tk/users_emi/user/" +
              i["objectId"].toString(),
          headers: {
            "Content-type": "application/json",
            HttpHeaders.authorizationHeader: basicAuth,
          },
          body: json.encode(js));

      print(a.body);
    }
  }*/

  initState() {
    super.initState();
    //   getusers_last();

    Parse().initialize(ConfigUrl.appId, ConfigUrl.url,
        // SharedPref is the default store
        appName: "EMI Connect",
        // sessionId: prefs.getString('session'),
        liveQueryUrl: ConfigUrl.url,
        /*  clientCreator: (
            {bool sendSessionId, SecurityContext securityContext}) =>
            ParseDioClient(
                sendSessionId: sendSessionId,
                securityContext: securityContext),
        clientKey: ConfigUrl.clientKey,*/
        autoSendSessionId: true);

    //getvideos();

    // SearchApis.searchposts("jihad");
    //get_connect();

    init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _signedIn() {
    authStatus = AuthStatus.signedIn;
  }

  void _signedOut() {
    authStatus = AuthStatus.notSignedIn;
  }

  got() {
    print("-----staaaaate---------------------------");
    print(state);
    switch (state) {
      case -1:
        return new Homeslides();
      case 1:
        return new BottomNavigation(
            auth, _signedIn, user_me, [], true, widget.analytics);
        break;
      case 7:
        return new ActiveWidget();
      case 5:
        return new InactiveWidget([], user_me.id);
      case 3:
        return new CChooseRole();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return !connect
        ? NoWifi(init, true)
        : gps_exist == false
        ? Scaffold(body: new NoGps(verify_gps, null))
        : wait
        ? Scaffold(
      //backgroundColor: Colors.grey[100],
        body: SplashScreen())
        : got();
  }
}
