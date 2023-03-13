import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/Fonts.dart';

class UserConn extends StatefulWidget {
  UserConn(this.id, this.id_notification,this.my_id /*,this.image,this.name*/);

  String id;
  String id_notification;
  String my_id;

  //var name;
  //var image;

  @override
  _UserConnState createState() => _UserConnState();
}

class _UserConnState extends State<UserConn> {
  bool loading = true;
  User user = new User();
  ParseServer parse_s = new ParseServer();
  bool stop= false ;

  getUserInfo() async {

    String id = widget.id;

    var response = await parse_s.getparse('users?where={"id1":"$id"}&include=user_formations,role');
    if (!this.mounted) return;
    setState(() {
      loading = false;
      user = new User.fromMap(response["results"][0]);


    });
  }

  @override
  void initState() {
    getUserInfo();
     Firestore.instance
        .collection('user_notifications')
        .document(widget.my_id)
        .collection("Notifications").document(widget.id_notification).updateData({
       "read"
           :true     });
    super.initState();
  }

  String getKey() => widget.my_id + "_" + widget.id;
  String getKey1() => widget.id + "_" + widget.my_id;

  confirmer() async {
    /*setState(() {
      stop = true;
    });*/
    await Firestore.instance
        .collection('user_notifications')
        .document(widget.my_id)
        .collection("Notifications")
        .document(widget.id_notification)
        .updateData({"accept": true});

    DatabaseReference gMessagesDbRef2 =
        FirebaseDatabase.instance.reference().child("room_medz").child(getKey());
    gMessagesDbRef2.set({
      widget.my_id: true,
      "lastmessage": "Aucun message",
      "key": getKey(),
      "timestamp": ServerValue.timestamp /*new DateTime.now().toString()*/,
    });

    FirebaseDatabase.instance.reference().child("room_medz").child(getKey1()).set({
      widget.id: true,
      "lastmessage": "Aucun message",
      "key": getKey1(),
      "timestamp": ServerValue.timestamp /*new DateTime.now().toString()*/,
    });
    Navigator.pop(context);

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text("Demande de connexion")),
        body: loading
            ? new Center(child: new Container())
            : new Container(
                //padding: new EdgeInsets.all(12.0),
                child: new ListTile(
                  leading: new ClipOval(
                      child: new Container(
                          color: Fonts.col_app,
                          width: 50.0,
                          height: 50.0,
                          child: new Center(
                              child: Image.network(
                            user.image,
                            fit: BoxFit.cover,
                          )))),
                  title: new Text(user.fullname.toString() +
                      " " +
                      user.firstname.toString()),
                  subtitle: new Text(user.titre.toString()),
                  trailing: new RaisedButton(
                    onPressed: () {
                      confirmer();

                      /* if(stop)
                      else {

                      }*/
                    },
                    child: new Text("Confirmer"),
                  ),
                ),
              ));
  }
}
