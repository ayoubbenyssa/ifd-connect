import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/reclamation/provider/reclamation_provider.dart';
import 'package:ifdconnect/reclamation/widgets/chat_item.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:provider/provider.dart';

class ReclamationsList extends StatefulWidget {
  ReclamationsList(this.user, {Key key}) : super(key: key);
  User user;

  @override
  _ReclamationsListState createState() => _ReclamationsListState();
}

class _ReclamationsListState extends State<ReclamationsList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ReclamationProvider(context,widget.user),
        builder: (context, __) {
          final provider = context.watch<ReclamationProvider>();

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
                      // ),              Container(width: 7.w,),
                      Padding(
                        padding: const EdgeInsets.only(top: 10,bottom:10),
                        child: Text(
                          "Reclamations",
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
              body:

              provider.load
                  ? Container(
                  color: Fonts.col_app,
                  child: ClipRRect(
                      borderRadius: BorderRadius.only(topRight : Radius.circular(39.r)),

                      child: Container(
                          color: Colors.white,child : Center(child: CupertinoActivityIndicator()))))

                  :
              provider.reclamations.isEmpty
                      ? Center(child: Text("Aucune reclamation trouvée !"))
                      : Container(
                       color: Fonts.col_app,

                       child: ClipRRect(
                borderRadius: BorderRadius.only(topRight : Radius.circular(39.r)),

                child: Container(
                color: Colors.white,
                            child: ListView(
                                padding: EdgeInsets.all(8),
                                children: provider.reclamations
                                    .map((e) => Container(
                                        padding: EdgeInsets.all(4.0),

                                        // key: new ValueKey<String>(widget.snapshot.key),
                                        child: new Material(
                                            color: Colors.white,
                                            elevation: 0.0,
                                            borderRadius:
                                                new BorderRadius.circular(10.0),
                                            shadowColor: Colors.grey[300],
                                            child: ChatItem(e, widget.user))))
                                    .toList(),
                              ),
                          ),
                        ),
                      ));
        });
  }
}
