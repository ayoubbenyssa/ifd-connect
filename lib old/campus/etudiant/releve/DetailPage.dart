import 'package:flutter/material.dart';
import 'Module.dart';
import 'SousModule.dart';

class DetailPage extends StatelessWidget {
  final Module module;
  DetailPage(this.module);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(module.name),
        ),
        body: Column(
          children: <Widget>[
            Column(
              children:
                  this.module.detail.map((val) => SousModule(val)).toList(),
            ),
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
                            Image.asset("assets/story.png",
                                width: 22.0, height: 22.0),
                            Container(
                              width: 10.0,
                            ),
                            Text(
                              "La moyenne générale du module : ${format(module.noteAvantRatt)}",
                              style: TextStyle(fontSize: 16.0),
                            ),
                            Container(
                              width: 10.0,
                            ),
                            decision()
                          ],
                        )
                      ],
                    )
                  ],
                )),
          ],
        ));
  }

  String format(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
  }

  Widget decision() {
    return module.noteAvantRatt > 11.0
        ? Image.asset("assets/checked.png", width: 25.0, height: 25.0)
        : Image.asset("assets/minus.png", width: 25.0, height: 25.0);
  }
}
