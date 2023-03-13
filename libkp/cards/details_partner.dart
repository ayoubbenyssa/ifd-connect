import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:ifdconnect/models/partner.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/widgets/common.dart';
import 'package:url_launcher/url_launcher.dart';

class PartnerCardDetails extends StatefulWidget {
  PartnerCardDetails(this.partner);

  Partner partner;

  @override
  _ShopCardState createState() => _ShopCardState();
}

class _ShopCardState extends State<PartnerCardDetails> {
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
      appBar: new AppBar(          backgroundColor: Fonts.col_app,
      ),
      body: new ListView(
        children: <Widget>[
          new Container(
              color: Colors.grey[200],
              height: 300.0,
              child: new Container(
                      color: Colors.grey[200],
                      child: new FadingImage.network(
                        widget.partner.logo.toString()
                            /*"http://via.placeholder.com/350x150"*/,
                        fit: BoxFit.cover,
                      ))),
          new Container(height: 12.0),
          new Container(
            padding: new EdgeInsets.only(left: 2.0, right: 2.0),
            child:
              HtmlWidget(
              widget.partner.name.toString().replaceAll(RegExp(r'(\\n)+'), ''),

              )
          ),
          new Container(
            padding: new EdgeInsets.only(left: 2.0, right: 2.0),
            child:
              HtmlWidget(
              widget.partner.description.toString().replaceAll(RegExp(r'(\\n)+'), ''),

    )
          ),
          new Container(
            padding: new EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new GestureDetector(
                  onTap: () {
                    /* var lat = shop.latLng.toString().split(";")[0];
                    var lng = shop.latLng.toString().split(";")[1];
                    _launched = _launch('https://www.google.com/maps/@$lat,$lng,16z');
*/
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
                  widget.partner.address,
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
