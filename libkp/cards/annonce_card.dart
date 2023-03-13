
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ifdconnect/annonces/add_annonces.dart';
import 'package:ifdconnect/annonces/details_annonce.dart';
import 'package:ifdconnect/chat/chatscreen.dart';
import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/models/offers.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/services/block.dart';
import 'package:ifdconnect/widgets/common.dart';

class AnnonceCard extends StatefulWidget {
  AnnonceCard(this.offer, this.user, this.auth, this.sign, this.analytics,
      this.observer, this.list_partner);

  Offers offer;

  User user;
  var auth;
  var sign;
  var analytics;
  var observer;
  List list_partner;

  @override
  _ParcPubCardState createState() => _ParcPubCardState();
}

class _ParcPubCardState extends State<AnnonceCard> {
  ParseServer parse_s = new ParseServer();
  String text = "";
  bool click = false;

  block_user() async {
    await Block.insert_block(widget.offer.author.auth_id, widget.user.auth_id,
        widget.offer.author.id, widget.user.id);
    await Block.insert_block(
        widget.user.auth_id, widget.offer.author.auth_id, widget.user.id,
        widget.offer.author..id);
  }



  confirmer(my_id, his_id, user_me, user) async {
    // widget.delete();

    onLoading(context);

    DatabaseReference gMessagesDbRef2 =
    FirebaseDatabase.instance.reference().child("room_medz").child(
        my_id + "_" + his_id);
    Navigator.of(context, rootNavigator: true).pop('dialog');
    Navigator.push(context, new MaterialPageRoute(
        builder: (BuildContext context) {
          return new ChatScreen(
              my_id, his_id, widget.list_partner, false, widget.auth,widget.analytics,
              user: user_me);
        }));
  }


  void onLoading(context) {
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
                new RefreshProgressIndicator(),
                new Container(height: 8.0),
                new Text(
                  "En cours ..",
                  style: new TextStyle(
                    color: Fonts.col_app_fonn,
                  ),
                ),
              ],
            ),
          ),
        ));

    // Navigator.pop(context); //pop dialog
    //  _handleSubmitted();
  }


  bool delete = false;


  Widget spons = Container(
      height: 10,
      width: 60,
      child: SizedBox(
        // height: 20.0,
        // width: 180.0,
          child: new Center(
              child: ColorizeAnimatedTextKit(
                text: [
                  "Sponsorisé",
                ],
                textStyle: TextStyle(
                  fontSize: 16.0,
                ),
                colors: [
                  Colors.pink,
                  Colors.blue,
                  Colors.yellow[400],
                  Colors.blue[700],
                ],
              ))));

  delete_post() async {
    await parse_s.deleteparse("offers/" + widget.offer.objectId);
    setState(() {
      delete = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    double height = MediaQuery
        .of(context)
        .size
        .height;


    void showMenuSelection(String value) async {
      if (value == "Supprimer") {
        delete_post();
      } else {
        Navigator.push(context,
            new MaterialPageRoute(
                builder: (BuildContext context) {
                  return new AddAnnonce(
                    widget.user,
                    widget.auth,
                    widget.sign,
                    widget.list_partner,widget.offer.type,
                    an: widget.offer,

                  );
                }));


        /* setState(() {
          widget.offer = an;
        });*/
      }
    }


    Widget menusubscribe = new Container(
        width: 28.0,
        height: 28.0,
        child: new PopupMenuButton<String>(
            padding: new EdgeInsets.all(2.0),
            onSelected: showMenuSelection,
            itemBuilder: (BuildContext context) =>
            <PopupMenuEntry<String>>[
              /* new PopupMenuItem<String>(
                  value: "Block",
                  child: new ListTile(
                      title: new Text(
                          isBlock ? "Unblock this user" : "Block this user")*/
              new PopupMenuItem<String>(
                  value: "Modifier",
                  child: new ListTile(title: new Text("Modifier"))),
              new PopupMenuItem<String>(
                  value: "Supprimer",
                  child: new ListTile(
                      title: new Text("Supprimer"))),
            ]));


    return delete ? new Container() : new Card(
      child: new Container(
        height: height * 0.25,
        padding: new EdgeInsets.only(top: 4.0, bottom: 4.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new GestureDetector(
                onTap: () {
                  Navigator.push(context, new MaterialPageRoute(
                      builder: (BuildContext context) {
                        return new DetailsAnnonce(
                          widget.offer, widget.user, widget.list_partner,
                          widget.auth,widget.analytics
                        );
                      }));
                }
                ,
                child: new Container(
                    color: Colors.grey[200],
                    child: widget.offer.image == "" ? new FadingImage.asset(
                      "images/logo_last.png",
                      width: width * 0.28,
                      height: height * 0.26,
                      fit: BoxFit.contain,
                    ) : new FadingImage.network(
                      widget.offer.image,
                      width: width * 0.29,
                      height: height * 0.24,
                      fit: BoxFit.cover,
                    ))),
            new Container(
              width: 12.0,
            ),
            new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Container(
                    width: width * 0.64,
                    child: new Text(
                      widget.offer.title,
                      overflow: TextOverflow.ellipsis,
                      style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                          fontSize: 12.0),
                    )),
                new Container(height: height * 0.005),
                new Container(
                    width: width * 0.64,
                    child: new Text(
                        widget.offer.description == ""
                            ? "----Aucune description trouvée----"
                            : widget.offer.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: new TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                            fontSize: 11.0))),
                new Container(height: 2.0,),
                new Expanded(child: new Container()),
                new Container(
                    width: width * 0.64,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new ClipOval(
                            child: new Container(
                                color: Fonts.col_app,
                                width: 30.0,
                                height: 30.0,
                                child: new Center(
                                    child: FadingImage.network(
                                      widget.offer.author.image,
                                      width: 36.0,
                                      height: 36.0,
                                      fit: BoxFit.cover,
                                    )))),
                        new Container(
                          width: 8.0,
                        ),
                        new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text(
                                widget.offer.author.fullname +
                                    " " +
                                    widget.offer.author.firstname,
                                style: new TextStyle(
                                    color: Fonts.col_app,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11.5)),
                            new Text(
                              new DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.offer.createdAt)),
                              style: new TextStyle(
                                  color: Colors.grey[600],
                                  //  fontWeight: FontWeight.bold,
                                  fontSize: 11.0),
                            ),
                          ],
                        ),


                      ],
                    )),


                Container(height: 8,),


                new Container(
                    width: width * 0.60,
                    child: new Row(children: <Widget>[
                      // new Container(width: height*0.05),
                      new Expanded(child: new Container()),


                      Container(width: 4.0,),

                      widget.offer.author.id != widget.user.id ? new InkWell(
                          onTap: () async {
                            confirmer(widget.user.auth_id,
                                widget.offer.author.auth_id, widget.user,
                                widget.offer.author);
                          },
                          child: new Container(
                              padding: new EdgeInsets.all(4.0),
                              child: new Text("CONTACTER",
                                  style: new TextStyle(
                                      color: const Color(0xffff374e),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0)))) : menusubscribe,
                      new Container(width: 2.0,)
                    ],))
              ],
            )
          ],
        ),
      ),
    );
  }
}
