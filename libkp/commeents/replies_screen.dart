
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'package:ifdconnect/commeents/comment_repository.dart';
import 'package:ifdconnect/models/comment.dart';
import 'package:ifdconnect/models/user.dart';
/*
class RepliesScreen extends StatefulWidget {
  final List<Comment> comments;
  User user_me;

  /// final FeedPost post;

   RepliesScreen({@required this.comment,this.user_me /*, @required this.post*/
  });

  @override
  _RepliesScreenState createState() => _RepliesScreenState();

/* @override
  Widget get wrappedRoute {
    final commentsRepository = CommentsRepository();
    final commentsBloc = CommentsBloc(commentsRepository: commentsRepository);
    return BlocProvider(
      create: (_) => commentsBloc,
      child: this,
    );
  }
}*/

}

class _RepliesScreenState extends State<RepliesScreen> {


  final _replayController = TextEditingController();
  String _reply;
  bool _isReplyComment = false;

  String error;

  StreamSubscription _dbPeakSubscription;
  bool _isRecording = false;
  String _path;

  Timer timer;
  int seconds;


  Future<bool> _postReply( String message,
      {BuildContext context}) async {
    if (_reply == null || _reply.isEmpty) {
      return false;
    }

    setState(() {
      _isReplyComment = true;
    });

    final commentsRepository = CommentsRepository();
    print(
        '----------------------------------------------------------------------');
    /*final result = await commentsRepository.reply(
      token: user.token,
      postId: widget.post.id,
      parentId: widget.comment.commentId,
      comment: _reply,
      duration: _recorderTxt.toString(),
      type: type,
    );*/

    print(
        '----------------------------------------------------------------------');
   // print('${widget.comment.date}');
    // final result = await commentsRepository.post(
    //   token: user.token,
    //   parentId: widget.comment.id,
    //   postId: widget.post.id,
    //   content: _reply,
    //   duration: _recorderTxt.toString(),
    //   type: type,
    // );

    var result;
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
      _isReplyComment = false;
//      if (result == true) {
      _replayController.clear();

      // final reply = Reply(

      //   user: user,
      //   parentId: '0',
      //   postId: '1',
      //   date: DateTime.now(),
      //   content: _reply,
      //   duration: _recorderTxt,
      //   type: type.toString() == "PostType.audio" ? "audio" : 'text',
      // );
      /*final reply = Replies(
        user: user,
        id: '0',
        date: DateTime.now().toString(),
        comment: _reply,
        duration: _recorderTxt,
        type: type.toString() == 'PostType.audio' ? 'audio' : 'text',
      );
      widget.comment.replies.insert(0, reply);*/

      _reply = null;
//      }
    });

    return result;
  }


  Widget _buildMsgBtn({Function onP}) {
    return Material(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: IconButton(
          icon: Image.asset("assets/images/send.png", color: Color(0xffFF5A1E)),
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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundImage: NetworkImage(
                    '${widget.comment.}',
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      // border: Border.all(
                      //   width: 1,
                      //   color: Colors.grey,
                      // ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.comment.firstName} ${widget.comment.lastName}',
                          style: TextStyle(
                            fontFamily: 'Avenir LT Std 85 Heavy',
                            fontSize: ScreenUtil().setSp(15).toDouble(),
                            color: Color(0xFF262628),
                          ),
                        ),
                        Text(
                          widget.comment.type == 'text'
                              ? widget.comment.comment
                              : '',
                          // 'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
                          // overflow: TextOverflow.ellipsis,
                        ),
                        widget.comment.type == 'audio'
                            ? AudiPlay(widget.comment.comment, 'left',
                            widget.comment.duration.toString())
                            : Container(),
                      ],
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 46,
              ),
              child: Row(
                children: [
                  Text(
                    '$timaAgo',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade400,
                      fontFamily: 'Avenir LT Std 85 Heavy',
                    ),
                  ),
                  // SizedBox(
                  //   width: 5,
                  // ),
                  // Text(
                  //   'Like ',
                  //   style: TextStyle(
                  //     fontSize: 12,
                  //     color: Colors.grey.shade400,
                  //     fontWeight: FontWeight.bold,
                  //     fontFamily: 'Avenir LT Std 85 Heavy',
                  //   ),
                  // ),
                  SizedBox(
                    width: 5,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Reply',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Avenir LT Std 85 Heavy',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 40,
                ),
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: widget.comment.replies.length,
                  itemBuilder: (context, index) {
                    var time2 =
                    DateTime.parse('${widget.comment.replies[index].date}');
                    var timeAgo2 = convertToAgo(time2);
                    final reply = widget.comment.replies[index];

                    return Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 14,
                              backgroundImage: NetworkImage(
                                '${user.avatarUrl}',
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${user.firstName} ${user.lastName}',
                                      style: TextStyle(
                                        fontFamily: 'Avenir LT Std 85 Heavy',
                                        fontSize:
                                        ScreenUtil().setSp(15).toDouble(),
                                        color: Color(0xFF262628),
                                      ),
                                    ),
                                    Text(
                                      widget.comment.replies[index].type ==
                                          'text'
                                          ? widget
                                          .comment.replies[index].comment
                                          .toString()
                                          : '',
                                      // overflow: TextOverflow.ellipsis,
                                    ),
                                    widget.comment.replies[index].type ==
                                        'audio'
                                        ? AudiPlay(
                                      reply.comment.toString(),
                                      'left',
                                      reply.duration.toString(),
                                      // context: context,
                                    )
                                        : Container(),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                            start: 46,
                          ),
                          child: Row(
                            children: [
                              Text(
                                '$timeAgo2',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade400,
                                  fontFamily: 'Avenir LT Std 85 Heavy',
                                ),
                              ),
                              // SizedBox(
                              //   width: 5,
                              // ),
                              // Text(
                              //   'Like ',
                              //   style: TextStyle(
                              //     fontSize: 12,
                              //     color: Colors.grey.shade400,
                              //     fontWeight: FontWeight.bold,
                              //     fontFamily: 'Avenir LT Std 85 Heavy',
                              //   ),
                              // ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Reply',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade400,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Avenir LT Std 85 Heavy',
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Stack(
              children: <Widget>[
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
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 1.0),
                          decoration: BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          child: IconButton(
                            icon: Image.asset("assets/images/microphone.png"),
                            onPressed: () => _onRecorderPreesed(context),
                            color: Colors.black,
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _replayController,
                            onChanged: (String value) {
                              setState(() {
                                _reply = value;
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
                              hintText: 'Write a comment...',
                              hintStyle: TextStyle(
                                fontFamily: 'Avenir LT Std 35 Light',
                                fontSize: ScreenUtil().setSp(15).toDouble(),
                                color: Color(0xFFC2C4CA),
                              ),
                            ),
                          ),
                        ),
                        Builder(
                          builder: (context) {
                            final enabled = !_isReplyComment &&
                                _reply != null &&
                                _reply.isNotEmpty;

                            return InkWell(
                              onTap: enabled
                                  ? () async {
                                await _postReply(
                                  PostType.text,
                                  _reply,
                                  context: context,
                                );
                              }
                                  : null,
                              child: Padding(
                                padding: EdgeInsetsDirectional.only(
                                  top: ScreenUtil().setHeight(13).toDouble(),
                                  end: ScreenUtil().setWidth(19).toDouble(),
                                  bottom: ScreenUtil().setHeight(11).toDouble(),
                                  start: ScreenUtil().setWidth(21).toDouble(),
                                ),
                                child: _isReplyComment
                                    ? CupertinoActivityIndicator()
                                    : Text(
                                  'Post',
                                  style: TextStyle(
                                    fontFamily: 'Avenir LT Std 95 Black',
                                    fontSize:
                                    ScreenUtil().setSp(14).toDouble(),
                                    color: enabled
                                        ? Color(0xFF4E596F)
                                        : Color(0xFFE3E3E3),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                _isRecording ? _buildRecordingView(context) : SizedBox()
              ],
            ),
            Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height * 0.1,
            )
          ],
        ),
      ),
    );
  }
}
*/