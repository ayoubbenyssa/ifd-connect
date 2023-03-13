import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:ifdconnect/commeents/comment_bloc/comments_bloc.dart';
import 'package:ifdconnect/commeents/comment_bloc/comments_event.dart';
import 'package:ifdconnect/commeents/comment_bloc/comments_state.dart';
import 'package:ifdconnect/commeents/comment_item.dart';
import 'package:ifdconnect/commeents/comment_repository.dart';
import 'package:ifdconnect/fils_actualit/wall_card.dart';
import 'package:ifdconnect/models/comment.dart';
import 'package:ifdconnect/models/offers.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/Fonts.dart';

class CommentsScreen extends StatefulWidget {
  final Offers post;
  bool focus = false;
  var increment;
  User user_me;

  CommentsScreen(
      {Key key, @required this.post, this.user_me, this.focus, this.increment})
      : assert(post != null),
        super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();

/* @override
  Widget get wrappedRoute {
    final commentsRepository = CommentsRepository();
    final commentsBloc = CommentsBloc(commentsRepository: commentsRepository);
    return BlocProvider(
      create: (_) => commentsBloc,
      child: this,
    );
  }*/
}

class _CommentsScreenState extends State<CommentsScreen> {
  final _commentController = TextEditingController();
  String _comment;
  bool _isPostingComment = false;
  String error;
  ScrollController scrollController = new ScrollController();

  List<Comment> comments_list = [];

  CommentsBloc commentsbloc;

  _postComment(String message) async {
    if (_comment == null || _comment.isEmpty) {
      return false;
    }

    setState(() {
      _isPostingComment = true;
    });

    final commentsRepository = CommentsRepository();
    final result = await commentsRepository.post(widget.post.type,
        postId: widget.post.objectId, content: _comment, id: widget.user_me.id);

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

      final comment = Comment(
          author1: widget.user_me,
          id: '0',
          createdat: DateTime.now(),
          text: _comment,
          replies: []);
      comments_list.insert(0, comment);
      widget.increment(1);

      new Timer(new Duration(seconds: 1), () {
        scrollController.animateTo(0.0,
            curve: Curves.easeOut, duration: const Duration(milliseconds: 1));
      });
      _comment = null;
//      }
    });

    // return result;
  }

  Widget _buildMsgBtn({Function onP}) {
    return Material(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: IconButton(
          icon: Image.asset("assets/images/send.png", color: Fonts.col_grey),
          onPressed: () {
            onP();
          },
          color: Colors.black,
        ),
      ),
      color: Colors.white,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    commentsbloc = BlocProvider.of<CommentsBloc>(context);
    commentsbloc.add(CommentsRequested(
        postId: widget.post.objectId, type: widget.post.type));
  }

  @override
  Widget build(BuildContext context) {
    // final comments = comments_list;

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 1,
          backgroundColor: Fonts.col_app_green,
          title: Text("Commentaires", style: TextStyle(color: Colors.white)),
          bottom: (widget.post.type != "news" && widget.post.type != "event")
              ? PreferredSize(
                  preferredSize: Size.fromHeight(
                      MediaQuery.of(context).size.height * 0.01),
                  child: Container(
                    height: 0.01,
                  ))
              : PreferredSize(
                  preferredSize: Size.fromHeight(
                    MediaQuery.of(context).size.height * 0.22,
                  ),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 8,
                        ),
                        Container(
                            //width: 260,
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: MediaQuery.of(context).size.height * 0.2,
                            child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(18)),
                                child: widget.post.pic.toString() != "null" &&
                                        widget.post.pic.toString() != "[]"
                                    ? Image.network(
                                        widget.post.pic[0],
                                        fit: BoxFit.fitHeight,
                                      )
                                    : Container())),
                        Container(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Container(
                                    child: Text(
                                        widget.post.name.toString() == "null"
                                            ? ""
                                            : widget.post.name.toString(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(15.5),
                                            fontWeight: FontWeight.bold)))),
                            Container(
                              height: 12,
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: HtmlWidget(
                                  widget.post.description.toString().length >
                                          90
                                      ? widget.post.description
                                              .toString()
                                              .substring(0, 90) +
                                          '..'.replaceAll(RegExp(r'(\\n)+'), '')
                                      : widget.post.description
                                          .toString()
                                          .replaceAll(RegExp(r'(\\n)+'), ''),
                                  textStyle: TextStyle(
                                      fontSize: 11.0, color: Colors.white),
                                ))
                          ],
                        )
                      ],
                    ),
                    padding: EdgeInsets.only(bottom: 12.0),
                  ),
                ),
        ),
        backgroundColor: Colors.white,
        body: BlocBuilder<CommentsBloc, CommentsState>(
            builder: (context, homeState) {
          if (homeState is CommentsLoadInProgress) {
            return Center(
              child: Padding(
                  padding: EdgeInsets.only(top: 64),
                  child: CupertinoActivityIndicator()),
            );
          } else if (homeState is CommentsLoadFailure) {
            print(homeState.commentsResponse.message);
            return Center(
              child: Text(homeState.commentsResponse.message),
            );
          } else if (homeState is CommentsLoadSuccess) {
            comments_list = homeState.commentsResponse.comments;
            print("hellooooo");

            return Column(
              children: <Widget>[
                (comments_list.length == 0)
                    ? Expanded(
                        child: Padding(
                        padding: EdgeInsets.only(
                            left: ScreenUtil().setWidth(32),
                            right: ScreenUtil().setWidth(32),
                            top: ScreenUtil().setWidth(64)),
                        child: Text("Aucun commentaire trouvé !"),
                      ))
                    : Expanded(
                        child: ListView.separated(
                          controller: scrollController,
                          reverse: true,
                          padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(16).toDouble(),
                            vertical: ScreenUtil().setHeight(16).toDouble(),
                          ),
                          itemCount: comments_list.length,
                          separatorBuilder: (_, __) {
                            return SizedBox(
                                height: ScreenUtil().setHeight(2).toDouble());
                          },
                          itemBuilder: (BuildContext context, int index) {
                            final comment = comments_list[index];

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                CommenntItem(comment, widget.increment,
                                    widget.post, widget.user_me)
                                /*RichText(
                                  text: TextSpan(
                                    text:
                                        '${comment.user.firstname} ${comment.user.lastname} ',
                                    style: TextStyle(
                                      fontFamily: 'Avenir LT Std 85 Heavy',
                                      fontSize:
                                          ScreenUtil().setSp(15).toDouble(),
                                      color: Color(0xFF262628),
                                    ),
                                    children: [
                                      TextSpan(
                                        text: comment.text,
                                        style: TextStyle(
                                          fontFamily: 'Avenir LT Std 35 Light',
                                          fontSize:
                                              ScreenUtil().setSp(12).toDouble(),
                                          color: Color(0xFF4E596F),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),*/
                              ],
                            );
                          },
                        ),
                      ),
                Container(
                  padding: EdgeInsets.only(
                    top: ScreenUtil().setHeight(16).toDouble(),
                    right: ScreenUtil().setWidth(16).toDouble(),
                    bottom: ScreenUtil().setHeight(20).toDouble(),
                    left: ScreenUtil().setWidth(16).toDouble(),
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
                            autofocus: widget.focus,
                            controller: _commentController,
                            onChanged: (String value) {
                              setState(() {
                                _comment = value;
                              });
                            },
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsetsDirectional.only(
                                top: ScreenUtil().setHeight(13).toDouble(),
                                bottom: ScreenUtil().setHeight(10).toDouble(),
                                start: ScreenUtil().setWidth(21).toDouble(),
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              hintText: 'Écrire un commentaire ..',
                              hintStyle: TextStyle(
                                fontSize: ScreenUtil().setSp(15).toDouble(),
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
                                  top: ScreenUtil().setHeight(13).toDouble(),
                                  end: ScreenUtil().setWidth(19).toDouble(),
                                  bottom: ScreenUtil().setHeight(11).toDouble(),
                                  start: ScreenUtil().setWidth(21).toDouble(),
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
                ),
              ],
            );
          }
        }));
  }
}
