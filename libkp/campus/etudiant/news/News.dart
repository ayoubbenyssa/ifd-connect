import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ifdconnect/campus/etudiant/classPackge/News.dart';
import 'package:http/http.dart' as http;
import 'package:ifdconnect/services/Fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import './NewsDetail.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class NewsPage extends StatefulWidget {
  final int _userId;
  final int _studentId;
  final int _token;
  final int _employeeId;

  NewsPage(this._userId, this._studentId, this._token, this._employeeId);
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  ListNews news;
  var data;
  String sub;
  bool loading = true;
  String message = "";

  final Random _random = Random();


  Future<http.Response> getNews(int user_id, int student_id, int token, int employee_id) async {
    final param = {
      "user_id": "$user_id",
      "student_id": "$student_id",
      "auth_token": "$token",
      "employee_id": "$employee_id"
    };


    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("&&&&&&&&&&&& ${prefs.getString('api_url')}");

    final absenceData = await http.post(
      "${prefs.getString('api_url')}/news",
      body: param,
    );
    setState(() {
      data = json.decode(absenceData.body);
      news = new ListNews.fromJson(data["student"]);
      loading = false;
    });
    return absenceData;
  }

  Widget _buildNewsItem(BuildContext context, int index) {
    return Card(

        clipBehavior: Clip.antiAliasWithSaveLayer,
        semanticContainer: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22.0.r),
          side: BorderSide(
            color: Fonts.col_app_fon,
            width: 1.0.w,
          ),        ),
        elevation: 0.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 6.0.h),
        child: Container(
          decoration: BoxDecoration(
            color: Fonts.col_cl,
          ),
          child: ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 10.0.h),
            leading: Container(
              padding: EdgeInsets.only(right: 16.0),
              decoration: new BoxDecoration(
                  border: new Border(
                      right:
                          new BorderSide(width: 1.0, color: Colors.black12))),
              child: Icon(Icons.account_circle,size: 50,)
            ),
            title: Text(
              news.newToos[index].newToo.title,
              style:
                  TextStyle(color: Fonts.col_grey, fontWeight: FontWeight.bold,fontSize: 15.sp),
            ),
            trailing: Text(
              "Détail...",
              style: TextStyle(
                  color: Fonts.col_app,fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline),
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Container(
                  //  padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                        "Crée le : ${_formatDate(news.newToos[index].newToo.created_at)}",
                      style:
                      TextStyle(color: Fonts.col_grey, fontWeight: FontWeight.w500,fontSize: 13.sp),
                    ),
                  ),
                )
              ],
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          NewsDetailPage(news.newToos[index].newToo)));
            },
          ),
        ));
  }

  Widget _buildNewsList() {
    Widget moduleItems;
    if (news.newToos.length > 0) {
      moduleItems = ListView.builder(
        itemBuilder: _buildNewsItem,
        itemCount: news.newToos.length,
      );
    } else {
      moduleItems = Container();
    }
    return moduleItems;
  }

  @override
  void initState() {
    getNews(widget._userId, widget._studentId, widget._token, widget._employeeId);
    super.initState();
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
              SvgPicture.asset(
                "assets/icons/news.svg",
                color: Colors.white,
                width: 23.5.w,
                height: 25.5.h,
              ),              Container(width: 7.w,),
              Padding(
                padding: const EdgeInsets.only(top: 10,bottom:10),
                child: Text(
                  "News",
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
        body: loading
            ?   Container(
            color: Fonts.col_app,
            child: ClipRRect(
                borderRadius: BorderRadius.only(topRight : Radius.circular(39.r)),

                child: Container(
                    color: Colors.white,child : Center(child: CircularProgressIndicator()))))
            :
        Container(
            color: Fonts.col_app,
            child: ClipRRect(
                borderRadius: BorderRadius.only(topRight : Radius.circular(39.r)),

                child: Container(
                    color: Colors.white,
        child : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 15.h,),
                  Expanded(
                    child: _buildNewsList(),
                  )
                ],
              )
    )))
    );
  }

  String _formatDate(String date) {
    String day = DateTime.parse(date).day.toString();
    String month = DateTime.parse(date).month.toString();
    String year = DateTime.parse(date).year.toString();
    String m = int.parse(month) < 10 ? "0$month" : "$month";

    return "$day/$m/$year";
  }
}
/*Image.asset(
                "assets/images/newspaper.png",
                height: 35.0,
                width: 35.0,
              ),*/