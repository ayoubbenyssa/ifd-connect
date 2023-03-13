import 'dart:math';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:ifdconnect/campus/etudiant/classPackge/emploiDuTemps.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ifdconnect/campus/etudiant/emploiDuTemp/EmploiCards.dart';
import 'package:ifdconnect/campus/shared/fixdropdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ifdconnect/widgets/custom_widgets/buttons_appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';


class TimeTable extends StatefulWidget {
  final int _userId;
  final int _studentId;
  final int _token;

  TimeTable(this._userId, this._studentId, this._token);

  @override
  _TimeTableState createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  List<DropdownMenuItem<String>> listItem = [];
  TimeTableList ttList;
  var data;
  var dataDetails;
  bool loading = true;
  String selected;
  String message = "Veuillez choisir un calendrier et une semaine";
  bool seulFois = false;
  bool load1 = true;
  List<dynamic> _list = [];
  List list = [];

  var selectedValue = null;
  var selected_week = null;

  bool periode = false;
  int indx = 0;

  TimeTablee initialVal;
  st(i) {
    setState(() {
      indx = i;
    });
    ld(i);
  }
  ld(i) {
    setState(() {
      selectedValue = list[i]["name"];
    });
    //com = value;
    // Reload();
  }

  Future<http.Response> getTimeTables(
      int user_id, int student_id, int token) async {
    final param = {
      "user_id": "$user_id",
      "student_id": "$student_id",
      "auth_token": "$token",
    };
//http://umpo.ml
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final timeTablesData = await http.post(
      "${prefs.getString('api_url')}/timetables_student",
      body: param,
    );
    setState(() {
      data = json.decode(timeTablesData.body);
      print('here');
      print(data);
      ttList = new TimeTableList.fromJson(data["student"]);
      load1 = false;
      loading = false;
    });
    return timeTablesData;
  }

  Future<http.Response> getTimeTablesDetails(
      user_id, student_id, token, tt_id, selected) async {
    final param = {
      "user_id": "$user_id",
      "student_id": "$student_id",
      "auth_token": "$token",
      "week": "$tt_id",
      "tt_id": "${selected.toString()}"
    };

    print("##############################");
    print(tt_id);
    print(selected.toString());
    print("##############################");



    SharedPreferences prefs = await SharedPreferences.getInstance();
    final timeTablesDetailsData = await http.post(
      "${prefs.getString('api_url')}/timetable_student_details",
      body: param,
    );
    setState(() {
      dataDetails = json.decode(timeTablesDetailsData.body);

      print("-------------------------------------");
      print(dataDetails);

      /* dataDetails.sort((a, b) {
        return a.lastName.toLowerCase().compareTo(b.lastName.toLowerCase());
      });*/

      message = "Aucun emploi du temps";
      loading = false;
      load1 = false;
    });

    return timeTablesDetailsData;
  }

  getSSTimeTables(int user_id, int student_id, int token, int id) async {
    var datares;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final timeTablesDataSS = await http.get(
      "${prefs.getString('api_url')}/display_weeks?auth_token=$token&user_id=$user_id&student_id=$student_id&id=$id",
    );
    setState(() {
      datares = json.decode(timeTablesDataSS.body);
      //  ttList = new TimeTableList.fromJson(data[""]);
      load1 = false;
      loading = false;
      _list = datares["weeks"];
    });
  }

  @override
  void initState() {
    int weekday = DateTime.now().weekday - 1;
    list = [
      {"name": "Lun"},
      {"name": "Mar"},
      {"name": "Mer"},
      {"name": "Jeu"},
      {"name": "Ven"},
    ];
    tabController = TabController(
        length: 5,
        vsync: this,
        initialIndex: weekday > 4 ? 0 : DateTime.now().weekday - 1);
    getTimeTables(widget._userId, widget._studentId, widget._token);
    super.initState();
  }

  void load() {
    listItem = [];
    for (var tt in ttList.timeTables) {
      listItem.add(new DropdownMenuItem(
        child: Text(
          "De ${_formatDate(tt.start_date)} à ${_formatDate(tt.end_date)}",
          maxLines: 2,
          softWrap: true,
          style: TextStyle(color: Colors.blueGrey,fontSize: 13),
        ),
        value: "${tt.id}",
      ));
    }
  }

  ggg() {
    var dd = DateTime.now();
    for (var tt in ttList.timeTables) {
      bool dateStart = dd.isAfter(DateTime.parse(tt.start_date));
      bool dateEnd = DateTime.parse(tt.end_date).isAfter(dd);
      if (dateStart && dateEnd) {
        setState(() {
          selected = tt.id.toString();
          initialVal = tt;
        });

        getSSTimeTables(widget._userId, widget._studentId, widget._token,
            int.parse(selected));

        /* getTimeTablesDetails(widget._userId, widget._studentId, widget._token,
            int.parse(selected));*/
      }
    }
  }

  _getTableTime(String id) {
    for (var tt in ttList.timeTables) {
      if (tt.id == int.parse(id)) {
        setState(() {
          initialVal = tt;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading == false) {
      load();
      if (seulFois == false) {
        ggg();
        setState(() {
          seulFois = true;
        });
      }
    }
 Widget drop_down1 = new Container(
   height: 43.0.h,
   width: 320.w,
   margin: const EdgeInsets.symmetric(horizontal: 8,vertical: 8 ),
   padding: const EdgeInsets.only(left: 10.0, right: 8.0),
   decoration: new BoxDecoration(
     color: Fonts.col_cl,
     border: new Border.all(color: Fonts.col_app_fon, width: 0.5),
     borderRadius: new BorderRadius.circular(22.r),
   ),
   child: new DropdownButton(
       underline: SizedBox(),
       isExpanded: true,
       iconSize: 32.0.r,
       icon: Icon(Icons.arrow_drop_down,color: Fonts.col_app_fonn,),
       isDense: false,
       hint: new Text(
         periode
             ? "De ${_formatDate(initialVal.start_date)} à ${_formatDate(initialVal.end_date)}"
             : "Choisir un calendrier",
         maxLines: 2,
         softWrap: true,
         style: new TextStyle(color: Fonts.col_app_fonn , fontSize: 15.sp ,fontWeight: FontWeight.bold),
       ),
       items: listItem,

       onChanged: (value) {
         periode=true;
         selected = value;
         setState(() {
           _getTableTime(value);
           _list = [];
           selectedValue = null;
         });

         getSSTimeTables(widget._userId, widget._studentId,
             widget._token, int.parse(selected));

         /*getTimeTablesDetails(widget._userId, widget._studentId,
                      widget._token, int.parse(value));*/
       }),
     );
     tab(title){
      return Container(
        width: 50.w,
        height: 50.h,

        // padding: EdgeInsets.symmetric(horizontal: 7.w,vertical: 10.h),
        // backgroundColor: ,
        // minRadius: 500.0,
        decoration: BoxDecoration(
          color: Fonts.col_cl,
          borderRadius: BorderRadius.all(Radius.circular(7.r)),
          border: Border.all(color: Fonts.col_app_fonn,width: 0.5.r,style: BorderStyle.solid),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(color: Fonts.col_app_fonn,fontSize: 15.sp,fontWeight: FontWeight.bold),
        ),
      );
    }
    Widget drop_down = new Container(
        height: 43.0.h,
        width: 320.w,
        margin: const EdgeInsets.symmetric(horizontal: 8,vertical: 8 ),
        padding: const EdgeInsets.only(left: 10.0, right: 8.0),
        decoration: new BoxDecoration(
            color: Fonts.col_cl,
            border: new Border.all(color: Fonts.col_app_fon, width: 0.5),
            borderRadius: new BorderRadius.circular(22.r)),
        child: new DropdownButton(
            underline: SizedBox(),
            isExpanded: true,
            iconSize: 32.0.r,
            icon: Icon(Icons.arrow_drop_down,color: Fonts.col_app_fonn,),
            isDense: false,
            items: _list.map((value) {
              return new DropdownMenuItem(
                value: value,
                child: new Text(
                  value,
                  maxLines: 2,
                  softWrap: true,
                  style: new TextStyle(color: Fonts.col_app_fonn , fontSize: 15.sp ,),
                ),
              );
            }).toList(),
            hint: new Text(
              selected_week != null ? selected_week : "Choisir une semaine",
              maxLines: 1,
              softWrap: true,
              style: new TextStyle(color: Fonts.col_app_fonn , fontSize: 15.sp ,fontWeight: FontWeight.bold),
            ),
            onChanged: (value) {
              selected_week = value;
              /* setState(() {
                _getTableTime(value);
              });*/
              getTimeTablesDetails(widget._userId, widget._studentId,
                  widget._token, value, selected);
            }));

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),

        elevation: 0.0,
        titleSpacing: 0.0,
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
              SvgPicture.asset(
                "assets/icons/emploi.svg",
                color: Colors.white,
                width: 23.5.w,
                height: 25.5.h,
              ),              Container(width: 7.w,),
              Padding(
                padding: const EdgeInsets.only(top: 10,bottom:10),
                child: Text(
                  "Emploi du temps ",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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

        // leading: IconButton(
        //   icon: Icon(
        //     Icons.close,
        //     color: Colors.red,
        //   ),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
        // backgroundColor: Colors.white,
        //Color.fromRGBO(240,248,255,1),
        // automaticallyImplyLeading: false,
        // centerTitle: true,
        // elevation: 0.0,
        // title: new

        bottom: new PreferredSize(
            preferredSize: new Size.fromHeight(180.h),
            child: Container(
              color: Fonts.col_app,
              child: ClipRRect(
                borderRadius: BorderRadius.only(topRight : Radius.circular(39.r)),
                child: Container(
                  color: Colors.white,
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        drop_down1,
                        Container(
                          width: 16.0.w,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        drop_down,
                        Container(
                          width: 16.0.w,
                        )
                      ],
                    ),

                    PreferredSize(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 1.w,
                          color: Colors.white,
                          child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 15.w,vertical: 5.h ),
                              // height: 50.0.h,
                              child: ButtonsTabBar(

                                backgroundColor: Fonts.col_app,
                                radius: 10.r,
                                contentPadding: EdgeInsets.all(6.w),
                                borderWidth: 1.0,
                                controller: tabController,
                                borderColor: Fonts.col_app,
                                unselectedBorderColor: Fonts.col_app_fon,
                                unselectedBackgroundColor: Colors.white,
                                unselectedLabelStyle:
                                TextStyle(color: Fonts.col_app_fon, fontSize: 16.sp),
                                labelStyle: TextStyle(
                                    fontSize: 15.0.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                onPressed: st,
                                tabs: list.map((a) => new
                                Tab(text: a["name"])).toList(),
                              )),
                        ))
                  ]),
                ),
              ),
            )),
      ),
      body: load1
          ? Center(
        child: CircularProgressIndicator(),
      )
          : dataDetails == null
          ? Center(
        child: Text(
          "${message}",
          style: TextStyle(color: Colors.blueGrey),
        ),
      )
          : (dataDetails["student"].toString() == "null")
          ? Center(
        child: Text(
          "${message}",
          style: TextStyle(color: Colors.blueGrey),
        ),
      )
          : Container(
        // margin: EdgeInsets.all(10.0),
        child: TabBarView(controller: tabController, children: [
          dataDetails["student"]["Lun"] == null
              ? Center(
            child: Text(
              "Aucun cours trouvé !",
              style: TextStyle(
                  fontSize: 17.0, color: Colors.blueGrey),
            ),
          )
              : EmploiCards(dataDetails["student"]["Lun"]),
          dataDetails["student"]["Mar"] == null
              ? Center(
            child: Text("Aucun cours trouvé !",
                style: TextStyle(
                    fontSize: 17.0,
                    color: Colors.blueGrey)),
          )
              : EmploiCards(dataDetails["student"]["Mar"]),
          dataDetails["student"]["Mer"] == null
              ? Center(
            child: Text("Aucun cours trouvé !",
                style: TextStyle(
                    fontSize: 17.0,
                    color: Colors.blueGrey)),
          )
              : EmploiCards(dataDetails["student"]["Mer"]),
          dataDetails["student"]["Jeu"] == null
              ? Center(
            child: Text("Aucun cours trouvé !",
                style: TextStyle(
                    fontSize: 17.0,
                    color: Colors.blueGrey)),
          )
              : EmploiCards(dataDetails["student"]["Jeu"]),
          dataDetails["student"]["Ven"] == null
              ? Center(
            child: Text("Aucun cours trouvé !",
                style: TextStyle(
                    fontSize: 17.0,
                    color: Colors.blueGrey)),
          )
              : EmploiCards(dataDetails["student"]["Ven"]),
        ]),
      ),
    );
  }

  String _formatDate(String date) {
    String day = DateTime.parse(date).day.toString();
    String month = DateTime.parse(date).month.toString();
    String year = DateTime.parse(date).year.toString();
    String m = int.parse(month) < 10 ? "0$month" : "$month";
    String d = int.parse(day) < 10 ? "0$day" : "$day";

    return "$d-$m-$year";
  }
}
/*DropdownButton(
            isDense: true,
              value: selected,
              items: listItem,
              iconSize: 30.0,
              disabledHint: LinearProgressIndicator(),
              onChanged: (value) {
                selected = value;
                setState(() {});
                getTimeTablesDetails(widget._userId, widget._studentId,
                    widget._token, int.parse(value));
              }),*/
