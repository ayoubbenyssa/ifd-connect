import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:ifdconnect/services/Fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notes_Ratt extends StatefulWidget {
  final int _userId;
  final int _employeeId;
  final int _token;
  final int _subjectId;
  final int _batchId;
  bool chef_dept = false;

  Notes_Ratt(this._userId, this._employeeId, this._token, this._subjectId,
      this._batchId, this.chef_dept);

  @override
  _Notes_RattState createState() => _Notes_RattState();
}

class _Notes_RattState extends State<Notes_Ratt> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  var data;
  List controllers;
  bool _isChanged = false;
  bool confirm = false;
  bool _isPublished = false;

  Future<http.Response> putNotes(
      int user_id, int student_id, int token, int subject_id, var body) async {
    body = body["student"];
    Map param = {
      "user_id": user_id,
      "employee_id": student_id,
      "auth_token": token,
      "subject_id": subject_id,
      "students": body,
      // "batch_id": "$batch_id",
    };
    print(json.encode(param));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final batchData = await http.post(
      "${prefs.getString('api_url')}/save_scores",
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(param),
    );

    return batchData;
  }

  Future<http.Response> putblierMasquer(
    int user_id,
    int student_id,
    int token,
    int subject_id,
  ) async {
    print('body');
    Map param = {
      "user_id": user_id,
      "employee_id": student_id,
      "auth_token": token,
      "subject_id": subject_id,
      "is_published": !_isPublished,
    };

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final batchData = await http.post(
      "${prefs.getString('api_url')}/publish_exam_scores",
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(param),
    );
    setState(() {
      _isPublished = !_isPublished;
    });
  }

  Future<http.Response> getNotes(int user_id, int student_id, int token,
      int subject_id, int batch_id) async {
    final param = {
      "user_id": "$user_id",
      "employee_id": "$student_id",
      "auth_token": "$token",
      "subject_id": "$subject_id",
      "batch_id": "$batch_id",
    };

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final batchData = await http.post(
      "${prefs.getString('api_url')}/employee_subject_marks_ar",
      body: param,
    );
    List controllers2 = [];
    print(batchData.body);
    setState(() {
      data = json.decode(batchData.body);
    });
    for (Map<String, dynamic> stud in data["student"]) {
      TextEditingController controller = TextEditingController();
      setState(() {
        controller.text =
            ((stud["mark_ar"] != null) && (stud["mark_ar"].toString() != ''))
                ? stud["mark_ar"].toString()
                : '';
        controllers2.add(controller);

        _isPublished = data["student"][0]["is_published"] == null
            ? false
            : data["student"][0]["is_published"];
        controllers = controllers2;
      });
    }

    return batchData;
  }

  @override
  void initState() {
    getNotes(widget._userId, widget._employeeId, widget._token,
        widget._subjectId, widget._batchId);
    super.initState();
  }

  Widget _buildNotesItem(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.w),

        decoration: BoxDecoration(
          color: Fonts.col_cl,
          borderRadius: BorderRadius.all(Radius.circular(25.r)),
          border: Border.all(
              color: Fonts.border_col, style: BorderStyle.solid, width: 0.1),
        ),

      child: ListTile(
        title: Text("${data["student"][index]["student"]}",
          style: TextStyle(
              color: Fonts.col_app_grey,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold),
        ),
        trailing: Container(
          width: 70.w,

          child: widget.chef_dept == true
              ? TextFormField(
                  keyboardType: TextInputType.number,
                  onChanged: (_) {
                    setState(() {
                      _isChanged = true;
                      print('verdad');
                      print((controllers[controllers.length - 1].text));
                    });
                  },
                  textAlign: TextAlign.center,
                  validator: (value) {
                    // if (double.parse(value)==null && value!="") {
                    //   return '!!';
                    // }
                    // return null;
                  },
                  controller: controllers[index],
                  // focusNode: FocusNode(),
                  style: TextStyle(fontSize: 15.0.sp, color: Fonts.col_app_fon,fontWeight: FontWeight.bold),
                  decoration: InputDecoration(border: InputBorder.none),
                  // keyboardType: TextInputType.multiline,
                  // maxLines: null,
                )
              : IgnorePointer(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    onChanged: (_) {
                      setState(() {
                        _isChanged = true;
                        print('verdad');
                        print((controllers[controllers.length - 1].text));
                      });
                    },
                    textAlign: TextAlign.center,
                    validator: (value) {
                      // if (double.parse(value)==null && value!="") {
                      //   return '!!';
                      // }
                      // return null;
                    },
                    controller: controllers[index],
                    // focusNode: FocusNode(),
                    style: TextStyle(fontSize: 15.0.sp, color: Fonts.col_app_fon,fontWeight: FontWeight.bold),
                    decoration: InputDecoration(border: InputBorder.none),
                    // keyboardType: TextInputType.multiline,
                    // maxLines: null,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildNotesList() {
    Widget timeCards;
    if (data["student"].length > 0) {
      timeCards = ListView.builder(
        itemBuilder: _buildNotesItem,
        itemCount: data["student"].length,
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
            bottomNavigationBar: widget.chef_dept == true
                ? Container(
                    height: 54,
                    margin: EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(width: 12),
                        Expanded(
                            child: RaisedButton(
                          child: Text("Confirmer"),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          color: Colors.grey[200],
                          /*style: TextButton.styleFrom(
                  elevation: 1,
                  primary: Colors.white,
                  backgroundColor: !_isChanged ? Colors.grey[300] : Fonts.col_app,
                  shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  textStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.white
                  )
              ),*/
                          onPressed: !_isChanged
                              ? null
                              : () async {
                                  print('Form validated');
                                  for (int i = 0;
                                      i < data["student"].length;
                                      i++) {
                                    //  if ( controllers[i].text != "" ) {
                                    data["student"][i]["mark_ar"] =
                                        controllers[i].text;
                                    // }
                                  }
                                  print(data);

                                  await putNotes(
                                      widget._userId,
                                      widget._employeeId,
                                      widget._token,
                                      widget._subjectId,
                                      data);
                                },
                        )),
                        Container(width: 12)
                      ],
                    ),
                  )
                : Container(height: 1),
            body: Column(
              children: <Widget>[
                Expanded(
                  child: Container(color: Colors.white,child: _buildNotesList()),
                )
              ],
            ))
        : Center(child: CircularProgressIndicator());
  }
}
