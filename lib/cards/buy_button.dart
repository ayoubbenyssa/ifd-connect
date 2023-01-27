import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/models/offers.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/buy_services.dart';
import 'package:ifdconnect/services/favorite_service.dart';
import 'package:flutter/services.dart';


class BuyButton extends StatefulWidget {
  BuyButton(this.offer, this.user, this.show);

  Offers offer;
  User user;
  var show;

  @override
  _FavoriteButtonState createState() => new _FavoriteButtonState();
}

class _FavoriteButtonState extends State<BuyButton>
    with SingleTickerProviderStateMixin {
  Animation<double> _heartAnimation;
  AnimationController _heartAnimationController;
  Color _heartColor = Colors.grey[400];
  bool favorite = false;
  int fav_id;
  static const int _kHeartAnimationDuration = 100;
  FavoriteService favservice = new FavoriteService();
  BuyServices likeFunctions = new BuyServices();
  bool show = false;
  ParseServer parse_s = new ParseServer();



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


  var barcode;

  void showInSnackBar(String value) {
    Scaffold
        .of(context)

        .showSnackBar(new SnackBar(content: new Text(value)));
  }



  Future scan() async {
    try {
      String barcode ;
      print(barcode);

      setState(() => this.barcode = barcode);


      if(this.barcode == widget.offer.partner.objectId)
        {

          toggletar(false);

        }
        else{

      }
    } on PlatformException catch (e) {

    } on FormatException{
      setState(() => this.barcode = 'null (User returned using the "back"-button before scanning anything. Result)');
      print(this.barcode);

    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
      print(this.barcode);

    }
  }

  /*


    /*
    var uuid = new Uuid();
    print(uuid.v4());
    final birthday = DateTime(2018, 12, 2);
    final date2 = DateTime.now();
    final difference = date2.difference(birthday).inDays;
    print(difference);

              parse_s.putparse("buy/"+res["objectId"], {"dte": DateTime.now().toString()});//buy

     */


   */
  var dte = null;
  ParseServer parseFunctions = new ParseServer();

  /**
   *
   * jiya
   */

  void onLoading(context, text) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => new Dialog(
          child: new Container(
            padding: new EdgeInsets.all(16.0),
            width: 40.0,
            color: Colors.transparent,
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                new Container(height: 8.0),
                new Text(
                  "Le code généré par cette convention: ",
                  style: new TextStyle(fontSize: 16),
                ),
                Container(
                  height: 12,
                ),
                new Text(
                  text.toString(),
                  style: new TextStyle(
                      color: Fonts.col_app_fonn, fontWeight: FontWeight.bold),
                ),
                Container(height: 8),
                FlatButton(
                  child: Text(
                    "OK",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                )
              ],
            ),
          ),
        ));
  }

  insertp(val) async {
    // var uuid = new Uuid();
    //  var code = new Random();
    var rng = new Random();
    var code = rng.nextInt(90000000) + 100000;

    var jss = {
      "author": {
        "__type": "Pointer",
        "className": "users",
        "objectId": widget.user.id
      },
      "code": val? code.toString():"",
      "post": {
        "__type": "Pointer",
        "className": "offers",
        "objectId": widget.offer.objectId,
        "dte": dte.toString()
      },
      "tel":widget.user.phone,
      "dte": DateTime.now().toString()
    };
    var a = await parseFunctions.postparse('buy', jss);

    /*

    setState(() {
      widget.offer.liked = false;
    });
   */
    if(val)
    onLoading(context, code);
    else
      showInSnackBar("Vous avez bénificier de cette convention");

  }

  String id;
  bool sh = false;
  DateTime dt;

  toggletar(val) async {

    var res =
        await likeFunctions.like(widget.user.id, widget.offer.objectId, dte);
    if (!this.mounted) return;



    print(res);


    if (res == false) {

      await insertp(val);

      setState(() {
        show = false;
        widget.offer.liked = true;
      });

      //insertp();
    } else {

      dt = DateTime.parse(res["results"][0]["dte"]);
      final date2 = DateTime.now();
      final difference = date2.difference(dt).inDays;
      print(difference);
      if (difference < 1) {
        setState(() {
          show = false;
          sh = true;
          widget.offer.liked = true;
        });
      } else {
        //await parseFunctions.deleteparse("buy/" + res["results"]["objectId"]);
        setState(() {
          show = false;
          widget.offer.liked = true;
        });
        toggletar(val);
      }
    }
  }

  /*


       if (widget.offer.liked) {
        Scaffold.of(context).showSnackBar(new SnackBar(
            content:
            new Text("Votre requette sera transmise à notre partenaire!")));

        parse_s
            .putparse("buy/" + res["id"], {"dte": DateTime.now().toString()});
      } else {}



    if (res == false) return;

    try {
      setState(() {
        show = false;
        widget.offer.liked = res["isLiked"];
        widget.offer.numberlikes = res["numberlikes"];
      });

      if (widget.offer.liked) {
        Scaffold.of(context).showSnackBar(new SnackBar(
            content:
                new Text("Votre requette sera transmise à notre partenaire!")));

        parse_s
            .putparse("buy/" + res["id"], {"dte": DateTime.now().toString()});
      } else {}
    } catch (e) {
      e.toString();
    }
*/

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

  @override
  void dispose() {
    _heartAnimationController.dispose();
    super.dispose();
  }


  /*_showDialog() async {
    return  await showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content:

        Container(height: 160,child:
        Column(children: <Widget>[

          Text( widget.user.phone.toString() != "null" && widget.user.phone != ""?"Est ce  que c'est bien votre numéro de téléphone?":
          "Entrer le numéro de téléphonne"),
          new Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                  autofocus: true,
                  controller: _textController,
                  decoration: new InputDecoration(


                      hintText: 'Numéro de téléphonne'),
                ),
              )
            ],
          ),

        ],)),


        actions: <Widget>[
          new FlatButton(
              child: const Text('Annuler'),
              onPressed: () {

                Navigator.pop(context);

              }),
          new FlatButton(
              child: const Text('Ok'),
              onPressed: () async {
                Navigator.pop(context);

                widget.user.phone = _textController.text;
                var js = {
                  "phone": widget.user.phone
                };


                await parse_s.putparse("users/" + widget.user.id, js);
               conv();



                /* new Timer(const Duration(milliseconds: 300), () =>  toggletar()
                );*/

              })
        ],

      ),
    );
  }
*/

  conv() {
    //Navigator.pop(context);

    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => new Dialog(
            child: new Container(
                height: 232.0,
                // width: MediaQuery.of(context).size.width,
                child: new Container(
                    // padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                    child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                      Container(
                        height: 26,
                      ),
                      Center(
                          child: Text("Bénificier d'une convention:",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700))),
                      Container(
                        height: 16,
                      ),
                      ListTile(
                          title: Row(
                            children: <Widget>[
                              Image.asset(
                                "images/qr.png",
                                width: 26,
                                height: 26,
                                color: Colors.blue,
                              ),
                              Container(
                                width: 12,
                              ),
                              new Text("A l'aide de QRcode",style: TextStyle(fontSize: 14)),
                            ],
                          ),
                          onTap: () {
                            print("hdpojdipjdpo");
                            Navigator.pop(context);

                            scan();
                          }),
                      Container(
                        height: 1,
                        width: 250,
                        color: Colors.grey[300],
                      ),
                      ListTile(
                          title: Row(
                            children: <Widget>[
                              Image.asset(
                                "images/code.png",
                                width: 26,
                                height: 26,
                                color: Colors.blue,
                              ),
                              Container(
                                width: 12,
                              ),
                              new Text("Générer un code de réduction",style: TextStyle(fontSize: 14),)
                            ],
                          ),
                          onTap: () {
                            toggletar(true);
                            _heartAnimationController.forward().whenComplete(() {
                              _heartAnimationController.reverse();
                            });
                          }),
                      Container(
                        height: 1,
                        width: 250,
                        color: Colors.grey[300],
                      ),
                    ])))));
  }

  toggle() async {
    Scaffold.of(context)
        .showSnackBar(new SnackBar(content: new Text("Suppriméé")));
  }


  final TextEditingController _textController = new TextEditingController();



  @override
  Widget build(BuildContext context) {
    final Widget child = widget.show
        ? new InkWell(
            //padding: new EdgeInsets.all(1.0),
            child: new Container(
                child: new Text(
              widget.offer.liked == true ? "Bénificier" : "Bénificier",
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
              )*/
                ),

            onTap: (() {
              conv();

            }),
          )
        : Center(
            child: new InkWell(
                onTap: () {
                  /*  toggletar();
      _heartAnimationController.forward().whenComplete(() {
        _heartAnimationController.reverse();
      });*/

                  conv();
               },
                child: new Container(
                    //width: 100.0,
                    padding: EdgeInsets.all(4.0),
                    height: 42.0,
                    width: 310.0,
                    decoration: new BoxDecoration(
                      border: new Border.all(
                          color: widget.offer.liked == true
                              ? Colors.green
                              : const Color(0xffff374e),
                          width: 1.5),
                      borderRadius: new BorderRadius.circular(8.0),
                    ),
                    child: new Center(
                        child: new Text(
                      'Bénificier',
                      style: new TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: widget.offer.liked == true
                            ? Colors.green
                            : const Color(0xffff374e),
                      ),
                    )))));

    /*new InkWell(
      //padding: new EdgeInsets.all(1.0),
      child: new Container(
          child: new Text(
                widget.offer.liked == true ? "Bénificier" : "Bénificier",
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
              )*/
              ),

      onTap: (() {
        toggletar();
        _heartAnimationController.forward().whenComplete(() {
          _heartAnimationController.reverse();
        });
      }),
    )*/

    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          sh
              ? StreamBuilder(
                  stream: Stream.periodic(Duration(seconds: 1), (i) => i),
                  builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                    DateFormat format = DateFormat("mm:ss");

                    Duration remaining = Duration(
                        milliseconds: -1 *
                            (-24 * 60 * 60 * 1000 -
                                (dt.millisecondsSinceEpoch -
                                    DateTime.now().millisecondsSinceEpoch)));
                    var dateString =
                        '${remaining.inHours}:${format.format(DateTime.fromMillisecondsSinceEpoch(remaining.inMilliseconds))}';
                    return Container(
                      padding: EdgeInsets.all(8.0),
                      width: 260.0,
                      color: Colors.redAccent.withOpacity(0.24),
                      // alignment: Alignment.center,
                      child: Text("Il vous reste  " +
                          dateString +
                          "  pour valider une autre commande"),
                    );
                  })
              : Container(),
          new Row(
            children: <Widget>[
              child,
              new Container(width: 4.0),
              widget.offer.liked == true
                  ? new Icon(
                      Icons.check,
                      color: Colors.green,
                    )
                  : new Container(),
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
          )
        ]);
  }
}
