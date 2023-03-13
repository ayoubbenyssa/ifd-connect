import 'dart:convert';

import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'package:ifdconnect/models/conference.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ViseoCard extends StatefulWidget {
  ViseoCard(this.user, this.conf, this.user_id, this.type, {Key key})
      : super(key: key);
  Conference conf;
  var user_id;
  User user;
  String type;

  @override
  _ViseoCardState createState() => _ViseoCardState();
}

class _ViseoCardState extends State<ViseoCard> {
  Future _launched;

  Future _launch(String url) async {
    if (await canLaunch(url)) {
      await launch(url, enableJavaScript: true, forceSafariVC: false);
    } else {
      throw 'Could not launch $url';
    }
  }

  join_live(Conference conf) async {
    String meeting_id = conf.meetingID;
    String attendeePW = conf.attendeePW;
    String moderatorPW = conf.moderatorPW;
    String title = conf.name;
    String welcome = "hello";

    print(
        "http://51.255.95.133:1322/join?fullName=${widget.user.firstname + widget.user.fullname}&meetingId=$meeting_id&attendeePW=$attendeePW");

    _launch(Uri.parse(Uri.encodeFull(
            "http://51.255.95.133:1322/join?fullName=${widget.user.firstname + widget.user.fullname}&meetingId=$meeting_id&attendeePW=$attendeePW"))
        .toString());
  }

  lancer_live(Conference conf) async {
    String meeting_id = conf.meetingID;
    String attendeePW = conf.attendeePW;
    String moderatorPW = conf.moderatorPW;
    String title = conf.name;
    String welcome = conf.welcome_msg;

    print(
        "http://51.255.95.133:1322/start?name=$title&meetingId=$meeting_id&attendeePW=$attendeePW&moderatorPW=$moderatorPW&welcome=$welcome&moderatorName=${widget.conf.user_name}");

    _launch(Uri.parse(Uri.encodeFull(
            "http://51.255.95.133:1322/start?name=$title&meetingId=$meeting_id&attendeePW=$attendeePW&moderatorPW=$moderatorPW&welcome=$welcome&moderatorName=${widget.conf.user_name}"))
        .toString());
  }

  @override
  void initState() {
    super.initState();

    print("--------------------------");
    print(widget.conf.userid);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(12),
        child: Container(
            child: Material(
                shadowColor: Fonts.col_grey.withOpacity(0.24),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 28,
                child: Container(
                    margin: EdgeInsets.all(12),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: [
                                Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.26,
                                    child: Text(
                                      "Programmé le : ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Fonts.col_app_fon,
                                          decoration: TextDecoration.underline,
                                          height: 1.4,
                                          fontSize: 15),
                                    )),
                                Icon(Icons.videocam_outlined),
                                Container(
                                  width: 12,
                                ),
                                Text(
                                  DateFormat.jm().format(widget.conf.date) +
                                      ' (' +
                                      DateFormat.MMMEd()
                                          .format(widget.conf.date) +
                                      ')',
                                  locale: Locale("fr"),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Helvetica',
                                      fontSize: 14),
                                )
                              ],
                            ),
                          ),
                          (widget.conf.userid == widget.user.user_id)
                              ?  Container()
                              : Container(
                                  height: 24,
                                ),
                          (widget.conf.userid == widget.user.user_id)
                              ? Container()
                              : Row(
                                  children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.18,
                                        child: Text(
                                          "Créé par : ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Fonts.col_app_fon,
                                              decoration:
                                                  TextDecoration.underline,
                                              height: 1.4,
                                              fontSize: 15),
                                        )),
                                    Container(
                                      width: 22,
                                    ),
                                    Text(
                                      widget.conf.user_name + " ",
                                      style: TextStyle(
                                          color: Colors.grey[900],
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1),
                                    ),
                                  ],
                                ),
                          Container(
                            height: 24,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.18,
                                    child: Text(
                                      "Titre : ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Fonts.col_app_fon,
                                          decoration: TextDecoration.underline,
                                          height: 1.4,
                                          fontSize: 15),
                                    )),
                                Container(
                                  width: 22,
                                ),
                                Container(
                                    child: Text(
                                  widget.conf.name,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )),
                              ]),
                          Container(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          side: BorderSide(
                                              width: 0.1,
                                              style: BorderStyle.solid)),
                                      color: Fonts.col_app_green,
                                      onPressed: () {
                                        if (widget.conf.userid !=
                                            widget.user.user_id) {
                                          join_live(widget.conf);
                                        } else {
                                          print("yesss");
                                          lancer_live(widget.conf);
                                        }
                                      },
                                      child: Text(
                                        widget.conf.userid ==
                                                widget.user.user_id
                                            ? "Lancer le cours"
                                            : "Rejoindre",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      )))
                            ],
                          )
                        ])))));
  }
}
