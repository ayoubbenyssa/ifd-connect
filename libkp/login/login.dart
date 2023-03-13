import 'dart:async';
import 'dart:convert';
import 'package:ifdconnect/config/config.dart';
import 'package:ifdconnect/widgets/custom_widgets/app_textfield.dart';
import 'package:ifdconnect/widgets/custom_widgets/primary_button.dart';
import 'package:ifdconnect/login/register.dart';
import 'package:ifdconnect/login/reset_password_role.dart';
import 'package:ifdconnect/models/role.dart';
import 'package:ifdconnect/widgets/bottom_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
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

class Login1 extends StatefulWidget {
  Login1(this._scf, {this.role});

  var _scf;
  Role role;
  BaseAuth auth;
  VoidCallback onSignedIn;
  List list_partner;
  var analytics;

  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login1> {
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
    widget._scf.currentState.showSnackBar(new SnackBar(
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
            builder: (BuildContext context) => new Reset_PasswordRole(
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

  /* login_func() async {
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
          'users?where={"id1":"$userId"}&include=user_formations,role');
      var res2 = res["results"][0];
      user = new User.fromMap(res["results"][0]);
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
          "name": res2["firstname"] + "  " + res2["familyname"],
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
      print(
          "1-------------------------------------------------------------------------");

      print('Error: $e');
      print("error");

      if (e.details.toString() ==
          "The password is invalid or the user does not have a password.") {
        print(
            "2-------------------------------------------------------------------------");

        AuthResult userI9 = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: user.email, password: user.password);
        FirebaseUser userf = await FirebaseAuth.instance.currentUser();

        //Pass in the password to updatePassword.
        userf.updatePassword(_passcontroller.text).then((_) {
          parse_s
              .putparse("users/" + user.id, {"password": _passcontroller.text});
          login_func();

          print("Successfully changed password");
        }).catchError((error) {
          print("Password can't be changed" + error.toString());
          //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
        });
      }
      if (e.details.toString() ==
          "The password is invalid or the user does not have a password.") {
        setState(() {
          _authHint = "Le mot de passe n'est pas valide";
        });
      } else if (e.details.toString() ==
          "There is no user record corresponding to this identifier. The user may have been deleted.") {
        setState(() {
          _authHint = " il n'y aucun utilisateur enregistré avec cette adresse";
        });
      } else {
        setState(() {
          _authHint = '${e.details.toString()}';
        });
      }

      print(e);
    }
  }*/

  auth_api_school(String identifiant, String password) async {

    prefs = await SharedPreferences.getInstance();

    print("#####################");
    print(identifiant.toString());
    print(password.toString());
    print("${prefs.getString('api_url')}");



    final param = {
      "username": identifiant.toString().toLowerCase().replaceAll(" ", ""),
      "password": password
    };
    prefs = await SharedPreferences.getInstance();
    //http://ifd-erp.tk http://ifd-erp.tk
    final loginData = await http.post(
      "${"${prefs.getString('api_url')}"}/login",
      body: param,
    );

    var resBody = json.decode(loginData.body.toString());
    print("%%%%%%%%%%%%%%%%%%%%%");
    print(resBody);
    print("!@@!@@!@@!@!@!@!@@!@!@!");

    // print(json.decode(resBody["student_data"]["user"].toString()));
    // print("%%%%%%%%%%%%%%%%%%%%%");

    if(resBody.containsKey("employee_data")){

      resBody['employee_data']['user'] = json.decode(resBody['employee_data']['user']);
      prefs.setBool("resto_api_check", resBody['employee_data']['user']['resto_api_check']??false) ;
      prefs.setString("resto_api_check_date", resBody['employee_data']['user']['resto_api_check_date']??null) ;

    }else{
      resBody['student_data']['user'] = json.decode(resBody['student_data']['user']);
      prefs.setBool("resto_api_check", resBody['student_data']['user']['resto_api_check']??false) ;
      prefs.setString("resto_api_check_date", resBody['student_data']['user']['resto_api_check_date']??null) ;

    }

    if (resBody["status"] == 1) {
      setState(() {
        _authHint = "";
      });

      if (resBody["type"] != widget.role.type) {
        setState(() {
          load = false;
        });
        showInSnackBar("Vous avez mal choisis le rôle d'utilisateur ! ");
      } else {
        var resultat = await parse_s.getparse(
            'users?where={"identifiant":"${_emailcontroller.text.toString().toLowerCase().replaceAll(" ", "")}"}&limit=1&count=1&include=user_formations,role');

        if (resultat["count"] == 0) {
          /// NNot exist so go to Inscription

          var js;
          InfoUser info;

          if (resBody.containsKey("employee_data")) {
            print(widget.role.id);

            js =  resBody["employee_data"]["user"] ;

            // js = json.decode(resBody["employee_data"]["user"]);

            info = InfoUser(
                first_name: js["first_name"],
                employee_id: resBody["employee_id"],
                email: js["email"],
                auth_token: resBody["auth_token"],
                identifiant:
                    _emailcontroller.text.toLowerCase().replaceAll(" ", ""),
                password: _passcontroller.text,
                role: widget.role,
                phone: js["phone2"],
                user_id: resBody["user_id"],
                last_name: js["last_name"]);
          } else {
            // print("@@@@@@@@@@@");
            // print(resBody["student_data"]["user"]);
            // print("@@@@@111@@@@@@");
            //
            // print(json.decode(resBody["student_data"]["user"].toString()));
            // print("@@@@@222@@@@@@");



            js =  resBody["student_data"]["user"] ;
            // print("@@@@@@@@@@@1111");

            info = InfoUser(
                first_name: js["first_name"].toString(),
                // employee_id: ,
                email: js["email"],
                auth_token: resBody["auth_token"],
                identifiant:
                    _emailcontroller.text.toLowerCase().replaceAll(" ", ""),
                password: _passcontroller.text,
                role: widget.role,
                phone: js["phone2"],
                sudent_id: resBody["student_id"],
                user_id: resBody["user_id"],
                last_name: js["last_name"]);
          }
          setState(() {
            load = false;
          });
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Register(info)));
        } else {
          user = new User.fromMap(resultat["results"][0]);

          prefs.setInt("token_user", resBody["auth_token"]);
          prefs.setInt("user_id", user.user_id);
          prefs.setInt("student_id", user.student_id);
          prefs.setInt("eployee_id", user.employee_id);

          print(_passcontroller.text);
          try {
            await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: user.email, password: _passcontroller.text);
            prefs.setString("user", json.encode(resultat["results"][0]));
            setState(() {
              load = false;
            });

            /// Exist so go to home
            Navigator.pushReplacement(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) => new BottomNavigation(
                        widget.auth,
                        widget.onSignedIn,
                        user,
                        [],
                        true,
                        widget.analytics))
            );
          } catch (e) {
            //  Navigator.pop(context);
            // Navigator.of(context, rootNavigator: true).pop('dialog');
            setState(() {
              load = false;
            });
            print( "1-------------------------------------------------------------------------");

            print(e.message.toString());
            if (e.message.toString() ==
                "The password is invalid or the user does not have a password.") {
              print(
                  "2-------------------------------------------------------------------------");
              print(user.password);
              print(_emailcontroller.text);



              AuthResult userrr = await FirebaseAuth.instance
                  .signInWithEmailAndPassword(
                      email: user.email, password: user.password);
              FirebaseUser userf = await FirebaseAuth.instance.currentUser();

              //Pass in the password to updatePassword.
              userf.updatePassword(_passcontroller.text).then((_) {
                parse_s.putparse("users/" + user.id, {"password": _passcontroller.text});







                auth_api_school(user.identifiant, _passcontroller.text);

                print("Successfully changed password");
              }).catchError((error) {
                print("Password can't be changed" + error.toString());
                //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
              });
            }
          }
        }
      }
    } else {
      ///false mot de passe
      setState(() {
        load = false;
        _authHint = "Votre identifiant ou mot de passe incorrect !";
      });
    }
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

      auth_api_school(_emailcontroller.text, _passcontroller.text);
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
      "Identifiant",
      _focusemail,
      _emailcontroller,
      TextInputType.text,
      val.validateid,
      suffixIcon: "",
    );
    /*Widgets.textfield("Identifiant", _focusemail, user.email,
            _emailcontroller, TextInputType.emailAddress, val.validateid)*/
    ;

    Widget password = TextFieldWidget("Mot de passe", _focuspassword,
            _passcontroller, TextInputType.text, val.validatePassword,
            obscure: true,
            suffixIcon: "assets/icons/Lock.svg") /*Widgets.textfield("Mot de passe", _focuspassword, user.password,
            _passcontroller, TextInputType.text, val.validatePassword,
            obscure: true)*/
        ;

    var style = new TextStyle(
        color: const Color(0xffeff2f7),
        fontSize: ScreenUtil().setSp(18.0),
        fontWeight: FontWeight.w500);

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
          onTap: ()  {
            _handleSubmitted();
          },
        )
        );
    deviceSize = MediaQuery.of(context).size;

    return new Center(
        child: new Container(
            //color: Colors.grey[50],

            child: new Stack(fit: StackFit.expand, children: <Widget>[
      /*  ListView(children: <Widget>[
                    new Container(
                        height: 870.0,
                        child: new LoginBackground(Widgets.kitGradients1))
                  ]),*/
      ListView(children: <Widget>[
        new Padding(
            padding: new EdgeInsets.only(left: 12.0, right: 12.0, bottom: 18.0),
            child: new Form(
                key: _formKey,
                autovalidate: _autovalidate,
                //onWillPop: _warnUserAboutInvalidData,
                child: new Container(
                    padding: new EdgeInsets.all(8.0),
                    child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Container(
                            height: 28.0.h,
                          ),
                          email,
                          new Container(height: 12.0),
                          password,
                          new Container(height: 8.0),
                          new Container(height: 8.0),
                          Container(

                              // width: MediaQuery.of(context).size.width*0.28,

                              child: new InkWell(
                                  onTap: () {
                                    print("oublier mot de pass");
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              new Reset_PasswordRole(),
                                        ));
                                  },
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      new Expanded(child: new Container()),
                                      new Text(
                                        "Vous oubliez le mot de passe ?",
                                        style: new TextStyle(
                                            color: Fonts.col_app_grey,
                                            decoration:
                                                TextDecoration.underline),
                                      )
                                    ],
                                  ))),
                          new Container(height: 32.0),
                          /* Container(

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
                                                    color: Colors.grey[700],
                                                    decoration:
                                                    TextDecoration.underline),
                                              )
                                            ],
                                          ))),*/
                          new Container(height: 32.0),
                          btn_log,
                          Container(height: 12),
                          hintText(),
                          new Container(height: 8.0),
                          /* FaceLogin(
                                    widget.list_partner,
                                    widget._scf,
                                    null,

                                  ),*/
                          new Container(height: 8.0),

                          /* new Container(
                                      height: 45.0,
                                      child: LoginWithGoogle(widget._scf,
                                          )),*/

                          new Container(height: 8.0),
                        ]))))
      ])
    ])));
  }
}

class InfoUser {
  int sudent_id;
  int user_id;
  int employee_id;
  String first_name;
  String last_name;
  Role role;
  String phone;
  String email;
  String password;
  String identifiant;
  var auth_token;

  InfoUser(
      {this.employee_id,
      this.first_name,
      this.last_name,
      this.role,
      this.phone,
      this.password,
      this.identifiant,
      this.email,
      this.sudent_id,
      this.auth_token,
      this.user_id});
}
