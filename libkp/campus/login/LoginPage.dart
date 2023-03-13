import 'package:ifdconnect/models/role.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/login/login_w.dart';
import 'package:ifdconnect/models/community.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:ifdconnect/campus/etudiant/home/Accueil.dart';
import 'package:ifdconnect/campus/employee/home/AccueilProf.dart';

class LoginPage extends StatefulWidget {
  LoginPage(this.user1, this.func, this.go, this.page, this.role, {this.co});

  bool go;
  var func;
  User user1;
  var co;
  Role role;

  //from login or editprofile
  var page;

  @override
  State createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  Animation<double> _iconAnimation;
  AnimationController _iconAnimationController;
  var resBody;
  String _username;
  String _password;
  String _messageError = "";
  ParseServer parse_s = new ParseServer();

  Future<bool> saveSessionVar(
      int user_id, int student_id, int auth_token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("user_id", user_id);
    prefs.setInt("student_id", student_id);
    prefs.setInt("auth_token", auth_token);
  }

  static onLoading(context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => new Dialog(
              child: new Container(
                padding: new EdgeInsets.all(16.0),
                width: 60.0,
                color: Fonts.col_app.withOpacity(0.5),
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

  set_session(token_user, id_user, id_student, employee_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("token_user", token_user);
    prefs.setInt("user_id", id_user);
    prefs.setInt("student_id", id_student);
    prefs.setInt("employee_id", employee_id);
    if (widget.role != null) prefs.setString("role", widget.role.name);
  }

  Future<http.Response> login(String username, String password) async {
    onLoading(context);

    if (username == null && password == null) {
      setState(() {
        _messageError = "les deux champs sont nécessaires";
        return null;
      });
    }
    final param = {
      "username": username,
      "password": password,
    };
    //http://umpo.ml http://umpo.ml

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final loginData = await http.post(
      "${prefs.getString('api_url')}/login",
      body: param,
    );

    print("--");
    Navigator.pop(context);

    setState(() {
      resBody = json.decode(loginData.body);
    });

    if (resBody["status"] == 1) {
      await set_session(resBody["auth_token"], resBody["user_id"],
          resBody["student_id"], resBody["employee_id"]);

      print(
          "------àààà0============================================================");

      print(resBody);

      if (widget.user1 != null) {
        var js = {
          "sudent_id": resBody["student_id"],
          "user_id": resBody["user_id"],
          "employee_id": resBody["employee_id"],
          "role": widget.role == null ? "" : widget.role.name
        };
        parse_s.putparse("users/" + widget.user1.id, js);
      }

      if (widget.go == true) {
        Navigator.pop(context, widget.role);
      } else {
        setState(() {
          _messageError = "";
        });

        Navigator.pop(context, widget.user1);
      }
    } else {
      setState(() {
        _messageError = "Votre nom d'utilisateur ou mot de passe incorrect";
      });
    }

    return loginData;
  }

  @override
  void initState() {
    super.initState();
    _iconAnimationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 500));
    _iconAnimation = new CurvedAnimation(
      parent: _iconAnimationController,
      curve: Curves.bounceOut,
    );
    _iconAnimation.addListener(() => this.setState(() {}));
    _iconAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    var style = new TextStyle(
        color: const Color(0xffeff2f7),
        fontSize: 14.0,
        fontWeight: FontWeight.w600);

    var style2 = new TextStyle(
        color: Fonts.col_app, fontSize: 14.0, fontWeight: FontWeight.w600);

    Widget btn_log = new Container(
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
                  print("jjojo 222");

                  login(_username, _password);
                },
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Image.asset(
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
                ))));

    return new Scaffold(
        body: new Center(
            child: new Container(
                decoration: new BoxDecoration(
                    color: Colors.grey[400],
                    image: new DecorationImage(
                        fit: BoxFit.cover,
                        colorFilter: new ColorFilter.mode(
                            Colors.white.withOpacity(0.3), BlendMode.dstATop),
                        image: new AssetImage("images/back.jpg"))),
                child: new Stack(fit: StackFit.expand, children: <Widget>[
                  ListView(children: <Widget>[
                    new Container(
                        height: 700.0,
                        child: new LoginBackground(Widgets.kitGradients))
                  ]),
                  ListView(children: <Widget>[
                    Column(children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 34,
                            ),
                            onPressed: () {
                              Navigator.pop(context, null);
                            },
                          )
                        ],
                      ),
                      new Padding(
                          padding: new EdgeInsets.only(
                              top: 128.0,
                              left: 12.0,
                              right: 12.0,
                              bottom: 18.0),
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.98,
                              child: new Material(
                                  elevation: 20.0,
                                  borderRadius: new BorderRadius.circular(12.0),
                                  shadowColor: Fonts.col_app_fon,
                                  child: new Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        height: 30,
                                      ),
                                      new Center(
                                          child: Widgets.subtitle(
                                              Fonts.col_app_fon)),
                                      Container(
                                        height: 16,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0, vertical: 0.0),
                                        child: new TextField(
                                            decoration: InputDecoration(
                                                labelText:
                                                    "Identifiant de l'utilisateur"),
                                            onChanged: (value) {
                                              setState(() {
                                                _username = value;
                                              });
                                            }),
                                      ),
                                      new SizedBox(
                                        height: 8.0,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0, vertical: 0.0),
                                        child: new TextField(
                                            decoration: InputDecoration(
                                                labelText: 'Mot de passe'),
                                            obscureText: true,
                                            onChanged: (value) {
                                              setState(() {
                                                _password = value;
                                              });
                                            }),
                                      ),
                                      Text(
                                        _messageError,
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      Container(
                                        height: 32,
                                      ),
                                      btn_log,
                                      Container(
                                        height: 24,
                                      )
                                    ],
                                  ))))
                    ])
                  ])
                ]))));
  }
}
