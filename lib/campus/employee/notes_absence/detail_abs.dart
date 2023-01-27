import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ifdconnect/campus/absence_prof/absence_repository.dart';
import 'package:ifdconnect/config/config.dart';
import 'package:ifdconnect/services/Fonts.dart';



class Detail_abs extends StatefulWidget {

  final int _userId;
  final int _employeeId;
  final int _token;
  final int _batchId;
  final int stud_id ;
  String stud_nom ;


  Detail_abs(this._userId, this._employeeId, this._token,
      this._batchId, this.stud_id ,this.stud_nom);
  @override
  _Detail_absState createState() => _Detail_absState();
}

class _Detail_absState extends State<Detail_abs> {

  bool load = true;
  // var json = {};
  List detail_abs = List() ;

  Absence_repository home_repos = Absence_repository();


  getList_abs() async {
    final param = {
      "user_id": "${widget._userId}",
      "auth_token": "${widget._token}",
      "student_id": "${widget.stud_id}",
      "batch_id": "${widget._batchId}"
    };

    print(param);

    /**
        "date"
        "student_id"

     */

    final profileData = await http.post(
        "${Config.url_api}/api/detail_attendance",
        body: json.encode(param)
    );
    if (!this.mounted) return;
    print("------------333333------------");

    print(profileData.body);
    // print(a);
    print("----------33333--------------");

    setState(() {
      print(profileData.body);
      final a =  profileData.body ;
      print("QQAAAAAAaaaaaa == ${a}");
      // detail_abs = profileData.body;
      // attendance = a["attendance"].toList();
      // cats = a;

      print("**********************13******");



      load = false;
    });
  }

  attandence_table(matiere , date ){
    return
      Container(
          margin: EdgeInsets.only(left: 12.w,right: 12.w, bottom: 5.h,top: 15.h),
          height: 140.h,width: 354.w,
          decoration: BoxDecoration(
            border: Border.all(color: Fonts.col_app_fonn,width: 0.5.w),
            borderRadius: BorderRadius.all(Radius.circular(22.r)),
          ),
          child:
          Row(
            children: [
              Text(matiere ,style: TextStyle(fontWeight: FontWeight.bold),),
              Text(date ,style: TextStyle(fontWeight: FontWeight.bold),)

            ],
          )
      );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getList_abs();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(


        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Fonts.col_app,
          titleSpacing: 0.0,
          toolbarHeight: 70.h ,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              )),
          leading: Container(
            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.r),

                ),
                color: Fonts.col_app,

              ),
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
          ),
          title: Container(
            color: Colors.white,
            child: Container(
              padding: const EdgeInsets.only(top: 0,bottom:10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(30.r),

                ),
                color: Fonts.col_app,

              ),
              child: Row(
                children: [
                  // Image.asset(
                  //   "images/appointment.png",
                  //   color: Colors.white,
                  //   width: 23.5.w,
                  //   height: 25.5.h,
                  // ),              Container(width: 7.w,),
                  Padding(
                    padding: const EdgeInsets.only(top: 10,bottom:10),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.54.w,
                      child: Text( widget.stud_nom,
                        // widget.student.first_name + " " + widget.student.last_name,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0.sp),
                      ),
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
                                "images/launcher_icon_ehtp.png",
                              )))),
                  SizedBox(width: 22.w,),
                ],

              ),
            ),
          ),
        ),
        body:
        // load == true
        //     ? Center(
        //         child: CupertinoActivityIndicator(),
        //       )
        //     :
        Container(
          color: Colors.white,
          child: ClipRRect(
            borderRadius: BorderRadius.only(topRight : Radius.circular(39.r)),

            child: Container(
              color: Colors.white,
              child: ListView(children: [

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // children: cats.map((e) => row_widget(e, click_cat)).toList(),
                  children: [
                    // Container(height: 12.h),
                    Container(
                      // height: attendance.length == 0 ? 5.h :(double.parse("${attendance.length}") * 200).h ,
                      height: detail_abs.length == 0 ? 55.h : 200.h ,
                      child:
                      detail_abs.length == 0 ?
                      Center(child: Text("Aucun résultat trouvé",style: TextStyle(fontSize: 12.sp , fontWeight: FontWeight.w100),))
                          :
                      ListView.builder(
                          itemCount: detail_abs.length,
                          itemBuilder: (BuildContext context, int index) {

                            print("@@@@@@@@@##");
                            return attandence_table(detail_abs[index]["matiere"] ,detail_abs[index]["date"]);
                          }
                      ),
                    )


                  ],
                ),
                // Container(
                //   height: 52,
                // ),
              ]),
            ),
          ),
        ));
  }
}
