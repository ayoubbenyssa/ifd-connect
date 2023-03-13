import 'package:flutter/material.dart';
import 'package:ifdconnect/cards/promotion_card.dart';
import 'package:ifdconnect/models/offers.dart';
import 'package:ifdconnect/models/user.dart';


class Promo_details extends StatefulWidget {
  Promo_details(this.promo, this.user);

  Offers promo;
  User user;

  @override
  _Promo_detailsState createState() => _Promo_detailsState();
}

class _Promo_detailsState extends State<Promo_details> {
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(),
        body: new ListView(children: <Widget>[
      PromotionsCard(widget.promo,widget.user,true,false),

    ],)
    );
  }
}
