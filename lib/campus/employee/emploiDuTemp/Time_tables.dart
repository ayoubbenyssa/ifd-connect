import 'package:ifdconnect/config/config.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:ifdconnect/campus/employee/emploiDuTemp/EmploiCards.dart';
import 'package:ifdconnect/campus/etudiant/classPackge/emploiDuTemps.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import 'package:ifdconnect/campus/shared/fixdropdown.dart';
import 'package:ifdconnect/widgets/custom_widgets/buttons_appbar.dart';


class TimeTableEmployee extends StatefulWidget {
  final int _userId;
  final int _employeeId;
  final int _token;

  TimeTableEmployee(this._userId, this._employeeId, this._token);

  @override
  _TimeTableState createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTableEmployee>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  List<DropdownMenuItem<String>> listItem = [];
  TimeTableList ttList;
  var data;
  var dataDetails = null;
  bool loading = true;
  bool loading2 = true;
  String selected;
  String message = "Choisissez une période";
  bool seulFois = false;
  TimeTablee initialVal;
  List<dynamic> _list = [];
  var selectedValue = null;
  var selected_week = null;

  bool periode = false;
  List list = [];
  int indx = 0;


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
      int user_id, int employee_id, int token) async {
    final param = {
      "user_id": "$user_id",
      "employee_id": "$employee_id",
      "auth_token": "$token",
    };

    final timeTablesData = await http.post(
      "${Config.url_api}/timetables_employee",
      body: param,
    );
    setState(() {
      data = json.decode(timeTablesData.body);
      print("%%%%% ${data} %%%%%%%");
      print("%%%%% ${data["student"]} %%%%%%%");

      ttList = new TimeTableList.fromJson(data["student"]);
      print("2222 ${ttList.timeTables} 2222");

      loading = false;
      loading2 = false;
    });
    return timeTablesData;
  }

  getSSTimeTables(int user_id, int student_id, int token, int id) async {
    var datares;
    print("333333################");

    print("token == $token");
    print("user_id == $user_id");
    print("student_id == $student_id");


    final timeTablesDataSS = await http.get(
      "${Config.url_api}/display_weeks?auth_token=$token&user_id=$user_id&student_id=$student_id&id=$id",
    );
    setState(() {
      datares = json.decode(timeTablesDataSS.body);
      print("==========================");
      print(datares);
      //  ttList = new TimeTableList.fromJson(data[""]);
      loading = false;
      print("==========================");

      _list = datares["weeks"];

    });
  }

  Future<http.Response> getTimeTablesDetails(
      user_id,  student_id,  token,  tt_id, selected) async {
    print("*******");
    loading2 = true;
    final param = {
      "user_id": "$user_id",
      "employee_id": "$student_id",
      "auth_token": "$token",
      "week": "$tt_id",
      "tt_id": "${selected.toString()}"
    };
    print({
      "user_id": "$user_id",
      "employee_id": "$student_id",
      "auth_token": "$token",
      "week": "$tt_id",
      "tt_id": "${selected.toString()}"
    });


    final timeTablesDetailsData = await http.post(
      "${Config.url_api}/timetable_employee_details",
      body: param,
    );

    setState(() {
      dataDetails = json.decode(timeTablesDetailsData.body);
      print('samsa');
      print(dataDetails);
      message = "Aucun emploi du temps";
      loading2 = false;
    });

    return timeTablesDetailsData;
  }

  @override
  void initState() {
    int weekday = DateTime.now().weekday - 1;
    getTimeTables(widget._userId, widget._employeeId, widget._token);
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
    super.initState();
  }

/*
  @override
  void initState() {
    int weekday = DateTime.now().weekday - 1;
    tabController = TabController(
        length: 5,
        vsync: this,
        initialIndex: weekday > 4 ? 0 : DateTime.now().weekday - 1);
    getTimeTables(widget._userId, widget._studentId, widget._token);
    super.initState();
  }*/

  void load() {
    listItem = [];
    for (var tt in ttList.timeTables) {
      listItem.add(new DropdownMenuItem(
        child: Text(
          "De ${_formatDate(tt.start_date)} à ${_formatDate(tt.end_date)}",
          maxLines: 2,
          softWrap: true,
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
          print("******");
        });
        print("initialVal  $initialVal");
        getTimeTablesDetails(widget._userId, widget._employeeId, widget._token,initialVal,
            selected);
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
    Widget dop_down1 = new Container(
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
            icon: Icon(Icons.arrow_drop_down,color: Fonts.col_app_fonn,),            isDense: false,
            hint: new Text(
              periode
                  ? "De ${_formatDate(initialVal.start_date)} à ${_formatDate(initialVal.end_date)}"
                  : "Choisir un calendrier",
              maxLines: 1,
              softWrap: true,
              style: new TextStyle(color: Fonts.col_app_fonn , fontSize: 15.sp ,fontWeight: FontWeight.bold),
            ),
            items: listItem,
            onChanged: (value) {
              periode = true;
              selected = value;
              setState(() {
                _getTableTime(value);
                _list = [];
                selectedValue = null;

              });
              getSSTimeTables(widget._userId, widget._employeeId,
                  widget._token, int.parse(selected));

            })
    );
    Widget drop_down = new Container(
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
            items: _list.map((value) {
              return new DropdownMenuItem(
                value: value,
                child: Center(
                  child: new Text(
                    value,
                    maxLines: 2,
                    softWrap: true,
                    style: TextStyle(color: Colors.black),
                  ),
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
              print("__---____---");
              getTimeTablesDetails(widget._userId, widget._employeeId,
                  widget._token, value, selected);
            }));

    if (loading == false) {
      load();
      if (seulFois == false) {
        ggg();
        setState(() {
          seulFois = true;
        });
      }
    }
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Fonts.col_app_fonn),
        toolbarHeight: 250.h ,

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
                  "Emploi du temps ",
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
        backgroundColor: Colors.white,
        //Color.fromRGBO(240,248,255,1),
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0.0,
        // title: new

        bottom: new PreferredSize(
            preferredSize: new Size.fromHeight(170.h),
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
                        dop_down1,
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
      body: loading2
          ? Center(
        child: Text('Veuillez choisir un calendrier et une semaine'),
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
          : /*loading2?Center(child: CircularProgressIndicator(),):(dataDetails["student"].toString() == "null" )
          ? Center(
        child: Text(
          "${message}",
          style: TextStyle(color: Colors.blueGrey),
        ),
      )
          : */
      Container(
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
              : EmploiCards(dataDetails["student"]["Lun"],{
            "user_id": "${widget._userId}",
            "employee_id": "${widget._employeeId}",
            "auth_token": "${widget._token}",
            // "tte_id": "${dataDetails["student"]["Lun"].values.toList()[0]['tte_id']}"
          }),
          dataDetails["student"]["Mar"] == null
              ? Center(
            child: Text("Aucun cours trouvé !",
                style: TextStyle(
                    fontSize: 17.0,
                    color: Colors.blueGrey)),
          )
              : EmploiCards(dataDetails["student"]["Mar"],{
            "user_id": "${widget._userId}",
            "employee_id": "${widget._employeeId}",
            "auth_token": "${widget._token}",
            // "tte_id": "${dataDetails["student"]["Mar"].values.toList()[0]['tte_id']}"
          }),
          dataDetails["student"]["Mer"] == null
              ? Center(
            child: Text("Aucun cours trouvé !",
                style: TextStyle(
                    fontSize: 17.0,
                    color: Colors.blueGrey)),
          )
              : EmploiCards(dataDetails["student"]["Mer"],{
            "user_id": "${widget._userId}",
            "employee_id": "${widget._employeeId}",
            "auth_token": "${widget._token}",
            // "tte_id": "${dataDetails["student"]["Mer"].values.toList()[0]['tte_id']}"
          }),
          dataDetails["student"]["Jeu"] == null
              ? Center(
            child: Text("Aucun cours trouvé !",
                style: TextStyle(
                    fontSize: 17.0,
                    color: Colors.blueGrey)),
          )
              : EmploiCards(dataDetails["student"]["Jeu"],{
            "user_id": "${widget._userId}",
            "employee_id": "${widget._employeeId}",
            "auth_token": "${widget._token}",
            // "tte_id": "${dataDetails["student"]["Jeu"].values.toList()[0]['tte_id']}"
          }),
          dataDetails["student"]["Ven"] == null
              ? Center(
            child: Text("Aucun cours trouvé !",
                style: TextStyle(
                    fontSize: 17.0,
                    color: Colors.blueGrey)),
          )
              : EmploiCards(dataDetails["student"]["Ven"],{
            "user_id": "${widget._userId}",
            "employee_id": "${widget._employeeId}",
            "auth_token": "${widget._token}",
            // "tte_id": "${dataDetails["student"]["Ven"].values.toList()[0]['tte_id']}"
          }),
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

    return "$d/$m/$year";
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
