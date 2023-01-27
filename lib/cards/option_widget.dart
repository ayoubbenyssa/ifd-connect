import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ifdconnect/cards/details_partner.dart';
import 'package:ifdconnect/chat/chatscreen.dart';
import 'package:ifdconnect/models/offers.dart';
import 'package:ifdconnect/models/user.dart' as prefix0;
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/services/block.dart';
import 'package:ifdconnect/user/details_user.dart';

class ButtonWidget extends StatefulWidget {
  ButtonWidget(
      this.offer, this.user, this.ratefunc, this.lat, this.lng, this.chng);

  Offers offer;
  prefix0.User user;
  var ratefunc;
  var lat, lng;
  var chng;

  @override
  _ButtonWidgetState createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {

  block_user() async {
    await Block.insert_block(widget.user.auth_id, widget.offer.author1.auth_id,
        widget.user.id, widget.offer.author1.id);
    await Block.insert_block(widget.offer.author1.auth_id, widget.user.auth_id,
        widget.offer.author1.id, widget.user.id);

    setState(() {
      widget.user.show = false;
    });
  }

  goto() {}

  var st1 = TextStyle(
      color: Fonts.col_app,
      fontWeight: FontWeight.w500,
      fontSize: ScreenUtil().setSp(14));

  @override
  Widget build(BuildContext context) {

    return IconButton(
        icon: Icon(
          Icons.more_horiz,
          size: 32,
          color: Fonts.col_app_fonn,
        ),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext bc) {
                return Container(
                  child: new Wrap(
                    children: <Widget>[
                      Container(
                          color: const Color(0xfff3f3f3),
                          child: new ListTile(
                              leading: new Image.asset(
                                "images/prfile.png",
                                color: Fonts.col_app,
                                width: 25,
                                height: 25,
                              ),
                              title: new Text(
                                'Voir profil'.toUpperCase(),
                                style: st1,
                              ),
                              onTap: () {
                                Navigator.pop(context);
                                if (widget.offer.author1.toString() != "null")
                                  Navigator.of(context)
                                      .push(new PageRouteBuilder(
                                    pageBuilder: (_, __, ___) =>
                                        new Details_user(
                                            widget.offer.author1,
                                            widget.user,
                                            block_user,
                                            true,
                                            [],
                                            null,
                                            ),
                                  ));
                                else
                                  Navigator.push(context, new MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return new PartnerCardDetails(
                                        widget.offer.partner,
                                     );
                                  }));
                              })),
                      widget.offer.author.toString() == "null"
                          ? Container()
                          : widget.user.auth_id == widget.offer.author.auth_id
                              ? Container()
                              : new ListTile(
                                  leading: new Image.asset(
                                    "images/chat.png",
                                    color: Fonts.col_app,
                                    width: 27,
                                    height: 27,
                                  ),
                                  title: new Text(
                                    "Contacter",
                                    style: st1,
                                  ),
                                  onTap: () {
                                    Navigator.push(context,
                                        new MaterialPageRoute(
                                            builder: (BuildContext context) {
                                      return new ChatScreen(
                                          widget.user.auth_id,
                                          widget.offer.author.auth_id,
                                          goto,
                                          false,
                                          null,
                                          null,

                                          user: widget.user);
                                    }));
                                  },
                                ),


                     // DynamicLink(widget.offer.objectId),

                    /*  widget.offer.type == "event"
                          ? Container(
                              child: new ListTile(
                              leading: new Image.asset(
                                "images/prt.png",
                                color: Fonts.col_app,
                                width: 25,
                                height: 25,
                              ),
                              title: new Text(
                               "Participants",
                                style: st1,
                              ),
                              onTap: () {

                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          //new HomePage(widget.auth,widget.sign)
                                          new Participate(
                                              /*com,*/
                                              widget.user,
                                              widget.offer.objectId,
                                              widget.chng),
                                    ));
                              },
                            ))
                          : Container(),*/
                    ],
                  ),
                );
              });
        });
  }
}
