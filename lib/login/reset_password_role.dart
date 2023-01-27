import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:ifdconnect/config/config.dart';
import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/login/code_verification.dart';
import 'package:ifdconnect/login/login_w.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/services/validators.dart';
import 'package:ifdconnect/widgets/custom_widgets/app_textfield.dart';
import 'package:ifdconnect/widgets/custom_widgets/primary_button.dart';
import 'package:ifdconnect/widgets/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Reset_PasswordRole extends StatefulWidget {
  Reset_PasswordRole();

  @override
  _Reset_PasswordState createState() => _Reset_PasswordState();
}

class _Reset_PasswordState extends State<Reset_PasswordRole> {
  Future<int> GetUserInfo(email) async {
    var response = await parse_s.getparse(
        'users?where={"email":"$email"}&include=user_formations,role');
    return (response["results"].length);
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool _autovalidate = false;
  FocusNode _focusemail = new FocusNode();
  final _emailcontroller = new TextEditingController();
  String emailt = "";
  String _authHint = "";
  ParseServer parse_s = new ParseServer();

  var style = new TextStyle(
      color: const Color(0xffeff2f7),
      fontSize: 14.0,
      fontWeight: FontWeight.w600);

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  _onSubmit(message) {
    if (message.isNotEmpty) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(child: Text('Alert')),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  })
            ],
          );
        },
      );
    }
  }

  String _link = "";

  void _handleSubmitted() async {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      showInSnackBar("Veuillez corriger les erreurs en rouge");
    } else {
      setState(() {
        _authHint = '';
      });

      print("yesss");
      Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (BuildContext context) =>
            new Code_verification(),
          ));
      final param = {"username": "${_emailcontroller.text}"};

      final batchData = await http.post(
        "${Config.url_api}/forgot_password",
        body: param,
      );

      if (!this.mounted) return;
      print(batchData.body);

      var data = json.decode(batchData.body);

      if (data["status"] == "success") {
        showInSnackBar("Un email a été envoyé à votre adresse pour réintialiser votre mot de passe. ");

        setState(() {
          _link = data["url"];
        });
        // Navigator.push(
        //     context,
        //     new MaterialPageRoute(
        //       builder: (BuildContext context) =>
        //       new Reset_PasswordRole(),
        //     ));

      } else {
        setState(() {
          _authHint = data["message"];
        });
      }

/*
      String em = _emailcontroller.text;
      var response = await parse_s.getparse('users?where={"email":"$em"}&include=user_formations,role');
      if (!this.mounted) return;

      if(response["results"].length == 0)
      {
        showInSnackBar("Vous n'êtes pas un membre! veuillez s'inscrire");

        setState(() {
          _authHint = "Vous n'êtes pas un membre! veuillez s'inscrire " ;
        });
      }

      else {
        /****
         * New Modif
         */
        FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
        var a =   _firebaseAuth.sendPasswordResetEmail(
          email: _emailcontroller.text.toLowerCase(),
        );


        _onSubmit("Un email a été envoyé à l'adresse  $em pour réintialiser votre mot de passe. ");
*/

    }
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    Validators val = new Validators(context: context);

    Widget email =  TextFieldWidget(
      "Identifiant",
      _focusemail,
      _emailcontroller,
      TextInputType.text,
      val.validateid,
      suffixIcon: "",
    )/*new Container(
        decoration: new BoxDecoration(
            border: new Border.all(color: Colors.grey, width: 1.0),
            borderRadius: new BorderRadius.circular(12.0)),
        child: Widgets.textfield("Identifiant", _focusemail, emailt,
            _emailcontroller, TextInputType.text, val.validateid))*/;

    return new Scaffold(
        appBar: AppBar(backgroundColor: Colors.white,elevation: 0),

        backgroundColor: Colors.white,
        key: _scaffoldKey,
        body: new Center(
            child: new Padding(
                padding: new EdgeInsets.only(
                    left: 18.0, right: 18.0, bottom: 18.0),
                child: new Form(
                    key: _formKey,
                    autovalidate: _autovalidate,
                    //onWillPop: _warnUserAboutInvalidData,
                    child: new Container(
                        padding: new EdgeInsets.all(12.0),
                        child: SingleChildScrollView(
                          child: new Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: <Widget>[
                                new Container(height: 12.0.h),

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
                                new Center(
                                    child: Widgets.subtitle3(
                                        Fonts.col_app_fon)),

                                new Container(
                                  height: 24.0,
                                ),
                                email,
                                new Container(
                                  height: 52.0.h,
                                ),
                                _authHint.toString() == ""
                                    ? new Container()
                                    : new Center(
                                    child: new Text(
                                        _authHint.toString())),

                                Container(
                                    width: MediaQuery.of(context).size.width * 0.76,
                                    // height: ScreenUtil().setHeight(50),
                                    padding: new EdgeInsets.only(left: 12.0, right: 12.0),
                                    child: PrimaryButton(
                                      disabledColor: Fonts.col_grey,
                                      fonsize: 14.5.sp,
                                      icon: "",
                                      prefix: Container(),
                                      color: Fonts.col_app,
                                      text: "Envoyer",
                                      isLoading: false,
                                      onTap: ()  {
                                        print("subtitle33");
                                        _handleSubmitted();
                                      },
                                    )
                                ),
                                SizedBox(height: 300.h,),
                                /* new Container(
                                            height: 40.0,
                                            // padding: new EdgeInsets.only(left: 6.0, right: 6.0),
                                            child: new Material(
                                                elevation: 2.0,
                                                shadowColor: Fonts.col_app_fonn,
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        8.0),
                                                color: Fonts.col_app_fonn,

                                                child: new MaterialButton(
                                                    // color:  const Color(0xffa3bbf1),
                                                    onPressed: () {
                                                      _handleSubmitted();
                                                    },
                                                    child: new Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        new Container(
                                                          width: 8.0,
                                                        ),
                                                        //  new Container(height: 36.0,color: Colors.white,width: 1.5,),
                                                        new Container(
                                                          width: 8.0,
                                                        ),
                                                        new Text("Envoyer   ",
                                                            style: style)
                                                      ],
                                                    ))))*/
                              ]),
                        ))))));
  }
}
