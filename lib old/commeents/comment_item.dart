import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ifdconnect/commeents/comment_repository.dart';
import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/models/comment.dart';
import 'package:ifdconnect/models/offers.dart';
import 'package:ifdconnect/models/reply.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/Fonts.dart';
//import 'package:ifdconnect/services/send_email_service.dart';
import 'package:ifdconnect/user/details_user.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommenntItem extends StatefulWidget {
  CommenntItem(this.comment, this.func, this.post, this.user_me, {Key key})
      : super(key: key);
  Comment comment;
  var func;
  Offers post;
  User user_me;

  @override
  _CommenntItemState createState() => _CommenntItemState();
}

class _CommenntItemState extends State<CommenntItem> {
  ParseServer parse_s = new ParseServer();
  bool _isPostingComment = false;
  String _comment;

  final _commentController = TextEditingController();

  delete() async {
    await parse_s.deleteparse("comments1/" + widget.comment.id);

    setState(() {
      widget.comment.delete = true;
      widget.func(-1);
    });
  }

  _postComment(String message) async {
    if (_comment == null || _comment.isEmpty) {
      return false;
    }

    setState(() {
      _isPostingComment = true;
    });

    final commentsRepository = CommentsRepository();
    final result = await commentsRepository.postReply(
      widget.comment.id,
      postId: widget.post.objectId,
      content: _comment,
    );

    print("---------------------");
    print(widget.comment.author1.firstname);
    print(widget.comment.author1.token);
    if (widget.comment.author1.token != "" &&
        widget.comment.author1.token.toString() != "null") {

      /*EmailService.sendCustomNotif(
          widget.comment.author1.token,
          widget.user_me.firstname +
              " " +
              widget.user_me.fullname +
              " a répondu à votre commentarie ",
          widget.comment.id);*/
    }
    if (result == false) {
      await showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text('Error'),
          content: Text(
              'There was an error posting your comment. Please try again.'),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Ok'),
            ),
          ],
        ),
      );
    }

    setState(() {
      _isPostingComment = false;
//      if (result == true) {
      _commentController.clear();

      final comment = Reply(
        author1: widget.user_me,
        id: result,
        createdat: DateTime.now(),
        text: _comment,
      );

      widget.comment.replies.insert(0, comment);

      widget.comment.show_reply = false;

      print(widget.comment.replies);

      /*new Timer(new Duration(seconds: 1), () {
        scrollController.animateTo(0.0,
            curve: Curves.easeOut, duration: const Duration(milliseconds: 1));
      });*/
      _comment = null;
//      }
    });
  }

  @override
  Widget build(BuildContext context) {

    Widget icns = IconButton(
      icon: Icon(
        Icons.remove_circle,
        color: Colors.red[900],
      ),
      onPressed: () {
        Alert(
            context: context,
            title: "Voulez-vous  supprimer ce commentaire ? ",
            content: Column(
              children: <Widget>[],
            ),
            buttons: [
              DialogButton(
                color: Fonts.col_app_green,
                onPressed: () {
                  delete();
                  Navigator.pop(context);
                },
                child: Text(
                  "Ok",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              )
            ]).show();
      },
    );

    Widget reply_item(Reply reply) => Container(
          padding: EdgeInsets.all(12),
          decoration: new BoxDecoration(
            shape: BoxShape.rectangle,
            color: Fonts.col_app_green.withOpacity(0.07),
            borderRadius: new BorderRadius.all(new Radius.circular(16.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  new GestureDetector(
                      onTap: () =>
                          Navigator.of(context).push(new PageRouteBuilder(
                            pageBuilder: (_, __, ___) => new Details_user(
                                reply.author1,
                                widget.user_me,
                                null,
                                true,
                                [],
                                null,
                                ),
                          )),
                      //routesFunctions.gotoparams2("profile", context, widget.user,widget.user.objectId),
                      child: Container(
                          child: CircleAvatar(
                              radius: 17,
                              child: ClipOval(
                                  child: new Image.network(
                                reply.author1.image,
                                fit: BoxFit.cover,
                                width: ScreenUtil().setWidth(38),
                                height: ScreenUtil().setWidth(38),
                              ))),
                          padding: EdgeInsets.only(
                              right: ScreenUtil().setWidth(12)))),
                  Container(
                    width: 0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: RichText(
                          text: TextSpan(children: <TextSpan>[
                            TextSpan(
                                text: reply.author1.firstname +
                                    " " +
                                    reply.author1.fullname +
                                    " ",
                                style: TextStyle(
                                    color: Fonts.col_app,
                                    fontWeight: FontWeight.w600,
                                    fontSize: ScreenUtil().setSp(14))),
                          ]),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            timeago.format(
                              reply.createdat,
                              locale: "fr",
                            ),
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(12),
                                fontWeight: FontWeight.w500,
                                color: Color(0xff807F82)),
                          ),
                        ],
                      )
                    ],
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  /* widget.user_me.admin == true
                  ? icns
                  : widget.post.author.toString() != "null" &&
                  widget.user_me.id == widget.post.author.id
                  ? icns
                  : Container()*/
                ],
              ),
              Container(height: 12),
              Container(
                child: Text(reply.text),
              ),
            ],
          ),
        );

    return widget.comment.delete == true
        ? Container()
        : Container(
            padding: EdgeInsets.only(top: 4),
            margin: EdgeInsets.all(6),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 12, top: 12, bottom: 12),
                  decoration: new BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Fonts.col_app_green.withOpacity(0.08),
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(16.0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          new GestureDetector(
                              onTap: () => Navigator.of(context)
                                      .push(new PageRouteBuilder(
                                    pageBuilder: (_, __, ___) =>
                                        new Details_user(
                                            widget.comment.author1,
                                            widget.user_me,
                                            null,
                                            true,
                                            [],
                                            null,
                                            ),
                                  )),
                              //routesFunctions.gotoparams2("profile", context, widget.user,widget.user.objectId),
                              child: Container(
                                  child: CircleAvatar(
                                      radius: 17,
                                      child: ClipOval(
                                          child: new Image.network(
                                        widget.comment.author1.image,
                                        fit: BoxFit.cover,
                                        width: ScreenUtil().setWidth(38),
                                        height: ScreenUtil().setWidth(38),
                                      ))),
                                  padding: EdgeInsets.only(
                                      right: ScreenUtil().setWidth(12)))),
                          Container(
                            width: 0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: RichText(
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                        text: widget.comment.author1.firstname +
                                            " " +
                                            widget.comment.author1.fullname +
                                            " ",
                                        style: TextStyle(
                                            color: Fonts.col_app,
                                            fontWeight: FontWeight.w600,
                                            fontSize: ScreenUtil().setSp(14))),
                                  ]),
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    timeago.format(
                                      widget.comment.createdat,
                                      locale: "fr",
                                    ),
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(12),
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xff807F82)),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Expanded(
                            child: Container(),
                          ),
                           widget.post.author.toString() != "null" &&
                                      widget.user_me.id == widget.post.author.id
                                  ? icns
                                  : Container()
                        ],
                      ),
                      Container(height: 12),
                      Container(
                        child: Text(widget.comment.text),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.comment.show_reply = true;
                    });
                  },
                  child: Text(
                    "Répondre",
                    style: TextStyle(
                        color: Fonts.col_app_green,
                        fontWeight: FontWeight.bold,
                        height: 2,
                        decoration: TextDecoration.underline),
                  ),
                ),
                widget.comment.show_reply == true
                    ? Container(
                        padding: EdgeInsets.only(
                          top: ScreenUtil().setHeight(16).toDouble(),
                          bottom: ScreenUtil().setHeight(20).toDouble(),
                        ),
                        color: Colors.white,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              width: 1,
                              color: Color(0xFFC2C4CB),
                            ),
                          ),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: TextField(
                                  autofocus: false,
                                  controller: _commentController,
                                  onChanged: (String value) {
                                    setState(() {
                                      _comment = value;
                                    });
                                  },
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsetsDirectional.only(
                                      top:
                                          ScreenUtil().setHeight(13).toDouble(),
                                      bottom:
                                          ScreenUtil().setHeight(10).toDouble(),
                                      start:
                                          ScreenUtil().setWidth(21).toDouble(),
                                    ),
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    hintText: 'Répondre à un commentaire ..',
                                    hintStyle: TextStyle(
                                      fontSize:
                                          ScreenUtil().setSp(15).toDouble(),
                                      color: Color(0xFFC2C4CA),
                                    ),
                                  ),
                                ),
                              ),
                              Builder(
                                builder: (context) {
                                  final enabled = !_isPostingComment &&
                                      _comment != null &&
                                      _comment.isNotEmpty;

                                  return InkWell(
                                    onTap: enabled
                                        ? () async {
                                            await _postComment(_comment);
                                          }
                                        : null,
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.only(
                                        top: ScreenUtil()
                                            .setHeight(13)
                                            .toDouble(),
                                        end: ScreenUtil()
                                            .setWidth(19)
                                            .toDouble(),
                                        bottom: ScreenUtil()
                                            .setHeight(11)
                                            .toDouble(),
                                        start: ScreenUtil()
                                            .setWidth(21)
                                            .toDouble(),
                                      ),
                                      child: _isPostingComment
                                          ? CupertinoActivityIndicator()
                                          : Image.asset(
                                              'images/send.png',
                                              width: 24,
                                              color: enabled
                                                  ? Fonts.col_app
                                                  : Color(0xFFE3E3E3),
                                            ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(),
                Padding(
                    padding: EdgeInsets.only(left: 42),
                    child: Column(
                        children: widget.comment.replies
                            .map((e) => Container(
                                padding: EdgeInsets.only(bottom: 12),
                                child: reply_item(e)))
                            .toList())),
                Container(
                  height: ScreenUtil().setHeight(10),
                ),
                Divider(
                  height: 2.0,
                )
              ],
            ),
          );
  }
}
