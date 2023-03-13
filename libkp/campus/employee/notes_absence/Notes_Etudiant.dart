import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:ifdconnect/services/Fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notes extends StatefulWidget {
  final int _userId;
  final int _employeeId;
  final int _token;
  final int _subjectId;
  final int _batchId;
  bool chef_dept;

  Notes(this._userId, this._employeeId, this._token, this._subjectId,
      this._batchId, this.chef_dept);

  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  var data;

  // List<TextEditingController> controllers;
  List controllers;
  bool _isChanged = false;
  bool _isPublished = false;
  bool wait = false;

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
      "${prefs.getString('api_url')}/employee_subject_marks",
      body: param,
    );
    List controllers2 = [];
    setState(() {
      data = json.decode(batchData.body);

      for (Map<String, dynamic> stud in data["student"]) {
        TextEditingController controller = TextEditingController();
        controller.text =
            ((stud["mark"] != null) && (stud["mark"].toString() != ''))
                ? stud["mark"].toString()
                : '';
        controllers2.add(controller);
        print(controller.text);
      }
      _isPublished = data["student"][0]["is_published"] == null
          ? false
          : data["student"][0]["is_published"];
      controllers = controllers2;
    });

    return batchData;
  }

  Future<http.Response> putNotes(
      int user_id, int student_id, int token, int subject_id, var body) async {
    setState(() {
      wait=true;
    });
    print('body');
    // print(body);
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
    setState(() {
      wait = false;
    });

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

  @override
  void initState() {
    getNotes(widget._userId, widget._employeeId, widget._token,
        widget._subjectId, widget._batchId);

    print("jdjjjjdjdj");
    print(widget.chef_dept);

    // controllers = List<TextEditingController>(data["student"].length);
    // for(Map<String,dynamic> stud in data["student"]){
    //   TextEditingController controller = TextEditingController();
    //   controller.text = stud["mark"] ?? "";
    //   controllers.add(controller);
    // }
    // print('le grand test');
    // print(data["student"][1]["mark"]);
    // controllers = data["student"].map((Map<String,dynamic> stud) => TextEditingController(text: stud["mark"])).toList();
    // print('le grand test2');
    // print(controllers[1].text);
    super.initState();
  }

  Widget _buildNotesItem(BuildContext context, int index) {
    return /*index<data["student"].length ? */ Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.w),
      decoration: BoxDecoration(
          color: Fonts.col_cl,
        borderRadius: BorderRadius.all(Radius.circular(25.r)),
        border: Border.all(
            color: Fonts.border_col, style: BorderStyle.solid, width: 0.1),
      ),
      child: ListTile(
        title: Text(
          "${data["student"][index]["student"]}",
          style: TextStyle(
              color: Fonts.col_app_grey,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold),
        ),
        trailing: Container(
          width: 70.w,
          // width: 50.w,
          // padding: EdgeInsets.all(5),
          decoration: BoxDecoration(),
          // child: widget.chef_dept == true
          child: true
              ? Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white
                ),
                child: Center(
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
                      style: TextStyle(fontSize: 15.0.sp,fontWeight: FontWeight.bold, color: Fonts.col_app_fon),
                      decoration: InputDecoration.collapsed(),
                      // keyboardType: TextInputType.multiline,
                      // maxLines: null,
                    ),
                ),
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
                  style: TextStyle(fontSize: 15.0.sp,fontWeight: FontWeight.bold, color: Fonts.col_app_fon),
                  decoration: InputDecoration(border: InputBorder.none),
                  // keyboardType: TextInputType.multiline,
                  // maxLines: null,
                )),
        ),
      ),
    );
  }

  Widget _buildNotesList() {
    print("resulllltt");
    print(data["student"]);

    Widget timeCards;
    if (data["student"].length > 0) {
      timeCards = Form(
        key: _formKey,
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
    return (data != null && !wait)
        ? Scaffold(
            // bottomNavigationBar: widget.chef_dept == true
            bottomNavigationBar: true
                ? Container(
                    height: 54,
                    margin: EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(width: 12),
                        RaisedButton(
                          child: Text("Confirmer"),
                          shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10))),
                          color: Colors.grey[50],
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
                                data["student"][i]["mark"] =
                                    controllers[i].text;
                                // }
                              }

                              await putNotes(
                                  widget._userId,
                                  widget._employeeId,
                                  widget._token,
                                  widget._subjectId,
                                  data);
                            },
                        ),
                        Container(
                          width: 12,
                        ),
              //           Expanded(
              //               child: RaisedButton(
              //             child: Text(
              //               _isPublished ? "Masquer" : "Publier",
              //               style: TextStyle(color: Colors.white),
              //             ),
              //             shape: RoundedRectangleBorder(
              //                 borderRadius:
              //                     BorderRadius.all(Radius.circular(10))),
              //             color: Fonts.col_app,
              //             /* style: TextButton.styleFrom(
              //   elevation: 1,
              //   primary: Colors.white,
              //   backgroundColor: Fonts.col_app,
              //   shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              //   textStyle: TextStyle(
              //       fontSize: 16,
              //       color: Colors.white
              //   ),
              // ),*/
              //             onPressed: () async {
              //               if (_formKey.currentState.validate()) {
              //                 print('Form validated');
              //                 for (int i = 0; i < data["student"].length; i++) {
              //                   if (controllers[i].text != '' &&
              //                       controllers[i].text != null)
              //                     data["student"][i]["mark"] =
              //                         controllers[i].text;
              //                 }
              //                 await putblierMasquer(
              //                     widget._userId,
              //                     widget._employeeId,
              //                     widget._token,
              //                     widget._subjectId);
              //               } else
              //                 print('Form not validated');
              //             },
              //           )),
              //           Container(width: 12.w)
                      ],
                    ),
                  )
                : Container(
                    height: 1.h,
                  ),
            body: Column(
              children: <Widget>[
                Expanded(
                  child: Container(color: Colors.white,child: _buildNotesList()),
                ),
              ],
            ),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
