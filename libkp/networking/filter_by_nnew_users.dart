import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ifdconnect/app/filters_users_bloc/filter_bloc.dart';
import 'package:ifdconnect/app/filters_users_bloc/filter_event.dart';
import 'package:ifdconnect/app/filters_users_bloc/filter_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/networking/user_item.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FilterByNewUsers extends StatefulWidget {
  FilterByNewUsers(this.user);
  User user;
  @override
  _FilterByNewUsersState createState() => _FilterByNewUsersState();
}

class _FilterByNewUsersState extends State<FilterByNewUsers> {

  FilterUsersBloc _filteBloc;

  @override
  void initState() {
    super.initState();



    _filteBloc = BlocProvider.of<FilterUsersBloc>(context);
    _filteBloc.add(FilterUsersquested(type: "newer", user: widget.user));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Fonts.col_cl,
      body: BlocBuilder<FilterUsersBloc, FilterUsersState>(
          builder: (context, homeState) {
        if (homeState is FilterUsersLoadInProgress) {
          return Center(
            child: Padding(
                padding: EdgeInsets.only(top: 64),
                child: CupertinoActivityIndicator()),
          );
        } else if (homeState is FilterUsersLoadSuccess) {
          final users = homeState.calResponse.user;

          print(users);
          return (users.isEmpty)
              ? Center(
                  child: Padding(
                      padding: EdgeInsets.only(top: 64),
                      child: Text("Aucun utilisateur trouvé !")),
                )
              : ListView(children: users.map((e) => UserItem(e,widget.user,"newer")).toList());
        } else {
          return Container();
        }
      }),
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
                  "Nouveaux utilisateurs",
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
      // appBar: new AppBar(
      //   title: new Text(
      //     "Nouveaux utilisateurs",
      //     style: TextStyle(fontSize: 18.0, color: Colors.white),
      //   ),
      // ),
    );
  }
}
