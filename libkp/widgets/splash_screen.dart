import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/widgets/widgets.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );

    Widget item(icon) =>
        /*ClipRRect(
          borderRadius: BorderRadius.circular(12.0.r),
          child: Container(
            padding: EdgeInsets.all(4.w),
            width: 54.w,
            color: Colors.white,
            height: 54.w,
            child: */
        Container(
            width: 160.w,
            child: Image.asset(
              "assets/images/" + icon,
              fit: BoxFit.fitWidth,
              width: 160.w,
            ));

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Fonts.col_grey.withOpacity(0.3), blurRadius: 4.0)
        ],
        image: new DecorationImage(
            fit: BoxFit.cover,
            colorFilter:
                new ColorFilter.mode(Color(0xff2990E9).withOpacity(0.9), BlendMode.dstATop),
            image: new AssetImage("assets/images/logod.png")),
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [
              0.3,
              1
            ],
            colors: [
              Color(0xff2990E9),
              Color(0xff95DCFF).withOpacity(0.94),
            ]),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                item(
                  "logol.png",
                ),
              ],
            ),
          ),
          /*  Theme(
              data: ThemeData(
                  cupertinoOverrideTheme:
                      CupertinoThemeData(brightness: Brightness.dark)),
              child: CupertinoActivityIndicator()),

          Container(height: 14.h),*/
        ],
      ),
    );
  }
}
