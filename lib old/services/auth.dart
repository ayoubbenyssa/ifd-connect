import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


abstract class BaseAuth {
  Future<String> signInWithEmailAndPassword(String email, String password,context);
  Future<String> createUserWithEmailAndPassword(String email, String password);
  Future<String> currentUser();
  Future<void> signOut();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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

  Future<String> signInWithEmailAndPassword(
      String email, String password,context) async {
    AuthResult user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    //Navigator.of(context, rootNavigator: true).pop('dialog');

    user.user.email;
    return user?.user.uid;
  }

  Future<String> createUserWithEmailAndPassword(
      String email, String password) async {
    AuthResult user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return user?.user.uid;
  }

  Future<String> currentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user?.uid;
  }

  Future<void> signOut() async {
  return _firebaseAuth.signOut();
  }
}