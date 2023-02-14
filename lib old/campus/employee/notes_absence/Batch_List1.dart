import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ifdconnect/config/config.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'dart:convert';

import 'Notes_Etudiant.dart';
import 'Notes_Absences.dart';

class BatchesPage extends StatefulWidget {
  final int _userId;
  final int _employeeId;
  final int _token;
  bool chef_dept=false;

  BatchesPage(this._userId, this._employeeId, this._token, this.chef_dept);
  @override
  _BatchesPageState createState() => _BatchesPageState();
}

class _BatchesPageState extends State<BatchesPage> {
  var data;
  bool loading = true;
  List<String> keyList = [];
  Future<http.Response> getResultBatches(
      int user_id, int student_id, int token) async {
    final param = {
      "user_id": "$user_id",
      "employee_id": "$student_id",
      "auth_token": "$token",
    };

    final batchData = await http.post(
      "${Config.url_api}/employee_batches",
      body: param,
    );
    setState(() {
      data = json.decode(batchData.body);
      print(data);
      print(data["result"].keys);
      for (var k in data["result"].keys) {
        keyList.add(k);
      }
      loading = false;
      //print(data["result"][keyList[1]][1]);
    });

    return batchData;
  }

  @override
  void initState() {
    getResultBatches(widget._userId, widget._employeeId, widget._token);
    super.initState();
  }

  Widget _builBatchList(String batch) {
    Widget timeCards;
    if (data["result"][batch].length > 0) {
      Container(
        child: timeCards = ListView.builder(
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotesAbsences(
                          batch,
                            widget._userId,
                            widget._employeeId,
                            widget._token,
                            data["result"][batch][index]["subject_id"],
                            data["result"][batch][index]["batch_id"], widget.chef_dept)));
              },
              title: Text(
                "${data["result"][batch][index]["subject"]}",
              ),
            );
          },
          itemCount: data["result"][batch].length,
        ),
      );
    } else {
      timeCards = Container();
    }
    return timeCards;
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            body: new ListView.builder(
                itemCount: data["result"].length,
                itemBuilder: (context, index) {
                  return new StickyHeader(
                    header: new Container(
                      height: 50.0,
                      color: Fonts.col_app,
                      padding: new EdgeInsets.symmetric(horizontal: 16.0),
                      alignment: Alignment.centerLeft,
                      child: new Text(
                        "${keyList[index]}",
                        style: const TextStyle(color: Colors.black54,fontSize: 20.0),
                      ),
                    ),
                    content: new Container(
                        height: 100.0, child: _builBatchList(keyList[index])),
                  );
                }));
  }
}
