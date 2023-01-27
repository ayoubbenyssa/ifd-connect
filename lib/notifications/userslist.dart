
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/widgets/widgets.dart';
import 'package:timeago/timeago.dart' as ta;
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/notifications/invite_view_user.dart';

class Listusers extends StatefulWidget {
  Listusers(this.user_me, this.auth, this.sign,
      this.list_partner,this.load, this.analytics);

  User user_me;
  var sign;
  var auth;
  var list_partner;
  var load;
  var analytics;

  @override
  _PostsBycategoryState createState() => new _PostsBycategoryState();
}

class _PostsBycategoryState extends State<Listusers> {
  int postCount;

  FirebaseUser me;
  ParseServer parse_s = new ParseServer();
  bool loading = true;
  List<User> posts = null;
  String id;

  getid() async {
    var a = await FirebaseAuth.instance.currentUser();
    if (!mounted) return;
    setState(() {
      id = a.uid;
    });
  }

  @override
  void initState() {
    getid();
    super.initState();
    getPosts();
  }

  getPosts() async {
    var a = await FirebaseAuth.instance.currentUser();
    if (!mounted) return;

    setState(() {
      id = a.uid;
    });
    var snap = await Firestore.instance
        .collection('user_notifications')
        .document(id)
        .collection("Notifications")
        .orderBy('time', descending: true)
        .getDocuments();
    if (!mounted) return;

    setState(() {
      loading = false;
      posts = [];
    });

    if (snap.documents.length == 0) {
      setState(() {
        posts = [];
        loading = false;
      });
    }

    for (var doc in snap.documents) {
      //posts.add(new User.fromDoc(doc));
      String id_other = doc.data["id_user"];

      var response = await parse_s.getparse('users?where={"id1":"$id_other"}&include=user_formations,role');
      if(!this.mounted) return;

      User user = new User.fromMap(response["results"][0]);
      user.accept = doc.data["accept"];
      user.notif_time = doc.data["time"];
      user.read = doc.data["read"];
      user.notif_id = doc.documentID;
      user.type_req = doc.data["type"];
      setState(() {
        postCount = snap.documents.length;
        posts.add(user);
      });
    }
  }

  int i;

  delete_not() {
    setState(() {
      posts.removeAt(i - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          iconTheme: IconThemeData(color: Colors.white),
        title: new Text("Notifications",style:TextStyle(color:Colors.white)),
          elevation: 0,
    ),
    body:loading
        ? Center(
        child: Widgets.load())
        : posts.isEmpty
            ? new Center(
                child: new Text("Aucune notification trouvée"),
              )
            : new ListView(
                children: new List.generate(posts.length, (int index) {
                //print(snapshot.data[index]);

                return posts[index].accept == true
                    ? new Container()
                    : new InkWell(
                        child: new Column(children: <Widget>[
                          new Container(
                            color: posts[index].read == false
                                ? Colors.blue[50]
                                : Colors.white,
                            padding: new EdgeInsets.all(8.0),
                            height: 60.0,
                            child: new Row(
                              children: <Widget>[
                                new ClipOval(
                                    child: new Container(
                                        width: 40.0,
                                        height: 40.0,
                                        child: new Image.network(
                                            posts[index].image,
                                            fit: BoxFit.cover))),
                                new Container(width: 10.0),
                                new Container(
                                    width: 180.0,
                                    child: new RichText(
                                      text: new TextSpan(
                                        text: "",
                                        style:
                                           TextStyle(color: Colors.black),
                                        children: <TextSpan>[
                                          new TextSpan(
                                              text: posts[index].firstname +
                                                  "  " +
                                                  posts[index].fullname,
                                              style: new TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13.0)),
                                          new TextSpan(
                                              text: posts[index].type_req ==
                                                      "connect"
                                                  ? " vous a envoyé une demande de connexion"
                                                  : " a accepté votre demande de connexion",
                                              style: new TextStyle(
                                                  fontSize: 13.0)),
                                        ],
                                      ),
                                    )),
                                new Expanded(child: new Container()),
                                new Text(
                                  ta.format(
                                      new DateTime.fromMillisecondsSinceEpoch(
                                          posts[index].notif_time)),
                                  style: new TextStyle(
                                      color: Colors.grey, fontSize: 11.0),
                                )
                              ],
                            ),
                          ),
                          new Container(
                            height: 1.0,
                            width: 1000.0,
                            color: Colors.grey[300],
                          )
                        ]),
                        onTap: () {
                          // UserConn(this.id, this.id_notification,this.my_id /*,this.image,this.name*/)
                          i = index;

                          bool go = true;
                          if (posts[index].type_req == "connect") {
                            go = true;
                          } else {
                            go = false;
                          }
                          /*
                            widget.images[_currentIndex].auth_id,
          null,
          widget.user_me.auth_id,
          widget.user_me,
          true,
          false,
          widget.auth,
          widget.sign,
          null,
          null,
          widget.list_partners,
          widget.images[_currentIndex],widget.load
                           */

                          Navigator.push(context, new MaterialPageRoute(
                              builder: (BuildContext context) {
                            return new Invite_view(
                                posts[index].auth_id,
                                posts[index].notif_id,
                                id,
                                widget.user_me,
                                go,
                                delete_not,
                                widget.auth,
                                widget.sign,
                                widget.list_partner,
                                posts[index]   ,widget.load,widget.analytics);
                          }));
                        },
                      );
              })));
  }
}
