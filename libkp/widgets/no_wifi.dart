import 'package:flutter/material.dart';


class NoWifi extends StatefulWidget {
  NoWifi(this.ontap,this.show);
  var ontap;
  bool show;





  @override
  _NoWifiState createState() => _NoWifiState();
}

class _NoWifiState extends State<NoWifi> {
  @override
  Widget build(BuildContext context) {
    var wid = new Container(
        decoration: new BoxDecoration(
            color: Colors.grey[300],
            image: new DecorationImage(
                fit: BoxFit.cover,
                colorFilter: new ColorFilter.mode(
                    Colors.grey.withOpacity(0.6), BlendMode.dstATop),
                image: new AssetImage("images/bac.jpg"))),
        child: new Center(child:
    new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(height: 12,),
        new Container(
            child: new GestureDetector(
                onTap: () {},
                child: new Image.asset(
                  "images/logo.png",
                  width: 120.0,
                  height: 120.0,
                ))),
        Container(height: 34,),
        new Text("Pas d'Internet"),
        new Container(height: 24.0,),
        new Image.asset("images/con.png",width: 100,height: 100,),
        new Container(height: 24.0,),
        Container(width: 300,
            child:new RaisedButton(
                color: Colors.grey[50],
                elevation: 4.0,
                child:new Text("Actualiser",style: TextStyle(color: Colors.blue),),onPressed: (){
              widget.ontap();
            }))
      ],
    )));

    return widget.show?Scaffold(body:wid):wid;
  }
}
