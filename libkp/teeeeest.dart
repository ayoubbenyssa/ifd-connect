import 'dart:async';

import 'package:flutter/material.dart';

class ShapedWidget extends StatelessWidget {
  ShapedWidget(this.text, this.onp,this.height);

  String text;
  var onp;
  double height;

  final double padding = 8.0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
          color: Colors.blue[50],
          clipBehavior: Clip.antiAlias,
          shape: _ShapedWidgetBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              padding: padding),
          elevation: 22.0,
          shadowColor: Colors.blue,
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(padding).copyWith(bottom: padding * 2),
                child: SizedBox(
                  width: 270.0,
                  height: height,
                  child: Container(
                    padding: EdgeInsets.only(left: 12.0,right: 12.0,top: 12.0),
                    child: Text(
                      text,
                      style: TextStyle(fontSize: 20.0, fontFamily: "Helvetica",
                      color: Colors.blueGrey[900]),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
              ),
              Row(
                //mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  RaisedButton(
                    color: Colors.blue[700],
                    child: Text(
                      "Passer",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                    onPressed: () {
                      onp();
                    },
                  )
                ],
              ),
              Container(
                height: 18.0,
              )
            ],
          )),
    );
  }
}

class _ShapedWidgetBorder extends RoundedRectangleBorder {
  _ShapedWidgetBorder({
    @required this.padding,
    side = BorderSide.none,
    borderRadius = BorderRadius.zero,
  }) : super(side: side, borderRadius: borderRadius);
  final double padding;

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    return Path()
      ..moveTo(rect.width - 12.0, rect.top)
      ..lineTo(rect.width - 20.0, rect.top - 16.0)
      ..lineTo(rect.width - 32.0, rect.top)
      ..addRRect(borderRadius.resolve(textDirection).toRRect(Rect.fromLTWH(
          rect.left, rect.top, rect.width, rect.height - padding)));
  }
}
