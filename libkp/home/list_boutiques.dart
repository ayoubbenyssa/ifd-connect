import 'package:flutter/material.dart';
import 'package:ifdconnect/cards/shop_item.dart';
import 'package:ifdconnect/models/shop.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/search/search_user_widget.dart';
import 'package:ifdconnect/services/connect.dart';
import 'package:ifdconnect/services/partners_list.dart';
import 'package:ifdconnect/services/search_service.dart';
import 'package:ifdconnect/user/user_accept_widget.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/widgets/widgets.dart';


class ShopLIst extends StatefulWidget {
  ShopLIst(this.id, this.objectId,this.lat,this.lng);

  String id;
  String objectId;
  var lat;var  lng;


  @override
  _UserListsResultsState createState() => _UserListsResultsState();
}

class _UserListsResultsState extends State<ShopLIst> {
  List<Shop> btq = new List<Shop>();
  bool loading = true;
  int count = 0;

  @override
  void initState() {
    super.initState();

    PartnersList.get_list_shop(widget.id, widget.objectId).then((val) {
      setState(() {
        loading = false;
        btq = val;

        count = btq.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
        appBar: new AppBar(
          title: new Text("Nos boutiques"),
        ),
        body: loading == true
            ? Center(
            child: Widgets.load())
            : count == 0
            ? new Center(child: new Text("Aucun resultat trouvé"))
            : new ListView(
          children: btq.map((Shop shop) {
            return ShopItem(shop,widget.lat,widget.lng);
          }).toList(),
        ));
  }
}
