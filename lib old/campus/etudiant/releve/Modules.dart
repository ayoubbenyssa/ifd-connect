import 'package:ifdconnect/services/Fonts.dart';
import 'package:flutter/material.dart';
import 'package:ifdconnect/widgets/custom_widgets/buttons_appbar.dart';
import 'ListModule1.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class MyHomePageNote extends StatefulWidget {
  MyHomePageNote(this.title, this._userId, this._studentId, this._token);

  final String title;
  final int _userId;
  final int _studentId;
  final int _token;

  @override
  MyHomePageNoteState createState() => MyHomePageNoteState();
}

class MyHomePageNoteState extends State<MyHomePageNote>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  List _list = [];
  String selectedValue = "Semestre 1";
  int indx = 0;


  ld(i) {
    setState(() {
      selectedValue = _list[i]["name"];
    });
    //com = value;
    // Reload();
  }

  st(i) {
    setState(() {
      indx = i;
    });
    ld(i);
  }

  @override
  void initState() {
    super.initState();
    _list = [
      {"name": "Semestre 1"},
      {"name": "Semestre 2"},
    ];
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          toolbarHeight: 110.h ,
          elevation: 0.0,

          // iconTheme: IconThemeData(color: Fonts.col_app),
          // titleSpacing: double.infinity,
          titleSpacing: 0,
          backgroundColor: Colors.white,
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
                  "images/modul.png",
                  color: Colors.white,
                  width: 23.5.w,
                  height: 25.5.h,
                ), Container(width: 7.w,),
                Padding(
                  padding: const EdgeInsets.only(top: 10,bottom:10),
                  child: Text(
                    "Modules",
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
            bottom: PreferredSize(
                child: Container(
                    color: Fonts.col_app,
                    padding: EdgeInsets.all(0),
                    margin: EdgeInsets.all(0),
                    child :  ClipRRect(
                      borderRadius: BorderRadius.only(topRight : Radius.circular(39.r)),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 1.w,
                        color: Colors.white,
                        child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 8.w,vertical: 5.h ),
                            // padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 5.h ),

                            height: 50.0.h,
                            // color: Colors.red,

                            child: ButtonsTabBar(

                              backgroundColor: Fonts.col_app,
                              radius: 42.r,
                              contentPadding: EdgeInsets.symmetric(horizontal: 30.w,vertical: 5.h ),
                              borderWidth: 1.0,
                              controller: tabController,
                              borderColor: Fonts.col_app,
                              unselectedBorderColor: Fonts.col_app_fon,
                              unselectedBackgroundColor: Colors.white,
                              unselectedLabelStyle:
                              TextStyle(color: Fonts.col_app_fon, fontSize: 16.sp),
                              labelStyle: TextStyle(
                                  fontSize: 16.0.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              onPressed: st,
                              tabs: _list.map((a) => new
                              Tab(text: a["name"])).toList(),
                            )),
                      ),
                    )
                ))
        ),
      body: TabBarView(controller: tabController, children: [
        ListModule(widget._userId, widget._studentId, widget._token, 1),
        ListModule(widget._userId, widget._studentId, widget._token, 2),
      ]),

    );
  }
}

class ColoredTabBar extends Container implements PreferredSizeWidget {
  ColoredTabBar(this.color, this.tabBar);

  final Color color;
  final TabBar tabBar;

  @override
  Size get preferredSize => tabBar.preferredSize;

  @override
  Widget build(BuildContext context) => Container(
        color: color,
        child: tabBar,
      );
}
