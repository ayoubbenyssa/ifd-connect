import 'package:ifdconnect/config/config.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sticky_headers/sticky_headers.dart';
import 'Notes_Etudiant.dart';
import 'Notes_Absences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class BatchesPage extends StatefulWidget {
  final int _userId;
  final int _employeeId;
  final int _token;
  bool chef_dept = false;

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
    print("auth_token = ${token}");
    print("user_id = ${user_id}");

    print("employee_id = ${student_id}");

    final batchData = await http.post(
      "${Config.url_api}/employee_batches",
      body: param,
    );
    setState(() {
      data = json.decode(batchData.body);
      print(data);
      print("ayoub loading");

      // print(data["result"].keys);
      print("data ${data["result"]}");

      print("ayoub loading 2");

      for (var k in data["result"].keys) {
        keyList.add(k);
      }
      loading = false;
      //print(data["result"][keyList[1]][1]);
    }
    );

    return batchData;
  }

  @override
  void initState() {
    getResultBatches(widget._userId, widget._employeeId, widget._token);
    super.initState();
  }

  Widget _builBatchList(String batch) {
    Widget timeCards;
    List<Map<String, dynamic>> vv = [];
    data["result"][batch].forEach((val) {
      vv.add(val);
    });

    if (vv.length > 0) {
      Container(
          child: timeCards = Column(
              children: vv
                  .map((Map<String, dynamic> val) =>
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 0.w,vertical: 0.h),
                      margin: EdgeInsets.symmetric(horizontal: 30.w,vertical: 5.h),
                      decoration: BoxDecoration(
                          color: Fonts.col_cl,
                          borderRadius: BorderRadius.all(Radius.circular(29.r)),
                          border: Border.all(color: Fonts.col_app,width: 0.5,style: BorderStyle.solid)
                      ),
                      child:ListTile(
                          trailing: Icon(Icons.arrow_right,color: Fonts.col_app_fon,size: 35.r,),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NotesAbsences(
                                  batch,
                                    widget._userId,
                                    widget._employeeId,
                                    widget._token,
                                    val["subject_id"],
                                    val["batch_id"], widget.chef_dept)));
                      },
                      title: Text(
                        "${val["subject"]}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 11.sp,
                            color: Fonts.col_app
                        ),
                      )
                      )))
                  .toList()));
    } else {
      timeCards = Container();
    }
    return timeCards;
  }

  @override
  Widget build(BuildContext context) {
    return
      loading
        ? Scaffold(
        body:Center(
            child: CircularProgressIndicator(),
          ))
        :
    Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        toolbarHeight: 60.h ,
        elevation: 0.0,

        // iconTheme: IconThemeData(color: Fonts.col_app),
        // titleSpacing: double.infinity,
        titleSpacing: 0,
        leading: Container(
          color: Fonts.col_app,
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: Container(
          padding: const EdgeInsets.only(top: 10,bottom:10),
          color: Fonts.col_app,
          child: Row(
            children: [
              Image.asset(
                "images/appointment.png",
                color: Colors.white,
                width: 23.5.w,
                height: 25.5.h,
              ), Container(width: 7.w,),
              Padding(
                padding: const EdgeInsets.only(top: 10,bottom:10),
                child: Text(
                  "Notes",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18.0.sp),
                ),
              ),

              Expanded(child: Container()),
              Padding(
                  padding: EdgeInsets.all(8.w),
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10.r)),
                      child: Container(
                          height: 44.w,
                          width: 44.w,
                          color: Colors.white.withOpacity(0.9),
                          padding: EdgeInsets.all(0.w),
                          child: Image.asset(
                            "images/launcher_icon_ifd.png",
                          )))),
              SizedBox(width: 22.w,),
            ],

          ),
        ),

      ),

            body: Container(
              color: Fonts.col_app,
              child: ClipRRect(
                borderRadius: BorderRadius.only(topRight : Radius.circular(39.r)),
                child: Container(
                  color: Colors.white,
                  child: new ListView.builder(
                      itemCount: data["result"].length,
                      itemBuilder: (context, index) {
                        return new Column(
                          children: [
                            Container(
                              height: 60.0.h,
                              margin: EdgeInsets.symmetric(horizontal: 20.w,vertical: 15.h),
                              decoration: BoxDecoration(
                                  color: Fonts.col_cl,
                                  borderRadius: BorderRadius.all(Radius.circular(29.r)),
                                  border: Border.all(color: Fonts.border_col,width: 0.5,style: BorderStyle.solid)
                              ),
                              //Colors.lightGreen,
                              padding: new EdgeInsets.symmetric(horizontal: 16.0.w),
                              alignment: Alignment.centerLeft,
                              child: new Text(
                                "${keyList[index]}",
                                style: TextStyle(color: Fonts.col_app_fon, fontSize: 16.sp),
                              ),
                            ),
                            Container(child: _builBatchList(keyList[index])),
                          ],
                        );

                      }),
                ),
              ),
            )
    );
  }
}
