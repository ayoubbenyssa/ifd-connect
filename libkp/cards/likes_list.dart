import 'package:flutter/material.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/parc_events_stream/parc_events_stream.dart';
import 'package:ifdconnect/services/Fonts.dart';

class LikeList extends StatefulWidget {
  LikeList(this.lat, this.lng, this.user_me, this.like_id);

  var lat;
  var lng;
  User user_me;
  var like_id;

  @override
  _LikeListState createState() => _LikeListState();
}

class _LikeListState extends State<LikeList> {
  int count1 = 0;

  setSount1(c) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Fonts.col_app,
        title: Text("J'aime "),
      ),
      body: new StreamParcPub(
        new Container(),
        widget.lat,
        widget.lng,
        widget.user_me,
        "0",
        [],
        null,
        favorite: false,
        boutique: false,
        likepost: widget.like_id,
      ),
    );
  }
}
