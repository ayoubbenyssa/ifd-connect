import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/models/objectif.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/services/partners_list.dart';

class Objectifs_widget extends StatefulWidget {
  Objectifs_widget(this.user);

  User user;

  var id;

  @override
  _AvailableTaimeState createState() => new _AvailableTaimeState();
}

class _AvailableTaimeState extends State<Objectifs_widget> {
  List<Objectif> object_list = new List<Objectif>();
  int postCount;
  bool loading = true;
  List<String> objectif = new List<String>();
  List<Objectif> obj = new List<Objectif>();

  Future<List<Objectif>> getObjectifs() async {
    obj = await PartnersList.get_objectifs();

    for (int i = 0; i < widget.user.objectif.length; i++) {
      if (widget.user.objectif.contains(obj[i].name)) {
        obj[i].isselected = true;
      }
    }
    setState(() {
      postCount = obj.length;
      object_list = obj;
      loading = false;
    });

    return object_list.reversed.toList();
  }

  ParseServer parse_s = new ParseServer();

  @override
  void initState() {
    getObjectifs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /*  Widget btn_confirm = new Padding(
      padding: new EdgeInsets.symmetric(vertical: 0.0),
      child: new Material(
        borderRadius: new BorderRadius.circular(30.0),
        shadowColor: Colors.purple,
        elevation: 5.0,
        child: new MaterialButton(
          minWidth: 180.0,
          height: 30.0,
          onPressed: () {
            //  Navigator.pop(context,time_available);
          },
          color: Colors.purple,
          child:
              new Text('Confirmer', style: new TextStyle(color: Colors.white)),
        ),
      ),
    );*/

    row(title, List<Objectif> data, index) {
      return new Container(
          margin: new EdgeInsets.all(8.0),
          height: 45.0,
          child: new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new InkWell(
                  //highlightColor: Colors.red,
                  splashColor: Fonts.col_app,
                  onTap: () {
                    /*  setState(() {
                     // data.forEach((element) => element.isselected = false);
                      data[index].isselected = true;
                      objectif.add(data[index].name);

                    });*/

                    if (data[index].isselected == true) {
                      setState(() {
                        data[index].isselected = false;
                        objectif.remove(data[index].name);
                        if (widget.user.list_obj.contains(data[index].name)) {
                          widget.user.list_obj.remove(data[index].name);
                          widget.user.objectif.remove(data[index].name);
                        }
                      });
                    } else
                      setState(() {
                        data[index].isselected = true;
                        objectif.add(data[index].name);
                      });
                  },
                  child: new Container(
                    margin: new EdgeInsets.only(left: 8.0, right: 16.0),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        new Container(
                          // height: 70.0,
                          //width: 70.0,
                          child: data[index].isselected
                              ? new Icon(
                            Icons.check,
                            color: Colors.white,
                          )
                              : new Container(
                            width: 25.0,
                            height: 25.0,
                          ),
                          decoration: new BoxDecoration(
                            color: data[index].isselected
                                ? Fonts.col_app
                                : Colors.transparent,
                            border: new Border.all(
                                width: 1.0,
                                color: data[index].isselected
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
                Container(width:8.0,),
                Image.network(data[index].img,width: 25.0,height: 25.0,),
                Container(width:12.0,),
                new Text(title),
              ]));
    }

    return new WillPopScope(
        onWillPop: () {
          Navigator.pop(context, widget.user);
        },
        child: new Scaffold(
            appBar: new AppBar(
              iconTheme: new IconThemeData(color: Fonts.col_app),
              backgroundColor: Colors.grey[50],
              title: new Text(
                "Objectifs actuels",
                style: new TextStyle(color: Fonts.col_app),
              ),
              actions: <Widget>[
                new IconButton(
                    icon: new Icon(Icons.check),
                    onPressed: () async {
                      /* if (tapped) {
                  }*/
                      // widget.user.list_obj = [];
                      // widget.user.objectif = [];

                      if (objectif != null) {
                        for (var i in objectif) {
                          widget.user.list_obj.add(i);
                          widget.user.objectif.add(i);
                        }
                      }

                      var js = {
                        "objectif": widget.user.list_obj,
                      };

                      await parse_s.putparse("users/" + widget.user.id, js);

                      Navigator.pop(context, widget.user);
                    })
              ],
            ),
            body: loading
                ? new Center(
              child: new RefreshProgressIndicator(),
            )
                : new ListView(
                children: object_list.map((Objectif obj) {
                  return row(obj.name, object_list, object_list.indexOf(obj));
                }).toList())));
  }
}
