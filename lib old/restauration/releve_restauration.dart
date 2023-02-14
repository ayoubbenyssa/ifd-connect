import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ifdconnect/config/config.dart';
import 'package:ifdconnect/models/relve.dart';
import 'package:ifdconnect/services/Fonts.dart';


class ReleveRestauration extends StatefulWidget {
  ReleveRestauration(this._userId, this._studentId, this._token);

  final int _userId;
  final int _studentId;
  final int _token;

  @override
  _ReleveRestaurationState createState() => _ReleveRestaurationState();
}

class _ReleveRestaurationState extends State<ReleveRestauration> {
  var data;
  var cancel;
  var reserve;
  var active;
  bool loading = true;
  var refills;
  var js = {};

  Relve  relve = Relve();

  Future<http.Response> getReleve(
      int user_id, int student_id, int token) async {
    final param = {
      "user_id": "$user_id",
      "student_id": "$student_id",
      "auth_token": "$token",
    };



    final releveData = await http.post(
      "${Config.url_api}/resto_releve",
      body: param,
    );
    setState(() {
      data = json.decode(releveData.body);
    });
    return releveData;
  }

  List test = [];
  var cancelOperations = new SplayTreeMap<String, Map>();
  var reserveOperations = new SplayTreeMap<String, Map>();
  var allData = new SplayTreeMap<String, Map>();
  List keyList = [];
  var keyListReverse;
  int i=0;

  getData() {
    //cansel = res
    if (data["result"]["cancelled"] != null) {
      cancel = data["result"]["cancelled"];
    }

    if (data["result"]["res"] != null) {
      reserve = data["result"]["active"];
    }
    // print("  print(a.runtimeType);");
    // print(cancel);
    // print(cancel == reserve ? " yes" : "no" );
    //
    // print(reserve);
    //
    // print("  print(a.runtimeType);");



    if (data["result"]["refills"] != null) {
      refills = data["result"]["refills"];
    }

    if (data["result"]["active"] != null) {
      active = data["result"]["active"];
    }

    if (data["result"]["cancelled"] != null) {
      for (var k in cancel.keys) {
        // print(_formaterDate1("${active[k]["created_at"]}$k"));
        cancel[k]["operation"] = "Annulation";
cancelOperations["${cancel[k]["operation_date"]}$k"] = cancel[k];
      }
    }

print("*********** ${data["result"]["res"]} **************");

    print("*********** ${data["result"]} **************");

    if (data["result"]["res"].isNotEmpty ) {
    //
      print("+++++===+++====+++++====");
      for (var k in reserve.keys) {
        reserve[k]["operation"] = "Réservation";
        reserveOperations["${reserve[k]["created_at"]}$k"] = reserve[k];
      }
    }

    if (data["result"]["refills"] != null) {

      //refills = data["result"]["refills"][0];
      for (var i in refills) {
        var key = "resto_refill";
        i["resto_refill"]["operation"] = "Recharge";
        reserveOperations["${i["resto_refill"]["created_at"]}$key"] =
        i["resto_refill"];
      }
//{received: null, id: 7, updated_at: 2019-06-17T10:16:01Z, student_id: 1500, returned: null, amount: 150.0, created_at: 2019-06-17T10:16:01Z, operation: Recharge}
      //2019-06-17T10:16:01Zresto_refill

    }

    if (data["result"]["active"] != null) {
      for (var key in active.keys) {

        // print(_formaterDate1("${active[key]["created_at"]}$key"));

        active[key]["operation"] = "Réservation";
        reserveOperations["${active[key]["created_at"]}$key"] = active[key];
      }
    }

    for (var k1 in reserveOperations.keys) {
      allData[k1]= reserveOperations[k1];
      var k2 = reserveOperations.keys.elementAt(i);

      if(reserveOperations[k1]["price"] != null) {

        if(_formaterDate1(k1) == _formaterDate1(k2)){

          setState(() {
            js[_formaterDate1(k1)+"_plus"]= js[_formaterDate1(k1)+"_plus"].toString()=="null"?0:reserveOperations[k1]["price"]+js[_formaterDate1(k1)+"_plus"];

          });

        }
        else {
          print("noooo");
        }
        i++;
      }
    }


    /*js{
      "10/01/2019":a
    };*/

    for (var k2 in cancelOperations.keys) {
      allData[k2] = cancelOperations[k2];
    }

    for (var k in allData.keys) {
      keyList.add(k);
    }
    Iterable inReverse = keyList.reversed;
    keyListReverse = inReverse.toList();

    setState(() {
      loading = false;
    });

  }

  @override
  void initState() {
    getReleve(widget._userId, widget._studentId, widget._token).then((_) {
      getData();
    });
    super.initState();
  }

  String _formatDate(String date) {
    String day = DateTime.parse(date).day.toString();
    String month = DateTime.parse(date).month.toString();
    String year = DateTime.parse(date).year.toString();
    String m = int.parse(month) < 10 ? "0$month" : "$month";
    String d = int.parse(day) < 10 ? "0$day" : "$day";

    return "$d/$m/$year";
  }

  String _formaterDate1(String dateTime) {
    String date = _formatDate(dateTime.split("T")[0]);
    String part2 = dateTime.split("T")[1];
    return date;
  }

  String _formaterDate2(String dateTime) {
    // print("&&&&&&&&&&&&&&&&&&&");
    // print(dateTime);
    String date = _formatDate(dateTime.split("T")[0]);
    String part2 = dateTime.split("T")[1];
    String time = part2.split("Z")[0];
    String time2 = time.split(":")[0]+":"+time.split(":")[1];


    return "$time2";
  }

  @override
  Widget build(BuildContext context) {
    var st = new TextStyle(
        color: Colors.blueAccent,
        fontSize: 14,
        fontWeight: FontWeight.bold
    );
    return loading
        ? Center(
      child: CircularProgressIndicator(),
    )
        : Scaffold(
        appBar: AppBar(
elevation: 0.0,
          backgroundColor:
          // data["sold"] < 10.0 ? Colors.red[200] : Colors.green[500],
          Colors.white ,
          automaticallyImplyLeading: false,
          title: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w ,vertical: 8.h ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(26.r)),
              border: Border.all(color: Fonts.border_col, width: 1.r),
            ),


            child: Center(
              child: Row(
                children: [
                  Container(
                    child: Icon(Icons.money , color: Fonts.col_app_fon ,size: 20.r ,),
                  ),
                  Container(width: 6.w,),
                  Container(
                    child: Text(
                      "Votre solde actuel  :",
                      style: TextStyle(fontSize: 16.0.sp, color: Fonts.col_app_fon,fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(width: 8.w,),
                  Container(
                    child: Text(
                      "${data["sold"]} DHS",
                      style: TextStyle(fontSize: 16.0.sp, color: data["sold"] < 10.0 ? Fonts.col_app_red : Fonts.col_green,fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: ListView.builder(
            padding: EdgeInsets.all(0.0),
            itemCount: allData.length,
            itemBuilder: (context, index) {
              // print("########################");
              // print('test ${keyListReverse[index].split("T")[0]}');
              // print("index == ${index}");
              relve.fromDoc(allData[keyListReverse[index]]);
              // print(relve.day);
              // print("########################");
              return Container(
                decoration: BoxDecoration(

                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      index == 0
                          ?
                      Container(
                        // color: Color(0xffFAFAFA),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Row(children: [
                                Container(
                                  width: 18.w,
                                ),
                                Image.asset(
                                  "images/appointment.png",
                                  color: Fonts.col_app_fon,
                                  width: 15.5.w,
                                  height: 17.5.h,
                                ),
                                Container(
                                  width: 10.0.w,
                                ),

                                Container(
                                  child: new Text(
                                    _formaterDate1(keyListReverse[index]),
                                    style:
                                    TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp,
                                        fontFamily: "Helvetica",
                                        color:  Fonts.col_app_fon
                                    ),
                                  ),
                                ),
                              ],
                              ),),
                            Expanded(child: Container()),
                            InkWell(
                              child: Container(
                                child:
                                Icon(
                                  // val.more_dtaills ?
                                  // Icons.arrow_drop_up_outlined
                                    // :
                                Icons.arrow_drop_down,
                                  size: 30.r,color: Fonts.col_app_fonn,),
                              ),
                              // onTap: (){
                              //   setState(() {
                              //     if(val.more_dtaills == true){
                              //       val.more_dtaills = false ;
                              //       print(val.more_dtaills);
                              //     } else{
                              //       val.more_dtaills = true ;
                              //       print(val.more_dtaills);
                              //
                              //     }
                              //   });
                              // },
                            )

                          ],
                        ),
                      )

                          : _formaterDate1(keyListReverse[index]) == _formaterDate1(keyListReverse[index - 1])
                          ? Container()
                          :Container(
                        // color: Color(0xffFAFAFA),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Row(children: [
                                Container(
                                  width: 18.w,
                                ),
                                Image.asset(
                                  "images/appointment.png",
                                  color: Fonts.col_app_fon,
                                  width: 15.5.w,
                                  height: 17.5.h,
                                ),
                                Container(
                                  width: 10.0.w,
                                ),

                                Container(
                                  child: new Text(
                                    _formaterDate1(keyListReverse[index]),
                                    style:
                                    TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp,
                                        fontFamily: "Helvetica",
                                        color:  Fonts.col_app_fon
                                    ),
                                  ),
                                ),
                              ],
                              ),),
                            Expanded(child: Container()),
                            InkWell(
                              child: Container(
                                child:
                                Icon(
                                  // val.more_dtaills ?
                                  // Icons.arrow_drop_up_outlined
                                  // :
                                  Icons.arrow_drop_down,
                                  size: 30.r,color: Fonts.col_app_fonn,),
                              ),
                              // onTap: (){
                              //   setState(() {
                              //     if(val.more_dtaills == true){
                              //       val.more_dtaills = false ;
                              //       print(val.more_dtaills);
                              //     } else{
                              //       val.more_dtaills = true ;
                              //       print(val.more_dtaills);
                              //
                              //     }
                              //   });
                              // },
                            )

                          ],
                        ),
                      ),


                      Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          color: Colors.red,
                          semanticContainer: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          elevation: 1.0,
                          margin: new EdgeInsets.symmetric(
                              horizontal: 4.0, vertical: 4.0),
                          child: Container(
                            decoration: BoxDecoration(
                              // border: Border(
                              //   left: BorderSide(
                              //       width: 6.0,
                              //       color: allData[keyListReverse[index]]
                              //       ["operation"] ==
                              //           'Réservation'
                              //           ? Colors.green
                              //           : allData[keyListReverse[index]]["operation"] ==
                              //           'Recharge'
                              //           ? Colors.blueAccent
                              //           : Colors.redAccent),
                              // ),
                            ),
                            child: Container(
                              padding: EdgeInsets.only(left: 30.w ),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Container(
              // width: MediaQuery.of(context)
              //     .size
              //     .width *
              //     0.59,
              child: Text(
              relve.operation == 'Recharge'
              ? relve.operation
                  : "${relve.operation} d'un ${relve.mean}",
              style: TextStyle(
              fontSize: 18.sp,
              color: Fonts.col_app_grey,
              fontWeight: FontWeight.w500)),
              ),
                Container(height: 6.h,),
                Container(
              child: Row(
              children: [
                Container(
              child: Row(
              children: [
                Container(
              child: Icon(Icons.lock_clock ,size: 15.r,color: Fonts.col_app_grey,),
              ),
              Container(width: 7.5.w ,),
              Container(
              padding: EdgeInsets.only(top: 4.0),
              child: Text(
              "${_formaterDate2(keyListReverse[index])}",
              style: TextStyle(fontSize: 12.0.sp,color: Fonts.col_app_grey),
              ),
              ),
              ],
              ),
              ),
              Container(width: 11.w ,),

              Container(
              child:
              Row(
              children: [
                Container(
              child: Icon(Icons.wallet_giftcard,size: 14.r,color: Fonts.col_app_fon,),
              ),
              Container(width: 7.5.w,),
              Container(
              child:
              relve.operation == 'Recharge'
              ? Text(
              "+${relve.amount} DHS",
                style: TextStyle(color: Fonts.col_app_fonn,fontSize: 14.sp,fontWeight: FontWeight.bold),
              )
                  : relve.operation ==
              'Réservation'
              ? Text(
              "-${relve.price} DHS",
              style: TextStyle(color: Fonts.col_app_red,fontSize: 14.sp,fontWeight: FontWeight.bold),
              )
                  : Text(
              "+${relve.price} DHS",
              style:
              TextStyle(color: Fonts.col_green,fontSize: 14.sp,fontWeight: FontWeight.bold)
              ),

              )

              ],
              ),
              )

              ],
              ),
              ),
                Container(height: 10.h,)
              ],
              ),
              )

                          )
                      ),
                    ]
                ),
              );
            }
            )
    );
  }
}
