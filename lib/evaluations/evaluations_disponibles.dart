import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/models/EvaluationDisponible.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'evaluations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ifdconnect/widgets/widgets.dart';
import 'package:collection/collection.dart';


class EvaluationsDisponibles extends StatefulWidget {
  EvaluationsDisponibles(this._userId, this._studentId, this._token, this._employee_id);

  final int _userId;
  final int _studentId;
  final int _token;
  final int _employee_id;

  @override
  _EvaluationsDisponiblesState createState() => _EvaluationsDisponiblesState();
}

class _EvaluationsDisponiblesState extends State<EvaluationsDisponibles> {
  List evaluations=[];
  bool loading = true;



  getAvailableEvaluations(int user_id, int student_id, int token, int employee_id) async{
    final param = {
      "user_id": "$user_id",
      "student_id": "$student_id",
      "auth_token": "$token",
      "employee_id": "$employee_id"
    };

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final data = await http.post(
      "${prefs.getString('api_url')}/index_evaluation",
      body: param,
    );
    var decodedData = json.decode(data.body);
    print(decodedData);
    decodedData['result'].forEach((val) {
      if(!val['deja_rempli']) evaluations.add(EvaluationDisponible.fromDoc(val));
    });
    // evaluations = decodedData['result']
    //     .map((var contactRaw) => contactRaw["deja_rempli"] ? null : EvaluationDisponible.fromDoc(contactRaw))
    //     .toList();
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAvailableEvaluations(widget._userId, widget._studentId, widget._token, widget._employee_id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        titleSpacing: 0.0,
        toolbarHeight: 60.h ,
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
              // SizedBox(width: 23.5.w,),
              Image.asset(
                "images/evaluation2.png",
                color: Colors.white,
                width: 23.5.w,
                height: 25.5.h,
              ),
              SizedBox(width: 7.w,),
              Padding(
                padding: const EdgeInsets.only(top: 10,bottom:10),
                child: Text(
                  "Evaluations disponibles",
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
                  child : !loading
                      ? evaluations.length==0
                      ? Center(
                    child: Text('Aucune évaluation disponible'),
                  )
                      : ListView(
                    children: <Widget>[
                      SizedBox(height: 15.h,),
                      ...evaluations
                          .map((var evaluation) => GestureDetector(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Evaluations(
                                        evaluation,
                                        widget._userId,
                                        widget._studentId,
                                        widget._token,
                                        widget._employee_id)));
                          },
                            child: new Card(
                        margin: EdgeInsets.all(10.r),
                        shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(15.r))
                        ),
                        // color: Colors.white38,
                        shadowColor: Colors.blueGrey,
                        elevation: 4,
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                title: Text(
                                  evaluation.title,
                                  style: TextStyle(fontSize: 18.sp),
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 18.w,
                                ),
                              ),
                            ],
                        ),
                      ),
                          ))
                          .toList(),
                    ],
                  )
                      : Center(
                    child: Widgets.load(),
                  )
              ))),
    );
  }
}
