import 'package:flutter/material.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'Notes_Etudiant.dart';
import 'Absences_Etudiant.dart';
import 'Notes_Etudient_Ratt.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class Absences_Etud extends StatefulWidget {
  Absences_Etud(this.batch,this._userId, this._employeeId, this._token,this._subjectId,this._batchId);
  final String batch;
  final int _userId;
  final int _employeeId;
  final int _token;
  final int _subjectId;
  final int _batchId;
  @override
  Absences_EtudState createState() => Absences_EtudState();
}

class Absences_EtudState extends State<Absences_Etud>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        // backgroundColor: Fonts.col_app,
        // iconTheme: IconThemeData(color: Colors.white),
        // title: Text("${widget.batch}",style: TextStyle(color: Colors.white),),
        // elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.white),
        toolbarHeight: 60.h ,
        elevation: 0.0,

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
                "images/absences.png",
                color: Colors.white,
                width: 23.5.w,
                height: 25.5.h,
              ), Container(width: 7.w,),
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
          child: Container( color: Colors.white, child :
            Column(
              children: [
                Container(
                  height: 60.0.h,
                  margin: EdgeInsets.symmetric(horizontal: 20.w,vertical: 15.h),
                  decoration: BoxDecoration(
                      color: Fonts.col_cl,
                      borderRadius: BorderRadius.all(Radius.circular(29.r)),
                      border: Border.all(color: Fonts.border_col,width: 0.5,style: BorderStyle.solid)
                  ),
                  //Colors.lightGreen,
                  padding: new EdgeInsets.symmetric(horizontal: 16.0.w),
                  alignment: Alignment.centerLeft,
                  child: new Text(
                    "${widget.batch}",
                    style: TextStyle(color: Fonts.col_app_fon, fontSize: 16.sp),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: 10.h,left: 15.w,right: 15.w),
decoration: BoxDecoration(
    // color: Colors.green,
  borderRadius: BorderRadius.all(Radius.circular(22.r)),
  border: Border.all(color: Color(0xff187FB2),width: 0.5.w)
),
                height: MediaQuery.of(context).size.height * 0.72.w
                ,child: Container(
                  // color: Colors.orange,
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(22)),
                        child: Absences(widget._userId , widget._employeeId, widget._token,widget._subjectId,widget._batchId)
                    )
                )
                ),
              ],
            ),
          ),
        ),
      ),
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
