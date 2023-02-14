
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:ifdconnect/user/edit_my_profile.dart';
import 'package:intl/intl.dart';
import 'package:ifdconnect/chat/chatscreen.dart';
import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/models/offers.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/widgets/common.dart';

class DetailsAnnonce extends StatefulWidget {
  DetailsAnnonce(this.ads, this.user, this.listp, this.auth, this.analytics);

  Offers ads;
  User user;
  var listp;
  var auth;
  var analytics;

  @override
  _ShopCardState createState() => _ShopCardState();
}

class _ShopCardState extends State<DetailsAnnonce> {
  ParseServer parseFunctions = new ParseServer();

  @override
  void initState() {
    super.initState();
    parseFunctions.putparse(
        "offers/" + widget.ads.objectId, {"count": widget.ads.count + 1});
  }

  void onLoading(context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => new Dialog(
          child: new Container(
            padding: new EdgeInsets.all(16.0),
            width: 40.0,
            color: Colors.transparent,
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                new RefreshProgressIndicator(),
                new Container(height: 8.0),
                new Text(
                  "En cours ..",
                  style: new TextStyle(
                    color: Fonts.col_app_fonn,
                  ),
                ),
              ],
            ),
          ),
        ));

    // Navigator.pop(context); //pop dialog
    //  _handleSubmitted();
  }

  confirmer(my_id, his_id, user_me, user) async {
    // widget.delete();

    onLoading(context);



    Navigator.of(context, rootNavigator: true).pop('dialog');

    Navigator.push(context,
        new MaterialPageRoute(builder: (BuildContext context) {
      return new ChatScreen(my_id, his_id, widget.listp, false, widget.auth,widget.analytics,
          user: user_me);
    }));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: new ListView(
        children: <Widget>[
          new Container(
              color: Colors.grey[200],
              height: 300.0,
              child: widget.ads.pic.isEmpty
                  ? new FadingImage.asset(
                      "images/logo_last.png",
                      width: width * 0.28,
                      height: height * 0.26,
                      fit: BoxFit.contain,
                    )
                  : widget.ads.pic.length == 1
                      ? GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FullScreenWrapper(
                                        imageProvider: NetworkImage(
                                            widget.ads.pic[0].toString()),
                                      ),
                                ));
                          },
                          child: new FadingImage.network(
                            widget.ads.pic[0],
                            fit: BoxFit.cover,
                          ))
                      : new Swiper(
                          itemBuilder: (BuildContext context, int index) {
                            return new Container(
                                color: Colors.grey[200],
                                child: new FadingImage.network(
                                  widget.ads.pic[index].toString()
                                      /*"http://via.placeholder.com/350x150"*/,
                                  fit: BoxFit.cover,
                                ));
                          },
                          itemCount: widget.ads.pic.length,
                          pagination: new SwiperPagination(),
                          control: new SwiperControl(),
                          onTap: (val) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FullScreenWrapper(
                                        imageProvider: NetworkImage(
                                            widget.ads.pic[val].toString()),
                                      ),
                                ));
                          },
                        )),
          new Container(
              padding: new EdgeInsets.only(
                  left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
              width: width * 0.64,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new ClipOval(
                      child: new Container(
                          color: Fonts.col_app,
                          width: 36.0,
                          height: 36.0,
                          child: new Center(
                              child: new FadingImage.network(
                            widget.ads.author.image,
                            width: 36.0,
                            height: 36.0,
                            fit: BoxFit.cover,
                          )))),

                  new Container(
                    width: 8.0,
                  ),
                  new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(
                          widget.ads.author.fullname +
                              " " +
                              widget.ads.author.firstname,
                          style: new TextStyle(
                              color: Fonts.col_app,
                              fontWeight: FontWeight.bold,
                              fontSize: 13.0)),
                      new Text(
                        new DateFormat('yyyy-MM-dd').format(  DateTime.parse(widget.ads.createdAt)),
                        style: new TextStyle(
                            color: Colors.grey[800],
                            //  fontWeight: FontWeight.bold,
                            fontSize: 13.0),
                      ),
                    ],
                  ),

                  // new Container(width: height*0.05),
                  new Expanded(child: new Container()),

                  widget.ads.author.id != widget.user.id
                      ? new FlatButton(
                          padding: new EdgeInsets.all(4.0),
                          onPressed: () async {
                            var my_id =
                                widget.user.id + "_" + widget.ads.author.id;
                            var his_id =
                                widget.ads.author.id + "_" + widget.user.id;

                            confirmer(
                                widget.user.auth_id,
                                widget.ads.author.auth_id,
                                widget.user,
                                widget.ads.author);
                          },
                          child: new Text("CONTACTER",
                              style: new TextStyle(
                                  color: const Color(0xffff374e),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0)))
                      : new Container()
                ],
              )),
          new Container(
            padding: new EdgeInsets.only(left: 16.0, right: 16.0),
            child: Text(
              widget.ads.title,
              style: new TextStyle(
                  color: Colors.blueGrey[800], fontWeight: FontWeight.bold),
            ),
          ),
          new Container(height: 8.0),
          new Container(
            padding: new EdgeInsets.only(left: 16.0, right: 16.0),
            child: Text(
              widget.ads.description,
              textAlign: TextAlign.justify,
            ),
          )
        ],
      ),
    );
  }
}
