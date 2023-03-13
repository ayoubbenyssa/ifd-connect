import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/networking/filter_by_last_user.dart';
import 'package:ifdconnect/networking/filter_by_nnew_users.dart';
import 'package:ifdconnect/networking/filter_users_by_nearest.dart';
import 'package:ifdconnect/networking/titles_list.dart';
import 'package:ifdconnect/services/Fonts.dart';

class FilterPage extends StatefulWidget {
  FilterPage(this.user);
  User user;

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  tap(String text) {
    var res;

    if (text == "Près de vous") res = FilterUsersByNearest(widget.user);
    if (text == "Nouveaux utilisateurs") res = FilterByNewUsers(widget.user);
    if (text == "Dernière connexion") res = FilterByLasteUsesr(widget.user);
   // if (text == "centresd".tr()) res = FilterUsersByObjectifs();
    //if (text == "fonction".tr()) res = FilterUsersByFonction();
    if (text == "Rôle") res = TitlesScreen(widget.user);

    Navigator.push(
      context,
      new PageRouteBuilder(
        pageBuilder:
            (BuildContext context, Animation<double> _, Animation<double> __) {
          return res;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {



    Widget divid = Container(
      margin: EdgeInsets.only(top: 4, bottom: 4),
      width: MediaQuery.of(context).size.width,
      height: 1,
      color: Fonts.col_grey.withOpacity(0.4),
    );

    TextStyle st = TextStyle(
        color: Colors.black,
        fontSize: ScreenUtil().setSp(16.5),
        fontWeight: FontWeight.w500);

    Widget roww(String text) => InkWell(
        onTap: () {
          tap(text);
        },
        child: Container(
            padding: EdgeInsets.only(top: 12, bottom: 12),
            child: Row(
              children: [
                Text(text, style: st),
                Expanded(
                  child: Container(),
                ),
                Image.asset(
                  "images/arrr.png",
                  color: Fonts.col_grey.withOpacity(0.77),
                  width: ScreenUtil().setWidth(16),
                  height: ScreenUtil().setWidth(16),
                ),
                Container(
                  width: 16,
                )
              ],
            )));

    return Container(
      padding: EdgeInsets.only(left: 16, top: 12, right: 12),
      child: ListView(
        children: [
          /* SearchWidget(widget.user, [], widget.lat != null ? widget.lat : 0.0,
              widget.lng != null ? widget.lng : 0.0, null, null, widget.chng),*/
          Container(
            height: 10,
          ),
          Text(
            "TRIER PAR" + ":",
            style: TextStyle(
                fontSize: ScreenUtil().setSp(18),
                color: Fonts.col_app,
                fontWeight: FontWeight.w900),
          ),
          Container(
            height: ScreenUtil().setHeight(12),
          ),
          divid,
          roww("Près de vous"),
          divid,
          roww("Nouveaux utilisateurs"),
          divid,
          roww("Dernière connexion"),
          divid,
          Container(
            height: ScreenUtil().setHeight(36),
          ),
          Text(
            'FILTRER PAR' + ":",
            style: TextStyle(
                fontSize: ScreenUtil().setSp(18),
                color: Fonts.col_app,
                fontWeight: FontWeight.w900),
          ),
          Container(
            height:ScreenUtil().setHeight( 12),
          ),
          divid,

          roww("Rôle"),
          divid,
        ],
      ),
    );
  }
}
