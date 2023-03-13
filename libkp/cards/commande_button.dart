

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/models/like.dart';
import 'package:ifdconnect/models/offers.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/buy_services.dart';
import 'package:ifdconnect/services/commande_service.dart';
import 'package:ifdconnect/services/favorite_service.dart';

class CommandeButton extends StatefulWidget {
  CommandeButton(this.offer, this.user, this.ctx,this.show);

  Offers offer;
  User user;
  var ctx;
  bool show = false;

  @override
  _CommandeButtonState createState() => new _CommandeButtonState();
}

class _CommandeButtonState extends State<CommandeButton>
    with SingleTickerProviderStateMixin {
  AnimationController _heartAnimationController;
  bool favorite = false;
  int fav_id;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  static const int _kHeartAnimationDuration = 100;
  final TextEditingController _textController = new TextEditingController();

  // FavoriteService favservice = new FavoriteService();
  CommandeService likeFunctions = new CommandeService();
  bool show = false;
  String phone;

  _configureAnimation() {
    Animation<double> _initAnimation(
        {@required double from,
          @required double to,
          @required Curve curve,
          @required AnimationController controller}) {
      final CurvedAnimation animation = new CurvedAnimation(
        parent: controller,
        curve: curve,
      );
      return new Tween<double>(begin: from, end: to).animate(animation);
    }

    _heartAnimationController = new AnimationController(
      duration: const Duration(milliseconds: _kHeartAnimationDuration),
      vsync: this,
    );


  }

  @override
  void dispose() {
    _heartAnimationController.dispose();
    super.dispose();
  }


  isliked() async {
    widget.offer.liked = false;
    var res =
    await likeFunctions.isliked(widget.user.id, widget.offer.objectId);
    try {
      setState(() {
        widget.offer.liked = res;
      });
    } catch (e) {
      e.toString();
    }
  }

  /*

  new TextField(
                  autofocus: true,
                  controller: _textController,
                  decoration: new InputDecoration(
                      labelText: 'Full Name', hintText: 'eg. John Smith'),
                )
   */





  void _handleSubmitted() async {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      // _autovalidate = true; // Start validating on every change.
      //showInSnackBar("Veuillez corriger les erreurs en rouge");
    } else {
      Navigator.pop(widget.ctx);

      widget.user.phone = _textController.text;
      var js = {
        "phone": widget.user.phone
      };

       parse_s.putparse("users/" + widget.user.id, js);
     await  toggletar();

    //  new Timer(const Duration(milliseconds: 100), () =>  toggletar());






    }
  }

  String validateMobile(String value) {
    /*if (value.length <= 0)
      return "Siil vous plait entrz le numéro de téléphonne";
    else*/

    print("idjijdijddjiod");
    print(value);
    if (value.length > 0 && value.length != 10 && value.length != 12) {

      print("idjidjiojdyes--------------------------------------------");
      return 'Le numéro de téléphone n est pas valid';
    }
    else if (value.length > 0 &&
        !value.startsWith("06") &&
        !value.startsWith("07") &&
        value[0] != "+") return 'Le numéro de téléphone n est pas valid';

    return null;
  }

  ParseServer parse_s = new ParseServer();




  @override
  void initState() {
    super.initState();

    if(widget.user.phone.toString()!="null" && widget.user.phone !="")
      setState(() {
        _textController.text = widget.user.phone;
      });
    _configureAnimation();
    isliked();

    //verify_fav();
  }

  String id;

  toggle() async {
    Scaffold.of(context)
        .showSnackBar(new SnackBar(content: new Text("Suppriméé")));
  }


  toggletar()  async {




    var res = await likeFunctions.like(widget.user.id, widget.offer.objectId, widget.user.phone);
    print("___________________________________________________________________________________________________");
    print(res);

    if (res == false) return;

    if(!this.mounted) return;


      setState(() {
        show = false;
        widget.offer.liked = res["isLiked"];
        print(widget.offer.liked);

        widget.offer.numberlikes = res["numberlikes"];
      });

      if (widget.offer.liked) {
        Scaffold.of(context).showSnackBar(new SnackBar(
            content:
            new Text("Votre requette sera transmise à notre partenaire!")));
      } else {}


    //  return {"numberlikes": numberlikes + 1, "isLiked": true};
  }


  @override
  Widget build(BuildContext context) {



    _showDialog() async {
      return  await showDialog(
        context: widget.ctx,
        builder: (_) => new AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content:Container(
              height: 160,
              child: Column(
                children: <Widget>[
                  Text(widget.user.phone.toString() != "null" &&
                      widget.user.phone != ""
                      ? "Est ce  que c'est bien votre numéro de téléphone?"
                      : "Entrer le numéro de téléphonne"),
                  new Row(
                    children: <Widget>[
                      new Expanded(
                        child: Form(
                            key:_formKey,
                            child: new TextFormField(
                              autofocus: true,
                              validator: validateMobile,
                              controller: _textController,
                              decoration: new InputDecoration(
                                  hintText: 'Numéro de téléphonne'),
                            )),
                      )
                    ],
                  ),
                ],
              )),

          actions: <Widget>[
            new FlatButton(
                child: const Text('Annuler'),
                onPressed: () {

                  Navigator.pop(widget.ctx);

                }),

            new Togg(          _handleSubmitted)
          ],

        ),
      );
    }

    final Widget child = widget.show?new GestureDetector(

        onTap: () {
          /*  print("jiji");
          print(widget.user.phone.toString() );

          if (widget.user.phone.toString() != "null" && widget.user.phone != "") {
            phone = widget.user.phone;
            toggletar();

          } else {*/
          _showDialog();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              widget.offer.liked == true ? "Annuler" : "Commander",
              style: new TextStyle(
                  color: widget.offer.liked == true
                      ? Colors.grey[600]
                      : const Color(0xffff374e),
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0),
            ),
            Container(
              width: 12.0,
            ),
            show
                ? new Container(
                width: 15.0,
                height: 15.0,
                child: new CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(
                      Colors.pink[100]),
                  strokeWidth: 2.0,
                ))
                : new Container(),
          ],
        )) : new Container(
        height: 40.0,
        color: widget.offer.liked ? Colors.grey : Colors.blue,
        width: 5000.0,
        child: InkWell(
          onTap: () {

            print("jiji");
            print(widget.user.phone.toString() );


            _showDialog();

          },

          /*

               new Text(
                widget.offer.liked == true
                    ? "Annuler": "Participer",
                style: new TextStyle(
                    color: widget.offer.liked == true
                        ? Colors.grey[600]
                        : const Color(0xffff374e),
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0),
              )
               */
          //padding: EdgeInsets.symmetric(vertical: 32.0),
          child: new MaterialButton(
              elevation: 0.0,
              padding: new EdgeInsets.all(0.0),
              color: widget.offer.liked == true ? Colors.grey : Colors.blue,
              onPressed: () {
                print("jiji");
                print(widget.user.phone.toString() );


                _showDialog();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    widget.offer.liked == true ? "Annuler" : "Commander",
                    style: TextStyle(color: Colors.white),
                  ),
                  Container(
                    width: 4.0,
                  ),
                  show
                      ? new Container(
                      width: 15.0,
                      height: 15.0,
                      child: new CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            Colors.pink[100]),
                        strokeWidth: 2.0,
                      ))
                      : new Container(),
                ],
              )),
        )) /*new Container(
          child: new ScaleTransition(
              scale: _heartAnimation,
              child: new Text(
                widget.offer.liked == true
                    ? "Acheté": "J'achète",
                style: new TextStyle(
                    color: widget.offer.liked == true
                        ? Colors.green
                        : const Color(0xffff374e),
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0),
              )

            /*new Icon(
                Icons.favorite,
                color: widget.offer.liked == true ? const Color(0xffff374e):Colors.grey[400],
                size: 24.0,
              )*/))*/

    ;

    /*
     show
          ? new Container(width:15.0,
          height: 15.0,
          child: new CircularProgressIndicator(strokeWidth: 1.0,))
          : new Container(),
     */

    return child;
  }
}



class Togg extends StatefulWidget {
  Togg(this.func);
  var func;

  @override
  _ToggState createState() => _ToggState();
}

class _ToggState extends State<Togg> {
  @override
  Widget build(BuildContext context) {
    return   new FlatButton(
        child: const Text('Ok'),
        onPressed: ()  {


          widget.func();

        });
  }
}

/*
class _SystemPadding extends StatelessWidget {
  final Widget child;

  _SystemPadding({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return new AnimatedContainer(
        padding: mediaQuery.viewInsets,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}
*/