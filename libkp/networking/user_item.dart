import 'package:ifdconnect/user/details_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:intl/intl.dart';

class UserItem extends StatefulWidget {
  UserItem(this.user, this.user_me, this.type);

  User user;
  String type;
  User user_me;

  @override
  _UserItemState createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  @override
  Widget build(BuildContext context) {
    return (widget.type == "near" && widget.user.id == widget.user_me.id)
        ? Container()
        : InkWell(
            onTap: () {
              Navigator.push(context,
                  new MaterialPageRoute(builder: (BuildContext context) {
                return new Details_user(
                    widget.user, widget.user_me, () {}, true, [], null);
              }));
            },
            child: new Container(
                padding: new EdgeInsets.only(top: 8.0),
                width: MediaQuery.of(context).size.width,
                child: new Material(
                    elevation: 0.0,
                    borderRadius: new BorderRadius.circular(8.0),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(10),
                      leading: CircleAvatar(
                        radius: 28,
                        child: ClipOval(
                            child: new Image.network(
                          widget.user.image,
                          fit: BoxFit.cover,
                          width: 56,
                          height: 56,
                        )),
                      ),
                      title: Text(
                        widget.user.firstname + " " + widget.user.fullname,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: widget.type != "newer" &&
                              widget.type != "old" &&
                              widget.type != "near"
                          ? Text(
                              widget.user.role.toString() == "null"
                                  ? ""
                                  : widget.user.role.name.toString(),
                              style: new TextStyle(
                                  color: Fonts.col_grey,
                                  //  fontWeight: FontWeight.bold,
                                  fontSize: 14.5))
                          : widget.type == "title"
                              ? Text(widget.user.role.name,
                                  style: new TextStyle(
                                      color: Fonts.col_grey,
                                      //  fontWeight: FontWeight.bold,
                                      fontSize: 14.5))
                              : widget.type == "near"
                                  ? Text(
                                      widget.user.lat == "0"
                                          ? "-.- Kms"
                                          : widget.user.dis,
                                      style: new TextStyle(
                                          color: Fonts.col_grey,
                                          //  fontWeight: FontWeight.bold,
                                          fontSize: 14.5))
                                  : new Text(
                                      "Membre depuis: " +
                                          new DateFormat('dd-MM-yyyy')
                                              .format(widget.user.createdAt),
                                      style: new TextStyle(
                                          color: Fonts.col_grey,
                                          //  fontWeight: FontWeight.bold,
                                          fontSize: 14.5),
                                    ),
                      trailing: Image.asset(
                        "images/arrr.png",
                        color: Fonts.col_grey.withOpacity(0.77),
                        width: ScreenUtil().setWidth(16),
                        height: ScreenUtil().setWidth(16),
                      ),
                    ))));
  }
}
