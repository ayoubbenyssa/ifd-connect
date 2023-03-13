import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/reclamation/chat_page.dart';
import 'package:ifdconnect/reclamation/models/reclamation.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:timeago/timeago.dart' as ta;

class ChatItem extends StatefulWidget {
  ChatItem(this.rec, this.me);

  Reclamation rec;
  User me;

  @override
  _PatientWidgetConversationState createState() =>
      _PatientWidgetConversationState();
}

class _PatientWidgetConversationState extends State<ChatItem> {
  ParseServer ps = new ParseServer();

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: ListTile(
          dense: false,
          onTap: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (BuildContext context) {
                    return new ChatScreen(
                       widget.me,
                      widget.rec,

                    );
                  },
                ),
              );
          },
          leading: new ClipOval(
              child: new Container(
            color: Fonts.col_app_green.withOpacity(0.1),
            width: 50.0,
            height: 50.0,
            child: new Image.asset(
              "assets/images/logo.png",
              fit: BoxFit.contain,
            ),
            /**
                 * new Image.asset(
                    "images/logo.png",
                    width: 120.0,
                    height: 120.0,
                    )
                 */

            /* child: new Center(
                        child: widget.rec.photoProfil == null
                            ? Container()
                            : Image.network(
                          widget.patient.photoProfil,
                          fit: BoxFit.cover,
                        ))*/
          )),
          title: new Text(
            "Administrateur IFD",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: ScreenUtil().setSp(15.2)),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(height: 4.h),
              new Text(
                widget.rec.description.toString(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(14), color: Colors.grey[800]),
              ),
              Container(height: 4.h),
              new Text(
                ta.format(widget.rec.createdAt),
                locale: Locale("fr"),
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(14), color: Fonts.col_grey),
              ),
            ],
          ),
        ));
  }
}
