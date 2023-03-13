import 'package:flutter/material.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/notifications/invite_view_user.dart';

class UserAcceptWidget extends StatefulWidget {
  UserAcceptWidget(this.user, this.user_me, this.auth, this.sign,
      this.list_partners, this.load, this.analytics);

  User user;
  var auth;
  var sign;
  var list_partners;
  User user_me;
  var load;
  var analytics;

  @override
  _UserSearchWidgetState createState() => _UserSearchWidgetState();
}

class _UserSearchWidgetState extends State<UserAcceptWidget> {
  @override
  Widget build(BuildContext context) {
    return new InkWell(
      child: new Column(children: <Widget>[
        new Container(
          padding: new EdgeInsets.all(8.0),
          height: 60.0,
          child: new Row(
            children: <Widget>[
              new ClipOval(
                  child: new Container(
                      width: 40.0,
                      height: 40.0,
                      child: new Image.network(widget.user.image,
                          fit: BoxFit.cover))),
              new Container(width: 16.0),
              new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      height: 4.0,
                    ),
                    new Container(
                        width: 140.0,
                        child: new RichText(
                          text: new TextSpan(
                            text: "",
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              new TextSpan(
                                  text: widget.user.firstname +
                                      "  " +
                                      widget.user.fullname,
                                  style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13.0)),
                            ],
                          ),
                        )),
                    Container(
                        width: 140.0,
                        child: new Text(  widget.user.organisme ==
                            ""
                            ? widget.user.titre
                            :
                        widget.user.titre + " à " + widget.user.organisme,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: new TextStyle(color: Colors.grey[800]),
                        ))
                  ]),
              new Expanded(child: new Container()),
              new RaisedButton(
                  padding: new EdgeInsets.all(0.0),
                  color: Colors.blue,
                  child: new Text(
                    "Confirmer",
                    style: new TextStyle(color: Colors.white),
                  ),
                  onPressed: () {

                    Navigator.push(context,
                        new MaterialPageRoute(builder: (BuildContext context) {
                      return new Invite_view(
                          widget.user.auth_id,
                          null,
                          widget.user_me.auth_id,
                          widget.user_me,
                          true,
                          false,
                          widget.auth,
                          widget.sign,
                          widget.list_partners,
                          widget.user,
                          widget.load, widget.analytics);
                    }));

                  })
            ],
          ),
        ),
        new Container(
          height: 1.0,
          // width: 1000.0,
          color: Colors.grey[300],
        )
      ]),
      onTap: () {
        /* Navigator.push(context,
            new MaterialPageRoute(builder: (BuildContext context) {
              return new Invite_view(posts[index].auth_id, posts[index].notif_id,id,widget.user_me,go,delete_not);
            }));*/
      },
    );
  }
}
