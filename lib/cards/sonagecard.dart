import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ifdconnect/cards/details_partner.dart';
import 'package:ifdconnect/cards/option_card.dart';
import 'package:ifdconnect/fils_actualit/card_footer.dart';
import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/models/offers.dart';
import 'package:ifdconnect/models/option.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/services/block.dart';
import 'package:ifdconnect/services/posts_services.dart';
import 'package:ifdconnect/user/details_user.dart';
import 'package:ifdconnect/widgets/common.dart';
import 'package:ifdconnect/widgets/easy_badge.dart';
import 'package:ifdconnect/widgets/easy_card.dart';

import 'package:timeago/timeago.dart' as ta;

class SondageCard extends StatefulWidget {
  SondageCard(this.user, this.offers, this.list);

  Offers offers;
  User user;
  List list;


  @override
  _SondageCardState createState() => _SondageCardState();
}

class _SondageCardState extends State<SondageCard> {
  ParseServer parse_s = new ParseServer();

  delete() async {
    await parse_s.deleteparse("offers/" + widget.offers.objectId);
    setState(() {
      widget.offers.delete = true;
    });
  }

  bool load = false;

  loadi(val) {
    setState(() {
      widget.offers = val;
    });
    /*setState(() {
      widget.offers.delete=true;
    });
    new Timer(const Duration(milliseconds: 50), () {
      try {
        setState(() => widget.offers.delete = false);
      } catch (e) {
        e.toString();
      }
    });*/
  }

  block_user() async {
    await Block.insert_block(widget.user.auth_id, widget.offers.author1.auth_id,
        widget.user.id, widget.offers.author1.id);
    await Block.insert_block(widget.offers.author1.auth_id, widget.user.auth_id,
        widget.offers.author1.id, widget.user.id);

    setState(() {
      widget.user.show = false;
    });
  }

  delete_option(i) async {
    var js = {
      "users": {
        "__op": "Remove",
        "objects": [
          {
            "__type": "Pointer",
            "className": "users",
            "objectId": widget.user.id
          }
        ]
      }
    };

    return parse_s.putparse('options/' + i.id, js);
  }

  int skip = 0;

  func(a) async {
    var s =
    await PostsServices.get_sondage_by_id(a.objectId, widget.user, skip);
    print("functions");
    print(s["results"][0].objectId);
    setState(() {
      widget.offers = s["results"][0];
      for (Option i in s["results"][0].options) {
        print("aaaaaaaaaaaaaaaaaaaaaa");
        print(i.users.length);
        /*if (i.check == false) {
       await delete_option(i);
       setState(() {
         i.check = false;
       });
      }*/

      }
    });

    for (Option i in widget.offers.options) {
      /*if (i.check == false) {
       await delete_option(i);
       setState(() {
         i.check = false;
       });
      }*/

    }
    /* setState(() {
      widget.offers = a;
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return widget.offers.delete
        ? Container()
        : Container(
      child: Card(
          elevation: 3.0,
          child: Container(

              child: Column(
                children: <Widget>[
                  widget.offers.author1.toString() == "null" &&
                      widget.offers.partner.toString() == "null"
                      ? Container()
                      : new Container(
                      padding: new EdgeInsets.all(8.0),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .push(new PageRouteBuilder(
                                  pageBuilder: (_, __, ___) =>
                                  new Details_user(
                                      widget.offers.author1,
                                      widget.user,
                                      block_user,
                                      true,
                                      widget.list,
                                      null),
                                ));
                              },
                              child: new ClipOval(
                                  child: new Container(
                                      color: Fonts.col_app,
                                      width: 42.0,
                                      height: 42.0,
                                      child: new Center(
                                          child: FadingImage.network(
                                            widget.offers.author1
                                                .toString() ==
                                                "null"
                                                ? widget.offers.partner.logo
                                                : widget.offers.author1.image,
                                            width: 42.0,
                                            height: 42.0,
                                            fit: BoxFit.cover,
                                          ))))),
                          new Container(
                            width: 8.0,
                          ),
                          new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(children: [
                                Container(
                                    child: new Text(
                                        widget.offers.author1
                                            .toString() ==
                                            "null"
                                            ? widget.offers.partner.name
                                            : widget.offers.author1
                                            .fullname +
                                            " " +
                                            widget.offers.author1
                                                .firstname,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: new TextStyle(
                                            color: Colors.grey[800],
                                            fontWeight: FontWeight.w600,
                                            fontSize: 11.5))),
                                Container(
                                  width: 8,
                                ),

                                Container(
                                  width: 8,
                                ),

                              ]),
                              new Container(height: 2.0),

                                  new Text(
                                    ta.format(widget.offers.create,
                                        locale: "fr"),
                                    style: new TextStyle(
                                        color: Colors.grey[600],
                                        //  fontWeight: FontWeight.bold,
                                        fontSize: 11.0),
                                  ),
                            ],
                          ),
                          new Expanded(child: new Container()),

                          // type()
                          /* widget.offers.pic.isEmpty
                            ? MenuCard(
                            widget.offers, widget.user, delete, Colors.black)*/
                          //   : Container()
                        ],
                      )),
                  new EasyBadgeCard(
                    leftBadge: Colors.white,
                    title: widget.offers.title,
                    backgroundColor: Fonts.col_cl,
                    prefixIcon: "images/pv.png",

                    // prefixIconColor: Fonts.col_app_green,
                    suffixIconColor: Colors.white,
                    titleColor: Fonts.col_app,
                    descriptionColor: Colors.white,
                  ),
                  Column(
                      children: widget.offers.options
                          .map((option) => OptionCard(widget.offers, option,
                          widget.user, func, loadi))
                          .toList()),
                  CardFooter(
                      widget.offers,
                      widget.user,
                      delete,
                      context,
                      widget.list,
                      null,
                      null,
                      null,)
                ],
              ) //Text(widget.offers.title)),

          )),
    );
  }
}
