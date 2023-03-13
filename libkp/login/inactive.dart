import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/login/login_tabs.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/services/app_services.dart';
import 'package:ifdconnect/widgets/bottom_menu.dart';
import 'package:ifdconnect/widgets/widgets.dart';

class InactiveWidget extends StatefulWidget {
  InactiveWidget(this.list_partner, this.id);

  List list_partner;

  var func;
  var id;

  @override
  _InactiveWidgetState createState() => new _InactiveWidgetState();
}

class _InactiveWidgetState extends State<InactiveWidget> {
  bool loading = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  submit() {
    setState(() {
      loading = true;
    });
  }

  String img = "";
  var photo;

  ParseServer parse_s = new ParseServer();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  bool load = false;

  getUser() async {
    String id = widget.id;

    var a = await parse_s.getparse('users?where={"objectId":"$id"}&include=user_formations,role');
    if (!this.mounted) return;
    setState(() {
      img = a["results"][0]["diplome"];
    });
  }

  @override
  void initState() {
    super.initState();
    print("d^^^ld^^^^^^^^pd^^d^^p^^p^^pd^^dpd^^d^^p");
    getUser();
  }

  String text = "";

  goto() async {
    setState(() {
      load = true;
    });
    String id = widget.id;
    print(id);

    var a = await parse_s.getparse('users?where={"active":1,"objectId":"$id"}&include=user_formations,role');
    if (!this.mounted) return;
    setState(() {
      load = false;
    });

    if (a["results"].length == 1) {
      User user = new User.fromMap(a["results"][0]);

      Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
              builder: (BuildContext context) => new BottomNavigation(
                  null,
                  null,
                  user,
                  widget.list_partner,
                  false,
                  null,

                  animate: true)));
    } else {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
          content: new Text("Votre compte est en attente de vérification !")));
    }
  }

  bool uploading = false;
  AppServices appservices = AppServices();




  @override
  Widget build(BuildContext context) {
    var style = new TextStyle(
        color: const Color(0xffeff2f7),
        fontSize: 20.0,
        fontWeight: FontWeight.w500);

    var style0 = new TextStyle(
        color: Colors.black,
        fontSize: 20.0,
        fontWeight: FontWeight.w500);


    var style2 = new TextStyle(
        color: Colors.grey[700], fontSize: 20.0, fontWeight: FontWeight.w500);

    Widget ess = new Container(
        child: new Material(
            elevation: 4.0,
            shadowColor: Colors.grey[700],
            borderRadius: new BorderRadius.circular(8.0),
            color: Fonts.col_app_green,
            child: new MaterialButton(
                onPressed: () {
                  //  widget.func();
                  //nearDistance();

                  goto();
                },
                child: Row(
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
                        : Container(),
                    Container(
                      width: 2,
                    ),
                    new Text("Réessayer", style: style)
                  ],
                ))));




    Widget ret = new Container(
        child: new Material(
            elevation: 4.0,
            shadowColor: Colors.grey[700],
            borderRadius: new BorderRadius.circular(8.0),
            color: Fonts.col_cl,
            child: new MaterialButton(
                onPressed: () {
                 Navigator.pop(context);
                 Navigator.pop(context);

                  //  widget.func();
                  //nearDistance();

                  /*Navigator.pushReplacement(context,
                      new MaterialPageRoute(builder: (BuildContext context) {
                        return new LoginScreen();
                      }));*/
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    Container(
                      width: 2,
                    ),
                    new Text("Retourner", style: style0)
                  ],
                ))));


    return new Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: new Container(

          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // new Container(height:8.0),
              new Center(
                  child: new Image.asset(
                    "images/logo_last.png",
                    width: MediaQuery.of(context).size.width*0.7,
                  )),
              Container(
                height: 48.0,
              ),
              new Padding(
                  padding: EdgeInsets.all(12.0),
                  child: new Text(
                    "  Votre profil est en cours de verification, un mail de confirmation vous sera envoyé une fois l'opération terminée",
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                        color: Colors.grey[700], height: 1.2, fontSize: 18.0),
                  )),
              new Container(height: 50.0),


              Container(
                height: 8.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  img.toString() == ""
                      ? new Container()
                      : Container(
                      padding: EdgeInsets.only(top: 8),
                      height: 50,
                      width: 50,
                      child: new SizedBox(
                          height: 50.0,
                          width: 50,
                          child: new Stack(
                            children: <Widget>[
                              new Positioned.fill(
                                child: new Image.network(
                                  img.toString(),
                                  height: 50.0,
                                  width: 50,
                                  fit: BoxFit.cover,
                                ),
                              )
                            ],
                          ))),
                ],
              ),

              !loading ? new Container() : Widgets.load(),
              // new Center(child: ess),

              Container(height: 28,),

              new Center(child: Row(
                mainAxisAlignment: MainAxisAlignment.center
                ,
                children: <Widget>[

                  ret,
                  Container(width: 12,),
                  ess

                ],)),
            ],
          ),
        ));
  }
}
//Revenir en arrière
