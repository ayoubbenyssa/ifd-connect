

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/models/user.dart';

class Database {
  ParseServer parse_s = new ParseServer();


  Future<User> GetUserInfo(id) async {

    print(id);
    var response = await parse_s.getparse('users?where={"id1":"$id"}&include=user_formations,role');
    return new User.fromMap(response["results"][0]);
  }



  push_data(gMessagesDbRef,text,id,imageUrl,audio){
    gMessagesDbRef.push().set({
      'timestamp': ServerValue.timestamp,
      'messageText': text,
      'idUser': "$id",
      'imageUrl': imageUrl,
      'audio': audio
    });
  }


  Future<bool> deleteConversation(context,key,key1) async {
    return await showDialog<bool>(
      context: context,
      builder: (_) => new AlertDialog(
        title: const Text(''),
        content:
        const Text('Do you realy want to delete this conversation ?'),
        actions: <Widget>[
          new FlatButton(
              child: const Text('Ok'),
              onPressed: () {
                FirebaseDatabase.instance
                    .reference()
                    .child("message_medz")
                    .child(key)
                    .remove();
                FirebaseDatabase.instance
                    .reference()
                    .child("lastm_medz")
                    .child(key1)
                    .remove();
                FirebaseDatabase.instance
                    .reference()
                    .child("room_medz")
                    .child(key)
                    .remove();

                Navigator.of(context).pop(false);
              }),
          new FlatButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        ],
      ),
    ) ??
        false;
  }



  Future<bool> confirmblock(context,isBlock,func) async {
    return await showDialog<bool>(
      context: context,
      builder: (_) => new AlertDialog(
        title: const Text(''),
        content: new Text(isBlock
            ? 'Do you realy want to unblock this user ?'
            : 'Do you realy want to block this user ?'),
        actions: <Widget>[
          new FlatButton(
              child: const Text('Ok'),
              onPressed: () {
                func();
               /* toggleblock(isBlock, widget.myid, widget.idOther)
                    .then((_) {
                  try {
                    setState(() {
                      isBlock = !isBlock;
                    });
                  } catch (e) {}
                });*/
                Navigator.of(context).pop(false);
              }),
          new FlatButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        ],
      ),
    ) ??
        false;
  }



}