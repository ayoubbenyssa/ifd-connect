import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ifdconnect/config/config.dart';
import 'dart:convert';

import 'package:ifdconnect/services/Fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'detail_abs.dart';


class Absences extends StatefulWidget {
  final int _userId;
  final int _employeeId;
  final int _token;
  final int _subjectId;
  final int _batchId;
  Absences(this._userId, this._employeeId, this._token, this._subjectId,
      this._batchId);

  @override
  _AbsencesState createState() => _AbsencesState();
}

class _AbsencesState extends State<Absences> {
  var data;
  Future<http.Response> getAbsences(int user_id, int student_id, int token,
      int subject_id, int batch_id) async {
    final param = {
      "user_id": "$user_id",
      "employee_id": "$student_id",
      "auth_token": "$token",
      "subject_id": "$subject_id",
      "batch_id": "$batch_id",
    };

    final batchData = await http.post(
      "${Config.url_api}/employee_subject_attendances",
      body: param,
    );
    setState(() {
      data = json.decode(batchData.body);
      print(data);
    });

    return batchData;
  }

  @override
  void initState() {
    getAbsences(widget._userId, widget._employeeId, widget._token,
        widget._subjectId, widget._batchId);
    super.initState();
  }

  Widget _buildNotesItem(BuildContext context, int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(22)),
        // color: Colors.red,

      ),
      child: Column(
        children: [
          InkWell(
            child: ListTile(
              title: Text(
                "${data["student"][index]["student"]}",
                style: TextStyle(color: Fonts.col_app_grey,fontWeight: FontWeight.bold,fontSize: 12.sp ),
              ),
              trailing: Container(
                padding: data["student"][index]["nb_abs"] != 0? EdgeInsets.fromLTRB(8.w, 5.h, 8.w, 5.h):EdgeInsets.all(0.0),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0.r),color: Fonts.col_app_fonn),
                child: (data["student"][index]["nb_abs"] != null && data["student"][index]["nb_abs"] != 0)
                    ? Text(
                        "${data["student"][index]["nb_abs"]} heures",
                        style: TextStyle(fontSize: 10.0.sp,color: Colors.white,fontWeight: FontWeight.bold),
                      )
                    : Text(""),
              ),
            ),
            onTap: (){
          print("**************");
          Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
          builder: (BuildContext context) => new Detail_abs(
          widget._userId,widget._employeeId,widget._token,widget._batchId,data["student"][index]["id"],data["student"][index]["student"]
          )));
          print("${data}");
          },
          ),
          data["student"].length != index + 1 ?    Divider(color: Fonts.border_col,thickness: 0.5,) : Container(),
        ],
      ),
    );
  }

  Widget _buildNotesList() {
    Widget timeCards;
    if (data["student"].length > 0) {
      timeCards = Container(
        // decoration: BoxDecoration(
        //     // color: Colors.black,
        //     borderRadius:BorderRadius.all(Radius.circular(22))),
        child: ListView.builder(
          itemBuilder: _buildNotesItem,
          itemCount: data["student"].length,
        ),
      );
    } else {
      timeCards = Container();
    }
    return timeCards;
  }

  @override
  Widget build(BuildContext context) {
    return data != null
        ? Scaffold(
            body: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(22)),
                // color: Colors.blue,
              ),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: _buildNotesList(),
                  )
                ],
              ),
            ),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
