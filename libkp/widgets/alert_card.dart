import 'package:flutter/material.dart';
import 'package:ifdconnect/widgets/block_reasons_widget.dart';

class Alert {
  static showAlert(context,block) async{
    return showDialog<String>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
      return  new AlertDialog(
        content: new Container(
            width: 260.0,
            height: 300.0,
            decoration: new BoxDecoration(
              shape: BoxShape.rectangle,
              color: const Color(0xFFFFFF),
              borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
            ),
            child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // dialog top
                  new Expanded(child: new BlockReasons(block))
                ])),
   );}
    );
  }
}
