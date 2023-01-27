import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/models/offers.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/favorite_service.dart';
import 'package:ifdconnect/services/participate_service.dart';
import 'package:ifdconnect/services/validators.dart';

class ParticipateButton extends StatefulWidget {
  ParticipateButton(this.offer, this.user, this.analytics, this.ctx);

  Offers offer;
  User user;
  var analytics;
  var ctx;

  @override
  _FavoriteButtonState createState() => new _FavoriteButtonState();
}

class _FavoriteButtonState extends State<ParticipateButton>
    with SingleTickerProviderStateMixin {
  ParseServer parse_s = new ParseServer();
  Animation<double> _heartAnimation;
  AnimationController _heartAnimationController;
  Color _heartColor = Colors.grey[400];
  bool favorite = false;
  int fav_id;
  static const int _kHeartAnimationDuration = 100;
  FavoriteService favservice = new FavoriteService();
  ParticipateServices likeFunctions = new ParticipateServices();
  bool show = false;
  final TextEditingController _textController = new TextEditingController();

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

    _heartAnimation = _initAnimation(
        from: 1.0,
        to: 1.8,
        curve: Curves.easeOut,
        controller: _heartAnimationController);
  }

  isliked() async {
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

  participate() async {
    await widget.analytics.logEvent(
      name: 'participate',
      parameters: <String, dynamic>{
        'partner': widget.offer.partner.objectId,
        'user': widget.user.objectif,
      },
    );
  }

  toggletar() async {
    setState(() {
      show = true;
    });
    var res = await likeFunctions.like(
        widget.user.id, widget.offer.objectId, widget.user.phone);
    if (res == false) return;
    try {
      setState(() {
        show = false;
        widget.offer.liked = res["isLiked"];
        widget.offer.numberlikes = res["numberlikes"];
      });

      if (widget.offer.liked) {
        participate();

        Scaffold.of(context).showSnackBar(new SnackBar(
            content:
                new Text("Votre requette sera transmise à notre partenaire!")));
      } else {}
    } catch (e) {
      e.toString();
    }

    //  return {"numberlikes": numberlikes + 1, "isLiked": true};
  }

  @override
  void initState() {
    super.initState();
    if (widget.user.phone.toString() != "null" && widget.user.phone != "")
      setState(() {
        _textController.text = widget.user.phone;
      });

    _configureAnimation();
    isliked();

    //verify_fav();
  }

  @override
  void dispose() {
    _heartAnimationController.dispose();
    super.dispose();
  }

  String id;

  toggle() async {
    Scaffold.of(context)
        .showSnackBar(new SnackBar(content: new Text("Suppriméé")));
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

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  _showDialog() async {
    return await showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: Container(
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
                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('Ok'),
              onPressed: () async {

                print("jdhkdk");
                _handleSubmitted();



                /* new Timer(const Duration(milliseconds: 300), () =>  toggletar()
                );*/
              })
        ],
      ),
    );
  }



  void _handleSubmitted() async {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      // _autovalidate = true; // Start validating on every change.
      //showInSnackBar("Veuillez corriger les erreurs en rouge");
    } else {
      Navigator.pop(context);

      widget.user.phone = _textController.text;
      var js = {"phone": widget.user.phone};
      await parse_s.putparse("users/" + widget.user.id, js);
      toggletar();
    }
  }


  @override
  Widget build(BuildContext context) {



    final Widget child = new InkWell(
      //padding: new EdgeInsets.all(1.0),
      child: new Container(
          child: new ScaleTransition(
              scale: _heartAnimation,
              child: new Text(
                widget.offer.liked == true ? "Annuler" : "Participer",
                style: new TextStyle(
                    color: widget.offer.liked == true
                        ? Colors.grey[600]
                        : const Color(0xffff374e),
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0),
              )

              /*new Icon(
                Icons.favorite,
                color: widget.offer.liked == true ? const Color(0xffff374e):Colors.grey[400],
                size: 24.0,
              )*/
              )),

      onTap: (() {
      //

        _showDialog();

        _heartAnimationController.forward().whenComplete(() {
          _heartAnimationController.reverse();
        });
      }),
    );

    return new Row(
      children: <Widget>[
        child,
        new Container(width: 4.0),

        /*  widget.offer.liked == true
          ? new Icon(Icons.check, color: Colors.green,)
          : new Container(),*/
        show
            ? new Container(
                width: 15.0,
                height: 15.0,
                child: new CircularProgressIndicator(
                  strokeWidth: 1.0,
                ))
            : new Container(),
        /*new Text(widget.offer.numberlikes.toString()=="null"?"0":widget.offer.numberlikes.toString(),
        style: new TextStyle(fontWeight: FontWeight.bold),),*/
        new Container(
          width: 6.0,
        ),
      ],
    );
  }
}
