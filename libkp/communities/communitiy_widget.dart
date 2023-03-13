import 'package:flutter/material.dart';
import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/models/community.dart';
import 'package:ifdconnect/widgets/common.dart';




class Communitywidget extends StatefulWidget {
  Communitywidget(this.com, this.auth, this.sign, this.id,
      this.list_partner, this.func, this.index);

  Community com;
  var auth;
  var sign;
  String id = "";
  var func;
  List list_partner;
  int index;

  @override
  _CommunitywidgetState createState() => _CommunitywidgetState();
}

class _CommunitywidgetState extends State<Communitywidget> {
  ParseServer parse_s = new ParseServer();

  @override
  Widget build(BuildContext context) {

    final image = widget.com.picture == null
        ? new FadingImage.asset(
            "images/un.png",
            fit: BoxFit.contain,
          )
        : widget.com.picture == "images/un.png"
            ? new FadingImage.asset(
                "images/un.png",
                fit: BoxFit.contain,
              )
            : new FadingImage.network(
                widget.com.picture["url"],
                fit: BoxFit.cover,
      width: 50,height: 50,
              );

    var style = new TextStyle(
        fontWeight: FontWeight.w900, color: Colors.white, fontSize: 18.0);

    _buildTextContainer(BuildContext context) {
      final TextTheme textTheme = Theme.of(context).textTheme;
      final categoryText = new Text(
        widget.com.name,
        style: textTheme.caption.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 15.0,
        ),
        textAlign: TextAlign.center,
      );

      final desc = new Text(
        widget.com.description.toString(),
        style: textTheme.caption.copyWith(
          color: Colors.grey,
          fontWeight: FontWeight.w700,
          fontSize: 13.0,
          letterSpacing: 2.0,
        ),
        textAlign: TextAlign.center,
      );

      return  new Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            categoryText,
            // desc,
          ],
        )
      ;
    }



    return new GestureDetector(
        onTap: () {
          widget.func();

          if (widget.com.check == false)
            setState(() {
              widget.com.check = true;
            });
          else
            setState(() {
              widget.com.check = false;
            });
          // nearDistance();
        },
        child: new Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 4.0,
              horizontal: 4.0,
            ),
            child: new Material(
              elevation: 4.0,
              borderRadius: new BorderRadius.circular(8.0),
              child: new SizedBox.fromSize(
                size: new Size.fromHeight( 90.0),
                child: new Row(

                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                  new InkWell(
                        //highlightColor: Colors.red,
                        splashColor: Colors.blueAccent,
                        onTap: () {
                          widget.func();

                          setState(() {
                            widget.com.check = true;
                          });
                        },
                        child: new Container(
                          width: 30,height: 30,
                          margin: new EdgeInsets.only(left: 8.0, right: 0.0),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                             crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              new Container(
                                // height: 70.0,
                                //width: 70.0,
                                child: widget.com.check
                                    ? new Icon(
                                        Icons.check,
                                        size: 20.0,
                                        color: Colors.white,
                                      )
                                    : new Container(
                                        width: 20.0,
                                        height: 20.0,
                                      ),
                                decoration: new BoxDecoration(
                                  color: widget.com.check
                                      ? Colors.blueAccent
                                      : Colors.white,
                                  border: new Border.all(
                                      width: 2.0,
                                      color: widget.com.check
                                          ? Colors.blueAccent
                                          : Colors.blue[900]),
                                  borderRadius: const BorderRadius.all(
                                      const Radius.circular(2.0)),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                  Container(width: 12,),

                  image,

                  Container(width: 12,),
                  // wid,
                    _buildTextContainer(context),
                  ],
                ),
              ),
            )));
  }
}
