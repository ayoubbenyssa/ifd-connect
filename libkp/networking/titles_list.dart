import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ifdconnect/app/repository_home.dart';
import 'package:ifdconnect/models/role.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/networking/filter_by_title.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class TitlesScreen extends StatefulWidget {
  TitlesScreen(this.user);

  User user;

  @override
  _Publish1State createState() => _Publish1State();
}

class _Publish1State extends State<TitlesScreen> {
  List<Role> cats = new List<Role>();
  bool load = true;
  var json = {};
  HomeRepository home_repos = HomeRepository();

  getList() async {
    var a = await home_repos.titles_list();
    if (!this.mounted) return;
    setState(() {
      cats = a;
      load = false;
    });
  }

  Role choice_category;

  click_cat(Role category) {
    if (category.check == false) {
      setState(() {
        for (Role ct in cats) {
          setState(() {
            ct.check = false;
          });
        }
        category.check = true;
        choice_category = category;
      });
    } else
      setState(() {
        category.check = false;
        choice_category = null;
      });
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
        fontSize: ScreenUtil().setSp(e.check == true ? 18 : 18),
        fontWeight: e.check == true ? FontWeight.w800 : FontWeight.w500);

    Widget divid = Container(
      margin: EdgeInsets.only(
        left: ScreenUtil().setWidth(12),
        right: ScreenUtil().setWidth(12),
      ),
      width: MediaQuery.of(context).size.width,
      height: 1,
      color: Fonts.col_grey.withOpacity(0.06),
    );

    Widget row_widget(Role e, onPressed) => Container(
        color: e.check == true ? Fonts.col_app.withOpacity(0.06) : Colors.white,
        child: InkWell(
          child: Column(children: [
            Padding(
                padding: EdgeInsets.only(
                  top: 16,
                  bottom: 16,
                  left: ScreenUtil().setWidth(23),
                  right: ScreenUtil().setWidth(23),
                ),
                child: Row(children: [
                  Container(
                    width: ScreenUtil().setWidth(12),
                  ),
                  Expanded(
                      child: Text(
                    e.name,
                    style: text4(e),
                  )),
                  SvgPicture.asset("assets/icons/arrow.svg"),
                ])),
            divid
          ]),
          onTap: () {
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
                // SvgPicture.asset(
                //   "assets/icons/news.svg",
                //   color: Colors.white,
                //   width: 23.5.w,
                //   height: 25.5.h,
                // ),
                Container(width: 7.w,),
                Padding(
                  padding: const EdgeInsets.only(top: 10,bottom:10),
                  child: Text(
                    "Rôles",
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
        // appBar: AppBar(
        //   title: Text(
        //     "Rôles",
        //     style: TextStyle(color: Colors.white),
        //   ),
        // ),
        body: load == true
            ? Center(
                child: CupertinoActivityIndicator(),
              )
            : ListView(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: cats.map((e) => row_widget(e, click_cat)).toList(),
                ),
                Container(
                  height: ScreenUtil().setHeight(52),
                ),
                Column(children: [
                  Container(
                      height: ScreenUtil().setHeight(46),
                      width: ScreenUtil().setWidth(135),
                      child: RaisedButton(
                        color: choice_category == null
                            ? Color(0xffF1F0F5)
                            : Fonts.col_app,
                        elevation: 0,
                        shape: new RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(28),
                          ),
                        ),
                        onPressed: () {
                          if (choice_category != null) {
                            Navigator.push(context, new MaterialPageRoute(
                                builder: (BuildContext context) {
                              return FilterByTitle(
                                  choice_category, widget.user);
                            }));
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "ENTRER",
                              style: TextStyle(
                                  color: choice_category == null
                                      ? Color(0xffcccccc)
                                      : Colors.white),
                            ),
                          ],
                        ),
                      )),
                ])
              ]));
  }
}
