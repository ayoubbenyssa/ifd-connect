import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ifdconnect/models/like.dart';
import 'package:ifdconnect/models/offers.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/favorite_service.dart';

class FavoriteButton extends StatefulWidget {
  FavoriteButton(this.offer, this.user);

  Offers offer;
  User user;

  @override
  _FavoriteButtonState createState() => new _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton>
    with SingleTickerProviderStateMixin {
  Animation<double> _heartAnimation;
  AnimationController _heartAnimationController;
  Color _heartColor = Colors.grey[400];
  bool favorite = false;
  int fav_id;
  static const int _kHeartAnimationDuration = 400;
  FavoriteService favservice = new FavoriteService();
  Like likeFunctions = new Like();

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

  toggletar() async {
    var res = await likeFunctions.like(widget.user.id, widget.offer.objectId);
    if (res == false) return;
    try {
      setState(() {
        widget.offer.liked = res["isLiked"];
        widget.offer.numberlikes = res["numberlikes"];
      });
    } catch (e) {
      e.toString();
    }

    //  return {"numberlikes": numberlikes + 1, "isLiked": true};
  }

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    final Widget child = new InkWell(
      //padding: new EdgeInsets.all(1.0),
      child: new Container(
          child: new ScaleTransition(
              scale: _heartAnimation,
              child:widget.offer.liked == true
            ? new Image.asset(
                      "images/Heart2.png",
                      width: 24.0,
                      height: 24.0,
                      color: widget.offer.liked == true
                          ? const Color(0xffff374e)
                          : Colors.grey[400],
                    )
                  : new SvgPicture.asset(
                      "images/Heart.svg",
                      width: 24.0,
                      height: 24.0,
                    ) /*new Icon(
                Icons.favorite,
                color: widget.offer.liked == true ? const Color(0xffff374e):Colors.grey[400],
                size: 24.0,
              )*/
              )),

      onTap: (() {
        toggletar();
        _heartAnimationController.forward().whenComplete(() {
          _heartAnimationController.reverse();
        });
      }),
    );

    return new Row(
      children: <Widget>[
        child,
        new Container(
          width: 8.0,
        ),
        new Text(
          widget.offer.numberlikes.toString() == "null"
              ? "0"
              : widget.offer.numberlikes.toString(),
          style: new TextStyle(fontWeight: FontWeight.bold),
        ),
        new Container(
          width: 6.0,
        ),
      ],
    );
  }
}
