import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ifdconnect/models/partner.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/likepartnerservice.dart';

class LikePartnerButton extends StatefulWidget {
  LikePartnerButton(this.partner, this.user);

  Partner partner;
  User user;


  @override
  _FavoriteButtonState createState() => new _FavoriteButtonState();
}

class _FavoriteButtonState extends State<LikePartnerButton>
    with SingleTickerProviderStateMixin {

  Animation<double> _heartAnimation;
  AnimationController _heartAnimationController;
  Color _heartColor = Colors.grey[400];
  bool favorite = false;
  int fav_id;
  static const int _kHeartAnimationDuration = 100;
  //LikePartnertService favservice = new LikePartnertService();
  LikePartnertService likeFunctions = new LikePartnertService();
  bool show = false;


  _configureAnimation() {
    Animation<double> _initAnimation({@required double from,
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
    var res = await likeFunctions.isliked(
        widget.user.id, widget.partner.objectId);
    try {
      setState(() {
        widget.partner.liked = res;
      });
    } catch (e) {
      e.toString();
    }
  }


  toggletar() async {
    setState(() {
      show = true;
    });
    var res = await likeFunctions.like(widget.user.id, widget.partner.objectId);
    if (res == false) return;
    try {


      setState(() {
        show = false;
        widget.partner.liked = res["isLiked"];
        widget.partner.numberlikes = res["numberlikes"];
      });

      if(widget.partner.liked)
      {
       /* Scaffold
            .of(context)
            .showSnackBar(new SnackBar(content: new Text("Votre requette sera transmise à notre partenaire!")));*/
      }
      else{

      }

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
    Scaffold.of(context).
    showSnackBar(new SnackBar(content: new Text("Suppriméé")));
  }


 Color loginGradientStart =  Colors.blue[200];
 Color loginGradientEnd = Colors.deepPurple[400];



  Color loginGradientStart1 = Colors.green[200];
  Color loginGradientEnd1 =Colors.green[700];


  @override
  Widget build(BuildContext context) {
    final Widget child = new InkWell(
      //padding: new EdgeInsets.all(1.0),
      child:   Container(
      width:136.0,
      height: 42.0,
      margin: new EdgeInsets.only(bottom: 4.0),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: widget.partner.liked?loginGradientStart1:loginGradientStart,
            offset: Offset(1.0, 2.0),
            blurRadius: 4.0,
          ),
          BoxShadow(
            color: widget.partner.liked?loginGradientStart1:loginGradientStart,
            offset: Offset(1.0, 2.0),
            blurRadius: 2.0,
          ),
          BoxShadow(
            color: widget.partner.liked?loginGradientStart1:loginGradientStart,
            offset: Offset(1.0, 2.0),
            blurRadius: 4.0,
          ),
        ],
        gradient: new LinearGradient(
            colors: [
              widget.partner.liked == true?  loginGradientEnd1: loginGradientEnd,
              widget.partner.liked == true?    loginGradientStart1:loginGradientStart
            ],
            begin: const FractionalOffset(0.1, 0.1),
            end: const FractionalOffset(1.0, 1.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: MaterialButton(
          highlightColor: Colors.transparent,
          splashColor: loginGradientEnd,
          //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            show
                ? new Container(width:20.0,
                height: 20.0,
                child: new CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.pink[100]),
                  strokeWidth: 3.0,))
                : new Container(),
            new Container(width: 4.0),
            Text(
              widget.partner.liked == true
                  ? "AIMÉ": "J'AIME",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 15.0),

            ),
          ],),
          onPressed: () {
            toggletar();
          }
      ),
    )
    /*new Container(
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


    );

    return new Row(children: <Widget>[
      child,
      new Container(width: 4.0),


      /*new Text(widget.offer.numberlikes.toString()=="null"?"0":widget.offer.numberlikes.toString(),
        style: new TextStyle(fontWeight: FontWeight.bold),),*/
      new Container(width: 6.0,),

    ],);
  }
}