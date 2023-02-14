import 'package:flutter/material.dart';
import 'package:ifdconnect/models/block.dart';
import 'package:ifdconnect/services/Fonts.dart';

class BlockReasons extends StatefulWidget {
  BlockReasons(this.block);
  var block;

  @override
  _BlockReasonsState createState() => _BlockReasonsState();
}

class _BlockReasonsState extends State<BlockReasons> {
  String reason;

  Widget row(title, List<Map<String,dynamic>> data, index) {
    return new Container(
        margin: new EdgeInsets.all(8.0),
        height: 45.0,

        ///decoration:
        // LoDocDesign.buildShadowAndRoundedCorners3(Colors.grey[600]),
        child: new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new InkWell(
                //highlightColor: Colors.red,
                splashColor: Fonts.col_app,
                onTap: () {
                  setState(() {
                    data.forEach((element) => element["check"] = false);
                    data[index]["check"] = true;
                    reason = data[index]["name"];
                  });

                 /* if (data[index]["check"]  == true) {
                    setState(() {
                      data[index]["check"]  = false;
                      reason = data[index]["name"];
                    });
                  } else
                    setState(() {
                      data[index]["check"]  = true;
                      reason = data[index]["name"];
                    });*/
                },
                child: new Container(
                 // margin: new EdgeInsets.only(left: 8.0, right: 16.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Container(
                        child: data[index]["check"]
                            ? new Icon(
                                Icons.check,
                                color: Colors.white,
                              )
                            : new Container(
                                width: 18.0,
                                height: 18.0,
                              ),
                        decoration: new BoxDecoration(
                          color: data[index]["check"]
                              ? Fonts.col_app
                              : Colors.transparent,
                          border: new Border.all(
                              width: 1.0,
                              color: data[index]["check"]
                                  ? Fonts.col_app
                                  : Colors.grey),
                          borderRadius: const BorderRadius.all(
                              const Radius.circular(2.0)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
             new Container(width: 8.0),
             new Container(
               width: 170.0,
                 child: new Text(title,style: new TextStyle(fontSize: 11.5),)),
            ]));
  }

  @override
  Widget build(BuildContext context) {
    return  new WillPopScope(
        onWillPop: (){
          Navigator.pop(context,reason);
        },
        child: new Column(children: <Widget>[

          new Expanded(child: new ListView(
              children: Blocked.block_list.map((Map<String,dynamic> obj) {

                return row(obj["name"],  Blocked.block_list ,Blocked.block_list.indexOf(obj));
              }).toList())),
          new Center(child: new Material(
            child: new MaterialButton(
                child: new Text("Bloquer"),
                onPressed: (){
                  widget.block();

                  Navigator.pop(context,reason);
            }),
          ),)
        ],) );
  }
}
