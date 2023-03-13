import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:ifdconnect/models/evaluation_question.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/models/EvaluationDisponible.dart';
import 'package:ifdconnect/models/evaluation_paragraph.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ifdconnect/widgets/custom_widgets/primary_button.dart';
import 'package:ifdconnect/widgets/widgets.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Evaluations extends StatefulWidget {
  Evaluations(this._evaluation, this._userId, this._studentId, this._token, this._employee_id);

  final EvaluationDisponible _evaluation;
  final int _userId;
  final int _studentId;
  final int _token;
  final int _employee_id;

  @override
  _EvaluationsState createState() => _EvaluationsState();
}

class _EvaluationsState extends State<Evaluations> {
  bool loading = true;
  List evaluations;


  getEvaluations(int user_id, int student_id, int token, int evaluation_id, int employee_id) async{
    final param = {
      "user_id": "$user_id",
      "student_id": "$student_id",
      "auth_token": "$token",
      "id": "$evaluation_id",
      "employee_id": "$employee_id"
    };

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final data = await http.post(
      "${prefs.getString('api_url')}/evaluation_template",
      body: param,
    );
    var decodedData = json.decode(data.body);
    print(param);

    evaluations = decodedData['result']
        .map((var contactRaw) => new EvaluationParagraph.fromDoc(contactRaw))
        .toList();
    print(evaluations.length);
    setState(() {
      loading = false;
    });
  }
  validateEvaluations(int user_id, int student_id, int token, int employee_id, int evaluation_id, bool final_validation) async{
    List list1 = [];
    List list2 = [];
    for(EvaluationParagraph evalPgph in evaluations){
      for(EvaluationQuestion evalQst in evalPgph.questions){
        if(evalQst.controller.text.isNotEmpty){
          list2.add(
            {
              evalQst.key:evalQst.controller.text
            }
          );
        }
        else if(evalQst.answer!=null)
          list1.add(
              {
                evalQst.key:evalQst.answer
              }
          );
      }

    }
    final param = {
      "user_id": "$user_id",
      "student_id": "$student_id",
      "auth_token": "$token",
      "employee_id": "$employee_id",
      "eval_sample_id": "$evaluation_id",
      "final_submission": "$final_validation",
      "evaluation_value_simple": list1,
      "evaluation_value_simple_with_field": list2
    };

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final data = await http.post(
      "${prefs.getString('api_url')}/evaluation_result",
      // body: param,
      body: json.encode(param),
      headers: {"Content-type": "application/json"},
    );
    // var decodedData = json.decode(data.body);
    if(final_validation) {
      Navigator.pop(context);
      Navigator.pop(context);
    } else Navigator.pop(context);


  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getEvaluations(widget._userId, widget._studentId, widget._token, widget._evaluation.id, widget._employee_id);
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
              // Image.asset(
              //   "images/appointment.png",
              //   color: Colors.white,
              //   width: 23.5.w,
              //   height: 25.5.h,
              // ),
              // SizedBox(width: 7.w,),
              Padding(
                padding: const EdgeInsets.only(top: 10,bottom:10),
                child: SizedBox(
                  width: 240.w,
                  child: Text(
                    widget._evaluation.title,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 18.0.sp),
                    overflow: TextOverflow.fade,
                  ),
                ),
              ),

              Expanded(child: Container()),
              Padding(
                  padding: EdgeInsets.all(4.w),
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
                          .map((var evaluation) => Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Card(
                        elevation: 5,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.all(Radius.circular(20.r)),
                        ),
                              child: ExpansionTile(
                        initiallyExpanded: false,
                        tilePadding: EdgeInsets.symmetric(horizontal: 15.w),
                        childrenPadding: EdgeInsets.symmetric(horizontal: 15.w),
                        title: Text(
                              evaluation.name,
                              style: TextStyle(
                                height: 1.2,
                                fontSize: 18.sp,
                                // color: Color(0xff000A14),
                                fontWeight: FontWeight.w500
                              ),
                        ),
                        children: evaluation.questions
                                .map<Widget>((var quest) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  quest.name,
                                  // textAlign: TextAlign.left,
                                  style: TextStyle(
                                      height: 1.2,
                                      fontSize: 18.sp,
                                  ),
                                ),
                                if(quest.details.length==1) Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                                  child: TextField(
                                    controller: quest.controller,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15.r))),
                                      hintText: 'Votre réponse',
                                    ),
                                  ),
                                ),
                                if(quest.details.length>1) Wrap(
                                  spacing: 10.w,
                                    // shrinkWrap: true,
                                    // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    //   mainAxisSpacing: 10.0,
                                    //   crossAxisSpacing: 10.0,
                                    //   childAspectRatio: 4.0,
                                    //   crossAxisCount: 2,
                                    //
                                    // ),
                                    children: List<Widget>.generate(
                                      quest.details.length,
                                          (int index) {
                                        return ChoiceChip(
                                          backgroundColor: Color(0xffEFEFEF),
                                          label: Text(quest.details[index].answer),
                                          selected: quest.index == index,
                                          onSelected: (bool selected) {
                                            setState(() {
                                              quest.index = selected ? index : null;
                                            });
                                            if( quest.index!=null) quest.answer = quest.details[index].value;
                                            else quest.answer = null;
                                          },
                                        );
                                      },
                                    ).toList(),
                                )
                              ],
                        ))
                                .toList(),
                      ),
                            ),
                          )).toList(),
                      SizedBox(height: 10.h,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                                textStyle: TextStyle(fontSize: 20.sp)),
                            onPressed: ()async{
                              validateEvaluations(widget._userId, widget._studentId, widget._token, widget._employee_id, widget._evaluation.id, false);
                            },
                            child: const Text('Validation'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                                textStyle: TextStyle(fontSize: 20.sp)),
                            onPressed: ()async{
                              validateEvaluations(widget._userId, widget._studentId, widget._token, widget._employee_id, widget._evaluation.id, true);
                            },
                            child: const Text('Validation finale'),
                          )
                        ],
                      )

                    ],
                  )
                      : Center(
                    child: Widgets.load(),
                  )
              ))),
    );
  }
}
