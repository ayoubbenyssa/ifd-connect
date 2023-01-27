import 'package:flutter/material.dart';

class YoutubeWidget extends StatefulWidget {
  YoutubeWidget(this.title, this.img, this.link, this.play);

  String title;
  String img;
  String link = "";
  var play;

  @override
  _YoutubeWidgetState createState() => _YoutubeWidgetState();
}

class _YoutubeWidgetState extends State<YoutubeWidget> {
  static String key = "AIzaSyCfqw9PpyFDSQnX0AS2uEXHtUg1pnMoDEg";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
        onTap: () {
          widget.play();
        },
        child: new Container(
            color: Colors.grey[200],
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
              new SizedBox(
                  height: 200.0,
                  child: new Stack(
                    children: <Widget>[
                      new Positioned.fill(
                        child: new Image.network(
                          widget.img.toString(),
                          fit: BoxFit.cover,
                        ),
                      ), new Positioned(
                          top: 6.0,bottom: 6.0,left: 6.0,right: 6.0,
                          child: Image.asset("images/ytb.png"))
                    ],
                  )),
              new Container(
                  padding: new EdgeInsets.only(left: 16.0, bottom: 8.0),
                  child: new Text(widget.title.toString(),
                      style: new TextStyle(color: Colors.grey[900]))),
              new Container(
                  width: 5000.0,
                  color: Colors.grey[200],
                  padding: new EdgeInsets.only(left: 16.0, bottom: 8.0),
                  child: new Text(widget.link.toString(),
                      style: new TextStyle(
                          color: Colors.blue[500], fontSize: 11.0)))
            ])));
  }
}
