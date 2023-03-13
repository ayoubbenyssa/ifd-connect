import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Fonts {


  static const Color col_app_green = const Color(0xff17B3D5);
  static const Color col_app = const Color(0xff34B7F9);
  static const Color col_app_fon = const Color(0xff199BD7);
  static const Color col_grey = const Color(0xffC9C9C9);
  static const Color col_app_fonn = const Color(0xff187FB2);
  static const Color col_cl = const Color(0xffFAFAFA);
  static const Color col_app_grey = const Color(0xffA5A5A5);
  static const Color col_text = const Color(0xffADACAC);
  static const Color border_col = const Color(0xffE4E4E4);
  static const Color col_app_red = const Color(0xffFF0000);
  static const Color col_green = const Color(0xff00DD3B);


  static var title2 = new TextStyle(
      color: col_app_grey, fontWeight: FontWeight.w600, fontSize: 19.5.sp);

  static var sub_title = new TextStyle(
      color: col_text, fontWeight: FontWeight.w500, fontSize: 14.5.sp);

  static var title3 = new TextStyle(
      color: col_app_grey,
      fontWeight: FontWeight.w400,
      fontSize: 16.0.sp,
      height: 1.2);



  static const Color col_gr = const Color.fromRGBO(218,218,218,1);




  // static const Color col_app_fon = const Color(0xff22a044);

  static const Color col_app_shadow = const Color(0xffd8ebff);
  // static const Color col_app_fonn = const Color(0xff22a044);

  static var footer = new TextStyle(
      color: col_app_fonn, fontWeight: FontWeight.w500, fontSize: 9.5);

  static List<Color> kitGradients = [
    // new Color.fromRGBO(103, 218, 255, 1.0),
    // new Color.fromRGBO(3, 169, 244, 1.0),
    // new Color.fromRGBO(0, 122, 193, 1.0),
    Fonts.col_app,
    Fonts.col_app
  ];
}
