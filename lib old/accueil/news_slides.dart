import 'package:flutter/material.dart';
import 'package:ifdconnect/accueil/wall_card_news.dart';
import 'package:ifdconnect/models/offers.dart';
import 'package:ifdconnect/models/user.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewsSlides extends StatefulWidget {
  NewsSlides(this.user, this.lat, this.lng, this.news,
      {Key key})
      : super(key: key);
  User user;
  double lat;
  double lng;
  List<Offers> news = [];

  @override
  _NewsSlidesState createState() => _NewsSlidesState();
}

class _NewsSlidesState extends State<NewsSlides> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Fonts.col_grey2,
      height: /*MediaQuery.of(context).size.height >= 812 ? 505.h :*/ 400.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: widget.news
            .map((e) => Container(
            width: 280.w,
            //  height:
            /*MediaQuery.of(context).size.height >= 812 ? 472.h :*/ //480.h,
            child: Wall_card2(e, widget.user, [], widget.lat, widget.lng,
                null, true)))
            .toList(),
      ),
    );
  }
}
