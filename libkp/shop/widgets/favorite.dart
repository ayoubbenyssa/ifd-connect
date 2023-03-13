import 'package:flutter/material.dart';
import 'package:ifdconnect/parc_events_stream/parc_events_stream.dart';

class FavoriteShps extends StatefulWidget {
  FavoriteShps(this.user, this.lat, this.lng, this.list_partner, this.analytics);

  var user;
  var lat;
  var lng;
  List list_partner;
  var analytics;

  @override
  _FavoriteShpsState createState() => _FavoriteShpsState();
}

class _FavoriteShpsState extends State<FavoriteShps> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(title: new Text("Favoris")),
        /* appBar: CustomAppBar((s) {
          setState(() {
            searchTerm = s;
          });
        }, scaffoldKey),*/
        body: new StreamParcPub(Container(), widget.lat, widget.lng,
            widget.user, "0", widget.list_partner,widget.analytics,
            category: "boutique", favorite: true,boutique: false,));
  }
}
