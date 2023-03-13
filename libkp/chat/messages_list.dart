import 'dart:async';

import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/services/remote_config_service.dart';
import 'package:ifdconnect/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'message_data.dart';
import 'message_item.dart';

class MessagesList extends StatefulWidget {
  MessagesList(this.user,this.iduser, this._searchText,this._scrollViewController,this.listp,this.Rel,this.auth,
      this.analytics,{Key key}) : super(key: key);
  String iduser;
  ScrollController _scrollViewController;
  String _searchText;
  User user;
  var listp;
  var Rel;
  var auth;
  var analytics;


  @override
  _MessagesListState createState() => new _MessagesListState();
}

class _MessagesListState extends State<MessagesList> {
  List<Message> list = new List<Message>();
  Timer _time;
  var data;
  int i = 0;

  var loading = false;

  Reload() {
    setState(() {
      loading = true;
    });
    new Timer(const Duration(seconds: 1), () {
      try {
        setState(() => loading = false);
      } catch (e) {
        e.toString();
      }
    });
  }

  initializeRemoteConfig() async {
    RemoteConfigService _remoteConfigService;
    _remoteConfigService = await RemoteConfigService.getInstance();
    await _remoteConfigService.initialize();
    print(_remoteConfigService.getUrl.toString());

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('api_url', _remoteConfigService.getUrl);
    prefs.setString('url_parce', _remoteConfigService.geturl_parce);
    prefs.setString('urlclasse', _remoteConfigService.geturlclasse);
    prefs.setString('"appId_parce"', _remoteConfigService.getappId_parce);
    prefs.setString('Parse_Id', _remoteConfigService.getParse_Id);
    prefs.setString('Parse_Key', _remoteConfigService.getParse_Key);
    prefs.setString('Content_type', _remoteConfigService.getContent_type);
  }

  @override
  initState() {
    super.initState();

    initializeRemoteConfig();

    widget.Rel();

    /*_time = new Timer.periodic(const Duration(minutes: 1), (Timer it) {
      setState(() {});
    });*/

    /*data = FirebaseDatabase.instance
        .reference()
        .child("room");*/

    data = FirebaseDatabase.instance
        .reference()
        .child("room_medz")
        .orderByChild(widget.iduser)
        .equalTo(true);
    data.keepSynced(true);
    data.onValue.forEach((val) {
      try {
        setState(() {
          i = 1;
          if (val.snapshot.value == null) i = 2;
        });
      } catch (e) {}
    });

    FirebaseDatabase.instance.setPersistenceEnabled(true);
    // data.keepSynced(true);
  }

  /*@override
  dispose() {
    _time.cancel();
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    Widget loadingScreen() {
      final ThemeData theme = Theme.of(context);
      return new Container(
          child: new Center(
              child: new Text("Loading...")));
    }

    Widget emptyScreen() {
      final ThemeData theme = Theme.of(context);
      return new Container(
          child: new Center(
              child: new Text("Aucun Messages")));
    }

    Widget nomessagesfound = new Container(
        padding: new EdgeInsets.only(top: 24.0),
        child: new Center(child: new Text("Aucun message trouvé")));

    Widget listmessages =  Container(
       // color: Colors.grey[200],
        child: new FirebaseAnimatedList(
      controller: widget._scrollViewController,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        defaultChild: new Center(       child: Widgets.load()),
        padding: new EdgeInsets.all(4.0),
        query: data,
        sort: (a, b) => b.value['timestamp'].compareTo(a.value['timestamp']),
        itemBuilder:
            (_, DataSnapshot snap, Animation<double> animation, int a) {
          return new MessageItem(snap, widget.iduser, widget._searchText,Reload,widget.user,widget.listp,widget.auth,
          widget.analytics);
        },
        duration: new Duration(milliseconds: 1000)));


     return  i == 2 ? nomessagesfound :!loading? listmessages:new Container()


   ;
  }
}
