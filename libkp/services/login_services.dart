import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ifdconnect/login/inactive.dart';
import 'package:ifdconnect/login/login.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/user/edit_my_profile.dart';
import 'package:ifdconnect/widgets/bottom_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ifdconnect/func/parsefunc.dart';

class RegisterService {
  static ParseServer parse_s = new ParseServer();

  static onLoading(context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => new Dialog(
              child: new Container(
                padding: new EdgeInsets.all(16.0),
                width: 60.0,
                color: Colors.blue[200],
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    new CircularProgressIndicator(),
                    new Container(height: 8.0),
                    new Text(
                      "En cours ...",
                      style: new TextStyle(color: Colors.indigo[600]),
                    ),
                  ],
                ),
              ),
            ));

    // Navigator.pop(context); //pop dialog
    //  _handleSubmitted();
  }




  static insert_user(String name, String familyname, email, context, id, photo,
      titre, organisme, auth, sign, list_partners, analytics,
      {accessToken,
        idToken,
        password,
        phone,
        profession,
        region,
        lat,
        lng,
        addr,
        type_user,
        city,
        role,
        InfoUser infouser,
        zone, diplome}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

    Map<String, dynamic> map = new Map<String, dynamic>();
    map["id1"] = id;
    map["idblock"] = id;
    map["emi"] = true;
    map["firstname"] = name;
    map["competences"] = [];
    map["objectif"] = [];
    map["month"] = new DateTime.now().month;
    map["year"] = new DateTime.now().year;
    map["age"] = "";
    map["familyname"] = familyname;
    map["diplome"] = diplome;

    String alpha = name.toLowerCase()[0];
    map["titre"] = titre;
    map["organisme"] = organisme;
    map["photoUrl"] = photo;
    if (accessToken != null) map["accessToken"] = accessToken;
    if (idToken != null) map["idToken"] = idToken;
    map["timestamp"] = new DateTime.now().millisecondsSinceEpoch;
    map["email"] = email;
    if (phone != null) map["phone"] = phone;
    map["active"] = infouser.role.id == "9UHbnUrotk"?0:1;
    map["emi"] = true;
    print("dhdhhdh");

    Map<String, dynamic> map1 = new Map<String, dynamic>();


    map["role_user"] =   {
    "__type": "Pointer",
    "className": "role",
    "objectId": infouser.role.id
    };

    if (infouser.first_name != null) {
      map["user_id"] = infouser.user_id;
      map["student_id"] = infouser.sudent_id;
      map["identifiant"] = infouser.identifiant;
      map["role"] = infouser.role.name;
      map["employee_id"] = infouser.employee_id;
      map["password"] = infouser.password;

    }



    if (infouser.first_name != null) {
      prefs.setInt("token_user", infouser.auth_token);
      prefs.setInt("user_id", infouser.user_id);
      prefs.setInt("student_id", infouser.sudent_id);
      prefs.setInt("employee_id", infouser.employee_id);
      map["password"] = infouser.password;

    }
    map["online"] = true;
    map["online"] = true;
    map["last_active"] = 0;
    Firestore.instance.collection('users').document(id).setData(map1);
    String token = await _firebaseMessaging.getToken();

    map["token"] = token;
    Firestore.instance
        .collection('user_notifications')
        .document(id)
        .setData({
      "my_token": token,
      "name": name + " " + familyname,
      "image": photo
    });

    parse_s.postparse("users", map).then((val) async{
      print(val);
      prefs.setString("id", val["objectId"]);
      print(
          "------------------------------------------------------------------");
      var response = await parse_s.getparse('users?where={"objectId":"${ val["objectId"]}"}&include=user_formations,role');
      User us = new User.fromMap(response["results"][0]);

      if(infouser.role.id == "9UHbnUrotk")
        {

          print({
            us.id: {
              "name": familyname + "  " + name,
              "seen": false,
              "id": us.id,
              "type": "user",
              "time": us.createdAt,
              "image": us.image
            }
          });

          FirebaseDatabase.instance.reference().child("admin_notifications").set({
            us.id: {
              "name": familyname + "  " + name,
              "seen": false,
              "id": us.id,
              "type": "user",
              "time": us.createdAt,
              "image": us.image
            }
          });

        Navigator.pushReplacement(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) => new InactiveWidget(
                  [],
                  us.id,
                )));

        }
      else
      Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
              builder: (BuildContext context) => new BottomNavigation(
                  auth, sign, us, [], true,analytics)));
      /* Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
            builder: (BuildContext context) => new EditMyProfile(
                auth, sign, lat, lng, list_partners, null, analytics),
          ));*/
      //Navigator.pop(context);
    });

    //return ref.documentID;
  }
}
