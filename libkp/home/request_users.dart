import 'package:flutter/material.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/connect.dart';
import 'package:ifdconnect/services/search_service.dart';
import 'package:ifdconnect/user/user_accept_widget.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/widgets/widgets.dart';

class UserListsRequests extends StatefulWidget {
  UserListsRequests(this.my_id, this.user_me, this.auth, this.sign,
      this.list_partners, this.load, this.analytics);

  String my_id;
  User user_me;
  String text = "";
  var auth;
  var sign;
  var list_partners;
  var load;
  var analytics;

  @override
  _UserListsResultsState createState() => _UserListsResultsState();
}

class _UserListsResultsState extends State<UserListsRequests> {
  List users = new List();
  SearchFunctions func = new SearchFunctions();
  bool loading = true;
  int count = 0;

  @override
  void initState() {
    super.initState();

    Connect.get_list_connect_all(widget.my_id).then((val) {
      setState(() {
        loading = false;
        users = val["res"];
        count = users.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          backgroundColor: Fonts.col_app,
          title: new Text(widget.text),
        ),
        body: loading == true
            ? Center(child: Widgets.load())
            : count == 0
                ? new Center(child: new Text("Aucun resultat trouvé"))
                : new ListView(
                    children: users.map((var user) {
                      User us = new User.fromMap(user.author);

                      return UserAcceptWidget(
                          us,
                          widget.user_me,
                          widget.auth,
                          widget.sign,
                          widget.list_partners,
                          widget.load,
                          widget.analytics);
                    }).toList(),
                  ));
  }
}
