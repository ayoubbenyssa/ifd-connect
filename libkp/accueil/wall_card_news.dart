import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:ifdconnect/annonces/details_annonce.dart';
import 'package:ifdconnect/cards/details_parc.dart';
import 'package:ifdconnect/cards/prom_details.dart';
import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/models/offers.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/services/app_services.dart';
import 'package:ifdconnect/services/block.dart';
import 'package:ifdconnect/widgets/common.dart';
import 'package:ifdconnect/widgets/custom_widgets/im_widget_2.dart';
import 'package:ifdconnect/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as ta;

class Wall_card2 extends StatefulWidget {
  Wall_card2(this.offers, this.user, this.list, this.lat, this.lng,
      this.analytics, this.show);

  Offers offers;
  User user;
  var list;
  var lat;
  var lng;
  var analytics;
  bool show = false;

  @override
  _Wall_cardState createState() => _Wall_cardState();
}

class _Wall_cardState extends State<Wall_card2> {
  ParseServer parse_s = new ParseServer();

  delete() async {
    await parse_s.deleteparse("offers/" + widget.offers.objectId);
    setState(() {
      widget.offers.delete = true;
    });
  }

  Future _launched;

  Future _launch(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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

  tap() {
    if (widget.offers.type == "Mission" ||
        widget.offers.type == "Objets perdus" ||
        widget.offers.type == "Général" ||
        widget.offers.type == "Hébergement" ||
        widget.offers.type == "Annonces") {
      Navigator.push(context,
          new MaterialPageRoute(builder: (BuildContext context) {
        return new DetailsAnnonce(
            widget.offers, widget.user, widget.list, null, widget.analytics);
      }));
    } else if (widget.offers.type == "news" || widget.offers.type == "event") {
      Navigator.push(context,
          new MaterialPageRoute(builder: (BuildContext context) {
        return new DetailsParc(widget.offers, widget.user, widget.offers.type,
            widget.list, null, widget.analytics, widget.lat, widget.lng);
      }));
    }
    /*else if (widget.offers.type == "promotion") {
      Navigator.push(context,
          new MaterialPageRoute(builder: (BuildContext context) {
            return new Promo_details(widget.offers, widget.user, widget.lat,
                widget.lng);
          }));
    }*/ /*else if (widget.offers.type == "boutique") {
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (BuildContext context) => ProductPage(widget.offers,
                  widget.user, widget.lat, widget.lng)));
    } */
    else {}
  }

  Widget text_desc() => Row(
          mainAxisAlignment:
              AppServices.hasArabicCharacters(widget.offers.name.toString()) ==
                      true
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
          children: [
            Expanded(
                child: Container(
              padding: EdgeInsets.only(left: 16.w, right: 16.w),
              child: widget.offers.name.toString() == "null"
                  ? Container()
                  : InkWell(
                      onTap: () {
                        tap();

                        ///ji
                      },
                      child: Container(
                          child: new Linkify(
                        onOpen: (link) =>
                            AppServices.go_webview(link.url, context),
                        overflow: TextOverflow.ellipsis,

                        //jiji
                        text: widget.offers.name.toString() == "null"
                            ? ""
                            : widget.offers.name.toString(),
                        maxLines: 2,

                        textDirection: AppServices.hasArabicCharacters(
                                    widget.offers.name) ==
                                true
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        style: TextStyle(
                          fontFamily: AppServices.hasArabicCharacters(
                                  widget.offers.name)
                              ? 'open'
                              : 'Hbold',
                          color: Colors.black,
                          fontSize: ScreenUtil().setSp(13.0),
                          //  fontWeight: FontWeight.w600,
                        ),
                      ))),
            ))
          ]);

  var st = TextStyle(
      color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14.sp);

  void playYoutubeVideo(text) {
    Navigator.push(context,
        new MaterialPageRoute<String>(builder: (BuildContext context) {
      return new WebviewScaffold(
        url: text,
        appBar: new AppBar(
          title: new Text(""),
        ),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    var textcat = new TextStyle(color: Colors.grey[700], fontSize: 12.0);

    tell() {
      _launched = _launch('tel:' + widget.offers.partner.phone);
    }

    ratefunc() {}

    return widget.offers.delete
        ? Container()
        : Container(
            padding: new EdgeInsets.all(10.0.w),
            child: new Container(
                decoration: Widgets.boxdecoration_container3(),
                // decoration: Widgets.boxdecoration_container2(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      onTap: () {},
                                      child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: new Border.all(
                                                color: Fonts.col_grey
                                                    .withOpacity(0.3),
                                                width: 1.2),
                                          ),
                                          child: new ClipOval(
                                              child: new Container(
                                                  color: Fonts.col_app,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.12,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.12,
                                                  child: new Center(
                                                      child:
                                                          FadingImage.network(
                                                    widget.offers.author1
                                                                .toString() ==
                                                            "null"
                                                        ? widget.offers
                                                                    .partner.logo
                                                                    .toString() ==
                                                                "null"
                                                            ? widget.offers
                                                                .partner.logo
                                                                .toString()
                                                            : widget.offers
                                                                .partner.logo
                                                        : widget.offers.author1
                                                            .image,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.12,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.12,
                                                    fit: BoxFit.cover,
                                                  )))))),
                                  new Container(
                                    width: 8.0,
                                  ),
                                  new Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(children: <Widget>[
                                          new Text(
                                              widget.offers.author1
                                                          .toString() ==
                                                      "null"
                                                  ? widget.offers.partner.logo
                                                              .toString() ==
                                                          "null"
                                                      ? widget
                                                          .offers.partner.name
                                                      : widget
                                                          .offers.partner.name
                                                  : widget.offers.author1
                                                          .fullname +
                                                      " " +
                                                      widget.offers.author1
                                                          .firstname,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: new TextStyle(
                                                  fontFamily: "Hbold",
                                                  color: Colors.grey[800],
                                                  fontSize: ScreenUtil()
                                                      .setSp(13.5))),
                                          Container(
                                            width: 4,
                                          ),
                                        ]),
                                        new Container(height: 2.0),
                                        new Text(
                                          ta.format(widget.offers.create,
                                              locale: "fr"),
                                          style: new TextStyle(
                                              color: Fonts.col_grey,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600),
                                        )
                                      ])
                                ])),
                    Container(
                      margin: EdgeInsets.only(left: 0.w, right: 0.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0.r),
                        //  color: Colors.grey[200],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.offers.pic.toString() != "null" &&
                                  widget.offers.pic.toString() != "[]"
                              ? Container(
                                  //height: 490.h,

                                  constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width *
                                            0.98,
                                    // minWidth: 150.0,
                                  ),
                                  child: Stack(children: <Widget>[
                                    GestureDetector(
                                        onTap: () {
                                          tap();
                                        },
                                        child: ImageWidget2(
                                            widget.offers.pic, tap)),
                                    Positioned(
                                      top: MediaQuery.of(context).size.width *
                                          0.085,
                                      right: MediaQuery.of(context).size.width *
                                          0.09,
                                      child: widget.offers.pic.length > 3
                                          ? new Text(
                                              "+" +
                                                  (widget.offers.pic.length - 3)
                                                      .toString(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 32,
                                                  fontWeight: FontWeight.w600),
                                            )
                                          : Container(),
                                    ),
                                    Positioned(
                                      bottom: 4,
                                      right: 4,
                                      child:
                                          widget.offers.urlVideo.toString() !=
                                                      "null" &&
                                                  widget.offers.urlVideo
                                                          .toString() !=
                                                      ""
                                              ? IconButton(
                                                  iconSize: 42,
                                                  icon: CircleAvatar(
                                                      radius: 28,
                                                      // backgroundColor: Colors.orange[500],
                                                      child: Padding(
                                                          padding:
                                                              EdgeInsets.all(8),
                                                          child: Image.asset(
                                                            "images/pdf.png",
                                                            color: Colors.white,
                                                            width: 28,
                                                            height: 28,
                                                          ))),
                                                  onPressed: () {},
                                                )
                                              : Container(),
                                    )
                                  ]),
                                )
                              : new Container(),
                          Container(height: 6.h),
                          text_desc(),
                          Container(
                            height: 0.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                )));
  }
}
