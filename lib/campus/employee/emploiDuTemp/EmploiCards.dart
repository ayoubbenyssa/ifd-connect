import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ifdconnect/campus/employee/emploiDuTemp/postpone_Sessions.dart';
import 'package:ifdconnect/config/config.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class EmploiCards extends StatefulWidget {
  final emploiDuJour;
  final params;


  EmploiCards(this.emploiDuJour,this.params);
  @override
  _EmploiCardsState createState() => _EmploiCardsState();
}


class _EmploiCardsState extends State<EmploiCards> {

  final Random _random = Random();
  List<String> time;



  Future getDecisionsList(String tte_id) async {
    Map param = widget.params;
    param["tte_id"] = tte_id;

    var decisionsList = await http.post(
      "${Config.url_api}/select_decision",
      body: param,
    );
    var data = jsonDecode(decisionsList.body);
    print('data');
    print(data);
    return data['ttes'];
  }
  Future sendDecision(String tte_id, String tte_id_reporte) async {
    final params = widget.params;
    Map param = {
      "user_id": params["user_id"],
      "employee_id": params["employee_id"],
      "auth_token": params["auth_token"],
      "tte_id": tte_id,
      "tte_id_reporte": tte_id_reporte,
      // "batch_id": "$batch_id",
    };

    var data = await http.post(
        "${Config.url_api}/valid_decision",
        body: json.encode(param),
        headers: {
          'Content-Type': 'application/json',
        }
    );
    data = jsonDecode(data.body);
    print(data);
    return data;
  }

  Widget _buildTimeItem(BuildContext context, int index) {
    // List<String> time = widget.emploiDuJour.keys.toList();


    print(widget.emploiDuJour.keys.toList());
    print(time);


    return widget.emploiDuJour[time[index]] != null
        ? InkWell(
      onLongPress: (){
        return  showDialog<String>(
            context: context,
            builder: (BuildContext context) {
              return new AlertDialog(
                title: const Text(''),
                content: const Text(
                    'Voulez vous reporter cette séance ?'),
                actions: <Widget>[
                  new FlatButton(
                      child: const Text('Oui'),
                      onPressed: () async{
                        final sessions = await getDecisionsList(widget.emploiDuJour[time[index]]["tte_id"].toString());
                        Navigator.of(context,rootNavigator: true).pop('dialog');
                        if (sessions!=null) {
                          Map params = widget.params;
                          params['tte_id']=widget.emploiDuJour[time[index]]["tte_id"].toString();
                          await Navigator.push(context,MaterialPageRoute(builder: (context) => PostponeSession(sessions,params)));
                          print('returned');
                        }
                      }),
                  new FlatButton(
                    child: const Text('Non'),
                    onPressed: () {
                      Navigator.of(context,rootNavigator: true).pop('dialog');
                    },
                  ),
                ],
              );
            });
      },
      child: Card(

          clipBehavior: Clip.antiAliasWithSaveLayer,
          semanticContainer: true,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),side: BorderSide(width: 0.1,style: BorderStyle.solid)
          ),
          elevation: 1.0,
          margin: new EdgeInsets.symmetric(horizontal: 15.0.w, vertical: 10.0.h),
          child: Container(
            decoration: BoxDecoration(
              color: Fonts.col_cl,
              border: Border.all(color: Fonts.border_col, width: 0.5.w),
            ),              child: ListTile(
            contentPadding: EdgeInsets.all(0.0),

            //contentPadding:
            // EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            leading: Container(
              padding: EdgeInsets.only(left:8.0,right: 8),
              decoration: new BoxDecoration(
                //  color:  const Color(0xffe4f1fd),
                  border: new Border(
                      right: new BorderSide(
                          width: 1.0, color: Colors.black12))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    " ${formatTimeString(widget.emploiDuJour[time[index]]["time_t"])[0]}",
                    style: TextStyle(color: Fonts.col_grey ,fontSize: 12.sp,fontWeight: FontWeight.w100),
                  ),
                  SizedBox(height: 4.h,),
                  Icon(Icons.lock_clock,size: 15.r,color: Colors.grey,),
                  SizedBox(height: 4.h,),
                  Text(
                      "${formatTimeString(widget.emploiDuJour[time[index]]["time_t"])[1]}",
                      style: TextStyle(color: Fonts.col_grey ,fontSize: 12.sp,fontWeight: FontWeight.w100),
                    ),
                ],
              ),
            ),
            title: Text(
              "${widget.emploiDuJour[time[index]]["subject"]}",
              style: TextStyle(
                  color: Fonts.col_app_fonn, fontWeight: FontWeight.bold,fontSize: 12.sp),
            ),
            subtitle: Row(
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                        "Classe : ${widget.emploiDuJour[time[index]]["batch"]}",
                    style: TextStyle(color: Fonts.col_grey, fontSize: 12.sp ,fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
          )),
    )
        : Container(child: Text(""));
  }

  Widget _buildTimeList(len) {

    Widget timeCards;
    if (widget.emploiDuJour.length > 0) {
      timeCards = ListView.builder(
        itemBuilder: _buildTimeItem,
        itemCount:len,
      );
    } else {
      timeCards = Container();
    }
    return timeCards;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    time = widget.emploiDuJour.keys.toList();
    for(String t in time){
      time.sort((a, b) {
        return a.compareTo(b.toLowerCase());
      });
    }
    // widget.emploiDuJour.forEach((k,v){
    //
    //   time.add(k);
    //   time.sort((a, b) {
    //     return a.compareTo(b.toLowerCase());
    //   });
    //
    // });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              child: _buildTimeList(widget.emploiDuJour.keys.toList().length),
            )
          ],
        ));
  }

  List formatTimeString(String string) {
    var st;
    st = string.split("-");
    return st;
  }
}
