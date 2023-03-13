import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ifdconnect/annonces/add_annonces.dart';
import 'package:ifdconnect/annonces/details_annonce.dart';
import 'package:ifdconnect/cards/details_parc.dart';
import 'package:ifdconnect/cards/like_widget.dart';
import 'package:ifdconnect/cards/likes_list.dart';
import 'package:ifdconnect/cards/prom_details.dart';
import 'package:ifdconnect/commeents/comments_screen.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/services/commentsfunctions.dart';
import 'package:ifdconnect/services/like_wall_function.dart';
import 'package:ifdconnect/shop/pages/product_page.dart';

class CardFooter extends StatefulWidget {
  CardFooter(this.an, this.user, this.deletepost, this.context, this.list,
      this.analytics, this.lat, this.lng,
      {this.ratefunc});

  var an;
  var deletepost;
  var context;
  User user;
  var list;
  var analytics;
  double lat;
  double lng;
  var ratefunc;

  @override
  _CardFooterState createState() => new _CardFooterState();
}

class _CardFooterState extends State<CardFooter> {
  String _value1 = 'addfav';
  CommentFunctions commentFunctions = new CommentFunctions();

  //likes
  LikeFunctions likeFunctions = new LikeFunctions();

  var likestext = "Likes";

  var load = true;

  isliked() async {
    var res =
        await likeFunctions.like(widget.user.id, context, widget.an.objectId);
    if (res == false) return;
    try {
      setState(() {
        widget.an.liked = res["isLiked"];
        widget.an.numberlikes = res["numberlikes"];
      });
    } catch (e) {
      e.toString();

      //  return {"numberlikes": numberlikes + 1, "isLiked": true};
    }
    /*  var onValue =
        await likeFunctions.isliked(widget.an.objectId, widget.user.id);
    try {
      setState(() => widget.an.isLiked = onValue);
    } catch (e) {}
    return onValue;*/
  }

  toggletar() async {
    /* _heartAnimationController.forward().whenComplete(() {
      _heartAnimationController.reverse();
    });*/
    var res =
        await likeFunctions.like(widget.an.objectId, context, widget.user.id);
    if (res == "nointernet") {
    } else if (res == "error") {
    } else {
      try {
        setState(() {
          widget.an.isLiked = res["isLiked"];
          widget.an.likesCount = res["numberLikes"];
        });
      } catch (e) {}
    }
  }

  @override
  initState() {
    super.initState();
  //  isliked();
    // getnumbers();
    getNumbeComments();
  }

  func() {
    setState(() {
      widget.an.numbercommenttext =
          (int.parse(widget.an.numbercommenttext) + 1).toString();
    });
  }

  /*getnumbers() async {
    var count = await likeFunctions.numberLikes(widget.an.objectId);
    try {
      setState(() {
        widget.an.likesCount = count;
        print("----");
        print(widget.an.likesCount);
        likestext = " Likes";
        if (widget.an.likesCount.toString() == "1") likestext = " like";
      });
    } catch (e) {}
  }*/

  func_update_comment(num) {
    setState(() {
      widget.an.numbercommenttext =
          (int.parse(widget.an.numbercommenttext) + num).toString();
    });
  }

  getNumbeComments() {
    commentFunctions.numberComments(widget.an.objectId).then((count) {
      try {
        setState(() {
          widget.an.numbercommenttext = count.toString() /*+" Comments"*/;
        });
      } catch (e) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget numbercomments = new Text(
      "  ( " + widget.an.numbercommenttext.toString() + " )",
      style: new TextStyle(
          fontWeight: FontWeight.w600, color: Colors.black, fontSize: 13),
    );

    /* Widget textlike = new Text(
        widget.an.likesCount.toString() == "null"
            ? "0"
            : widget.an.likesCount.toString(),
        style: new TextStyle(
            color: Fonts.col_app_fonn,
            fontSize: 12.5,
            fontWeight: FontWeight.w500));*/

    Widget textlike = widget.an.numberlikes.toString() != "null" &&
            widget.an.numberlikes.toString() != "0"
        ? new Text(
            widget.an.numberlikes.toString() == "null"
                ? "0"
                : widget.an.numberlikes.toString() + " J'aime",
            style: new TextStyle(
                color: Fonts.col_app,
                fontSize: 15.5,
                fontWeight: FontWeight.w600))
        : Container();

    Widget decodertoggletar = new Container(
        child: widget.an.isLiked
            ? new SvgPicture.asset("images/Heart2.svg",
                width: 22.0, height: 22.0)
            : new SvgPicture.asset("images/Heart.svg",
                width: 22.0, height: 22.0));

    goto() {}

    return new Container(
        padding: EdgeInsets.only(left: 16.w, right: 16.w),
        child: Column(children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  child: textlike,
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute<Null>(
                            builder: (BuildContext context) => new LikeList(
                                widget.lat,
                                widget.lng,
                                widget.user,
                                widget.an.objectId)));

                    //  rt.gotocomment(context, widget.news, widget.news.author["objectId"],false,false);
                  },
                )
              ]),
          new Container(
              padding: EdgeInsets.only(left: 8),
              color: /*const Color(0xffedd9ac)*/ Colors.white,
              child: new Container(
                  height: MediaQuery.of(context).size.height * 0.06,
                  margin: new EdgeInsets.only(
                      left: 4.0, right: 4.0, bottom: 6.0, top: 4.0),
                  child: new Row(mainAxisAlignment: MainAxisAlignment.start,
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        FavoriteButton(widget.an, widget.user),
                        /* new InkWell(
                      onTap: () => toggletar(),
                    */
                        new Container(
                          width: 8.0,
                        ),
                        //  textlike,

                        new InkWell(
                          child: new Container(
                              padding: new EdgeInsets.all(4.0),
                              child: new SvgPicture.asset("images/Chat.svg",
                                  color: Colors.black,
                                  width: 24.0,
                                  height: 24.0)),
                          onTap: () async {
                            print(widget.user.id);
                            Navigator.push(
                                context,
                                new MaterialPageRoute<Null>(
                                    builder: (BuildContext context) =>
                                        new CommentsScreen(
                                          post: widget.an,
                                          focus: false,
                                          increment: func_update_comment,
                                          user_me: widget.user,
                                        )));

                            /*   Navigator.push(
                          context,
                          new MaterialPageRoute<Null>(
                              builder: (BuildContext context) => new Comments(
                                  widget.an, "", true, widget.user, func)));*/

                            //  rt.gotocomment(context, widget.news, widget.news.author["objectId"],false,false);
                          },
                        ),
                        new Container(
                          width: 2.0,
                        ),
                        InkWell(
                            child: numbercomments,
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute<Null>(
                                      builder: (BuildContext context) =>
                                          new CommentsScreen(
                                            post: widget.an,
                                            focus: false,
                                            increment: func_update_comment,
                                            user_me: widget.user,
                                          )));
                              /*Navigator.push(
                            context,
                            new MaterialPageRoute<Null>(
                                builder: (BuildContext context) => new Comments(
                                    widget.an, "", true, widget.user, func)));*/

                              //  rt.gotocomment(context, widget.news, widget.news.author["objectId"],false,false);
                            }),
                        new Container(width: 8.0),

                        /* widget.an.type == "event"
                      ? CircleAvatar(
                          backgroundColor: Colors.white,
                          child: InkWell(
                              onTap: () {
                                rate();
                              },
                              child: new Image.asset(
                                "images/medal.png",
                                color: Colors.black,
                                width: 18.0,
                                height: 18.0,
                              )))
                      : Container(),*/

                        Container(
                          width: 2,
                        ),
                        /* widget.an.type == "event"
                      ? widget.an.docUrl == null || widget.an.docUrl == ""
                      ? Container()
                      : CircleAvatar(
                      backgroundColor: Colors.white,
                      // backgroundColor: Colors.amber[400],
                      child: InkWell(
                          onTap: () {
                            Navigator.push(context,
                                new MaterialPageRoute<String>(
                                    builder: (BuildContext context) {
                                      return new Scaffold(
                                        appBar: AppBar(
                                          title: new Text(
                                            widget.an.name,
                                          ),
                                        ),
                                        body: SimplePdfViewerWidget(
                                          completeCallback: (bool result) {
                                            print(
                                                "completeCallback,result:${result}");
                                          },
                                          initialUrl: widget.an.docUrl,
                                        ),
                                      );
                                    }));
                          },
                          child: new Image.asset(
                            "images/pdf.png",
                            color: Colors.black,
                            width: 18.0,
                            height: 18.0,
                          )))
                      : Container(),*/

                        /*

                    Navigator.push(context, new MaterialPageRoute<String>(
                  builder: (BuildContext context) {
                return new  Scaffold(
                  appBar: AppBar(
                    title: const Text('Plugin example app'),
                  ),
                  body: SimplePdfViewerWidget(
                    completeCallback: (bool result){
                      print("completeCallback,result:${result}");
                    },
                    initialUrl: "https://www.orimi.com/pdf-test.pdf",
                  ),
                );
              }));
                   */
                        new Container(width: 8.0),

                        /* widget.an.author.toString() == "null"
                      ? Container()
                      : widget.user.auth_id == widget.an.author.auth_id
                          ? Container()
                          : new InkWell(
                              child: new Image.asset("images/cht.png",
                                  color: Colors.green[600],
                                  width: 26.0,
                                  height: 26.0),
                              onTap: () async {
                                Navigator.push(context, new MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return new ChatScreen(
                                      widget.user.auth_id,
                                      widget.an.author.auth_id,
                                      goto,
                                      false,
                                      null,
                                      widget.analytics,
                                      widget.onLocaleChange,
                                      user: widget.user);
                                }));

                                //  rt.gotocomment(context, widget.news, widget.news.author["objectId"],false,false);
                              },
                            ),*/
                        Container(
                          width: 12,
                        ),
                        widget.an.author.toString() == "null"
                            ? Container()
                            : widget.an.author.id == widget.user.id
                                ? new InkWell(
                                    child: new Image.asset("images/delete.png",
                                        color: Colors.red[700],
                                        width: 22.0,
                                        height: 22.0),
                                    onTap: () async {
                                      await showDialog<String>(
                                            context: context,
                                            builder: (_) => new AlertDialog(
                                              title: const Text(''),
                                              content: const Text(
                                                  'Voulez vous supprimer ce post ?'),
                                              actions: <Widget>[
                                                new FlatButton(
                                                    child: const Text('Ok'),
                                                    onPressed: () {
                                                      widget.deletepost();

                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop('dialog');
                                                    }),
                                                new FlatButton(
                                                  child: const Text('Cancel'),
                                                  onPressed: () {
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop('dialog');
                                                  },
                                                ),
                                              ],
                                            ),
                                          ) ??
                                          false;

                                      //  rt.gotocomment(context, widget.news, widget.news.author["objectId"],false,false);
                                    },
                                  )
                                : Container(),
                        Container(
                          width: 30,
                        ),
                        widget.an.author.toString() == "null"
                            ? Container()
                            : (widget.an.author.id == widget.user.id &&
                                    widget.an.type != "sondage")
                                ? new InkWell(
                                    child: new Image.asset("images/edit.png",
                                        color: Fonts.col_gr,
                                        width: 22.0,
                                        height: 22.0),
                                    onTap: () async {
                                      Navigator.push(context,
                                          new MaterialPageRoute(
                                              builder: (BuildContext context) {
                                        return new AddAnnonce(
                                          widget.user,
                                          null,
                                          null,
                                          [],
                                          widget.an.type,
                                          an: widget.an,
                                        );
                                      }));
                                      //  rt.gotocomment(context, widget.news, widget.news.author["objectId"],false,false);
                                    },
                                  )
                                : Container(),

                        /**
                         *
                         *   Navigator.push(context,
                            new MaterialPageRoute(builder: (BuildContext context) {
                            return new AddAnnonce(
                            widget.user,
                            widget.auth,
                            widget.sign,
                            widget.list_partner,
                            widget.offer.type,
                            an: widget.offer,
                            );
                            }));
                         */
                        new Expanded(
                            child: new Container(
                          width: 6.0,
                        )),

                        widget.an.type != "sondage" &&
                                widget.an.type != "Photo" &&
                                widget.an.type != "opportunite" &&
                                widget.an.type != "Document" &&
                                widget.an.type != "Video"
                            ? new RaisedButton(
                                color: Colors.grey[100],
                                elevation: 1,
                                shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.all(
                                  Radius.circular(6.0),
                                )),
                                // padding: EdgeInsets.all(0),
                                onPressed: () {
                                  if (widget.an.type == "Annonces_emi" ||
                                      widget.an.type == "Achat / Vente_emi" ||
                                      widget.an.type == "Objets perdus_emi" ||
                                      widget.an.type == "Général_emi" ||
                                      widget.an.type == "Mission_emi") {
                                    Navigator.push(context,
                                        new MaterialPageRoute(
                                            builder: (BuildContext context) {
                                      return new DetailsAnnonce(
                                        widget.an,
                                        widget.user,
                                        widget.list,
                                        null,
                                        widget.analytics,
                                      );
                                    }));
                                  } else if (widget.an.type == "news" ||
                                      widget.an.type == "event") {
                                    Navigator.push(context,
                                        new MaterialPageRoute(
                                            builder: (BuildContext context) {
                                      return new DetailsParc(
                                          widget.an,
                                          widget.user,
                                          widget.an.type,
                                          widget.list,
                                          null,
                                          widget.analytics,
                                          widget.lat,
                                          widget.lng);
                                    }));
                                  } else if (widget.an.type == "promotion") {
                                    Navigator.push(context,
                                        new MaterialPageRoute(
                                            builder: (BuildContext context) {
                                      return new Promo_details(
                                        widget.an,
                                        widget.user,
                                        /* widget.lat,
                                    widget.lng,*/
                                      );
                                    }));
                                  } else if (widget.an.type == "boutique") {
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                ProductPage(
                                                  widget.an,
                                                  widget.user,
                                                  /* widget.lat,
                                          widget.lng,*/
                                                )));
                                  } else {
                                    if (widget.an.author == null)
                                      Navigator.push(context,
                                          new MaterialPageRoute(
                                              builder: (BuildContext context) {
                                        return new DetailsParc(
                                            widget.an,
                                            widget.user,
                                            widget.an.type,
                                            widget.list,
                                            null,
                                            widget.analytics,
                                            widget.lat,
                                            widget.lng);
                                      }));
                                    else
                                      Navigator.push(context,
                                          new MaterialPageRoute(
                                              builder: (BuildContext context) {
                                        return new DetailsAnnonce(
                                          widget.an,
                                          widget.user,
                                          widget.list,
                                          null,
                                          widget.analytics,
                                        );
                                      }));
                                  }
                                },
                                child: Container(
                                    child: Text(
                                  "Détails",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15.5.sp,
                                    color: Colors.black,
                                  ),
                                )))
                            : Container(),
                        Container(
                          width: 8,
                        )
                      ])))
        ])); //2E9E51
  }
}
