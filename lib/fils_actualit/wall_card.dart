import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'package:ifdconnect/annonces/annonces_tabs.dart';
import 'package:ifdconnect/annonces/details_annonce.dart';
import 'package:ifdconnect/cards/details_parc.dart';
import 'package:ifdconnect/cards/header_card.dart';
import 'package:ifdconnect/cards/prom_details.dart';
import 'package:ifdconnect/fils_actualit/card_footer.dart';
import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/home/publications.dart';
import 'package:ifdconnect/models/offers.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/services/app_services.dart';
import 'package:ifdconnect/services/block.dart';
import 'package:ifdconnect/shop/pages/product_page.dart';
import 'package:ifdconnect/widgets/image_widget.dart';
import 'package:ifdconnect/widgets/widgets.dart';
//import 'package:simple_pdf_viewer/simple_pdf_viewer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

class Wall_card extends StatefulWidget {
  Wall_card(this.offers, this.user, this.list, this.lat, this.lng,
      this.analytics);

  Offers offers;
  User user;
  var list;
  var lat;
  var lng;
  var analytics;

  @override
  _Wall_carState createState() => _Wall_carState();
}

class _Wall_carState extends State<Wall_card> {
  ParseServer parse_s = new ParseServer();

  delete() async {
    await parse_s.deleteparse("offers/" + widget.offers.objectId);
    setState(() {
      widget.offers.delete = true;
    });
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

  block_user() async {
    await Block.insert_block(widget.user.auth_id, widget.offers.author1.auth_id,
        widget.user.id, widget.offers.author1.id);
    await Block.insert_block(widget.offers.author1.auth_id, widget.user.auth_id,
        widget.offers.author1.id, widget.user.id);

    setState(() {
      widget.user.show = false;
    });
  }

  //

// Mission
//Hébergement
  //Objets perdus

  tap() {


    if (
    widget.offers.type == "Général_emi" ||
        widget.offers.type == "Mission_emi" ||
        widget.offers.type == "Objets perdus_emi" ||
        widget.offers.type == "Hébergement_emi" ||
        widget.offers.type == "Annonces_emi") {

      Navigator.push(context,
          new MaterialPageRoute(builder: (BuildContext context) {
            return new DetailsAnnonce(widget.offers, widget.user, widget.list, null,
                widget.analytics,);
          }));
    } else if (widget.offers.type == "news" || widget.offers.type == "event") {
      Navigator.push(context,
          new MaterialPageRoute(builder: (BuildContext context) {
            return new DetailsParc(
                widget.offers,
                widget.user,
                widget.offers.type,
                widget.list,
                null,
                widget.analytics,
                widget.lat,
                widget.lng);
          }));
    } else if (widget.offers.type == "promotion") {
      Navigator.push(context,
          new MaterialPageRoute(builder: (BuildContext context) {
            return new Promo_details(widget.offers, widget.user,  );
          }));
    } else if (widget.offers.type == "boutique") {
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (BuildContext context) => ProductPage(widget.offers,
                  widget.user, )));
    }
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
                        maxLines: 4,

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
                          fontSize: ScreenUtil().setSp(17),
                          fontWeight: FontWeight.w500,
                        ),
                      ))),
            ))
      ]);

  var st =
  TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16);

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

  type() {

      return Container();
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var textcat = new TextStyle(color: Colors.grey[700], fontSize: 12.0);

    getLinWidget() {
      if (widget.offers.items.toString() == "null" ||
          widget.offers.items == []) {
        return Container();
      } else {
        if (widget.offers.items.length == 1) {
          return new GestureDetector(
              onTap: () {
                _launched = _launch(
                    widget.offers.items[0].split(",").length == 0
                        ? widget.offers.items[0]
                        : widget.offers.items[0].split(",")[0]);
              },
              child: new Text(
                  widget.offers.items[0].split(",").length == 0
                      ? widget.offers.items[0]
                      : widget.offers.items[0].split(",")[0],
                  style: new TextStyle(
                      wordSpacing: 1.0,
                      color: Fonts.col_app,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w900)));
        } else {
          return new GestureDetector(
              onTap: () {

                AppServices.go_webview( widget.offers.items[0],context);

                //playYoutubeVideo(widget.offers.items[0]);
                //  _launched = _launch(items[0]);
              },
              child: new Container(
                  padding: EdgeInsets.only(top: 4),
                  child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        /* new Container(
                    padding: new EdgeInsets.only(left: 16.0, bottom: 8.0),
                    child: new Text(link1.title.toString(),
                        style: new TextStyle(color: Colors.grey[700]))),*/
                        new SizedBox(
                            height: 200.0,
                            child: new Stack(
                              children: <Widget>[
                                new Positioned.fill(
                                  child: new Image.network(
                                    widget.offers.items[1].toString(),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                new Positioned(
                                    left: 2,
                                    right: 2,
                                    top: 2,
                                    bottom: 2,
                                    child: Image.asset("images/youtube.png"))
                              ],
                            )),
                        new Container(
                          // color: Colors.grey[200],
                            padding: new EdgeInsets.only(
                                left: 16.0, bottom: 8.0, top: 8.0, right: 16),
                            child: new Text(widget.offers.items[3].toString(),
                                style: textcat)),
                        new Container(
                            width: 5000.0,
                            color: Colors.grey[200],
                            padding: new EdgeInsets.only(
                                left: 16.0, bottom: 8.0, right: 16),
                            child: new Text(widget.offers.items[2].toString(),
                                style: new TextStyle(
                                    color: Colors.grey[500], fontSize: 11.0)))
                      ])));
        }
      }
    }

    tell() {
      _launched = _launch('tel:' + widget.offers.partner.phone);
    }

    Widget spons = Container(
        height: 20,
        width: 80,
        child: SizedBox(
          // height: 20.0,
          // width: 180.0,
            child: new Center(
                child: ColorizeAnimatedTextKit(
                  text: [
                    "Sponsorisé",
                  ],
                  textStyle: TextStyle(
                    fontSize: 12.0,
                  ),
                  colors: [
                    Colors.pink,
                    Colors.blue,
                    Colors.yellow[400],
                    Colors.blue[700],
                  ],
                ))));

    ratefunc() {}

    return widget.offers.delete
        ? Container()
        : Container(
        margin: EdgeInsets.all(8),
        child:new Container(
            decoration: Widgets.boxdecoration_container3(),
            child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    HeaderCard(
                        widget.offers,
                        widget.user,
                        widget.lat,
                        widget.lng,
                        null,
                        block_user,
                        ratefunc),
                    widget.offers.pic.toString() != "null" &&
                        widget.offers.pic.toString() != "[]"
                        ? Container(
                      color: Colors.grey[200],
                      // constraints: ConstrainedBox(constraints: null),
                      //height: MediaQuery.of(context).size.height*0.42,
                      constraints: BoxConstraints(
                        maxHeight:
                        MediaQuery.of(context).size.height * 0.63,
                        maxWidth:
                        MediaQuery.of(context).size.width * 0.98,
                        // minWidth: 150.0,
                      ),
                      child: Stack(children: <Widget>[
                        GestureDetector(
                            onTap: () {
                              tap();
                            },
                            child: Container(
                                color: Colors.grey[200],
                                // height: MediaQuery.of(context).size.height*0.42,
                                child: ImageWidget(widget.offers.pic,tap)
                              /* : new Swiper(
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return new Container(
                                                        color: Colors.grey[200],
                                                        child: Hero(
                                                            tag: widget.offers
                                                                .pic[index]
                                                                .toString(),
                                                            child:
                                                                new FadingImage
                                                                    .network(
                                                              widget
                                                                      .offers
                                                                      .pic[
                                                                          index]
                                                                      .toString()
                                                                  /*"http://via.placeholder.com/350x150"*/,
                                                              fit: BoxFit.cover,
                                                            )));
                                                  },
                                                  itemCount:
                                                      widget.offers.pic.length,
                                                  pagination:
                                                      new SwiperPagination(),
                                                  control: new SwiperControl(),
                                                )*/
                            )),
                        Positioned(
                          right: 4,
                          top: 4,
                          child: type(),
                        ),
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
                          child: widget.offers.type == "promotion" ||
                              widget.offers.type == "boutique"
                              ? widget.offers.partner.phone
                              .toString() ==
                              "null"
                              ? Container()
                              : IconButton(
                            iconSize: 42,
                            icon: CircleAvatar(
                                radius: 28,
                                backgroundColor:
                                Colors.blue[500],
                                child: Padding(
                                    padding:
                                    EdgeInsets.all(8),
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
                              : Container()
                          /*widget.promo.rate.toString() != "" &&
                                  widget.promo.rate.toString() != "null"
                              ? Text(widget.promo.rate + "%")
                              : Container()*/
                          ,
                        ),
                        /*Positioned(
                          bottom: 4,
                          right: 4,
                          child: widget.offers.docUrl.toString() !=
                              "null" &&
                              widget.offers.docUrl.toString() !=
                                  ""
                              ? IconButton(
                            iconSize: 42,
                            icon: CircleAvatar(
                                radius: 28,
                                // backgroundColor: Colors.orange[500],
                                child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Image.asset(
                                      "images/pdf.png",
                                      color: Colors.white,
                                      width: 28,
                                      height: 28,
                                    ))),
                            onPressed: () {
                              Navigator.push(context,
                                  new MaterialPageRoute<String>(
                                      builder: (BuildContext
                                      context) {
                                        return new Scaffold(
                                          appBar: AppBar(
                                            title: new Text(
                                                widget.offers.name),
                                          ),
                                          body: SimplePdfViewerWidget(
                                            completeCallback:
                                                (bool result) {},
                                            initialUrl:
                                            widget.offers.docUrl,
                                          ),
                                        );
                                      }));
                            },
                          )
                              : Container()
                          /*widget.promo.rate.toString() != "" &&
                                  widget.promo.rate.toString() != "null"
                              ? Text(widget.promo.rate + "%")
                              : Container()*/
                          ,
                        ),*/
                        Positioned(
                          bottom: 12,
                          left: 12,
                          child: widget.offers.type == "promotion" ||
                              widget.offers.type == "boutique"
                              ? widget.offers.rate.toString() != "" &&
                              widget.offers.rate.toString() !=
                                  "null"
                              ? new Container(
                              padding: EdgeInsets.all(8),
                              //alignment: Alignment.center,
                              decoration: new BoxDecoration(
                                color: Fonts.col_app
                                    .withOpacity(0.8),
                                borderRadius:
                                new BorderRadius.circular(
                                    4.0),
                              ),
                              child: Text(widget.offers.rate,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight:
                                      FontWeight.bold)))
                              : Container()
                              : Container(),
                        )
                      ]),
                    )
                        : new Container(),
                    Row(
                      children: <Widget>[
                        Expanded(child: Container()),
                        widget.offers.nboost == 0 ? spons : Container(),
                      ],
                    ),
                    Container(
                      child: Column(
                        children: <Widget>[
                          Container(height: 16.h),
                          text_desc(),
                       //   Container(height: 4),
                        //  getLinWidget(),
                        ],
                      ),
                    ),
                    /*


                    title
                     */

                    CardFooter(
                      widget.offers,
                      widget.user,
                      delete,
                      context,
                      [],
                      null,
                      widget.lat,
                      widget.lng,

                       )
                  ],
                )));
  }
}
