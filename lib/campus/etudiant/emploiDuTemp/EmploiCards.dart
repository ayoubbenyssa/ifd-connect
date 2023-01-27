import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ifdconnect/services/Fonts.dart';


class EmploiCards extends StatefulWidget {
  final emploiDuJour;

  EmploiCards(this.emploiDuJour);
  @override
  _EmploiCardsState createState() => _EmploiCardsState();
}

class _EmploiCardsState extends State<EmploiCards> {
  List<String> time = [];


  final Random _random = Random();


  Widget _buildTimeItem(BuildContext context, int index) {
    print("§§§§§§§§§§§§§§§§§§§");
    print(time);



    return widget.emploiDuJour[time[index]] != null
        ? Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      semanticContainer: true,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(9.r),

      ),
            elevation: 0.0,
            margin: new EdgeInsets.symmetric(horizontal: 13.0.h, vertical: 5.0.w),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 15.h),
              decoration: BoxDecoration(
                  color: Fonts.col_cl,
                border: Border.all(color: Fonts.border_col,width: 0.5.r),
                borderRadius: BorderRadius.all(Radius.circular(9.r))
                ),
              child:
                  Container(
                    child: Row(
                      children: [
                        Container(
                          // color: Colors.green,
                          // padding: EdgeInsets.only(right: 10.w ),
                          child:
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(" ${formatTimeString(widget.emploiDuJour[time[index]]["time"])[0]}",
                                style: TextStyle(fontSize: 12.sp,fontWeight: FontWeight.w100,color: Fonts.col_app_grey),),
                              SizedBox(height: 3.h,),
                              Icon(Icons.lock_clock,size: 12.r,color: Fonts.col_app_grey,),
                              SizedBox(height: 3.h,),
                              Text("${formatTimeString(widget.emploiDuJour[time[index]]["time"])[1]}",
                                style: TextStyle(fontSize: 12.sp,fontWeight: FontWeight.w100,color: Fonts.col_app_grey),),
                            ],
                          ),
                        ),
                        SizedBox(width: 10.w,),
                        Container(width: 1.w,color: Fonts.col_app_grey,height: 52.h,),
                        SizedBox(width: 10.w,),

                        Container(

                         // color: Colors.blue,
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.start,
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                           Container(
                             // color: Colors.red,
                             width: MediaQuery.of(context).size.width * 0.697.w,
                             child: Text(
                               "${widget.emploiDuJour[time[index]]["subject"]}",
                               maxLines: 2,
                               softWrap: true,

                               style: TextStyle(
                                 color: Fonts.col_app_fonn, fontWeight: FontWeight.bold , fontSize: 12.sp
                               ),
                             ),
                           ),
                           Row(
                             children: <Widget>[
                               Padding(
                                 padding: EdgeInsets.only(top: 7.0.h),
                                 child: Text(
                                     "Prof : ${widget.emploiDuJour[time[index]]["employee"]}",
                                   style: TextStyle(fontSize: 12.sp,fontWeight: FontWeight.w500,color: Fonts.col_app_grey),),

                               )
                             ],
                           ),
                         ],),

                       ),
                      ],
                    ),
                  )
              // ListTile(
              //   contentPadding:
              //       EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
              //   leading: Container(
              //     padding: EdgeInsets.only(right: 12.0),
              //     decoration: new BoxDecoration(
              //         border: new Border(
              //             right: new BorderSide(
              //                 width: 1.0, color: Colors.black38))),
              //     child:
              //
              //
              //
              //
              //
              //   ),
              //   title:
              //
              //
              //
              //
              //
              //
              //
              //
              //
              //
              // ),
            ))
        : Container(
          );
  }

  Widget _buildTimeList() {
    Widget timeCards;
    if (widget.emploiDuJour.length > 0) {
      timeCards = ListView.builder(
        itemBuilder: _buildTimeItem,
        itemCount: time.length,
      );
    } else {
      timeCards = Container();
    }
    return timeCards;
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.emploiDuJour.forEach((k,v){

      time.add(k);
      time.sort((a, b) {
        return a.compareTo(b.toLowerCase());
      });

    });

  }

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(

        body: Container(
          color: Colors.white,
          child: Column(
      children: <Widget>[
          Expanded(
            child: _buildTimeList(),
          )
      ],
    ),
        )
    );
  }

  List formatTimeString(String string){
     var st ;
     st = string.split("-");
    return st;

  }
}
