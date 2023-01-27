import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:ifdconnect/func/users_info.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Potique extends StatefulWidget {
  @override
  _Potique_ConditionsState createState() => _Potique_ConditionsState();
}

class _Potique_ConditionsState extends State<Potique> {
  Usernfo user_inf = new Usernfo();
  String text = "";

  get_politiques() async {
    var a = await user_inf.get_politiques();
    setState(() {
      text = a["text"];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_politiques();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.white),
        title: Container(
          padding: const EdgeInsets.only(top: 10,bottom:10),
          color: Fonts.col_app,
          child: Row(
            children: [
              Container(width: 7.w,),
              Padding(
                padding: const EdgeInsets.only(top: 10,bottom:10),
                child: Text(
                  "Politique de confidentialité",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w100,
                      fontSize: 18.0.sp),
                ),
              ),
            ],

          ),
        ),
      ),
      body:
      Container(
          color: Fonts.col_app,
          child: ClipRRect(
              borderRadius: BorderRadius.only(topRight : Radius.circular(39.r)),

              child: Container(
                color: Colors.white,
      child : Column(
        children: [
          Center(
            child: new
            SingleChildScrollView(
              child: new Container(
                padding: new EdgeInsets.all(8.0),
                child: text == ""
                    ? Padding(
                  padding: EdgeInsets.all(16),
                    child: Widgets.load())
                    :HtmlWidget(
              text.toString()
                  .replaceAll(RegExp(r'(\\n)+'), ''),

    )
              ),
            ),
          ),
        ],
      ),
    )))
    );
  }
}
