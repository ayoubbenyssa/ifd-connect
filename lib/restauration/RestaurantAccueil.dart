import 'package:flutter/material.dart';
import 'package:ifdconnect/restauration/all_reservation.dart';
import 'package:ifdconnect/restauration/my_reservations.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/widgets/custom_widgets/buttons_appbar.dart';
import 'filtre_Myreservation.dart';
import 'releve_restauration.dart';
import 'all_reservations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class RestoAccuiel extends StatefulWidget {
  RestoAccuiel(this._userId, this._studentId, this._token);

  final int _userId;
  final int _studentId;
  final int _token;

  @override
  RestoAccuielState createState() => RestoAccuielState();
}

class RestoAccuielState extends State<RestoAccuiel>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  String selectedValue = "Liste des repas";
  int indx = 0;
  List _list = [];

  bool  relve = false ;
  bool tout_repas = true ;
  bool mes_reservation = false ;




  @override
  void initState() {
    super.initState();
    _list = [
      {"name": "Liste des repas"},
      {"name": "Mes réservation"},
      {"name": "Relvé"},
    ];
    tabController = TabController(length: 3, vsync: this);

    print("test date ====${DateTime.fromMillisecondsSinceEpoch(1653562444 * 1000)}");
  }

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
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),

        elevation: 0.0,
        titleSpacing: 0.0,
        toolbarHeight: 110.h ,
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
              // Image.asset(
              //   "images/resturation.png",
              //   color: Colors.white,
              //   width: 23.5.w,
              //   height: 25.5.h,
              // ),              Container(width: 7.w,),
              Padding(
                padding: const EdgeInsets.only(top: 10,bottom:10),
                child: Text(
                  "Restauration",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w100,
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
                  margin: EdgeInsets.symmetric(horizontal: 15.w,vertical: 5.h ),
                      height: 50.0.h,
                      child: ButtonsTabBar(
                        backgroundColor: Fonts.col_app,
                        radius: 42.r,
                        contentPadding: EdgeInsets.all(6.w),
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
         /**   child: ClipRRect(
              borderRadius: BorderRadius.only(topRight : Radius.circular(39.r)),
              child: ColoredTabBar(
                  Colors.white,
                  TabBar(
                      indicatorPadding: EdgeInsets.all(0),
                      labelPadding: EdgeInsets.all(6.r),
                      labelStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16.sp),
                      labelColor: Colors.orange,
                      isScrollable: true,
                      indicatorColor: Colors.red,
                      unselectedLabelColor: Colors.green ,
                      controller: tabController,
                      tabs: <Widget>[
                        Container(
                          width: 140.w,
                          height: 34.h,
                          padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 5.h),
                          // color: Colors.red,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(18.r)),
                            border: Border.all(color: Fonts.col_app_grey,width: 0.5),
                            // color: tout_repas ? Fonts.col_app : Colors.white
                          ),
                          child: Tab(
                            text: 'Liste des repas',
                          ),
                        ),
                        Container(
                          width: 140.w,
                          height: 34.h,
                          padding: EdgeInsets.symmetric(horizontal: 13.w,vertical: 6.h),
                          // color: Colors.red,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(18.r)),
                              border: Border.all(color: Fonts.col_app_grey,width: 0.5),
                              // color: mes_reservation ? Fonts.col_app : Colors.white
                          ),
                          child: Tab(
                            text: 'Mes réservations',
                          ),
                        ),
                        Container(
                          width: 140.w,
                          height: 34.h,
                          padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 5.h),
                          // color: Colors.red,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(18.r)),
                              border: Border.all(color: Fonts.col_app_grey,width: 0.5),
                              // color: relve ? Fonts.col_app : Colors.white
                          ),
                          child: Tab(
                            text: 'Relevé',
                          ),
                        ),
                      ])
              ),
            ),
            */
        //   ),
        // ),
      ),
      body: TabBarView(controller: tabController, children: [
        AllReservations(widget._userId, widget._studentId, widget._token),
        // Filtre_reservation(widget._userId, widget._studentId, widget._token),
        Myreservations(widget._userId, widget._studentId, widget._token),
        ReleveRestauration(widget._userId, widget._studentId, widget._token),
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
