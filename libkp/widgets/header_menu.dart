import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeaderMenuDrawer extends StatefulWidget {
  HeaderMenuDrawer(this.user, {Key key}) : super(key: key);
  User user;

  @override
  _HeaderMenuState createState() => new _HeaderMenuState();
}

class _HeaderMenuState extends State<HeaderMenuDrawer> {
  // RoutesFunctions routesFunctions = new RoutesFunctions();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget avatar(image) => new Container(
        width: 60.0.w,
        height: 60.0.h,
        child: new Center(
            child: new ClipOval(
                child: image == null
                    ? new Image.asset("images/logo_last.png",
                        width: 60.0.w, height: 60.0.h, fit: BoxFit.cover)
                    : new Image.network(image,
                        width: 60.0.w, height: 60.0.h, fit: BoxFit.cover))));

    Widget head() =>
        /* new StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('users')
            .document(widget.user.id)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData)
            return new Container(
                alignment: FractionalOffset.center,
                child: new CircularProgressIndicator());

          widget.user = new User.fromDoc(snapshot.data);
*/
        new Container(
             padding: new EdgeInsets.only( top: 32.h),
            child: new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
              Container(
                width: 24.w,
              ),
              // new Container(height: 8.0),
              widget.user == null ? new Container() : avatar(widget.user.image),
              new Container(width: 12.0.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width:304-100.w,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: new Text(
                          widget.user.fullname.toString() +
                              " " +
                              widget.user.firstname,
                          style: new TextStyle(
                              // color: Fonts.color_app_fonc,
                              fontWeight: FontWeight.w700)),
                    ),
                  ),
                  new Container(height: 8.0.h),
                  SizedBox(
                    width:304-100.w,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: new Text(widget.user.email.toString(),
                          style: new TextStyle(
                              // color: Fonts.color_app_fonc,
                              )),
                    ),
                  )
                ],
              )
            ]));

    return new GestureDetector(
        onTap: () =>
            null /* Routes.goto(context,"profile", id: widget.user.id),*/,
        // Routes.gotoparams2("profile", context, widget.user,widget.user.id),
        child: new Container(
            decoration: new BoxDecoration(
                // color: Colors.grey[300],
                ),
            //decoration: Widgets.back,

            child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  //  powered,
                  head(),
                  new Container(
                    height: 10.0,
                  ),
                ])));
  }
}
