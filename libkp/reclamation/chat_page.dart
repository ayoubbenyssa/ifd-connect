import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/reclamation/models/reclamation.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ChatScreen extends StatefulWidget {
  ChatScreen(this.user, this.reclamation, {Key key}) : super(key: key);
  User user;
  Reclamation reclamation;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final DatabaseReference root = FirebaseDatabase.instance.reference();

  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();

  List<Map<dynamic, dynamic>> messages = [];

  bool _isSigningOut = false;
  Map<dynamic, dynamic> _lastMessage;

  @override
  void dispose() {
    _messageController.dispose();
    _messageFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseReference chatReference =
        root.child('chatMessages/' + widget.reclamation.objectId).reference();

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        titleSpacing: 0.0,
        toolbarHeight: 60.h ,
        leading: Container(
          color: Fonts.col_app,
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: Container(
          padding: const EdgeInsets.only(top: 10,bottom:10),
          color: Fonts.col_app,
          child: Row(
            children: [
              // SvgPicture.asset(
              //   "assets/icons/news.svg",
              //   color: Colors.white,
              //   width: 23.5.w,
              //   height: 25.5.h,
              // ),
              Container(width: 7.w,),
              Padding(
                padding: const EdgeInsets.only(top: 10,bottom:10),
                child: Text(
                  "Conversation",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18.0.sp),
                ),
              ),

              Expanded(child: Container()),
              Padding(
                  padding: EdgeInsets.all(8.w),
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10.r)),
                      child: Container(
                          height: 44.w,
                          width: 44.w,
                          color: Colors.white.withOpacity(0.9),
                          padding: EdgeInsets.all(0.w),
                          child: Image.asset(
                            "images/launcher_icon_ifd.png",
                          )))),
              SizedBox(width: 22.w,),
            ],

          ),
        ),

      ),

      body: Container(
        color: Fonts.col_app,

        child: ClipRRect(
          borderRadius: BorderRadius.only(topRight : Radius.circular(39.r)),
          child: Container(
            color: Colors.white,

            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: StreamBuilder<Event>(
                      // TODO(lucky): should use standalone events
                      stream: chatReference.onValue,
                      builder: (context, snapshot) {
                        if (snapshot.hasData &&
                            snapshot.connectionState == ConnectionState.active) {
                          final Event event = snapshot.data;
                          final Map<dynamic, dynamic> collection =
                              event.snapshot.value as Map<dynamic, dynamic>;

                          if (collection != null) {
                            final List<dynamic> messages = collection
                                .map((key, item) {
                                  final Map<dynamic, dynamic> modifiedItem = (item
                                      as Map<dynamic, dynamic>)
                                    ..addAll({'key': key});

                                  return MapEntry(key, modifiedItem);
                                })
                                .values
                                .toList()
                                  ..sort((prev, next) {
                                    final prevTime = prev['timeSent'];
                                    final nextTime = next['timeSent'];

                                    return nextTime - prevTime;
                                  });

                            return ListView.builder(
                              padding: EdgeInsets.all(16.0),
                              reverse: true,
                              itemBuilder: (BuildContext context, int index) {
                                final Map<dynamic, dynamic> message = messages[index];
                                print("@@@@@@@@@@@@333@@@@@@@@");
                                print( message);
                                print( widget.user.id);

                                final String text = message['text'];
                                final String from = message['sender'];

                                final DateTime time =
                                    DateTime.fromMillisecondsSinceEpoch(
                                        message['timeSent']);
                                final bool isMe =
                                    message['sender'] != "admin" ? true : false;

                                return GestureDetector(
                                  onTap: () {
                                    if (isMe) {}
                                  },
                                  child: Column(
                                      mainAxisAlignment: isMe == true
                                          ? MainAxisAlignment.start
                                          : MainAxisAlignment.end,
                                      crossAxisAlignment: isMe == true
                                          ? CrossAxisAlignment.start
                                          : CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(top: 16.0),
                                          padding: EdgeInsets.all(12.0),
                                          width:
                                              MediaQuery.of(context).size.width * 0.7,
                                          decoration: BoxDecoration(
                                            color: isMe == true
                                                ? Fonts.col_app.withOpacity(0.4)
                                                : Fonts.col_app_fonn,
                                            borderRadius: BorderRadius.circular(12.0),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: isMe == true
                                                ? CrossAxisAlignment.start
                                                : CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                text,
                                                style: TextStyle(
                                                  color: isMe == false
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                              SizedBox(height: 8.0),
                                              Text(
                                                time.toIso8601String(),
                                                style: TextStyle(
                                                  fontSize: 10.0,
                                                  fontStyle: FontStyle.italic,
                                                  color: isMe == true
                                                      ? Colors.black26
                                                      : Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]),
                                );
                              },
                              itemCount: messages.length,
                            );
                          }
                        }

                        return SizedBox.shrink();
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 16.0),
                          child: TextField(
                            decoration: InputDecoration(hintText: 'Entrer un message'),
                            controller: _messageController,
                            focusNode: _messageFocusNode,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) {
                              _sendMessage();
                            },
                          ),
                        ),
                      ),
                      FlatButton.icon(
                        onPressed: _sendMessage,
                        icon: Icon(Icons.send, color: Colors.blue),
                        label: Text('Envoyer', style: TextStyle(color: Colors.blue)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _sendMessage() {
    final String message = _messageController.text;

    if (message.isNotEmpty) {
      /* if (_lastMessage != null &&
          _lastMessage['text'] != null &&
          _lastMessage['text'] != _messageController.text) {
        _messageController.clear();*/

//        // update
      Map<String, dynamic> chatData = {
        'text': message,
        'timeSent': DateTime.now().millisecondsSinceEpoch,
        'sender': widget.user.firstname + " " + widget.user.fullname
      };

      root
          .child('chatMessages/' + widget.reclamation.objectId)
          .push()
          .set(chatData);
      _messageController.clear();
      _messageFocusNode.unfocus();
    }
    /*else {
        final DatabaseReference chatReference =
            root.child('/chats/${widget.user.auth_id}/chats').reference();

        final String chatKey = chatReference.push().key;

        final String to = widget.user.auth_id == 'ecIvrKTpg3PwfzGm4b7ORQTrj6F3'
            ? 'zBLOguWRlISvI5YTiq6cnpIhLB22'
            : 'ecIvrKTpg3PwfzGm4b7ORQTrj6F3';

        // add
        Map<String, dynamic> chatData = {
          '/chats/${widget.user.auth_id}/with': to,
          '/chats/${widget.user.auth_id}/chats/$chatKey': {
            'text': message,
            'timestamp': DateTime.now().microsecondsSinceEpoch,
            'from': widget.user.auth_id,
          },

          /// destination
          '/chats/$to/with': widget.user.auth_id,
          '/chats/$to/chats/$chatKey': {
            'text': message,
            'timestamp': DateTime.now().microsecondsSinceEpoch,
            'from': widget.user.auth_id,
          },
        };

        root.update(chatData);
      }
    }*/
  }
}
