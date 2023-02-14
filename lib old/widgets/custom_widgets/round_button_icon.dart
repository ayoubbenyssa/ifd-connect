import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoundButtonIcon extends StatelessWidget {
  RoundButtonIcon({this.color, this.onPress, Key key}) : super(key: key);
  Color color;
  Function onPress;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 44.w,
        height: 44.w,
        child: FloatingActionButton(
            mini: true,
            elevation: 0,
            heroTag: null,
            backgroundColor: color,
            onPressed: () {
              onPress();
            },
            child: Icon(
              Icons.arrow_forward,
              color: Colors.white,
            )));
  }
}
