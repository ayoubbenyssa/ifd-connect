import 'package:flutter/material.dart';
import 'package:ifdconnect/services/Fonts.dart';

class SousModule extends StatelessWidget {
  final sousModule;
  SousModule(this.sousModule);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              color: Fonts.col_app,
              margin: EdgeInsets.all(15.0),
              padding: EdgeInsets.all(10.0),
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Text(sousModule["subject"],
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 20.0, fontFamily: 'Helvetica')))),
                ],
              )),
          Container(
              margin: EdgeInsets.all(5.0),
              padding: EdgeInsets.fromLTRB(10.0, 5.0, 5.0, 5.0),
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Image.asset("assets/discount.png",
                              width: 22.0, height: 22.0),
                          Container(
                            width: 10.0,
                          ),
                          Text(
                            "Le coefficient de sous module : ${sousModule["subject_weighting"]}",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              )),
          Container(
              margin: EdgeInsets.all(5.0),
              padding: EdgeInsets.fromLTRB(10.0, 5.0, 5.0, 5.0),
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Image.asset("assets/edit.png",
                              width: 22.0, height: 22.0),
                          Container(
                            width: 10.0,
                          ),
                          Text(
                            "La note du rattrapage : ${noteDeRatt(sousModule["mark_ar"])}",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              )),
          Container(
              margin: EdgeInsets.all(5.0),
              padding: EdgeInsets.fromLTRB(10.0, 5.0, 5.0, 5.0),
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Image.asset("assets/edit.png",
                              width: 22.0, height: 22.0),
                          Container(
                            width: 10.0,
                          ),
                          Text(
                            "La moyenne avant rattrapage : ${format(sousModule["mark"])}",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              )),
          Container(
              margin: EdgeInsets.all(5.0),
              padding: EdgeInsets.fromLTRB(10.0, 5.0, 5.0, 5.0),
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Image.asset("assets/edit.png",
                              width: 22.0, height: 22.0),
                          Container(
                            width: 10.0,
                          ),
                          Text(
                            "La moyenne retenue : ${format(sousModule["average"])}",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              )),
        ],
      ),
    );
  }

  String format(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
  }

  String noteDeRatt(double note) {
    if (note != 0) {
      return format(note);
    } else
      return "";
  }
}
