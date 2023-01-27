import 'package:flutter/material.dart';
import 'package:ifdconnect/campus/etudiant/classPackge/Module.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class SousModule extends StatelessWidget {
  final Module module;

  SousModule(this.module);

  @override
  Widget build(BuildContext context) {
    print("module range");
    // print(module.elements[0].subject.replaceAll("\n",''));
    print("module range");

    return ListView(
      children: this
          .module
          .elements
          .map((element) => Container(
        color: Colors.white,
        height: 205.h,
                margin: EdgeInsets.all(10.0),
                // elevation: 8.0,
                // clipBehavior: Clip.antiAliasWithSaveLayer,
                // semanticContainer: true,
                // shape: RoundedRectangleBorder(
                //   borderRadius: BorderRadius.circular(15.0),
                // ),
                child: Stack(
                  children: <Widget>[
                    // SizedBox(height: 20.h,),

                    Positioned(
                      top: 23.h,
                      left:8.w,
                      child: Container(
                        height: 180.h ,
                        width: MediaQuery.of(context).size.width * 0.89.w,
                        decoration: BoxDecoration(
                          border: Border.all(color: Fonts.col_app_fonn,),
                          color: Fonts.col_cl,
                          borderRadius: BorderRadius.all(Radius.circular(23.r))

                        ),
                        child: Column(children: [
                          SizedBox(height: 10.h,),
                          Container(
                              margin: EdgeInsets.only(top :5.0),
                              padding: EdgeInsets.fromLTRB(10.0.w, 5.0.h, 5.0.w, 5.0.h),
                              child: new Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          "Le coefficient de sous module :",
                                          style: TextStyle(fontSize: 12.0.sp,fontWeight: FontWeight.w500,color: Fonts.col_app_grey ),
                                        ),
                                      ),
                                      // Expanded(child: Container(),),
                                      Container(
                                        alignment: Alignment.centerRight,
                                        child:
                                        Text("${element.subjectWeighting}",
                                          style: TextStyle(fontSize: 14.0.sp,fontWeight: FontWeight.bold,color: Fonts.col_app_grey ),

                                        ),)

                                    ],
                                  )
                                ],
                              )),
                          Container(
                              margin: EdgeInsets.all(5.0),
                              padding: EdgeInsets.fromLTRB(10.0, 5.0, 5.0, 5.0),
                              child: new Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      "La note du rattrapage :",
                                      style: TextStyle(fontSize: 12.0.sp,fontWeight: FontWeight.w500,color: Fonts.col_app_grey ),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      "${element.markAr == "NC" ? 'NC' : noteDeRatt(double.parse(element.markAr))}",
                                      style: TextStyle(fontSize: 13.0.sp,fontWeight: FontWeight.bold,color: Fonts.col_app_grey ),
                                    ),
                                  )
                                ],
                              )),
                          Container(
                              margin: EdgeInsets.all(5.0),
                              padding: EdgeInsets.fromLTRB(10.0, 5.0, 5.0, 5.0),
                              child: new Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          // Image.asset("images/edit.png",
                                          //     width: 22.0, height: 22.0),
                                          // Container(
                                          //   width: 10.0,
                                          // ),
                                          Container(
                                            child: Text(
                                              "La moyenne avant rattrapage :",
                                              style: TextStyle(fontSize: 12.0.sp,fontWeight: FontWeight.w500,color: Fonts.col_app_grey ),
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              "${element.mark == "NC" ? 'NC' : noteDeRatt(double.parse(element.mark))}",
                                              style: TextStyle(fontSize: 13.0.sp,fontWeight: FontWeight.bold,color: Fonts.col_app_grey ),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              )),
                          Container(
                              margin: EdgeInsets.all(5.0),
                              padding: EdgeInsets.fromLTRB(10.0, 5.0, 5.0, 5.0),
                              child: new Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[

                                  Container(
                                    child: Text(
                                      "La moyenne retenue :",
                                      style: TextStyle(fontSize: 12.0.sp,fontWeight: FontWeight.w500,color: Fonts.col_app_grey ),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      "${element.average == "NC" ? 'NC' : noteDeRatt(double.parse(element.average))}",
                                      style: TextStyle(fontSize: 13.0.sp,fontWeight: FontWeight.bold,color: Fonts.col_app_grey ),
                                    ),
                                  )
                                ],
                              )),
                        ],
                        ),
                      ),
                    ),

                    Positioned(
                      top: 0.h,
                      right: 45.w,
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.7.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                              color: Fonts.col_cl,
                              border: Border.all(color: Fonts.col_app_fonn ,width: 0.5.w),
                              borderRadius: BorderRadius.circular(22.0.r)),
                          // margin: EdgeInsets.only(bottom: 30.h),
                          padding: EdgeInsets.all(5.0),
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  width: MediaQuery.of(context).size.width * 0.6.w,
                                  child: Text(
                                      element.subject.replaceAll("\n", ''),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Fonts.col_app_fonn,
                                        fontSize: 12.0.sp,
                                        fontWeight: FontWeight.bold
                                      ))),
                            ],
                          )),
                    ),

                  ],
                ),
              ))
          .toList(),
    );
  }

  String format(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
  }

  String noteDeRatt(double note) {
    if (note != 0) {
      return format(note);
    } else
      return "";
  }
}
