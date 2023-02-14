import 'package:ifdconnect/campus/absence_prof/add_absence_form.dart';
import 'package:ifdconnect/campus/etudiant/classPackge/AbsencesList.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ifdconnect/config/config.dart';
import 'package:ifdconnect/models/user.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:ifdconnect/services/Fonts.dart';

class AbsencePage extends StatefulWidget {
  final int _userId;
  final int _studentId;
  final int _token;
  User user_me;

  AbsencePage(this.user_me,this._userId, this._studentId, this._token);

  @override
  _AbsencePageState createState() => _AbsencePageState();
}

class _AbsencePageState extends State<AbsencePage> {
  AbsencesList absences;
  var data;

  bool loading = true;

  Future<http.Response> getAbcences(
      int user_id, int student_id, int token) async {
    print("token");
    print(token);
    final param = {
      "user_id": "$user_id",
      "student_id": "$student_id",
      "auth_token": "$token",
    };

    final absenceData = await http.post(
      "${Config.url_api}/attendances",
      body: param,
    );
    print("**** ${absenceData.body} ****");

    print(absenceData.body);
    setState(() {
      data = json.decode(absenceData.body);
      absences = new AbsencesList.fromJson(data["student"]);
      loading = false;
    });
    return absenceData;
  }

  @override
  void initState() {
    // TODO: implement initState
    getAbcences(widget._userId, widget._studentId, widget._token);
    super.initState();
  }

  Widget _buildAbsenceItem(BuildContext context, int index) {
    return Padding(
        padding:  EdgeInsets.symmetric(horizontal: 10.w,vertical: 7.h),
        child: Container(
          //height: 100.0,

          child: Card(
            elevation: 0.0,
            color: Fonts.col_cl,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22.0.r),
            ),
            child: Container(
              decoration: BoxDecoration(
                  color: Fonts.col_cl,

                  border: Border.all(color: Fonts.col_app_fon ,width: 0.5.w),
                borderRadius: BorderRadius.all(Radius.circular(22.r))
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        // color: Colors.orange[50],
                      margin: EdgeInsets.only(top: 5.h),
                        padding: EdgeInsets.symmetric(horizontal: 7.w,vertical: 10.h),
                        child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(width: 8.w ,),
                            Container(
                              // color: Colors.red,

                                width: MediaQuery.of(context).size.width * 0.7.w,
                                child: Text(absences.absences[index].name,
                                    maxLines: 2,
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0.sp,
                                      color: Fonts.col_app_fonn
                                    ))),
                            InkWell(child: Container(child: !absences.absences[index].more_ditail ? Icon(Icons.arrow_drop_down ,size: 35.r ,color: Fonts.col_app_fonn,) : Icon(Icons.arrow_drop_up,size: 35.r ,color: Fonts.col_app_fonn,)  ,),
                            onTap: (){
                              print("****");

                              setState(() {
                                print("****");
                                print( absences.absences[index].more_ditail );
                                absences.absences[index].more_ditail = absences.absences[index].more_ditail ? false : true ;
                                print( absences.absences[index].more_ditail );


                              });
                            },
                            )
                          ],
                        )
                    ),
                    // Container(
                    //   height: 8,
                    // ),
                    // Container(
                    //   height: 8,
                    // ),
                    absences.absences[index].more_ditail ?  Container(
                      // padding: EdgeInsets.all(10.0.r),

                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 15.w,),

                          Container(
                            child:
                          Row(children: [
                            // Container(child: Text("Période :",
                            //   style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.bold,color: Fonts.col_app_grey),
                            // ),),
                            // Container(child: Text("Matinée",
                            //   style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.bold,color: Fonts.col_app_grey),
                            // ),),

                          ],),
                          ),
                          Expanded(child: Container()),
                          Container(
                            child:
                          Row(children: [
                            Container(child: Text("Date :",
                              style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.bold,color: Fonts.col_app_grey),
                            ),),
                            Container(child: Text("${_formatDate(absences.absences[index].date)}",
                              style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.bold,color: Fonts.col_app_grey),
                            ),)

                          ],
                          ),
                          ),
                          SizedBox(width: 15.w,),

                        ],
                      ),
                    ) : Container(),

                    absences.absences[index].more_ditail ? Container(
                      padding: EdgeInsets.all(7.0.r),

                      child: Row(
                        children: <Widget>[
                       Container(child: Row(
                         children: [
                           SizedBox(width: 15.w,),

                           Container(
                             child: Image.asset("images/hour.png",
                                 width: 18.0.w, height: 18.0.h,color: Fonts.col_app_grey,),
                           ),
                           SizedBox(width: 4.w,),

                           Container(
                             child: Text(
                               "${absences.absences[index].nbh} ${nbrHeures(absences.absences[index].nbh)}",
                               style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.bold,color: Fonts.col_app_grey),
                             ),
                           ),

                         ],
                       ),
                       ),
                          Expanded(child: Container()),
                          Container(
                            decoration: BoxDecoration(
                              color: (absences.absences[index].justif == "null" || absences.absences[index].justif == null) ? Colors.white : Fonts.col_app_fonn,
                              borderRadius: BorderRadius.all(Radius.circular(14.r)),
                              border: Border.all(color: Fonts.col_app_fon,width: 0.5)
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 7.w,vertical: 5.h),
                            child: Text((absences.absences[index].justif == "null" || absences.absences[index].justif == null) ?"Non - Justifié " : "Justifié " ,
                              style: TextStyle(color: Fonts.col_app_fonn ,fontSize: 12.sp,fontWeight: FontWeight.w500),),
                          ),
                          SizedBox(width: 15.w,),

                        ],
                      ),
                    ) : Container(),



                    // Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: <Widget>[
                    //       Checkbox(
                    //         value: absences.absences[index].forenoon.toString() ==  "true"
                    //             ? true
                    //             : false,
                    //         onChanged: (val) {},
                    //       ),
                    //       Text("Matinée"),
                    //       // Container(
                    //       //   width: 28,
                    //       // ),
                    //       Checkbox(
                    //         value:
                    //             absences.absences[index].afternoon.toString() ==
                    //                     "true"
                    //                 ? true
                    //                 : false,
                    //         onChanged: (val) {},
                    //       ),
                    //       Text("Après-Midi"),
                    //     ]),





                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //   children: <Widget>[
                    //     Column(
                    //       children: <Widget>[
                    //         Row(
                    //           children: <Widget>[
                    //             Image.asset("images/hour.png",
                    //                 width: 18.0, height: 18.0),
                    //             Container(
                    //               width: 10.0,
                    //             ),
                    //             Text(
                    //               "${absences.absences[index].nbh} ${nbrHeures(absences.absences[index].nbh)}",
                    //               style: TextStyle(fontSize: 13.0),
                    //             ),
                    //           ],
                    //         )
                    //       ],
                    //     ),
                    //     Column(
                    //       children: <Widget>[
                    //         Row(
                    //           children: <Widget>[
                    //             Image.asset("images/cal1.png",
                    //                 color: Colors.black,
                    //                 width: 18.0,
                    //                 height: 18.0),
                    //             Container(
                    //               width: 10.0,
                    //             ),
                    //             Text(
                    //               "${_formatDate(absences.absences[index].date)}",
                    //               style: TextStyle(fontSize: 13.0),
                    //             ),
                    //           ],
                    //         )
                    //       ],
                    //     ),
                    //     Column(
                    //       children: <Widget>[
                    //         Container(
                    //             height: 30.0,
                    //             child: RaisedButton(
                    //                 shape: RoundedRectangleBorder(
                    //                     borderRadius: BorderRadius.circular(4.0),
                    //                     side: BorderSide(
                    //                         width: 0.1,
                    //                         style: BorderStyle.solid)),
                    //                 padding: EdgeInsets.only(left: 4, right: 4),
                    //                 color: Colors.green,
                    //                 onPressed: () {
                    //                   showDialog(
                    //                       context: context,
                    //                       barrierDismissible: true,
                    //                       builder: (BuildContext context) =>
                    //                           new Dialog(
                    //                             child: new Container(
                    //                               padding:
                    //                                   new EdgeInsets.all(16.0),
                    //                               width: 60.0,
                    //                               child: new Column(
                    //                                 mainAxisSize:
                    //                                     MainAxisSize.min,
                    //                                 children: [
                    //                                   new Text(
                    //                                     "Justification",
                    //                                     style: new TextStyle(
                    //                                         fontWeight:
                    //                                             FontWeight.bold),
                    //                                   ),
                    //                                   new Container(height: 12.0),
                    //                                   new Text(
                    //                                     absences.absences[index]
                    //                                                 .justif
                    //                                                 .toString() ==
                    //                                             "true"
                    //                                         ? "Justification disponible !"
                    //                                         : "Justification non disponible !",
                    //                                     style: new TextStyle(
                    //                                         color: Colors
                    //                                             .indigo[600]),
                    //                                   ),
                    //                                 ],
                    //                               ),
                    //                             ),
                    //                           ));
                    //                 },
                    //                 child: Row(
                    //                   children: <Widget>[
                    //                     Image.asset("images/guarantee.png",
                    //                         color: Colors.white,
                    //                         width: 18.0,
                    //                         height: 18.0),
                    //                     Container(
                    //                       width: 10.0,
                    //                     ),
                    //                     Text(
                    //                       "Justification",
                    //                       style: TextStyle(color: Colors.white),
                    //                     )
                    //                     // isJustify(absences.absences[index].justif)
                    //                   ],
                    //                 )))
                    //       ],
                    //     ),
                    //   ],
                    // ),
                    // Container(
                    //   height: 12,
                    // )
                  ]),
            ),
          ),
        ));
  }

  Widget _buildAbsneceList() {
    Widget productCards;
    if (absences.absences.length > 0) {
      productCards = ListView.builder(
        itemBuilder: _buildAbsenceItem,
        itemCount: absences.absences.length,
      );
    } else {
      productCards = Center(
        child: Text("Aucun résultat trouvé"),
      );
    }
    return productCards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),

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
                Image.asset(
                  "images/absences.png",
                  color: Colors.white,
                  width: 23.5.w,
                  height: 25.5.h,
                ),
                Container(width: 7.w,),
                Padding(
                  padding: const EdgeInsets.only(top: 10,bottom:10),
                  child: Text(
                    "Absences",
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
              child :
                loading
                    ? Center(child: CircularProgressIndicator())
                    : _buildAbsneceList()),
          ),
        ),
    );
  }

  Widget isJustify(name) {
    return Text(
      name,
      style: TextStyle(color: Colors.redAccent),
    );
  }

  String nbrHeures(String nbh) {
    if (nbh.toString() == "1")
      return "heure";
    else
      return "heures";
  }

  String _formatDate(String date) {
    String day = DateTime.parse(date).day.toString();
    String month = DateTime.parse(date).month.toString();
    String year = DateTime.parse(date).year.toString();
    String m = int.parse(month) < 10 ? "0$month" : "$month";

    return "$day/$m/$year";
  }
}
