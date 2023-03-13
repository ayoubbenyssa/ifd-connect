import 'package:flutter/material.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/parc_events_stream/parc_events_stream.dart';
import 'package:ifdconnect/search/search_user_widget.dart';
import 'package:ifdconnect/services/search_service.dart';

class UserListsResults extends StatefulWidget {
  UserListsResults(this.text,this.user_me,this.list, this.analytics,this.lat,this.lng);

  String text = "";
  User user_me;
  var list;
  var analytics;
  var lat;
  var lng;


  @override
  _UserListsResultsState createState() => _UserListsResultsState();
}

class _UserListsResultsState extends State<UserListsResults> {
  List<User> users = new List<User>();
  SearchFunctions func = new SearchFunctions();
  bool loading = true;
  int count = 0;

  @override
  void initState() {
    super.initState();

    func.search_text(widget.text,widget.user_me.auth_id).then((val) {
      setState(() {
        loading = false;
        users = val;
        count = users.length;

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text(widget.text),
        ),
        body:  new StreamParcPub(
          new Container(),
          widget.lat,
          widget.lng,
          widget.user_me,
          "0",
          widget.list,
          widget.analytics,
          favorite: false,
          boutique: false,
          search: widget.text,
        )/*loading == true
            ? Center(
            child: new SpinKitFadingCube(
              color: Colors.blue,
            ))
            :count ==0?new Center(child: new Text("Aucun resultat trouvé")): new ListView(
                children: users.map((User user) {
                  return UserSearchWidget(widget.user_me,user,widget.list, widget.analytics);
                }).toList(),
              )*/);
  }
}
