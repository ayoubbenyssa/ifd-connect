import 'package:flutter/material.dart';
import 'package:ifdconnect/campus/etudiant/classPackge/News.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewsDetailPage extends StatefulWidget {
  final New newdetail;
  const NewsDetailPage(this.newdetail);
  @override
  _NewsDetailPageState createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {

  String sub;
  @override
  void initState() {
    sub=widget.newdetail.content.replaceAll('/uploads/Image', 'http://umpo.ml/uploads/Image');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
                ),              Container(width: 7.w,),
                Padding(
                  padding: const EdgeInsets.only(top: 10,bottom:10),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.54.w,
                    child: Text(
                      widget.newdetail.title,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18.0.sp),
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

        body:     Container(
            color: Fonts.col_app,
            child: ClipRRect(
                borderRadius: BorderRadius.only(topRight : Radius.circular(39.r)),

                child: Container(
                    color: Colors.white,child :  ListView(
          children: <Widget>[
            HtmlWidget(sub),
          ],
        )
    )))
    );
  }
}
