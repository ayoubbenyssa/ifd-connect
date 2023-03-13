import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ifdconnect/cards/details_partner.dart';
import 'package:ifdconnect/cards/option_widget.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/user/details_user.dart';
import 'package:ifdconnect/widgets/common.dart';
import 'package:timeago/timeago.dart' as ta;

class HeaderCard extends StatefulWidget {
  HeaderCard(this.offers, this.user, this.lat, this.lng, this.onLocaleChange,
      this.block_user, this.ratefunc);

  var offers;
  User user;
  var lat, lng;
  var onLocaleChange;
  var block_user;
  var ratefunc;

  @override
  _HeaderCardState createState() => _HeaderCardState();
}

class _HeaderCardState extends State<HeaderCard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.offers.author1.toString() == "null" &&
            widget.offers.partner.toString() == "null"
        ? Container()
        : new Container(
            padding: new EdgeInsets.all(8.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                InkWell(
                    onTap: () {
                      if (widget.offers.author1.toString() != "null")
                        Navigator.of(context).push(new PageRouteBuilder(
                          pageBuilder: (_, __, ___) => new Details_user(
                            widget.offers.author1,
                            widget.user,
                            widget.block_user,
                            true,
                            [],
                            null,
                          ),
                        ));
                      else
                        Navigator.push(context, new MaterialPageRoute(
                            builder: (BuildContext context) {
                          return new PartnerCardDetails(
                            widget.offers.partner,
                          );
                        }));
                    },
                    child: new ClipOval(
                        child: new Container(
                            color: Fonts.col_app,
                            width: MediaQuery.of(context).size.width * 0.12,
                            height: MediaQuery.of(context).size.width * 0.12,
                            child: new Center(
                                child: FadingImage.network(
                              widget.offers.author1.toString() == "null"
                                  ? widget.offers.partner.logo.toString() ==
                                          "null"
                                      ? widget.offers.partner.im.toString()
                                      : widget.offers.partner.logo
                                  : widget.offers.author1.image,
                              width: MediaQuery.of(context).size.width * 0.12,
                              height: MediaQuery.of(context).size.width * 0.12,
                              fit: BoxFit.cover,
                            ))))),
                new Container(
                  width: 8.0,
                ),
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width * 0.60,
                        child: new Text(
                            widget.offers.author1.toString() == "null"
                                ? widget.offers.partner.logo.toString() ==
                                        "null"
                                    ? widget.offers.partner.username
                                    : widget.offers.partner.name
                                : widget.offers.author1.fullname.toString() +
                                    " " +
                                    widget.offers.author1.firstname.toString(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: new TextStyle(
                                color: Colors.grey[800],
                                fontWeight: FontWeight.w600,
                                fontSize: ScreenUtil().setSp(16)))),
                    new Container(height: 2.0),
                    Text(
                      ta.format(widget.offers.create, locale: "fr"),
                      style: new TextStyle(
                          color: Fonts.col_app_fonn,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
                new Expanded(child: new Container()),

                // type()

                ButtonWidget(widget.offers, widget.user, widget.ratefunc,
                    widget.lat, widget.lng, widget.onLocaleChange)
                /* widget.offers.pic.isEmpty
                            ? MenuCard(
                            widget.offers, widget.user, delete, Colors.black)*/
                //   : Container()
              ],
            ));
  }
}
