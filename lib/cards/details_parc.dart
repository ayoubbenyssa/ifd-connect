import 'dart:async';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:ifdconnect/commeents/comments_screen.dart';
import 'package:ifdconnect/services/app_services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:ifdconnect/cards/details_partner.dart';
import 'package:ifdconnect/cards/like_widget.dart';
import 'package:ifdconnect/cards/option_widget.dart';
import 'package:ifdconnect/chat/chatscreen.dart';
import 'package:ifdconnect/func/parsefunc.dart';

import 'package:ifdconnect/models/offers.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/services/youtube_service.dart';
import 'package:ifdconnect/widgets/common.dart';
import 'package:ifdconnect/widgets/image_widget.dart';
import 'package:ifdconnect/widgets/youtube_widget.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:timeago/timeago.dart' as ta;

class DetailsParc extends StatefulWidget {
  DetailsParc(this.offer, this.user, this.tpe, this.listp, this.auth,
      this.analytics, this.lat, this.lng);

  Offers offer;
  User user;
  var tpe;
  var listp;
  var auth;
  var analytics;
  var lat;
  var lng;

  @override
  _ShopCardState createState() => _ShopCardState();
}

class _ShopCardState extends State<DetailsParc> {
  ParseServer parseFunctions = new ParseServer();

  String link_img = "", link_title = "";

 /* getLink() {
    GetLinkData.getLink(widget.offer.urlVideo).then((vall) {
      setState(() {
        link_img = vall["image"];
        link_title = vall["title"];
      });
    });
  }*/

  @override
  void initState() {
    parseFunctions.putparse(
        "offers/" + widget.offer.objectId, {"count": widget.offer.count + 1});
    //getLink();

    super.initState();
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

  confirmer(my_id, his_id, user_me, user) async {
    // widget.delete();

    onLoading(context);

    DatabaseReference gMessagesDbRef2 = FirebaseDatabase.instance
        .reference()
        .child("room_medz")
        .child(my_id + "_" + his_id);
    Navigator.of(context, rootNavigator: true).pop('dialog');

    Navigator.push(context,
        new MaterialPageRoute(builder: (BuildContext context) {
          return new ChatScreen(my_id, his_id, widget.listp, false, widget.auth,
              widget.analytics,
              user: user_me);
        }));
  }

  //For ùaking a call
  Future _launched;

  Future _launch(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  gotomap() {
    var lat = widget.offer.latLng.toString().split(";")[0];
    var lng = widget.offer.latLng.toString().split(";")[1];
    _launched = _launch('https://www.google.com/maps/@$lat,$lng,16z');
  }

  void playYoutubeVideo() {
    AppServices.go_webview(widget.offer.urlVideo.toString(), context);
  }

  go_det() {
    Navigator.push(context,
        new MaterialPageRoute(builder: (BuildContext context) {
          return new DetailsParc(
              widget.offer,
              widget.user,
              widget.offer.type,
              [],
              null,
              widget.analytics,
              widget.lat,
              widget.lng);
        }));
  }

  func_update_comment(num) {
    setState(() {
      widget.offer.numbercommenttext =
          (int.parse(widget.offer.numbercommenttext) + num).toString();
    });
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(color: Colors.white),

      ),
      body: new ListView(
        children: <Widget>[
          ImageWidget(widget.offer.pic, go_det),
          Container(
            child: new Container(
                color: Fonts.col_cl,
                padding: new EdgeInsets.all(16.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    InkWell(
                        onTap: () {
                          Navigator.push(context, new MaterialPageRoute(
                              builder: (BuildContext context) {
                                return new PartnerCardDetails(
                                    widget.offer.partner,
                                   /* widget.lat,
                                    widget.lng,
                                    widget.user,*/
                                    );
                              }));
                        },
                        child: new ClipOval(
                            child: new Container(
                                color: Fonts.col_app,
                                width: MediaQuery.of(context).size.width * 0.12,
                                height:
                                MediaQuery.of(context).size.width * 0.12,
                                child: new Center(
                                    child: FadingImage.network(
                                      widget.offer.partner.logo,
                                      width:
                                      MediaQuery.of(context).size.width * 0.12,
                                      height:
                                      MediaQuery.of(context).size.width * 0.12,
                                      fit: BoxFit.cover,
                                    ))))),
                    new Container(
                      width: 8.0,
                    ),
                    new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            width: MediaQuery.of(context).size.width * 0.60,
                            child: new Linkify(
                                onOpen: (link) =>
                                    AppServices.go_webview(link.url, context),

                                //jiji
                                text: widget.offer.partner.name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: new TextStyle(
                                    color: Colors.grey[800],
                                    fontWeight: FontWeight.w600,
                                    fontSize:
                                    ScreenUtil().setSp(14)))),
                        new Container(height: 0.0),

                             new Text(
                              ta.format(widget.offer.create,
                                  locale: "fr"),
                              style: new TextStyle(
                                  color: Fonts.col_grey,
                                  //  fontWeight: FontWeight.bold,
                                  fontSize: ScreenUtil()
                                      .setSp(16))
                              ),
                      ],
                    ),
                    new Expanded(child: new Container()),
                    widget.tpe != "1"
                        ? new Container(
                        child:
                        new FavoriteButton(widget.offer, widget.user))
                        : new Container(),
                    Container(
                      width: 4,
                    )
                    /*  ButtonWidget(widget.offer, widget.user, ratefunc,
                        widget.lat, widget.lng, widget.onLocaleChange)*/
                  ],
                )),
          ),
          Container(
            height: 8,
          ),
          widget.offer.type == "event"
              ? new Container(
            padding: new EdgeInsets.only(
                top: 6.0, bottom: 6.0, left: 16.0, right: 16.0),
            width: width * 0.64,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new GestureDetector(
                    onTap: () {
                      gotomap();
                    },
                    child: new Container(
                      //padding: new EdgeInsets.only(left: 2.0,bottom: 2.0,top: 2.0,right: 2.0),
                      //  width: 150.0,
                      //alignment: Alignment.center,
                        decoration: new BoxDecoration(
                          border: new Border.all(
                              color: Colors.blue, width: 0.5),
                          color: Colors.transparent,
                          borderRadius: new BorderRadius.circular(4.0),
                        ),
                        child: new Row(
                          children: <Widget>[
                            new Icon(Icons.directions,
                                color: Fonts.col_app, size: 12.0),
                            new Container(
                              width: 4.0,
                            ),
                            new Text(
                              "Itinéraire",
                              style: new TextStyle(
                                  color: Fonts.col_app, fontSize: 11.5),
                            )
                          ],
                        ))),
                new Container(
                  width: 4.0,
                ),
                new GestureDetector(
                    onTap: () {
                      gotomap();
                    },
                    child: new Text( widget.offer.dis.toString()=="null"?"-.- Km":widget.offer.dis.toString(),
                        style: new TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                            fontSize: 11.0))),
                // new Container(width: height*0.05),
              ],
            ),
          )
              : Container(),
          new Container(
            padding: new EdgeInsets.only(left: 16.0, right: 16.0),
            child: new Linkify(
              maxLines: 60,
              onOpen: (link) => AppServices.go_webview(link.url, context),

              //jiji
              text: widget.offer.name,
              style: new TextStyle(
                  color: Colors.blueGrey[800], fontWeight: FontWeight.bold),
            ),
          ),
          new Container(height: 8.0),
          link_title == ""
              ? Container()
              : YoutubeWidget(link_title, link_img, widget.offer.urlVideo,
              playYoutubeVideo),
          /*GestureDetector(
              onTap: () {
                print("dhidhid");
                playYoutubeVideo();

              },
              child: new Container(
                padding: EdgeInsets.only(left: 8.0,right: 8.0),
                  width: width * 0.63,
                  child: new Text(
                      widget.offer.urlVideo == ""
                          ? ""
                          : widget.offer.urlVideo,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: new TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline))
              )),*/

          Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              width: MediaQuery.of(context).size.width * 0.84,
              child: new Linkify(
                onOpen: (link) => AppServices.go_webview(link.url, context),

                //jiji
                text: widget.offer.summary.toString() == "null"
                    ? ""
                    : widget.offer.summary.toString(),
                maxLines: 20,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[900],
                    fontSize: ScreenUtil().setSp(14)),
              )),
          Container(
              padding: EdgeInsets.only(left: 4, right: 4),
              width: MediaQuery.of(context).size.width * 0.84,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(),
                  ),
                  FlatButton(
                    child: Text(
                      widget.offer.numbercommenttext.toString() == "0"
                          ? "Commenter"
                          : widget.offer.numbercommenttext.toString() == "1"
                          ? widget.offer.numbercommenttext.toString() +
                          " Commentaire"
                          : widget.offer.numbercommenttext.toString() +
                          " Commentaires",
                      style: TextStyle(
                          color: Fonts.col_app_green,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {

                      Navigator.push(
                          context,
                          new MaterialPageRoute<Null>(
                              builder: (BuildContext context) =>
                              new CommentsScreen(
                                post: widget.offer,
                                focus: false,
                                increment: func_update_comment,
                                user_me: widget.user,
                              )));
                      /*Navigator.push(
                          context,
                          new MaterialPageRoute<Null>(
                              builder: (BuildContext context) => new Comments(
                                  widget.offer, "", true, widget.user, func)));*/
                    },
                  )
                ],
              )),
          new Container(
              padding: new EdgeInsets.only(left: 8.0, right: 8.0),
              child: HtmlWidget(
                widget.offer.description
                    .toString()
                    .replaceAll(RegExp(r'(\\n)+'), ''),

              )),
          /*InkWell(
            onTap: () {
             /* if (Platform.isIOS)
                Navigator.push(context, new MaterialPageRoute<String>(
                    builder: (BuildContext context) {
                      return Scaffold(
                        appBar: AppBar(
                          title: Text(""),
                        ),
                        body: WebView(
                          initialUrl: widget.offer.docUrl,
                        ),
                      );
                    }));
              else
                Navigator.push(context, new MaterialPageRoute<String>(
                    builder: (BuildContext context) {
                      return new Scaffold(
                        appBar: AppBar(
                          title: new Text(widget.offer.name),
                        ),
                        body: SimplePdfViewerWidget(
                          completeCallback: (bool result) {},
                          initialUrl: widget.offer.docUrl,
                        ),
                      );
                    }));*/
            },
            child: Row(
              children: <Widget>[
                widget.offer.docUrl.toString() == "null" ||
                    widget.offer.docUrl == ""
                    ? Container()
                    : IconButton(
                  iconSize: 42,
                  icon: CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.blue[500],
                      child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Image.asset(
                            "images/pdf.png",
                            color: Colors.white,
                            width: 28,
                            height: 28,
                          ))),
                  onPressed: () {
                    if (Platform.isIOS)
                      Navigator.push(context,
                          new MaterialPageRoute<String>(
                              builder: (BuildContext context) {
                                return Scaffold(
                                  appBar:
                                  AppBar(title: new Text(widget.offer.name)),
                                  body: WebView(
                                    initialUrl: widget.offer.docUrl,
                                    javascriptMode: JavascriptMode.unrestricted,
                                  ),
                                );
                              }));
                    else
                      Navigator.push(context,
                          new MaterialPageRoute<String>(
                              builder: (BuildContext context) {
                                return new Scaffold(
                                  appBar: AppBar(
                                    title: new Text(widget.offer.name),
                                  ),
                                  body: SimplePdfViewerWidget(
                                    completeCallback: (bool result) {},
                                    initialUrl: widget.offer.docUrl,
                                  ),
                                );
                              }));
                  },
                ),
              ],
            ),
          )*/
        ],
      ),
    );
  }
}
