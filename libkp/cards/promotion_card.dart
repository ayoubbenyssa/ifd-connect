import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:ifdconnect/cards/buy_button.dart';
import 'package:ifdconnect/cards/details_partner.dart';
import 'package:ifdconnect/cards/prom_details.dart';
import 'package:ifdconnect/models/offers.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/services/youtube_service.dart';
import 'package:ifdconnect/user/details_user.dart';
import 'package:ifdconnect/widgets/common.dart';
import 'package:ifdconnect/widgets/image_widget.dart';
import 'package:ifdconnect/widgets/youtube_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class PromotionsCard extends StatefulWidget {
  PromotionsCard(this.promo, this.user, this.show, this.show_im);

  Offers promo;
  User user;

  bool show = false;
  bool show_im = true;

  @override
  _PromotionsCardState createState() => _PromotionsCardState();
}

class _PromotionsCardState extends State<PromotionsCard> {
//Promo_details

  String link_img = "", link_title = "";

  getLink() {
    GetLinkData.getLink(widget.promo.urlVideo).then((vall) {
      setState(() {
        link_img = vall["image"];
        link_title = vall["title"];
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    getLink();
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
    var lat = widget.promo.latLng.toString().split(";")[0];
    var lng = widget.promo.latLng.toString().split(";")[1];
    _launched = _launch('https://www.google.com/maps/@$lat,$lng,16z');
  }

  void playYoutubeVideo(text,context) {
    Navigator.push(context, new MaterialPageRoute<String>(
        builder: (BuildContext context) {
          return new WebviewScaffold(
            url: text,
            appBar: new AppBar(
              title: new Text(""),
            ),
          );
        }));
  }



  tell() {
    _launched = _launch('tel:' + widget.promo.partner.phone);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    var style = new TextStyle(color: Fonts.col_app_fon, fontSize: 12.0);

    return Card(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
              padding: new EdgeInsets.all(6.0),
              // width: width * 0.64,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new GestureDetector(
                      onTap: () {
                        Navigator.push(context, new MaterialPageRoute(
                            builder: (BuildContext context) {
                          return new PartnerCardDetails(widget.promo.partner);
                        }));

                        /* Navigator.push(context, new MaterialPageRoute(
                            builder: (BuildContext context) {
                          return new ShopCardDetails(
                              widget.promo.partner.partnerKey.toString());
                        }));*/
                      },
                      child: new ClipOval(
                          child: new Container(
                              color: Fonts.col_app,
                              width: 46.0,
                              height: 46.0,
                              child: new Center(
                                  child: FadingImage.network(
                                widget.promo.partner.logo,
                                width: 46.0,
                                height: 46.0,
                                fit: BoxFit.cover,
                              ))))),
                  new Container(
                    width: 8.0,
                  ),
                  new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(widget.promo.partner.name,
                          style: new TextStyle(
                              color: Fonts.col_app,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.5)),
                      new Container(
                        height: 4.0,
                      ),
                      new Container(
                          width: width * 0.60,
                          child: new Text(
                            widget.promo.partner.address,
                            overflow: TextOverflow.ellipsis,
                            style: new TextStyle(
                                color: Colors.grey[600],
                                //  fontWeight: FontWeight.bold,
                                fontSize: 11.0),
                          )),
                    ],
                  ),

                  // new Container(width: height*0.05),
                ],
              )),
          new Container(
              color: Colors.grey[200],
              // height: 300.0,

              height: 225.0,
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.63,
                  maxWidth: MediaQuery.of(context).size.width * 0.98),
              child: !widget.show
                  ? GestureDetector(
                      onTap: () {
                        if (widget.show_im)
                          Navigator.push(context, new MaterialPageRoute(
                              builder: (BuildContext context) {
                            return new Promo_details(widget.promo, widget.user);
                          }));
                        else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullScreenWrapper(
                                      imageProvider: NetworkImage(
                                          widget.promo.pic[0].toString()),
                                    ),
                              ));
                        }
                      },
                      child: new Stack(fit: StackFit.expand, children: <Widget>[
                        ImageWidget(widget.promo.pic,null),
                        Positioned(
                          top: MediaQuery.of(context).size.width * 0.085,
                          right: MediaQuery.of(context).size.width * 0.085,
                          child: widget.promo.pic.length > 3
                                  ? new Text(
                                      "+" +
                                          (widget.promo.pic.length - 3)
                                              .toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 32,
                                          fontWeight: FontWeight.w600),
                                    )
                                  : Container()
                              /*widget.promo.rate.toString() != "" &&
                                  widget.promo.rate.toString() != "null"
                              ? Text(widget.promo.rate + "%")
                              : Container()*/
                              ,
                        ),
                        Positioned(
                          bottom: 4,
                          right: 4,
                          child: widget.promo.partner.phone.toString() == "null"
                                  ? Container()
                                  : IconButton(
                                      iconSize: 42,
                                      icon: CircleAvatar(
                                          radius: 28,
                                          backgroundColor: Colors.green[500],
                                          child: Padding(
                                              padding: EdgeInsets.all(8),
                                              child: Image.asset(
                                                "images/tel.png",
                                                color: Colors.white,
                                                width: 28,
                                                height: 28,
                                              ))),
                                      onPressed: () {
                                        tell();
                                      },
                                    )
                              /*widget.promo.rate.toString() != "" &&
                                  widget.promo.rate.toString() != "null"
                              ? Text(widget.promo.rate + "%")
                              : Container()*/
                              ,
                        ),
                        Positioned(
                          bottom: 12,
                          left: 12,
                          child: widget.promo.rate.toString() != "" &&
                                  widget.promo.rate.toString() != "null"
                              ? new Container(
                                  padding: EdgeInsets.all(8),
                                  //alignment: Alignment.center,
                                  decoration: new BoxDecoration(
                                    color: Fonts.col_app.withOpacity(0.8),
                                    borderRadius:
                                        new BorderRadius.circular(4.0),
                                  ),
                                  child: Text(widget.promo.rate,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)))
                              : Container(),
                        )
                      ]))
                  : ImageWidget(widget.promo.pic,null)),
          new Container(
            height: 8.0,
          ),
          new Container(
              padding: new EdgeInsets.all(12.0),
              child: new Text(widget.promo.name.toString(),
                  style: new TextStyle(
                      fontSize: 13.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold))),

/*          Row(
            children: <Widget>[
              widget.promo.partner.phone.toString() == "null"
                  ? Container()
                  : new Container(
                      padding: new EdgeInsets.only(left:12.0,right: 12),
                      child: new Text("Numéro de téléphone:   ",
                          style: new TextStyle(
                              fontSize: 13.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
              widget.promo.partner.phone.toString() == "null"
                  ? Container()
                  : new Container(
                      padding: new EdgeInsets.all(12.0),
                      child: new Text(widget.promo.partner.phone,
                          style: new TextStyle(
                              fontSize: 13.0,
                              color: Colors.blueGrey[800],
                              fontWeight: FontWeight.w500))),
            ],
          ),*/

          // Container(height: 4,),
          new Container(
              padding: new EdgeInsets.only(left: 12.0, right: 12.0),
              child: new Row(
                children: <Widget>[
                  new GestureDetector(
                      onTap: () {
                        gotomap();
                      },
                      child: new Container(
                          padding: new EdgeInsets.only(
                              left: 2.0, bottom: 2.0, top: 2.0, right: 2.0),
                          //  width: 150.0,
                          //alignment: Alignment.center,
                          decoration: new BoxDecoration(
                            border:
                                new Border.all(color: Colors.blue, width: 0.5),
                            color: Colors.transparent,
                            borderRadius: new BorderRadius.circular(4.0),
                          ),
                          child: new Row(
                            children: <Widget>[
                              new Icon(Icons.directions,
                                  color: Colors.blue[600], size: 12.0),
                              new Container(
                                width: 4.0,
                              ),
                              new Text(
                                "Itinéraire",
                                style: new TextStyle(
                                    color: Colors.blue, fontSize: 11.5),
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
                    child: new Row(
                      children: <Widget>[
                        new Icon(
                          Icons.location_on,
                          size: 12.0,
                          color: Fonts.col_app,
                        ),
                        new Container(
                          width: 2.0,
                        ),
                        new Text(
                          widget.promo.dis.toString()=="null"?"-.- Km": widget.promo.dis.toString(),
                          style: style,
                        ),
                      ],
                    ),
                  ),

                  Expanded(child: Container(),),

                widget.show?Container():  new InkWell(
                    // padding: EdgeInsets.all(0),
                      onTap: () {


                          Navigator.push(context, new MaterialPageRoute(
                              builder: (BuildContext context) {
                                return new Promo_details(
                                    widget.promo, widget.user);
                              }));

                      },
                      child: Container(
                          padding: EdgeInsets.only(right:8,top: 8,bottom: 8),
                          child:Text(
                            "Details",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.blue[800],
                                decoration: TextDecoration.underline),
                          )))


                ],
              )),
          widget.show
              ? Container(
                  height: 8.0,
                )
              : Container(),
          widget.show
              ? link_title == ""
                  ? Container()
                  : YoutubeWidget(link_title, link_img, widget.promo.urlVideo,
                      playYoutubeVideo)
              /*GestureDetector(
              onTap: () {
                print("dhidhid");
                playYoutubeVideo();

              },
              child: new Container(
                  padding: EdgeInsets.only(left: 8.0,right: 8.0),
                  width: width * 0.63,
                  child: new Text(
                      widget.promo.urlVideo == ""
                          ? ""
                          : widget.promo.urlVideo,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: new TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline))
              ))*/
              : Container(),
          new Container(
              padding: new EdgeInsets.only(top: 4.0, left: 12.0, right: 12.0),
              child: new Text(widget.promo.summary.toString(),
                  style: new TextStyle(
                    fontSize: 12.5,
                    color: Colors.blueGrey[600],
                    fontWeight: FontWeight.w500,
                  ))),
          widget.show
              ? new Container(
                  child: HtmlWidget(
                  widget.promo.description
                      .toString()
                      .replaceAll(RegExp(r'(\\n)+'), ''),

                ))
              : new Container(),
          new Container(height: 8.0),
          widget.promo.sellingPrice.toString() == ""
              ? Container()
              : new Container(
                  padding: new EdgeInsets.only(left: 4.0, right: 4.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Text("Prix:   "),
                      new Container(
                        width: 4.0,
                      ),
                      new Text(
                        widget.promo.sellingPrice.toString() + " DHS",
                        style: style,
                      ),
                      new Container(
                        width: 8.0,
                      ),
                      new Text(
                        widget.promo.initialPrice.toString() + " DHS",
                        style: new TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey[600],
                            fontSize: 12.0),
                      ),
                      new Container(
                        width: 8.0,
                      ),
                      new Text(
                        widget.promo.rate.toString(),
                        style: style,
                      ),
                      new Container(
                        width: 8.0,
                      ),
                    ],
                  )),
          new Container(
            height: 8.0,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[BuyButton(widget.promo, widget.user, false)],
          ),
          new Container(
            height: 8.0,
          ),
        ],
      ),
    );
  }
}
