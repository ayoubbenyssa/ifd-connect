import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ifdconnect/campus/absence_prof/absence_repository.dart';
import 'package:ifdconnect/campus/absence_prof/seances_list.dart';
import 'package:ifdconnect/models/classe.dart';
import 'package:ifdconnect/models/student.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/Fonts.dart';

class StudentsListOneChoice extends StatefulWidget {
  StudentsListOneChoice(this.user, this.batch_id, this.date);

  User user;
  var batch_id;
  DateTime date;

  @override
  _ClassListOneChoiceState createState() => _ClassListOneChoiceState();
}

class _ClassListOneChoiceState extends State<StudentsListOneChoice> {
  List<Student> cats = [];
  bool load = true;
  var json = {};
  Absence_repository home_repos = Absence_repository();
  final TextEditingController _searchQuery = new TextEditingController();
  List<String> _list;
  bool _IsSearching;
  String _searchText = "";

  getList() async {
    var a = await home_repos.students_list(widget.user, widget.batch_id);
    if (!this.mounted) return;
    setState(() {
      cats = a;
      load = false;
    });
  }

  _ClassListOneChoiceState() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _IsSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _IsSearching = true;
          _searchText = _searchQuery.text;
        });
      }
    });
  }

  Student choice_category =
      Student(first_name: "", check: false, batch_id: "-1", last_name: "");

  click_cat(Student category) {
    if (choice_category.first_name != category.first_name) {
      setState(() {
        for (Student ct in cats) {
          setState(() {
            ct.check = false;
          });
        }
        category.check = true;
        choice_category = category;
      });
    } else {
      setState(() {
        category.check = false;
        choice_category = Student(
            first_name: "", last_name: "", check: false, batch_id: "-1");
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getList();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle text4(e) => TextStyle(
        color: Colors.black,
        fontSize: e.check == true ? 20 : 16,
        fontWeight: e.check == true ? FontWeight.w800 : FontWeight.w500);

    Widget divid = Container(
      margin: EdgeInsets.only(
        left: 12,
        right: 12,
      ),
      width: MediaQuery.of(context).size.width,
      height: 1,
      color: Fonts.col_grey.withOpacity(0.06),
    );
    Widget row_widget(Student e, onPressed) => Container(
        color: e.check == true ? Fonts.col_app.withOpacity(0.06) : Colors.white,
        child: InkWell(
          child: Column(children: [
            Padding(
                padding: EdgeInsets.only(
                  top: 16,
                  bottom: 16,
                  left: 23,
                  right: 23,
                ),
                child: Row(children: [
                  Container(
                    width: 12,
                  ),

                  Expanded(
                      child: Text(
                    e.first_name + " " + e.last_name,
                    style: text4(e),
                  )),
                  SvgPicture.asset("images/next.svg"),
                ])),
            divid
          ]),
          onTap: () {
            print("******* ${e.first_name} *********** ");
            onPressed(e);
          },
        ));

    Widget text(String text) => Container(
        padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(28),
          top: ScreenUtil().setHeight(16),
        ),
        child: Text(
          text,
          style: TextStyle(
              color: Fonts.col_grey,
              fontSize: ScreenUtil().setSp(16),
              fontWeight: FontWeight.w900),
        ));

    Widget text2(String text) => Container(
        padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(28),
            bottom: ScreenUtil().setHeight(21)),
        child: Text(
          text,
          style: TextStyle(
              color: Fonts.col_grey,
              fontSize: ScreenUtil().setSp(12.5),
              fontWeight: FontWeight.w400),
        ));

    return Scaffold(
        bottomNavigationBar: Container(
            padding: EdgeInsets.only(left: 40, right: 40, bottom: 8, top: 4),
            //height: ScreenUtil().setHeight(66),
            //width: ScreenUtil().setWidth(135),
            child: RaisedButton(
              color: choice_category.first_name == ""
                  ? Color(0xffF1F0F5)
                  : Fonts.col_app,
              elevation: 0,
              shape: new RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              onPressed: () {
                if (choice_category.first_name != "" &&
                    choice_category.last_name != "") {
                  print("@@@@@@@@ ${choice_category.first_name}  @@@ ${choice_category.last_name} @@@");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChoiceSeances(widget.user,
                            choice_category, widget.date, widget.batch_id),
                      ));
                } else {
                  Navigator.pop(context, choice_category);

                  // Navigator.pop(context, null);
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Suivant",
                    style: TextStyle(
                        color: choice_category == null
                            ? Color(0xffcccccc)
                            : Colors.white),
                  ),
                ],
              ),
            )
        ),
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
                Image.asset(
                  "images/appointment.png",
                  color: Colors.white,
                  width: 23.5.w,
                  height: 25.5.h,
                ),
                Container(width: 7.w,),
                Padding(
                  padding: const EdgeInsets.only(top: 10,bottom:10),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.54.w,
                    child: Text(
                      "Étudiants",
                      maxLines: 2,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0.sp),
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
                              "images/launcher_icon_ifd.png",
                            )))),
                SizedBox(width: 22.w,),
              ],

            ),
          ),
        ),
        body: load == true
            ?
        PreferredSize(
            child: Container(
                color: Fonts.col_app,
                child:  ClipRRect(
                    borderRadius: BorderRadius.only(topRight : Radius.circular(39.r)),
                    child: Container(
                        color: Colors.white,
                        child :
        Center(
                child: CupertinoActivityIndicator(),
              )
    ))))
            :
        PreferredSize(
            child: Container(
                color: Fonts.col_app,
                child:  ClipRRect(
                    borderRadius: BorderRadius.only(topRight : Radius.circular(39.r)),
                    child: Container(
                        color: Colors.white,
                        child :
        ListView(children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 8.0),
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 8.0),
                  child: TextField(
                    controller: _searchQuery,
                    decoration: InputDecoration(
                        counterStyle: TextStyle(color: Colors.white),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 6.0,
                        ),
                        hintText: '  Chercher un étudiant...',
                        enabledBorder: OutlineInputBorder(
                          // width: 0.0 produces a thin "hairline" border
                          borderSide:
                              BorderSide(color: Colors.grey[600], width: 0.0),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        suffixIcon: Padding(
                          padding: const EdgeInsetsDirectional.only(
                              end: 12.0, start: 12.0),
                          child: Icon(
                            Icons.search,
                            color: Colors.grey[600],
                            size: 30.0,
                          ), // icon is 48px widget.
                        ),
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey[50], width: 0.0),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        filled: true),
                  ),
                ),
                /**
              (!e.first_name || !e.last_name)
              .toLowerCase()
              .contains(_searchText.toLowerCase()) &&
              _searchText.isNotEmpty)
              ? new Container()
              :
           **/
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: cats
                      .map((e) => (!e.first_name
                                      .toLowerCase()
                                      .contains(_searchText.toLowerCase()) &&
                                  _searchText.isNotEmpty) ||
                              (!e.last_name
                                      .toLowerCase()
                                      .contains(_searchText.toLowerCase()) &&
                                  _searchText.isNotEmpty)
                          ? Container()
                          : row_widget(e, click_cat))
                      .toList(),
                ),
                Container(
                  height: 52,
                ),
              ])
    ))))
    );
  }
}
