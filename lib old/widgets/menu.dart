import 'dart:async';
import 'dart:convert';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:ifdconnect/campus/employee/emploiDuTemp/Time_tables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ifdconnect/campus/employee/notes_absence/Batch_List.dart';
import 'package:ifdconnect/campus/employee/notes_absence/Batch_List_Absences.dart';
import 'package:ifdconnect/campus/etudiant/absences/AbsencesPage.dart';
import 'package:ifdconnect/campus/etudiant/emploiDuTemp/Time_tables.dart';
import 'package:ifdconnect/campus/etudiant/home/Accueil.dart';
import 'package:ifdconnect/campus/etudiant/news/News.dart';
import 'package:ifdconnect/campus/etudiant/releve/Modules.dart';
import 'package:ifdconnect/campus/login/LoginPage.dart';
import 'package:ifdconnect/config/config.dart';
import 'package:ifdconnect/cours/cours_student.dart';
import 'package:ifdconnect/fils_actualit/stream_posts.dart';
import 'package:ifdconnect/home/events.dart';
import 'package:ifdconnect/restauration/RestaurantAccueil.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/services/campus_services.dart';
import 'package:ifdconnect/services/cours_services.dart';
import 'package:ifdconnect/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ifdconnect/annonces/annonces_tabs.dart';
import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/home/conventions.dart';
import 'package:ifdconnect/home/parc.dart';
import 'package:ifdconnect/models/offers.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/payments/payment.dart';
import 'package:ifdconnect/services/auth.dart';
import 'package:ifdconnect/services/routes.dart';
import 'package:ifdconnect/shop/principal.dart';
import 'package:ifdconnect/widgets/header_menu.dart';
import 'package:ifdconnect/home/publications.dart';
import 'package:ifdconnect/widgets/invite_friends.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';

var API_KEY = "AIzaSyDCB1z3cOQuIaf9LxLI6adVYjsSJC5TpDU";

class Menu extends StatefulWidget {
  Menu(this.user, this.id, this.auth, this.onSignedIn, this.lat, this.lng,
      this.list_partner, this.analytics);

  var auth;
  var onSignedIn;
  User user;
  String id;
  var lat;
  var lng;
  List list_partner;
  var analytics;

  @override
  _MenuState createState() => new _MenuState();
}

class _MenuState extends State<Menu> {
  var colo1 = Fonts.col_app;
  var colo2 = Color(0xffA5A5A5);
  bool chef_dept = false;

  /*Future<User> getcurrentuser() async {
    FirebaseUser a = await FirebaseAuth.instance.currentUser();
    id = a.uid;
    DocumentSnapshot snap =
    await Firestore.instance.collection('users').document(a.uid).get();
    setState(() {
      widget.user = new User.fromDocument(snap);
    });
    return new User.fromDocument(snap);
  }*/

  /**
   *
   * Map
   */

  /**
   *
   *
   * Map code
   *
   *
   *
   */

  /**
   *
   * Map code end
   */

  int token_user = 0;
  CampusServices cmp = new CampusServices();
  SharedPreferences prefs;
  String etud_prof = "";
  bool loadin = true;

  auth_api_school() async {
    print("yesssssssssss");
    print(
      widget.user.identifiant,
    );
    print(widget.user.password);
    final param = {
      "username": widget.user.identifiant,
      "password": widget.user.password.toString()
    };
    prefs = await SharedPreferences.getInstance();

    final loginData = await http.post(
      "${Config.url_api}/login",
      body: param,
    );

    var resBody = json.decode(loginData.body);
    prefs.setInt("token_user", resBody["auth_token"]);
    token_user = prefs.getInt("token_user");

    verify_login_campus();
  }

  verify_login_campus() async {
    prefs = await SharedPreferences.getInstance();
    token_user = prefs.getInt("token_user");

    setState(() {
      loadin = true;
    });

    widget.user.token_user = prefs.getInt("token_user");

    if (token_user.toString() != "null" && token_user != 0) {
      if (widget.user.employee_id.toString() != "null" &&
          widget.user.employee_id.toString() != "") {
        var prfile = await cmp.profile_emp(widget.user.user_id,
            widget.user.employee_id, prefs.getInt("token_user"));

        setState(() {
          loadin = false;
        });
        if (prfile == false) {
          auth_api_school();
        } else {
          setState(() {
            etud_prof = "Professeur";
            chef_dept = prfile["employee"]["employee"]["chef_dept"];
          });
        }
      } else {
        var prfile = await cmp.profile_etud(widget.user.user_id,
            widget.user.student_id, prefs.getInt("token_user"));

        setState(() {
          loadin = false;
        });

        if (prfile == false) {
          auth_api_school();
        } else {
          setState(() {
            etud_prof = "Étudiant";
          });
        }
      }
    } else {
      auth_api_school();
      setState(() {
        etud_prof = "";
      });
    }
  }

  /* verify_login_campus() async {
    prefs = await SharedPreferences.getInstance();
    token_user = prefs.getInt("token_user");

    setState(() {
      loadin = true;
    });

    widget.user.token_user = prefs.getInt("token_user");
    if (token_user.toString() != "null" && token_user != 0) {
      print("yesssss");

      if (widget.user.employee_id.toString() != "null" &&
          widget.user.employee_id.toString() != "") {
        var prfile = await cmp.profile_emp(widget.user.user_id,
            widget.user.employee_id, prefs.getInt("token_user"));

        print("yeskosksoksoksokso");
        print(widget.user.user_id);
        print(widget.user.employee_id);
        print(prefs.getInt("token_user").toString());
        print("yeskosksoksoksokso");
        setState(() {
          loadin = false;
        });
        if (prfile == false) {
          print("gdgdggd");
        } else {
          setState(() {
            etud_prof = "Professeur";
          });
        }
      } else {
        var prfile = await cmp.profile_etud(widget.user.user_id,
            widget.user.student_id, prefs.getInt("token_user"));

        print("yeskosksoksoksokso");
        print(widget.user.user_id);
        print(widget.user.student_id);
        print(prefs.getInt("token_user").toString());
        print("yeskosksoksoksokso");

        setState(() {
          loadin = false;
        });
        if (prfile == false) {
          setState(() {});
        } else {
          setState(() {
            etud_prof = "Étudiant";
          });
        }
      }
    } else {
      // login

      setState(() {
        etud_prof = "";
      });
    }
    // token_user
  }*/

  tap() {}

  @override
  void initState() {
    super.initState();
    if (widget.user.role.id != "9UHbnUrotk") verify_login_campus();
  }

  campus() async {
    /* User us = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                new LoginPage(widget.user, null, false, false,null)));
                  verify_login_campus();
    setState(() {
      widget.user = us;

      // login_etudiant = false;
    });

                */
  }

  @override
  Widget build(BuildContext context) {
    Widget powered = Container(
        padding: EdgeInsets.all(12.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          new RichText(
            text: new TextSpan(
              text: "Powered by: ",
              style: new TextStyle(color: Colors.grey[700]),
              children: <TextSpan>[
                /* new TextSpan(
                  recognizer: new TapGestureRecognizer()
                    ..onTap = () => Navigator.push(context,
                        new MaterialPageRoute<String>(builder: (BuildContext context) {
                          return   new WebviewScaffold(
                            url: "http://www.linkommunity.com/",
                            appBar: new AppBar(
                              title: new Text("Linkommunity"),
                            ),
                          );
                        },
                        )),
                  text:
                  "Linkcommunity",
                  style: new TextStyle(
                      fontWeight:
                      FontWeight
                          .bold,
                      color: Colors
                          .blue[
                      600])),*/
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.only(top: 4.0),
              child: InkWell(
                child: Image.asset(
                  "images/linko.png",
                  height: 22.0,
                  width: 120.0,
                ),
                onTap: () {
                  Navigator.push(context, new MaterialPageRoute<String>(
                      builder: (BuildContext context) {
                    return new WebviewScaffold(
                      url: "http://www.linkommunity.com/",
                      appBar: new AppBar(
                        title: new Text("Linkommunity"),
                      ),
                    );
                  }));
                },
              ))
        ]));

    Widget notif = new ListTile(
      onTap: () {
        // Routes.goto(context,"login");
      },
      leading: new Icon(Icons.notifications, color: colo1),
      title: new Text("Notifications", style: new TextStyle(color: colo2)),
    );

    Widget lst(img, text, tp, w, h) => ListTile(
          dense: true,
          contentPadding: EdgeInsets.only(left: 42),
          onTap: () {
            /* if (text == "Notes et Absences") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BatchesPage(widget.user.user_id,
                          widget.user.employee_id, widget.user.token_user)));
            }

           else */
            if (text == "Absences ") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BatchesPage_Absences(
                          widget.user,
                          widget.user.user_id,
                          etud_prof == "Etudiant"
                              ? widget.user.student_id
                              : widget.user.employee_id,
                          widget.user.token_user)));
            } else if (text == "Notes") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BatchesPage(
                          widget.user.user_id,
                          widget.user.employee_id,
                          widget.user.token_user,
                          chef_dept)));
            } else if (text == "Emploi du temps") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TimeTable(widget.user.user_id,
                          widget.user.student_id, widget.user.token_user)));
            } else if (text == "Restauration") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RestoAccuiel(widget.user.user_id,
                          widget.user.student_id, widget.user.token_user)));
            } else if (text == "Emploi du temps  ") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => new TimeTableEmployee(
                          widget.user.user_id,
                          widget.user.employee_id,
                          widget.user.token_user)));
            } else if (text == "Séances en ligne ") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CoursStudent(
                          widget.user,
                          widget.user.user_id,
                          widget.user.token_user,
                          "prof")));
            } else if (text == "Modules") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyHomePageNote(
                          'Les notes',
                          widget.user.user_id,
                          widget.user.student_id,
                          widget.user.token_user)));
            } else if (text == "Séance en ligne") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CoursStudent(
                          widget.user,
                          widget.user.user_id,
                          widget.user.token_user,
                          "student")));
            } else if (text == "News") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NewsPage(widget.user.user_id,
                          widget.user.student_id, widget.user.token_user)));
            } else if (text == "Absences") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AbsencePage(
                          widget.user,
                          widget.user.user_id,
                          widget.user.student_id,
                          widget.user.token_user)));
            } else {
              /* Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TimeTable(widget.user.user_id,
                          widget.user.student_id, widget.user.token_user)));*/
              /*
                MyHomePageNote('Les notes', widget._userId, widget._studentId, widget._token),
      NewsPage(widget._userId, widget._studentId, widget._token),
      AbsencePage(widget._userId, widget._studentId, widget._token),
      TimeTable(widget._userId, widget._studentId, widget._token),
           */
            }
          },
          /* leading: new Image.asset(
            img,
            color: colo1,
            width: w,
            height: h,
          ),*/
          title: new Text(text,
              style: new TextStyle(
                  color: colo2, fontFamily: "Hbold", fontSize: 15.sp)),
        );

    Widget parc = etud_prof != ""
        ? Container()
        : new ListTile(
            onTap: () {
              campus();
            },
            leading: new Image.asset(
              "images/pub.png",
              color: colo1,
              width: 25.0,
              height: 25.0,
            ),
            title: new Text("Campus", style: new TextStyle(color: colo2)),
          );

    Widget prof = widget.user.role.id == "NXiGscrffB"
        ? new Container(
            margin: EdgeInsets.all(8.w),
            decoration: new BoxDecoration(
              color: Color(0xffFAFAFA),
              border: new Border.all(color: Fonts.col_app, width: 1.0),
              borderRadius: new BorderRadius.circular(24.0.r),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: new ExpansionTile(
                initiallyExpanded: true,
                title: new ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.all(0),
                  leading: new Image.asset(
                    "images/professor.png",
                    color: colo1,
                    width: 25.0,
                    height: 25.0,
                  ),
                  title: new Text("Espace Professeur ",
                      style: new TextStyle(color: colo2)),
                ),
                children: <Widget>[
                  // lst("images/ab.png", "Notes et Absences", tap, 25.0, 25.0),
                  //lst("images/calen.png", "Emploi du temps  ", tap, 20.0, 20.0),
                  lst("images/evaluation.png", "Notes", tap, 25.0, 25.0),
                  lst("images/absent.png", "Absences ", tap, 25.0, 25.0),
                  lst("images/calen.png", "Emploi du temps  ", tap, 20.0, 20.0),
                  lst("images/dish.png", "Restauration", tap, 25.0, 25.0),

                  // lst("images/ab.png", "Séances en ligne ", tap, 25.0, 25.0),
                ],
              ),
            ),
          )
        : Container();

    Widget etudiant = etud_prof == "Étudiant"
        ? new Container(
            margin: EdgeInsets.all(8.w),
            decoration: new BoxDecoration(
              color: Color(0xffFAFAFA),
              border: new Border.all(color: Fonts.col_app, width: 1.0),
              borderRadius: new BorderRadius.circular(24.0.r),
            ),
            child: new ExpansionTile(
              initiallyExpanded: true,
              title: new ListTile(
                dense: true,
                contentPadding: EdgeInsets.all(0),

                /* Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EtudiantHome(
                                widget.user.user_id,
                                widget.user.student_id,
                                widget.user.token_user)));*/

                leading: new Image.asset(
                  "images/user.png",
                  color: colo1,
                  width: 25.0,
                  height: 25.0,
                ),
                title: new Text("Espace Étudiant",
                    style: new TextStyle(
                        color: Fonts.col_app, fontFamily: "Helvetica_neu")),
              ),
              children: <Widget>[
                /* new ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RestoAccuiel(widget.user.user_id,
                                widget.user.student_id, widget.user.token_user)));
                  },
                  leading: new Image.asset(
                    "images/dish.png",
                    color: colo1,
                    width: 29.0,
                    height: 29.0,
                  ),
                  title: new Text("Restauration", style: new TextStyle(color: colo2)),
                ),*/
                lst("images/dish.png", "Restauration", tap, 25.0, 25.0),
                lst("images/modules.png", "Modules", tap, 25.0, 25.0),
                // lst("images/modules.png", "Séance en ligne", tap, 25.0, 25.0),

                lst("images/nes.png", "News", tap, 20.0, 20.0),
                lst("images/ab.png", "Absences", tap, 25.0, 25.0),
                lst("images/calen.png", "Emploi du temps", tap, 20.0, 20.0),

                ///Étudiant
              ],
            ),
          )
        : Container();

    /**
     *
     *
     * if (resBody["student_id"] != null) {
        Navigator.push(
        context,
        MaterialPageRoute(
        builder: (context) => EtudiantHome(resBody["user_id"],
        resBody["student_id"], resBody["auth_token"])));
        } else {
        Navigator.push(
        context,
        MaterialPageRoute(
        builder: (context) => ProfHome(resBody["user_id"],
        resBody["employee_id"], resBody["auth_token"])));
        }
     */

    Widget Publication = new Container(
        margin: EdgeInsets.all(8.w),
        decoration: new BoxDecoration(
          color: Color(0xffFAFAFA),
          border: new Border.all(color: Fonts.col_app, width: 1.0),
          borderRadius: new BorderRadius.circular(38.0.r),
        ),
        child: new ListTile(
          dense: true,
          onTap: () {
            Navigator.push(context,
                new MaterialPageRoute(builder: (BuildContext context) {
              return new Publications(widget.lat, widget.lng, widget.user,
                  widget.list_partner, widget.auth, 0, widget.analytics);
            }));
          },
          leading: new Image.asset(
            "images/pp.png",
            color: colo1,
            width: 30.0,
            height: 30.0,
          ),
          title: new Text("Publications",
              style: new TextStyle(
                  color: colo1, fontSize: 15.sp, fontFamily: "Helvetica_neu")),
        ));

    Widget ev = new Container(
        margin: EdgeInsets.all(8.w),
        decoration: new BoxDecoration(
          color: Color(0xffFAFAFA),
          border: new Border.all(color: Fonts.col_app, width: 1.0),
          borderRadius: new BorderRadius.circular(38.0.r),
        ),
        child: new ListTile(
          dense: true,
          onTap: () {
            Navigator.push(context,
                new MaterialPageRoute(builder: (BuildContext context) {
              return new Events(widget.lat, widget.lng, widget.user,
                  widget.list_partner, widget.auth, 0, widget.analytics);
            }));
          },
          leading: new Image.asset(
            "images/cal.png",
            color: colo1,
            width: 30.0,
            height: 30.0,
          ),
          title: new Text("Évènements",
              style: new TextStyle(
                  color: colo1, fontSize: 15.sp, fontFamily: "Helvetica_neu")),
        ));

    Widget con = widget.user.role.id == "usspFD3SAw"
        ? Container()
        : new Container(
            margin: EdgeInsets.all(8.w),
            decoration: new BoxDecoration(
              color: Color(0xffFAFAFA),
              border: new Border.all(color: Fonts.col_app, width: 1.0),
              borderRadius: new BorderRadius.circular(38.0.r),
            ),
            child: new ListTile(
              dense: true,
              onTap: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (BuildContext context) {
                  return new Conventions(widget.lat, widget.lng, widget.user,
                      widget.list_partner, widget.analytics);
                }));
              },
              leading: new Image.asset(
                "images/mic.png",
                color: colo1,
                width: 30.0,
                height: 30.0,
              ),
              title: new Text("Conventions",
                  style: new TextStyle(
                      color: colo1,
                      fontSize: 15.sp,
                      fontFamily: "Helvetica_neu")),
            ));

    Widget ann = new ListTile(
      dense: true,
      onTap: () {
        Navigator.push(context,
            new MaterialPageRoute(builder: (BuildContext context) {
          return new AnnoncesTabs(widget.user, widget.auth, widget.onSignedIn,
              widget.lat, widget.lng, widget.list_partner, 0, widget.analytics);
        }));
        // Routes.goto(context,"login");
      },
      leading: new Image.asset(
        "images/ad.png",
        color: colo1,
        width: 29.0,
        height: 29.0,
      ),
      title: new Text("Annonces",
          style: new TextStyle(
              color: colo1, fontSize: 15.sp, fontFamily: "Helvetica_neu")),
    );

    Widget shop = new ListTile(
      dense: true,
      onTap: () {
        Navigator.push(context,
            new MaterialPageRoute(builder: (BuildContext context) {
          return new MyAppShop(widget.user, widget.lat, widget.lng,
              widget.list_partner, widget.analytics);
        }));
        // Routes.goto(context,"login");
      },
      leading: new Image.asset(
        "images/bag.png",
        color: colo1,
        width: 29.0,
        height: 29.0,
      ),
      title: new Text("Boutique", style: new TextStyle(color: colo2)),
    );

    Widget fils = new ListTile(
      onTap: () {
        Navigator.push(context,
            new MaterialPageRoute(builder: (BuildContext context) {
          return new StreamPots(widget.user, widget.lat, widget.lng,
              widget.list_partner, widget.analytics);
        }));
        // Routes.goto(context,"login");
      },
      leading: new Image.asset(
        "images/bag.png",
        color: colo1,
        width: 29.0,
        height: 29.0,
      ),
      title: new Text("Boutique", style: new TextStyle(color: colo2)),
    );

    make_user_offline() async {
      Map<String, dynamic> map = new Map<String, dynamic>();
      map["online"] = false;
      map["last_active"] = new DateTime.now().millisecondsSinceEpoch;
      Firestore.instance
          .collection('users')
          .document(widget.user.auth_id)
          .updateData(map);

      FirebaseDatabase.instance
          .reference()
          .child("status")
          .update({widget.user.auth_id: false});

      FirebaseDatabase.instance
          .reference()
          .child("status")
          .update({widget.user.auth_id: false});
    }

    Widget rest = new ListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RestoAccuiel(widget.user.user_id,
                    widget.user.student_id, widget.user.token_user)));
      },
      leading: new Image.asset(
        "images/dish.png",
        color: colo1,
        width: 29.0,
        height: 29.0,
      ),
      title: new Text("Restauration", style: new TextStyle(color: colo2)),
    );

    Widget share = new ListTile(
      onTap: () {
        //Invitrefriends
        // Routes.goto(context,"login");
        Navigator.push(context,
            new MaterialPageRoute(builder: (BuildContext context) {
          return new Invitrefriends();
        }));
      },
      leading: new Image.asset("images/ch.png",
          color: colo1, width: 25.0, height: 25.0),
      title: new Text("Invitez vos contacts à rejoindre IFD CONNECT",
          style: new TextStyle(color: colo2)),
    );

    /* Widget pro = new ListTile(
      onTap: () {
        // Routes.goto(context,"login");
        Navigator.push(context, new MaterialPageRoute(
            builder: (BuildContext context) {
              return new EditProfile(widget.auth,widget.onSignedIn);
            }));

      },
      leading: new Icon(Icons.settings, color:  colo),
      title: new Text("Mon Profil",style: new TextStyle(color: colo)),
    );*/

    ParseServer parse_s = new ParseServer();

    Widget logout = new ListTile(
      dense: true,
      onTap: () async {
        Widgets.onLoading(context);
        await make_user_offline();
        Firestore.instance
            .collection('user_notifications')
            .document(widget.user.auth_id)
            .updateData({"send": "no"});
        var js = {
          "token": "",
        };
        await parse_s.putparse("users/" + widget.user.id, js);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.clear();
        prefs.setString("enter", "yess");
        prefs.setString("cov", "cov");
        prefs.setString("homes", "homes");
        prefs.setString("con", "con");
        prefs.setString("par", "par");
        prefs.setString("pub", "pub");
        prefs.setString("shop", "shop");

        await FirebaseAuth.instance.signOut();
        Navigator.of(context, rootNavigator: true).pop('dialog');

        Routes.go_login(context);
      },
      leading: new Icon(Icons.exit_to_app, color: colo1),
      title: new Text("Déconnexion",
          style: new TextStyle(
              color: Fonts.col_app_red,
              fontFamily: "Helvetica_neu",
              fontSize: 15.sp)),
    );

    return new ListView(
      children: [
        widget.id.toString() == ""
            ? new Container()
            : new HeaderMenuDrawer(widget.user),
        Container(
          height: 8,
        ),
        (loadin &&
                widget.user.role.id != "9UHbnUrotk" &&
                widget.user.role.id != "rZWnnQTWIr")
            ? Center(child: CircularProgressIndicator())
            : Container(),
        prof,
        //widget.user.role == "Étudiant" ? rest : Container(),
        etudiant,
        Publication,
        ev,
        con,
        new Container(
            margin: EdgeInsets.all(8.w),
            decoration: new BoxDecoration(
              color: Color(0xffFAFAFA),
              border: new Border.all(color: Fonts.col_app, width: 1.0),
              borderRadius: new BorderRadius.circular(38.0.r),
            ),
            child: ann),
        // shop,

        //  share,
        // pro,
        new Container(
            margin: EdgeInsets.all(8.w),
            decoration: new BoxDecoration(
              color: Color(0xffFAFAFA),
              border: new Border.all(color: Fonts.col_app, width: 1.0),
              borderRadius: new BorderRadius.circular(38.0.r),
            ),
            child: logout),
        // Expanded(child: Container()),
        //  powered,
        Container(
          height: 12,
        )
      ],
    );
  }
}
