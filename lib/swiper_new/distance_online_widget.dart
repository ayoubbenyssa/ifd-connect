import 'package:flutter/material.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:timeago/timeago.dart' as ta;

class Distance_Online_Widget extends StatelessWidget {
  Distance_Online_Widget(this.user);

  User user;

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding:
          new EdgeInsets.only(bottom: 4.0, left: 16.0, right: 16.0, top: 4.0),
      alignment: Alignment.center,
      decoration: new BoxDecoration(
        color: Colors.white,
        /*border: new Border(
                            bottom: new BorderSide(
                                color: Colors.black12))*/
      ),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Row(
            children: <Widget>[
              new Icon(
                Icons.map,
                color: Fonts.col_app,
                size: 20.0,
              ),
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Text(
                  (user.dis.toString() == "null")
                      ? "-.- Km(s)"
                      : (user.dis == "0.0" + " Km(s)")
                          ? ("-.-" + " Km(s)")
                          : user.dis,
                  style: TextStyle(fontSize: 12.0),
                ),
              )
            ],
          ),
          new Row(
            children: <Widget>[
              user.offline == "offline"
                  ? Container()
                  : user.last_active.toString() == "null"
                      ? Container()
                      : user.last_active.toString() == "0"
                          ? new CircleAvatar(
                              backgroundColor: Colors.blue, radius: 8.0)
                          : new Icon(
                              Icons.access_time,
                              color: Fonts.col_app,
                              size: 20.0,
                            ),

              /*


                                widget.user.last_active.toString() !=
                                                      "null" &&
                                                  widget.user.last_active.toString() !=
                                                      "" &&   widget.user.last_active.toString() !=
                                              "0"
                                              ? ta.format(new DateTime.fromMillisecondsSinceEpoch(
                                                          widget.user
                                                              .last_active)) ==
                                                      "il y a 49 ans"
                                                  ? ""
                                                  : ta.format(new DateTime
                                                          .fromMillisecondsSinceEpoch(
                                                      widget.user.last_active))
                                              : ""
                               */

              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Text(
                    user.offline == "offline"
                        ? "Hors ligne"
                        : user.last_active.toString() == "null"
                            ? ""
                            : user.last_active.toString() == "0"
                                ? "En ligne"
                                : ta.format(
                                    new DateTime.fromMillisecondsSinceEpoch(
                                        user.last_active),
                                    locale: "fr"),
                    style: TextStyle(fontSize: 12.0)),
              )
            ],
          )
        ],
      ),
    );
  }
}
