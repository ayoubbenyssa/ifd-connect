import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:ifdconnect/models/shop.dart';
import 'package:ifdconnect/services/partners_list.dart';
import 'package:ifdconnect/widgets/common.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopCardDetails extends StatefulWidget {
  ShopCardDetails(this.shop);

  Shop shop;

  @override
  _ShopCardState createState() => _ShopCardState();
}

class _ShopCardState extends State<ShopCardDetails> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(),
      body:  new ListView(
              children: <Widget>[
                new Container(
                    color: Colors.grey[200],
                    height: 300.0,
                    child: new Swiper(
                      itemBuilder: (BuildContext context, int index) {
                        return new Container(
                            color: Colors.grey[200],
                            child: new FadingImage.network(
                              widget.shop.pic[index].toString()
                                  /*"http://via.placeholder.com/350x150"*/,
                              fit: BoxFit.cover,
                            ));
                      },
                      itemCount: widget.shop.pic.length,
                      pagination: new SwiperPagination(),
                      control: new SwiperControl(),
                    )),
                new Container(height: 12.0),
                new Container(
                  padding: new EdgeInsets.only(left: 2.0, right: 2.0),
                  child: HtmlWidget(
                    widget.shop.name.toString().replaceAll(RegExp(r'(\\n)+'), ''),

                  )
                ),
                new Container(
                  padding: new EdgeInsets.only(left: 8.0, right: 8.0),
                  child: HtmlWidget(
                    widget.shop.description.toString().replaceAll(RegExp(r'(\\n)+'), ''),

                  )
                ),
                new Container(
                  padding: new EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new GestureDetector(
                        onTap: () {
                          var lat = widget.shop.latLng.toString().split(";")[0];
                          var lng = widget.shop.latLng.toString().split(";")[1];
                          _launched = _launch(
                              'https://www.google.com/maps/@$lat,$lng,16z');
                        },
                        child: new Icon(
                          Icons.location_on,
                          color: Colors.grey[600],
                        ),
                      ),
                      new Container(
                        width: 4.0,
                      ),
                      new Text(
                        widget.shop.address,
                        style: new TextStyle(color: Colors.grey[600]),
                      )
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
