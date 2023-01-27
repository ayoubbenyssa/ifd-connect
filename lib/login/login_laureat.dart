import 'package:firebase_auth/firebase_auth.dart';
import 'package:ifdconnect/login/register.dart';
import 'package:ifdconnect/models/role.dart';
import 'package:flutter/material.dart';
import 'package:ifdconnect/login/login.dart';

import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ifdconnect/widgets/custom_widgets/app_textfield.dart';
import 'package:ifdconnect/widgets/custom_widgets/primary_button.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';

import 'package:ifdconnect/login/inactive.dart';
import 'package:ifdconnect/models/community.dart';
import 'package:ifdconnect/user/edit_my_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/services/auth.dart';
import 'package:ifdconnect/services/routes.dart';
import 'package:ifdconnect/services/validators.dart';
import 'package:ifdconnect/widgets/widgets.dart';
import 'package:ifdconnect/func/parsefunc.dart';
import 'package:flutter/services.dart';

class LoginLaureat extends StatefulWidget {
  LoginLaureat(this.role);

  Role role;

  BaseAuth auth;
  VoidCallback onSignedIn;
  List list_partner;
  var analytics;

  @override
  _LoginLaurState createState() => new _LoginLaurState();
}

class _LoginLaurState extends State<LoginLaureat> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool _autovalidate = false;
  FocusNode _focuspassword = new FocusNode();
  FocusNode _focusemail = new FocusNode();
  final _passcontroller = new TextEditingController();
  final _emailcontroller = new TextEditingController();
  User user = new User();
  var deviceSize;
  String _authHint = '';
  ParseServer parse_s = new ParseServer();
  SharedPreferences prefs;
  var res;
  String token = "";
  bool load = false;
  AuthResult userId;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // var lat, lng;
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

//Position position;

  var currentLocation = <String, double>{};
  var location = new Location();
  StreamSubscription<Map<String, double>> _locationSubscription;

  /*getLocation() async {
    _locationSubscription =
        location.onLocationChanged().listen((Map<String, double> result) {
      if (!this.mounted) return;
      lat = currentLocation["latitude"];
      lng = currentLocation["longitude"];
    });

    try {
      currentLocation = await location.getLocation();
      print(currentLocation);

      lat = currentLocation["latitude"];
      lng = currentLocation["longitude"];
    } on PlatformException {
      print("noooooo");

      setState(() {});
      // showInSnackBar("Veuillez activer votre GPS");
    }
  }*/

  @override
  initState() {
    // getLocation();
    super.initState();
  }

  void showInSnackBar(String value) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(value),
      backgroundColor: Colors.red[900],
    ));
  }

  static onLoading(context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => new Dialog(
              child: new Container(
                padding: new EdgeInsets.all(16.0),
                width: 60.0,
                color: Colors.blue[200],
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    new CircularProgressIndicator(),
                    new Container(height: 8.0),
                    new Text(
                      "En cours ...",
                      style: new TextStyle(color: Colors.indigo[600]),
                    ),
                  ],
                ),
              ),
            ));
  }

  Community co;
  Distance distance = new Distance();

  /*getLoc(com_key) async {
    try {
      List pos = await Location_service.getLocation();
      var ref = FirebaseDatabase.instance.reference();
      ref.child('communities/' + com_key + "/").onValue.listen((Event ev) {
        co = new Community.fromMap(ev.snapshot.value, com_key);



        nearDistance(pos[0], pos[1]);
      });
    } on PlatformException {
      showInSnackBar("Veuillez activer votre GPS");
    }
  }*/

  /*/nearDistance(lat, lng) async {
    // await getLocation();
    print(co.other_distance);
  //  if (co.other_distance <= 3)
      Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (BuildContext context) => new EditMyProfile(
                widget.auth,
                widget.onSignedIn,
                lat,
                lng,
                widget.list_partner,
                co,
                widget.analytics),
          ));

  }*/

  go_home(user) async {
    prefs.setString("user", json.encode(res["results"][0]));

    var res2 = res["results"][0];

    var js = {"token": token, "emi": true};

    parse_s.putparse("users/" + user.id, js);
    await Firestore.instance
        .collection('user_notifications')
        .document(userId.user.uid)
        .setData({
      "send": "yes",
      "my_token": token,
      "name": res2["firstname"] + "  " + res2["familyname"],
      "image": res2["photoUrl"]
    });

    setState(() {
      load = false;
    });
    prefs.setString("id", res2["objectId"]);
    prefs.setString("user", json.encode(res["results"][0]));

    Routes.goto_home(context, widget.auth, widget.onSignedIn, user,
        widget.list_partner, true, widget.analytics);
  }

  void _handleSubmitted() async {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      showInSnackBar("Veuillez corriger les erreurs en rouge");
    } else {
      setState(() {
        load = true;
      });
      try {
        userId = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _emailcontroller.text, password: _passcontroller.text);

        if (!mounted) return;

        setState(() {
          _authHint = '';
        });
        //
        token = await _firebaseMessaging.getToken();

        res = await parse_s.getparse(
            'users?where={"id1":"${userId.user.uid}"}&include=user_formations,role');
        var res2 = res["results"][0];
        User user = new User.fromMap(res["results"][0]);
        prefs = await SharedPreferences.getInstance();
        prefs.setString("id", res["results"][0]["objectId"]);

        if (user.auth_id == "AfnG0de197PYPetjdsZlhu2AO2N2") {
          parse_s.putparse("users/" + user.id, {"token": token});
          await Firestore.instance
              .collection('user_notifications')
              .document(userId.user.uid)
              .setData({
            "send": "yes",
            "my_token": token,
            "name": res2["firstname"] + " " + res2["familyname"],
            "image": res2["photoUrl"]
          });

          setState(() {
            load = true;
          });
          prefs.setString("id", res2["objectId"]);
          prefs.setString("user", json.encode(res["results"][0]));

          Routes.goto_home(context, widget.auth, widget.onSignedIn, user,
              widget.list_partner, true, widget.analytics);
        } else if (user.active != 1) {
          // Navigator.of(context, rootNavigator: true).pop('dialog');

          setState(() {
            load = false;
          });
          /*if (user.active == -2) {

            print(user);

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => new LoginPage(user, go_home, true,true)));
          } else*/
          if (user.active == -1) {
            Navigator.pushReplacement(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) =>
                        new InactiveWidget([], user.id)));
          } else {
            Navigator.pushReplacement(
                context,
                new MaterialPageRoute(
                  builder: (BuildContext context) => new EditMyProfile(
                      widget.auth,
                      widget.onSignedIn,
                      null,
                      null,
                      widget.list_partner,
                      null,
                      widget.analytics),
                ));
          }
        } else {
          go_home(user);
        }
      } catch (e) {
        //  Navigator.pop(context);
        // Navigator.of(context, rootNavigator: true).pop('dialog');
        setState(() {
          load = false;
        });
        print('Error: $e');
        print("error");

        print(e.message);

        if (e.details.toString() == "The password is invalid or the user does not have a password.") {
          setState(() {
            _authHint = "Le mot de passe n'est pas valide";
          });
        } else if (e.message.toString() ==
            "There is no user record corresponding to this identifier. The user may have been deleted.") {
          setState(() {
            _authHint =
                " il n'y aucun utilisateur enregistré avec cette adresse";
          });
        } else if (e.details.toString() == "The email address is badly formatted."){

          setState(() {
            _authHint =
            "L'adresse email n'est pas valide";
          });

        } else {
          setState(() {
            _authHint = '${e.details.toString()}';
          });
        }

        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Validators val = new Validators(context: context);

    Widget hintText() {
      return _authHint == ""
          ? new Container()
          : new Container(
              //height: 80.0,
              padding: const EdgeInsets.all(0.0),
              child: new Text(_authHint,
                  key: new Key('hint'),
                  style: new TextStyle(fontSize: 13.0, color: Colors.red[700]),
                  textAlign: TextAlign.center));
    }

    Widget email = TextFieldWidget(
      "Email",
      _focusemail,
      _emailcontroller,
      TextInputType.emailAddress,
      val.validateid,
      suffixIcon: "",
    ) /*new Container(
        decoration: new BoxDecoration(
            border: new Border.all(color: Colors.grey, width: 1.0),
            borderRadius: new BorderRadius.circular(12.0)),
        child: Widgets.textfield("Email", _focusemail, user.email,
            _emailcontroller, TextInputType.emailAddress, val.validateEmail))*/
        ;

    Widget password = TextFieldWidget("Mot de passe", _focuspassword,
            _passcontroller, TextInputType.text, val.validatePassword,
            obscure: true,
            suffixIcon:
                "assets/icons/Lock.svg") /*new Container(
        decoration: new BoxDecoration(
            border: new Border.all(color: Colors.grey, width: 1.0),
            borderRadius: new BorderRadius.circular(12.0)),
        child: Widgets.textfield("Mot de passe", _focuspassword, user.password,
            _passcontroller, TextInputType.text, val.validatePassword,
            obscure: true))*/
        ;

    var style = new TextStyle(
        color: const Color(0xffeff2f7),
        fontSize: 14.0,
        fontWeight: FontWeight.w600);

    var style2 = new TextStyle(
        color: Fonts.col_app, fontSize: 14.0, fontWeight: FontWeight.w600);

    Widget btn_log = Container(
        width: MediaQuery.of(context).size.width * 0.76,
        // height: ScreenUtil().setHeight(50),
        padding: new EdgeInsets.only(left: 12.0, right: 12.0),
        child: PrimaryButton(
          disabledColor: Fonts.col_grey,
          fonsize: 14.5.sp,
          icon: "",
          prefix: Container(),
          color: Fonts.col_app,
          text: "Se connecter",
          isLoading: load,
          onTap: () {
            _handleSubmitted();
          },
        ));
    /*new Container(
        height: 40.0,
        padding: new EdgeInsets.only(left: 6.0, right: 6.0),
        child: new Material(
            elevation: 2.0,
            shadowColor: Fonts.col_app_fon,
            borderRadius: new BorderRadius.circular(8.0),
            color: Fonts.col_app_fonn,

            /*decoration: new BoxDecoration(
            border: new Border.all(color: const Color(0xffeff2f7), width: 1.5),
            borderRadius: new BorderRadius.circular(6.0)),*/
            child: new MaterialButton(
                // color:  const Color(0xffa3bbf1),
                onPressed: () {
                  print("jjojo");
                  _handleSubmitted();
                },
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    load
                        ? Container(
                            width: 20,
                            height: 20,

                            // padding: EdgeInsets.all(8),
                            child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Colors.white),
                            ))
                        : new Image.asset(
                            "images/log.png",
                            width: 25.0,
                            height: 25.0,
                            fit: BoxFit.cover,
                          ),
                    new Container(
                      width: 8.0,
                    ),
                    //  new Container(height: 36.0,color: Colors.white,width: 1.5,),
                    new Container(
                      width: 8.0,
                    ),
                    new Text("SE CONNECTER   ", style: style)
                  ],
                ))));*/
    deviceSize = MediaQuery.of(context).size;

    /**
        Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor: Colors.white,elevation: 0),
        key: _scaffoldKey,
        body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[


     */
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        key: _scaffoldKey,
        body: new Form(
            key: _formKey,
            autovalidate: _autovalidate,
            //onWillPop: _warnUserAboutInvalidData,
            child: new Container(
                padding: new EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                          height: 12.0,
                        ),
                        ClipRRect(
                            borderRadius: BorderRadius.circular(24.0),
                            child: Center(
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
                        new Container(height: 24.0.h),
                        email,
                        new Container(height: 12.0),
                        password,
                        new Container(height: 8.0),
                        Container(

                            // width: MediaQuery.of(context).size.width*0.28,

                            child: new InkWell(
                                onTap: () {
                                  Routes.goto(
                                    context,
                                    "reset",
                                    widget.auth,
                                    widget.onSignedIn,
                                    widget.list_partner,
                                    widget.analytics,
                                  );
                                },
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    new Expanded(child: new Container()),
                                    new Text(
                                      "Vous oubliez le mot de passe ?",
                                      style: new TextStyle(
                                          color: Fonts.col_app_grey,

                                          decoration: TextDecoration.underline),
                                    )
                                  ],
                                ))),
                        new Container(height: 32.0),
                        Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(32.r)),
                              border: new Border.all(
                                  color: Fonts.col_app_fon, width: 1.5),
                            ),
                            child: FlatButton(
                                onPressed: () {
                                  InfoUser info = InfoUser(role: widget.role);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Register(info)));
                                },
                                child: Text("Inscription",
                                    style: TextStyle(
                                      fontFamily: 'Hbold',
                                      fontSize: ScreenUtil().setSp(14.5),
                                      color: Fonts.col_app_fon,
                                    )))),
                        new Container(height: 8.0),
                        btn_log,
                        new Container(height: 8.0),
                        hintText(),
                        new Container(height: 8.0),
                        new Container(height: 8.0),
                        new Container(height: 8.0),
                      ]),
                ))));
  }
}
