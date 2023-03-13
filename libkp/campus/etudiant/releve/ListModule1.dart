import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ifdconnect/campus/etudiant/classPackge/ListMarques.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'DetailPage1.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ListModule extends StatefulWidget {
  final int _userId;
  final int _studentId;
  final int _token;
  final int _semestre;

  const ListModule(this._userId, this._studentId, this._token, this._semestre);

  @override
  _ListModuleState createState() => _ListModuleState();
}

class _ListModuleState extends State<ListModule> {
  ListMarques marques;
  bool loading = true;
  final Random _random = Random();

  /*

  _semestre
   */
  _getModules(int userid, int studentid, int token) async {
    final param = {
      "user_id": "$userid",
      "student_id": "$studentid",
      "auth_token": "$token",
    };
    print("----****************");

    print(widget._semestre);
    print("-----****************");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = await http.post("${prefs.getString('api_url')}/releve", body: param);

    print(data.body);

    var jsonData = json.decode(data.body);
    setState(() {
      marques = new ListMarques.fromJson(jsonData["marques"]);
      loading = false;
    });
  }

  Widget _buildModuleItem(BuildContext context, int index) {
    return marques.marques[index].semestre == widget._semestre
        ? Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        // semanticContainer: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0.r),
        ),
        elevation: 1.0,
        color: Colors.white,
        margin: new EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 6.0.h),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
            color: Fonts.col_cl,
          ),
          child: ListTile(
            contentPadding:
            EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 10.0.h),
            title:
            Row(children: <Widget>[

              Column(
                //mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  Row(
                    children: [
                      Container(
                        // color: Colors.red,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.70.w,
                        child:
                        Text(
                          marques.marques[index].modules[0].name,
                          style: TextStyle(color: Fonts.col_app_fon, fontWeight: FontWeight.bold,fontSize: 15.sp),
                        ),
                      ),

                      // Expanded(child: Container()),

                      Icon(Icons.arrow_right,
                          color: Fonts.col_app_fonn, size: 40.0.r),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.70.w,
                          padding: EdgeInsets.only(top: 4.0.h),
                          child: Text(
                            "La moyenne générale : ${marques.marques[index]
                                .modules[0].haverage == "NC" ? "NC" : format(
                                double.parse(marques.marques[index].modules[0]
                                    .haverage))
                            }",
                            style: TextStyle(
                                color:
                                    double.parse(marques.marques[index].modules[0]
                                        .haverage) < 10 ? Fonts.col_app_red : Fonts.col_green ,

                                fontWeight: FontWeight.w500,fontSize: 16.sp),


                          )),
                      // Expanded(child: Container()),

                      Container(alignment: Alignment.centerRight, child: validation(marques.marques[index].modules[0].decision))


                    ],
                  ),
                ],),



            ],),

            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DetailPage(marques.marques[index].modules[0])));
            },
          ),
        ))
        : Container();
  }

  Widget _buildModuleList() {
    Widget moduleItems;

    print("jiiiii");
    print(marques.marques.length);

    if (marques.marques.length > 0) {
      moduleItems = Container(
        color: Colors.white,
        child: ListView.builder(
          itemBuilder: _buildModuleItem,
          itemCount: marques.marques.length,
        ),
      );
    } else {
      /*

          else if(snapshot.data.length==0)
              return Center(child: Text("Aucun résultat trouvé",style: TextStyle(color: Colors.black),),);

       */
      moduleItems = Center(child: Text("Aucun résultat trouvé"),);
    }
    return moduleItems;
  }

  @override
  void initState() {
    _getModules(widget._userId, widget._studentId, widget._token);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: loading
            ? Center(child: CircularProgressIndicator())
            : Column(
          children: <Widget>[
            Expanded(
              child: _buildModuleList(),
            )
          ],
        ));
  }

  Widget validation(decision) {
      return Container(
        width: 33.w,height: 33.h,
        decoration: BoxDecoration(
          border: Border.all(color: Fonts.col_app_fonn , width: 1.w),
          borderRadius: BorderRadius.all(Radius.circular(10.r))
        ),
        child: Center(child: Text(decision,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.sp,color: Fonts.col_app_fonn),)),
      );
  }

  String format(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
  }
}
