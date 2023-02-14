import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:ifdconnect/login/login_w.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:share/share.dart';
import 'package:ifdconnect/widgets/widgets.dart';

class Invitrefriends extends StatefulWidget {
  @override
  _InvitrefriendsState createState() => _InvitrefriendsState();
}

class _InvitrefriendsState extends State<Invitrefriends> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.white,
          title: new Text(""),
          elevation: 0.0,
        ),
        body: new Container(
          decoration: new BoxDecoration(
              color: Colors.grey[300],
              image: new DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter: new ColorFilter.mode(
                      Colors.white.withOpacity(0.1), BlendMode.dstATop),
                  image: new AssetImage("images/back.jpg"))),
          child: new Stack(fit: StackFit.expand, children: <Widget>[
            ListView(children: <Widget>[
              new Container(
                  height: 700.0,
                  child: new LoginBackground(Widgets.kitGradients1))
            ]),
            new Container(
                padding: new EdgeInsets.only(
                    bottom: 32.0, top: 86.0, left: 24.0, right: 24.0),
                child: new Card(
                    child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                      "Invitez vos contacs a rejoindre IFD CONNECT ",
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                          color: Colors.grey[800],
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Container(height: 24.0),

                    new Image.asset(
                      "images/share.png",
                      color: Colors.deepOrange,
                      width: 100.0,
                      height: 100.0,
                    ),
                    Container(height: 12.0),
                    //new Text(,textAlign:TextAlign.center,style: new TextStyle(color: Fonts.col_app,fontWeight: FontWeight.w600,fontSize: 14.0,),),
                    new Container(
                      height: 0.0,
                    ),
                    SizedBox(
                        width: 250.0,
                        height: 80.0,
                        child: new FlatButton(
                            onPressed: () {
                              Share.share(
                                  "");
                            },
                            child: new Center(
                              child: new Padding(
                                  padding: new EdgeInsets.only(top: 28.0),
                                  child: ColorizeAnimatedTextKit(
                                    text: [
                                      "Partager",
                                    ],
                                    textStyle: TextStyle(
                                        fontSize: 32.0, fontFamily: "Helvetica"),
                                    colors: [
                                      Colors.purple,
                                      Colors.blue,
                                      Colors.yellow[200],
                                      Fonts.col_app_fon
                                    ],
                                  )),
                            )))
                  ],
                )))
          ]),
        ) /**/);
  }
}
