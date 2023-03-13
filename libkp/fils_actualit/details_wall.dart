import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:ifdconnect/fils_actualit/card_footer.dart';
import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/models/offers.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/services/block.dart';
import 'package:ifdconnect/user/details_user.dart';
import 'package:ifdconnect/widgets/common.dart';
import 'package:timeago/timeago.dart' as ta;

class Wall_card_details extends StatefulWidget {
  Wall_card_details(this.offers, this.user, this.list, this.analytics);

  Offers offers;
  User user;
  var list;
  var analytics;

  @override
  _Wall_carState createState() => _Wall_carState();
}

class _Wall_carState extends State<Wall_card_details> {
  ParseServer parse_s = new ParseServer();

  delete() async {
    await parse_s.deleteparse("offers/" + widget.offers.objectId);
    setState(() {
      widget.offers.delete = true;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(""),
          backgroundColor: Colors.white,
        ),
        body: widget.offers.delete
            ? Container()
            : Container(
                color: Colors.white,
                padding: new EdgeInsets.all(8.0),
                child: new Material(
                    elevation: 2.0,
                    shadowColor: Fonts.col_app,
                    borderRadius: new BorderRadius.circular(4.0),
                    color: Colors.white,
                    child: ListView(
                      children: <Widget>[
                        widget.offers.pic.isNotEmpty
                            ? Container(
                                color: Colors.grey[300],
                                height: 240.0,
                                child: Stack(children: <Widget>[
                                  Positioned.fill(
                                      child: Container(
                                    height: 240.0,
                                    child: widget.offers.pic.length == 1
                                        ? Hero(
                                            tag: widget.offers.pic[0],
                                            child: new FadingImage.network(
                                              widget.offers.pic[0],
                                              height: 240.0,
                                              fit: BoxFit.cover,
                                            ))
                                        : new Swiper(
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return new Container(
                                                  color: Colors.grey[200],
                                                  child: Hero(
                                                      tag: widget
                                                          .offers.pic[index]
                                                          .toString(),
                                                      child: new FadingImage
                                                          .network(
                                                        widget.offers.pic[index]
                                                            .toString()
                                                        /*"http://via.placeholder.com/350x150"*/,
                                                        fit: BoxFit.cover,
                                                      )));
                                            },
                                            itemCount: widget.offers.pic.length,
                                            pagination: new SwiperPagination(),
                                            control: new SwiperControl(),
                                          ),
                                  )),

                                  /* new Positioned(
                        left: 4,
                        bottom: 4,
                        child: RaisedButton(onPressed: (){

                    },child: Text(widget.offers.community),))*/
                                  /* new Positioned(
                            right: 4.0,
                            top: 4.0,
                            child: MenuCard(widget.offers, widget.user, delete,Colors.white))*/
                                ]),
                              )
                            : new Container(),
                        new Container(
                            padding: new EdgeInsets.all(8.0),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                new ClipOval(
                                    child: new Container(
                                        color: Fonts.col_app,
                                        width: 42.0,
                                        height: 42.0,
                                        child: new Center(
                                            child: FadingImage.network(
                                          widget.offers.author1.image,
                                          width: 42.0,
                                          height: 42.0,
                                          fit: BoxFit.cover,
                                        )))),
                                new Container(
                                  width: 8.0,
                                ),
                                new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new Text(
                                        widget.offers.author1.fullname +
                                            " " +
                                            widget.offers.author1.firstname,
                                        style: new TextStyle(
                                            color: Colors.grey[800],
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12.5)),
                                    new Container(height: 2.0),
                                    new Text(
                                      ta.format(widget.offers.create),
                                      style: new TextStyle(
                                          color: Colors.grey[600],
                                          //  fontWeight: FontWeight.bold,
                                          fontSize: 11.0),
                                    ),
                                  ],
                                ),
                                new Expanded(child: new Container()),
                                // widget.offers.pic.isEmpty?MenuCard(widget.offers, widget.user, delete,Colors.black):Container()
                              ],
                            )),
                        Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            padding: EdgeInsets.only(
                                left: 12.0, right: 12.0, bottom: 8.0),
                            child: new Text(
                              widget.offers.title,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600]),
                            )),
                        Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            padding: EdgeInsets.only(left: 12.0, right: 12.0),
                            child: new Text(
                              widget.offers.description,
                            )),
                        CardFooter(
                          widget.offers,
                          widget.user,
                          null,
                          context,
                          [],
                          null,
                          0.0,
                          0.0,
                        )
                      ],
                    ))));
  }
}
