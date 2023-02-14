import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ifdconnect/config/config.dart';
//import 'package:ifdconnect/campus/shared/fixdropdown.dart';
import 'package:ifdconnect/models/MealList.dart';
import 'package:ifdconnect/models/Mealcal.dart';
import 'package:ifdconnect/models/type_composant.dart';
import 'package:ifdconnect/models/type_ropa.dart';
import 'package:ifdconnect/restauration/servcies/localstorage_services.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:intl/intl.dart';
import 'package:ifdconnect/models/meal.dart';
import 'package:ifdconnect/restauration/Resto.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sticky_headers/sticky_headers.dart';

class AllReservations extends StatefulWidget {
  final int _userId;
  final int _studentId;
  final int _token;

  AllReservations(this._userId, this._studentId, this._token);

  @override
  _MesReservationState createState() => _MesReservationState();
}

class _MesReservationState extends State<AllReservations> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var reservationData;
  var annulationData;
  var dataDay;
  var data;
  List meals = [];
  List listmeals = [];
  bool loading = true;
  String date;
  bool check_all = false;
  var date_deb = DateFormat('yyyy-MM-dd')
      .format(new DateTime.now().add(new Duration(days: 0)));
  var date_fin = DateFormat('yyyy-MM-dd')
      .format(new DateTime.now().add(new Duration(days: 2)));
  String name_repas = "Tout";
  var mealsmap = new SplayTreeMap<String, Object>();
  List<int> mealsTrue = [];
  int index = 1;
  List listKey = [];
  List<Meal> _list = [];
  SlidableController ctrl;
  int i = 0;
  List<int> tikeckids = [];
  Key keys;
  bool test22 = false ;

  LocalStorageServices storage = LocalStorageServices();
  String _tableName = "meals";
  String _tableName1 = "allmeals";

  List<MealCal> mealCal =[];
  var composants_id;
  List Extra;
  List composont ;
  var dataMap;
  var data0;
  var data0TimeInterval;
  List dates = [];



  List mealcal =[
    {"MealCal"  : ""},
    {"extra" : []},
    {"composants" : []},
  ] ;




  //fonction pour adapter format d'affichage d'une date
  String _formatDate(String date) {
    String day = DateTime.parse(date).day.toString();
    String month = DateTime.parse(date).month.toString();
    String year = DateTime.parse(date).year.toString();
    String m = int.parse(month) < 10 ? "0$month" : "$month";
    String d = int.parse(day) < 10 ? "0$day" : "$day";

    return "$d/$m/$year";
  }

  //service pour annuler un repas
  Future<http.Response> makeCancel(
      int user_id, int student_id, int token, String ticketId) async {
    setState(() {
      loading = true;
    });
    final param = {
      "user_id": "$user_id",
      "student_id": "$student_id",
      "auth_token": "$token",
      "tickets_ids": "$ticketId"
    };

    final reservationsData = await http.post(
      "${Config.url_api}/make_cancellation",
      body: param,
    );
    setState(() {
      data = json.decode(reservationsData.body);
      annulationData = data;
      loading = false;

    });

    return reservationsData;
  }

  Future<List<Meal>> get_meals(int user_id, int student_id, int token) async {
    // final param = {
    //   "user_id": "$user_id",
    //   "student_id": "$student_id",
    //   "auth_token": "$token",
    // };
    // final reservationsData = await http.post(
    //   "${Config.url_api}/meals",
    //   body: param,
    // );
    // List list = [];
    // if (this.mounted) {
    //   setState(() {
    //     list = json.decode(reservationsData.body)["meals"];
    //   });
    // }
    // return list.map((contactRaw) => new Meal.fromDoc(contactRaw)).toList();

    final resStorage = await _fetchAllMealsFromSharedPreferences();
    print("^^^^^^^^^^1 get_meals");

    if (resStorage != null) {
      print("^^^^^^^^^^2 get_meals");

      List list = json.decode(resStorage);
      return list.map((contactRaw) => new Meal.fromDoc(contactRaw)).toList();
    } else {
      print("^^^^^^^^^^3 get_meals");

      return await get_meals_fromapi(user_id, student_id, token);

    }
  }

  Future<List<Meal>> get_meals_fromapi(
      int user_id, int student_id, int token) async {
    final param = {
      "user_id": "$user_id",
      "student_id": "$student_id",
      "auth_token": "$token",
    };
    final reservationsData = await http.post(
      "${Config.url_api}/meals",
      body: param,
    );

    List list = [];


    await storage.saveDataToSharedPrefrences(
      data: json.encode(json.decode(reservationsData.body)["meals"]),
      table: _tableName1,
    );
    if (this.mounted) {
      setState(() {
        list = json.decode(reservationsData.body)["meals"];
      });
    }

    return list.map((contactRaw) => new Meal.fromDoc(contactRaw)).toList();
  }

  bool wait = false;

  //service pour réserver un repas
  Future<http.Response> makeReservationConf(
      int user_id, int student_id, int token, String pmIds) async {
    setState(() {
      loading = true;
    });
    final param = {
      "user_id": "$user_id",
      "student_id": "$student_id",
      "auth_token": "$token",
      "pm_ids": "$pmIds",
    };

    final restoData = await http.post(
      "${Config.url_api}/make_reservation",
      body: param,
    );

    setState(() {
      reservationData = json.decode(restoData.body);
      setState(() {
        wait = false;
        loading = false;

      });
    });

    if (reservationData["result"] == false) {
      _showDialog();
    }

    return restoData;
  }



  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(
            "OUPS !",
            style: TextStyle(color: Colors.red),
          ),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                  "Votre solde est insuffisant pour effectuer cette operation"),
              Text(""),
              Text(
                  "Votre solde actuel : ${reservationData["current_amount"]} DHS "),
            ],
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            Container(
              decoration: BoxDecoration(
                  color: Fonts.col_app,
                  borderRadius: BorderRadius.circular(10.0)),
              child: new FlatButton(
                child: new Text(
                  "OK",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
    // flutter defined function
  }

  // fetch services from sqlite
  Future<String> _fetchMealsFromSharedPreferences() async {
    print("_fetchMealsFromSharedPreferences");
    print(storage.getDataFromSharedPreferences(table: _tableName));
    return await storage.getDataFromSharedPreferences(table: _tableName);
  }

  // fetch services from sqlite
  Future<String> _fetchAllMealsFromSharedPreferences() async {
    return await storage.getDataFromSharedPreferences(table: _tableName1);
  }
  // fetch reservated meals
  // Future<String> _fetchMyMealsFromSharedPreferences() async {
  //   return await storage.getDataFromSharedPreferences(table: _tableName2);
  // }

  SharedPreferences prefs;


  Future<http.Response> getMeals(int user_id, int student_id, int token,
      String start_date, String end_date) async {
      print("getMeals");
      final loadData = await storage.getBooleanDataFromSharedPreferences(
        table: "resto_api_check");
        print("getMeals loadData == ${loadData} ");

    final resStorage = await _fetchMealsFromSharedPreferences();


    print("***********************************************************************");

      print("resStorage");
      print(resStorage);

      print("***********************************************************************");

      //
    //   prefs = await SharedPreferences.getInstance();
    //   print("***************** getDataFromSharedPreferences allmeals");
    //   print(prefs.getString("allmeals"));
    //   final resStorage  = prefs.getString("allmeals") ;
    //   print("***************** getDataFromSharedPreferences allmeals");
    //   print(json.decode(resStorage));
    //   print("***********************************************************************");

    // final resStorage2 = await _fetchMyMealsFromSharedPreferences();
    // final date = await storage.getDataFromSharedPreferences(
    //     table: "resto_api_check_date");
    // final dateD = await storage.getDataFromSharedPreferences(
    //     table:
    //         "resto_api_date_debut"); /*date_deb des données enregistrées localement */
    // print("resStorage resStorage == ${json.decode(resStorage)} ");

    final dateF = await storage.getDataFromSharedPreferences(table: "resto_api_date_fin");
      print("dateF dateF 2 == ${dateF} ");
      if (dateF != null) {
      date_fin = dateF;
      end_date = date_fin;
    }

    print("dateF dateF == ${dateF} ");

// if(date!=null){
    //   if(DateTime.parse(date.substring(0,10)).difference(DateTime.parse(date_fin)).inDays>0) {
    //     date_fin = date.substring(0, 10);
    //     end_date = date_fin;
    //   }
    // }

    // if (resStorage2 != null) {
    //   data2 = json.decode(resStorage2);
    // }

    // if (false) {

    String timeIntervalEarly;
    String timeIntervalLate;
    List midTimeIntervals = [];
    int ext1;
    int ext2;
    if (resStorage != null && loadData == false){
      print("@@@@@@@@@@@@@@@@ 11");
      dataMap = json.decode(resStorage);
      print(dataMap);

    } else
      dataMap = {};
    print("!!!!!!!");

    for (String key in dataMap.keys) {
      List dates = key.split(',');
      // print("@@@@@@@@@@@@@@@@ 22");
      //
      // print(dates);
      //
      // print("DateTime.parse(dates[0]");
      //
      // print(DateTime.parse(dates[0]));
      // print("DateTime.parse(dates[0]");
      //
      // print("date_deb" + date_deb);
      // print("date_fin" + date_fin);



      if (DateTime.parse(dates[0]).difference(DateTime.parse(date_deb)).inDays <= 0
          &&
          DateTime.parse(dates[1]).difference(DateTime.parse(date_fin)).inDays >= 0 ) {
        // best case
        timeIntervalEarly = key;
        ext1 = ext2 = 0;
        print("###1###");
        break;
      } else if (DateTime.parse(dates[0])
          .difference(DateTime.parse(date_deb))
          .inDays <=
          0 &&
          DateTime.parse(dates[1])
              .difference(DateTime.parse(date_deb))
              .inDays >=
              0) {
        timeIntervalEarly = key;
        ext1 = 1;
        print("###2###");

      } else if (DateTime.parse(dates[0])
          .difference(DateTime.parse(addDays(date_deb, 31)))
          .inDays <=
          0 &&
          DateTime.parse(dates[1])
              .difference(DateTime.parse(addDays(date_deb, 31)))
              .inDays >=
              0) {
        timeIntervalLate = key;
        ext2 = 1;
        print("###3###");

      }
      if (DateTime.parse(dates[0]).difference(DateTime.parse(date_deb)).inDays >
          0 &&
          DateTime.parse(dates[1])
              .difference(DateTime.parse(addDays(date_deb, 31)))
              .inDays <
              0) {
        midTimeIntervals.add(key);
        print("###4###");

      }
    }

    if (ext1 != null && ext2 != null && ext1 == 0 && ext2 == 0) {
      print('scenario 1');
      data = dataMap[timeIntervalEarly];
      data0 = data;
      data0TimeInterval = timeIntervalEarly;
    } else if (ext1 != null && ext2 == null && ext1 == 1) {
      print('scenario 2');
      List dates = timeIntervalEarly.split(',');
      var halfData = await getMealsFromAPi2(
          user_id, student_id, token, dates[1], addDays(date_deb, 31));
      // combine with dataMap[timeIntervalEarly]
      dataMap['${dates[0]},${addDays(date_deb, 31)}'] = {
        'result': dataMap[timeIntervalEarly]['result'] +
            json.decode(halfData.body)['result']
      };
      dataMap.remove(timeIntervalEarly);
      data = dataMap['${dates[0]},${addDays(date_deb, 31)}'];
      data0 = data;
      data0TimeInterval = '${dates[0]},${addDays(date_deb, 31)}';
    } else if (ext1 == null && ext2 != null && ext2 == 1) {
      print('scenario 3');
      List dates = timeIntervalLate.split(',');
      var halfData = await getMealsFromAPi2(
          user_id, student_id, token, date_deb, dates[0]);
      // combine with dataMap[timeIntervalLate]
      dataMap['${date_deb},${dates[1]}'] = {
        'result': json.decode(halfData.body)['result'] +
            dataMap[timeIntervalLate]['result']
      };
      dataMap.remove(timeIntervalLate);
      data = dataMap['${date_deb},${dates[1]}'];
      data0 = data;
      data0TimeInterval = '${date_deb},${dates[1]}';
    } else if (ext1 == null && ext2 == null) {
      print('scenario 4');
      var encodedData = await getMealsFromAPi2(
          user_id, student_id, token, date_deb, addDays(date_deb, 31));
      dataMap['${date_deb},${addDays(date_deb, 31)}'] =
          json.decode(encodedData.body);
      data = dataMap['${date_deb},${addDays(date_deb, 31)}'];
      data0 = data;
      data0TimeInterval = "$date_deb,${addDays(date_deb, 31)}";
      print('fin scenario 4');

    } else if (ext1 == 1 && ext2 == 1) {
      print('scenario 5');
      List dates = timeIntervalEarly.split(',');
      List dates2 = timeIntervalLate.split(',');
      var halfData = await getMealsFromAPi2(
          user_id, student_id, token, dates[1], dates2[0]);
      // combine with dataMap[timeIntervalEarly] and dataMap[timeIntervalLate]
      dataMap['${dates[0]},${dates2[1]}'] = {
        'result': dataMap[timeIntervalEarly]['result'] +
            json.decode(halfData.body)['result'] +
            dataMap[timeIntervalLate]['result']
      };
      dataMap.remove(timeIntervalEarly);
      dataMap.remove(timeIntervalLate);
      data = dataMap['${dates[0]},${dates2[1]}'];
      data0 = data;
      data0TimeInterval = '${dates[0]},${dates2[1]}';
    }

    for (var elmnt in midTimeIntervals) {
      print('scenario mid');
      // remove dataMap[elmnt] from dataMap
      dataMap.remove(elmnt);
    }
    await storage.saveDataToSharedPrefrences(
      data: json.encode(dataMap),
      table: _tableName,
    );

    //

    // if (resStorage != null &&
    //     loadData == false &&
    //     dateD == date_deb &&
    //     !(date != null &&
    //         DateTime.parse(date.substring(0, 10))
    //                 .difference(DateTime.parse(dateF))
    //                 .inDays >
    //             0)) {
    //   print('yaasalam');
    //   data = json.decode(resStorage);
    //   data0 = data;
    //   return null;
    // } else {
    //   print('yaasalam2');
    //   if (date != null) {
    //     if (DateTime.parse(date.substring(0, 10))
    //             .difference(DateTime.parse(date_fin))
    //             .inDays >
    //         0) {
    //       date_fin = date.substring(0, 10);
    //       end_date = date_fin;
    //     }
    //   }
    //   return await getMealsFromAPi(
    //       user_id, student_id, token, start_date, addDays(date_fin, 31));
    // }

    // final param = {
    //   "user_id": "$user_id",
    //   "student_id": "$student_id",
    //   "auth_token": "$token",
    //   "start_date": "$start_date",
    //   "end_date": "$end_date",
    //   "meal_id": "all",
    //   "is_reserved": "all"
    // };
    //
    // final mealsData = await http.post(
    //   "${Config.url_api}/all_meals_calendar",
    //   body: param,
    // );
    //
    // // print(mealsData.body);
    //
    // if (this.mounted)
    //   setState(() {
    //     data = json.decode(mealsData.body);
    //   });
    //
    // return mealsData;
  }

  Future<http.Response> getMealsFromAPi2(int user_id, int student_id, int token,
      String start_date, String end_date) async {
    final param = {
      "user_id": "$user_id",
      "student_id": "$student_id",
      "auth_token": "$token",
      "start_date": "$start_date",
      "end_date": "$end_date",
      "meal_id": "all",
      "is_reserved": "all"
    };
    // "start_date": "2022-11-05",
    // "end_date": "2023-05-05",
    print("user_id == ${user_id}");
    print("student_id == ${student_id}");
    print("auth_token == ${token}");
    print("start_date == ${start_date}");
    print("end_date == ${end_date}");



    final mealsData = await http.post(
      "${Config.url_api}/all_meals_calendar",
      body: param,
    );

    // print(mealsData.body);

    if (this.mounted)
      setState(() {
        data = json.decode(mealsData.body);
      });
    print("_---------------____________---------_______-------_________  1    --");

    // print(data['result'][0]['27'][0]['type_composant'][0]["composants"]);

    print("_---------------____________---------_______-------_________  1    --");

    print(data);

    print("_---------------____________---------_______-------__   2    ---________-------__________-----");

    // mealCal = data.map
    return mealsData;
  }


  Future<http.Response> getMealsFromAPi(int user_id, int student_id, int token,
      String start_date, String end_date) async {
    final param = {
      "user_id": "$user_id",
      "student_id": "$student_id",
      "auth_token": "$token",
      "start_date": "$start_date",
      "end_date": "$end_date",
      "meal_id": "all",
      "is_reserved": "all"
    };

    final mealsData = await http.post(
      "${Config.url_api}/api/all_meals_calendar",
      body: param,
    );

    // update
    var encodedData =
    await storage.getDataFromSharedPreferences(table: _tableName);
    var decodedData;
    if (encodedData != null) {
      decodedData = json.decode(encodedData);
      decodedData['$start_date-$end_date'] = mealsData.body;
    } else
      decodedData = {'$start_date-$end_date': mealsData.body};

    await storage.saveDataToSharedPrefrences(
      data: json.encode(decodedData),
      table: _tableName,
    );

    // List dataList = await storage.getListStringDataFromSharedPreferences(table: _tableName);
    // var dataToSave = {
    //   'time interval': '$start_date-$end_date',
    //   'data' : mealsData.body
    // };
    //
    // await storage.saveListStringDataToSharedPrefrences(
    //   data: dataList + [json.encode(dataToSave)],
    //   table: _tableName,
    // );

    // await storage.saveDataToSharedPrefrences(
    //   data: mealsData.body,
    //   table: _tableName,
    // );

    print("------------------------------------");
    if (this.mounted)
      setState(() {
        data = json.decode(mealsData.body);
      });
    data0 = data;
    storage.saveBooleanDataToSharedPrefrences(
        table: "resto_api_check", data: false);
    // won't need resto_api_date_debut and resto_api_date_fin in this update
    storage.saveDataToSharedPrefrences(
        table: "resto_api_date_debut", data: start_date);
    storage.saveDataToSharedPrefrences(
        table: "resto_api_date_fin", data: end_date);
    // print('here0');
    // print(data0);
    // print('here1');
    // print(data2);

    return mealsData;
  }


  getMealsCal() {
    for (var i = 0; i < data["result"].length; i++) {
      for (var key in data["result"][i].keys) {
        meals = [];
        for (var j = 0; j < data["result"][i][key].length; j++) {
          date = data["result"][i][key][j]["start_date"];
          print(date);
          List test = [];
          List test2 = [];

          mealsTrue = [];

          // print("222333333");
          // print(data["result"][i][key].length);
          // print(key);
          // print("222333333");



          test.add(data["result"][i][key][j]["ticket"]);
          // print(data["result"][i][key][j]["type_composant"]);

          print("###################");
          print("key == ${key}");
          print("o == ${i}");


          print(data["result"][i]);
          print("###################");

          var meal =  MealCal.fromDoc(data["result"][i][key][j]);

          // var meal =  MealList.fromDoc(data["result"][i]);



          // {
          //   "date": "$date",
          //   "index": index,
          //   "check": false,
          //   "meal": "${data["result"][i][key][j]["meal"]}",
          //   "price": "${data["result"][i][key][j]["price"]}",
          //   "is_student_reserved": data["result"][i][key][j]
          //   ["is_student_reserved"],
          //   "pricemeal_id": "${data["result"][i][key][j]["pricemeal_id"]}",
          //   "ticket_id": test[0].isNotEmpty
          //       ? data["result"][i][key][j]["ticket"]["resto_ticket"]["id"]
          //       : "null",
          //   "type_composant" : data["  result"][i][key][j]["type_composant"],
          //   "type_repas" : data["result"][i][key][j]["type_repas"],
          // };
          if (meal.is_student_reserved == true) {
            mealsTrue.add(index);
          }
          index++;
          meals.add(meal);
        }
        mealsmap["$date"] = meals;
      } //end for key
    } //end for i

    listmeals.add(mealsmap);

    print(listmeals);

    getKey();
    loading = false;
    print("getMealsCal fin");
  }

  getKey() {
    for (var k in listmeals[0].keys) {
      listKey.add(k);
    }
    listKey = listKey.reversed.toList();
  }

  void handleSlideAnimationChanged(Animation<double> slideAnimation) {
    setState(() {
      //  _rotationAnimation = slideAnimation;
    });
  }

  void handleSlideIsOpenChanged(bool isOpen) {
    setState(() {
      //_fabColor = isOpen ? Colors.green : Colors.blue;
    });
  }

  @override
  void initState() {
    ctrl = SlidableController(
      onSlideAnimationChanged: handleSlideAnimationChanged,
      onSlideIsOpenChanged: handleSlideIsOpenChanged,
    );
    // print("test date ====${DateTime.fromMillisecondsSinceEpoch(1653562444 * 1000)}");
    print("test date ====${DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(1653562444 * 1000))}");

    print("initState");

    String today = DateTime.now().add(new Duration(days: -90)).toString();

    getMeals(
        widget._userId,
        widget._studentId,
        widget._token,
        new DateFormat('yyyy-MM-dd')
            .format(new DateTime.now().add(new Duration(days: -90))),
        addDays(today, 200))
        .then((_) {
      getMealsCal();
    });

    get_meals(widget._userId, widget._studentId, widget._token).then((val) {
      if (this.mounted)
        setState(() {
          _list = val;
        });
    });
    super.initState();
  }

  clear() async {
    setState(() {
      _list = [];
      loading = true;
    });
    String today = DateTime.now().add(new Duration(days: 1)).toString();

    getMeals(
        widget._userId,
        widget._studentId,
        widget._token,
        new DateFormat('yyyy-MM-dd')
            .format(new DateTime.now().add(new Duration(days: 1))),
        addDays(today, 200))
        .then((_) {
      getMealsCal();
    });

    get_meals(widget._userId, widget._studentId, widget._token).then((val) {
      if (this.mounted)
        setState(() {
          _list = val;
        });
    });
  }

  bool containsElement(int id) {
    for (var i = 0; i < mealsTrue.length; i++) {
      if (id == mealsTrue[i]) return true;
    }
    return false;
  }

  String addDays(String date, int nbrDays) {
    var parsedDate = DateTime.parse(date);
    var myDate = parsedDate.add(new Duration(days: nbrDays));
    String day = myDate.day.toString();
    String month = myDate.month.toString();
    String year = myDate.year.toString();
    String m = int.parse(month) < 10 ? "0$month" : "$month";
    String d = int.parse(day) < 10 ? "0$day" : "$day";

    return "$year-$m-$d";
  }

  isBefore(String date) {
    List<String> res = date.split("-");
    bool value = DateTime.now().isBefore(DateTime(
        int.parse(res[0]), int.parse(res[1]), int.parse(res[2]) - 1))
        ? false
        : true;
    return value;
  }

  Future<http.Response> get__Meals(int user_id, int student_id, int token,
      String start_date, String end_date, sel_id) async {
    meals = [];
    listmeals = [];
    mealsmap = new SplayTreeMap<String, Object>();
    mealsTrue = [];
    listKey = [];

    final param = {
      "user_id": "$user_id",
      "student_id": "$student_id",
      "auth_token": "$token",
      "start_date": "$start_date",
      "end_date": "$end_date",
      "meal_id": "$sel_id"
    };

    final mealsData = await http.post(
      "${Config.url_api}/all_meals_calendar",
      body: param,
    );

    setState(() {
      data = json.decode(mealsData.body);
    });

    /* Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AllMealsCalendar(
                data, widget._userId, widget._studentId, widget._token)));*/

    return mealsData;
  }

  Future get__Meals2(int user_id, int student_id, int token,
      String start_date, String end_date, sel_id) async {
    meals = [];
    listmeals = [];
    mealsmap = new SplayTreeMap<String, Object>();
    mealsTrue = [];
    listKey = [];

    String timeIntervalEarly;
    String timeIntervalLate;
    List midTimeIntervals = [];
    int ext1;
    int ext2;

    for (String key in dataMap.keys) {
      List dates = key.split(',');
      if (DateTime.parse(dates[0])
          .difference(DateTime.parse(date_deb))
          .inDays <=
          0 &&
          DateTime.parse(dates[1])
              .difference(DateTime.parse(date_fin))
              .inDays >=
              0) {
        // best case
        timeIntervalEarly = key;
        ext1 = ext2 = 0;
        break;
      } else if (DateTime.parse(dates[0])
          .difference(DateTime.parse(date_deb))
          .inDays <=
          0 &&
          DateTime.parse(dates[1])
              .difference(DateTime.parse(date_deb))
              .inDays >=
              0) {
        timeIntervalEarly = key;
        ext1 = 1;
      } else if (DateTime.parse(dates[0])
          .difference(DateTime.parse(date_fin))
          .inDays <=
          0 &&
          DateTime.parse(dates[1])
              .difference(DateTime.parse(date_fin))
              .inDays >=
              0) {
        timeIntervalLate = key;
        ext2 = 1;
      }
      if (DateTime.parse(dates[0]).difference(DateTime.parse(date_deb)).inDays >
          0 &&
          DateTime.parse(dates[1])
              .difference(DateTime.parse(date_fin))
              .inDays <
              0) {
        midTimeIntervals.add(key);
      }
    }

    if (ext1 != null && ext2 != null && ext1 == 0 && ext2 == 0) {
      print('scenario 11');
      data = dataMap[timeIntervalEarly];
      data0 = data;
      data0TimeInterval = timeIntervalEarly;
    } else if (ext1 != null && ext2 == null && ext1 == 1) {
      print('scenario 22');
      List dates = timeIntervalEarly.split(',');
      var halfData = await getMealsFromAPi2(
          user_id, student_id, token, dates[1], date_fin);
      // combine with dataMap[timeIntervalEarly]
      dataMap['${dates[0]},${date_fin}'] = {
        'result': dataMap[timeIntervalEarly]['result'] +
            json.decode(halfData.body)['result']
      };
      dataMap.remove(timeIntervalEarly);
      data = dataMap['${dates[0]},${date_fin}'];
      data0 = data;
      data0TimeInterval = '${dates[0]},${date_fin}';
    } else if (ext1 == null && ext2 != null && ext2 == 1) {
      print('scenario 33');
      List dates = timeIntervalLate.split(',');
      var halfData = await getMealsFromAPi2(
          user_id, student_id, token, date_deb, dates[0]);
      // combine with dataMap[timeIntervalLate]
      dataMap['${date_deb},${dates[1]}'] = {
        'result': json.decode(halfData.body)['result'] +
            dataMap[timeIntervalLate]['result']
      };
      dataMap.remove(timeIntervalLate);
      data = dataMap['${date_deb},${dates[1]}'];
      data0 = data;
      data0TimeInterval = '${date_deb},${dates[1]}';
    } else if (ext1 == null && ext2 == null) {
      print('scenario 44');
      var encodedData = await getMealsFromAPi2(
          user_id, student_id, token, date_deb, date_fin);
      dataMap['${date_deb},${date_fin}'] =
          json.decode(encodedData.body);
      data = dataMap['${date_deb},${date_fin}'];
      data0 = data;
      data0TimeInterval = "$date_deb,${date_fin}";
    } else if (ext1 == 1 && ext2 == 1) {
      print('scenario 55');
      List dates = timeIntervalEarly.split(',');
      List dates2 = timeIntervalLate.split(',');
      var halfData = await getMealsFromAPi2(
          user_id, student_id, token, dates[1], dates2[0]);
      // combine with dataMap[timeIntervalEarly] and dataMap[timeIntervalLate]
      dataMap['${dates[0]},${dates2[1]}'] = {
        'result': dataMap[timeIntervalEarly]['result'] +
            json.decode(halfData.body)['result'] +
            dataMap[timeIntervalLate]['result']
      };
      dataMap.remove(timeIntervalEarly);
      dataMap.remove(timeIntervalLate);
      data = dataMap['${dates[0]},${dates2[1]}'];
      data0 = data;
      data0TimeInterval = '${dates[0]},${dates2[1]}';
    }

    for (var elmnt in midTimeIntervals) {
      print('scenario midmid');
      // remove dataMap[elmnt] from dataMap
      dataMap.remove(elmnt);
    }
    await storage.saveDataToSharedPrefrences(
      data: json.encode(dataMap),
      table: _tableName,
    );




    // final param = {
    //   "user_id": "$user_id",
    //   "student_id": "$student_id",
    //   "auth_token": "$token",
    //   "start_date": "$start_date",
    //   "end_date": "$end_date",
    //   // "meal_id": "$sel_id"
    //   "meal_id": "all"
    // };
    //
    // final mealsData = await http.post(
    //   "https://lgi.iav.ac.ma/api/all_meals_calendar",
    //   body: param,
    // );
    //
    // setState(() {
    //   data = json.decode(mealsData.body);
    // });

    /* Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AllMealsCalendar(
                data, widget._userId, widget._studentId, widget._token)));*/

    // return mealsData;
  }

  _showDialogDate() async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => new AlertDialog(
          elevation: 0.0,
          shape: RoundedRectangleBorder(
              side: BorderSide(color:   Fonts.col_app_fonn),
              borderRadius: BorderRadius.circular(18.r)),
          title: Container(
            decoration: BoxDecoration(
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        icon: Icon(Icons.close,size: 20.r,color: Fonts.col_grey,),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ],
                ),
                Text(
                  "La période du réservation : ",
                  style: TextStyle(color:Fonts.col_app_fonn , fontWeight: FontWeight.bold ,fontSize: 18.sp),
                )
              ],
            ),
          ),
          content: ListMeals(
            widget._userId,
            widget._studentId,
            widget._token,
            this._list,
          ),
        ));
  }

  // flutter defined function

  filter_meal() async {
    List a = await _showDialogDate();

    print("********************Liste des repas");
    print(a);
    print("********************Liste des repas");
    if (a.toString() != "null") {
      setState(() {
        loading = true;
      });

      print("yess");
      setState(() {
        date_deb = a[3];
        date_fin = a[4];
        name_repas = a[6];
      });

      await get__Meals2(a[0], a[1], a[2], a[3], a[4], a[5]);
      await getMealsCal();

      setState(() {
        loading = false;
      });
    }
  }

  change(value) {
    print("aaaaaaaaaaaa");
    print(value);
    if (value == true) {
      setState(() {
        check_all = true;
      });
      print("------------_________________-----------______________-----------");
      print(listmeals[0]);
      for (var i in listKey) {
        listmeals[0][i].forEach((val) {
          setState(() {
            val.check= true;
          });
          if (!priceIds.contains(int.parse(val.pricemeal_id.toString()))) {
            priceIds.add(int.parse(val.pricemeal_id.toString()));
          }

          if (!tikeckids.contains(val.ticket_id) &&
              val.ticket_id.toString() != "null") {
            tikeckids.add(val.ticket_id);
          }

          //tikeckids
        });
      }
    } else {
      setState(() {
        check_all = false;
      });
      for (var i in listKey) {
        listmeals[0][i].forEach((val) {
          setState(() {
            val.check = false;
          });
          if (priceIds.contains(int.parse(val.pricemeal_id.toString()))) {
            priceIds.remove(int.parse(val.pricemeal_id.toString()));
          }

          if (tikeckids.contains(val.ticket_id)) {
            tikeckids.remove(val.ticket_id);
          }
        });
      }
    }
  }

  Widget preferredSize(hieght) {
    return PreferredSize(
      preferredSize: Size.fromHeight(hieght),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5.w,horizontal: 10.h),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                // color: Colors.white,
                margin: EdgeInsets.symmetric(vertical: 10.h),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(19.r)),
                    border: Border.all(style: BorderStyle.solid,color:  Fonts.border_col)),
                padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
                // decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                child: Row(
                  children: [
                    Container(
                      child: Text("De: ",
                          style: TextStyle(
                              color:  Fonts.col_app_grey,
                              fontSize: 12.sp
                          )
                      ),
                    ),
                    Container(
                      child: Text("${date_deb}",
                          style: TextStyle(
                              color:  Fonts.col_app_grey,
                              fontSize: 12.sp
                          )
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(19.r)),
                    border: Border.all(style: BorderStyle.solid,color:  Fonts.border_col)),
                padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
                child: Row(
                  children: [
                    Container(
                      child: Text(
                        "À : ",
                        style: TextStyle(
                            color:  Fonts.col_app_grey,
                            fontSize: 12.sp
                        ),
                      ),
                    ),
                    Container(
                      child: Text("${date_fin}",
                          style: TextStyle(
                              color:  Fonts.col_app_grey,
                              fontSize: 12.sp
                          )),
                    )
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(19.r)),
                    border: Border.all(style: BorderStyle.solid,color:  Fonts.border_col)),
                padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
                child: Row(
                  children: [
                    Container(
                      child: Text("Repas : ",
                          style: TextStyle(
                              color:  Fonts.col_app_grey,
                              fontSize: 12.sp
                          )),
                    ),
                    Container(
                      child: Text("${name_repas}",
                          style: TextStyle(
                              color:  Fonts.col_app_grey,
                              fontSize: 12.sp
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Container(
          //   height: 12.h,
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.57,
                      // color: Colors.white,
                      // decoration: BoxDecoration(border: Borde),
                      padding:
                      EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
                      // decoration: BoxDecoration(border: Border.all(color: Colors.red)),

                      child: new Container(
                        // padding: EdgeInsets.symmetric(vertical: 6.h,horizontal: 6.w),
                          decoration: new BoxDecoration(
                              color: Fonts.col_app_fon,
                              border: new Border.all(
                                  color: Fonts.border_col,
                                  width: 1.0),
                              borderRadius: new BorderRadius.circular(19.0.r)),
                          child: Row(
                            children: [
                              SizedBox(width: 5.r,),
                              Container(child: Icon(Icons.settings ,size: 20.r ,color: Colors.white,),),
                              SizedBox(width: 5.r,),
                              Container(
                                child: Text("Filtrer les repas par :",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12.0.sp)),
                              ),
                              Expanded(
                                child: Container(),
                              ),
                              Container(child: Icon(Icons.arrow_drop_down ,size: 35.r ,color: Colors.white,),),
                            ],
                          ))),
                  onTap: () {
                    filter_meal();
                  }),
              FlatButton(
                  onPressed: () {
                    clear();
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.close,
                        color: Fonts.col_app_red,
                      ),
                      Text(
                        "Effacer le filtre",
                        style:
                        TextStyle(color: Fonts.col_app_red, fontSize: 12.sp),
                      )
                    ],
                  )
              ),
            ],
          ),
          Divider(color: Fonts.col_grey,thickness: 0.5,),
        ]
        ),
      ),
    );
  }

  annuler() async {
    if (wait == false) {
      if (priceIds.length == 0) {
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text("Choisir une option")));
        setState(() {
          wait = false;
        });
      } else {
        setState(() {
          wait = true;
        });
        makeCancel(widget._userId, widget._studentId, widget._token,
            tikeckids.join(","))
            .then((_) {
          for (var i in listKey) {
            listmeals[0][i].forEach((val) {
              if (priceIds.contains(int.parse(val["pricemeal_id"])))
                setState(() {
                  val["is_student_reserved"] = false;
                  val["check"] = false;
                });
            });
          }

          setState(() {
            wait = false;
          });

          priceIds = [];
          count1 = 0;
          count2 = 0;
          setState(() {
            check_all = false;
          });
        });
      }
    }
  }

  reserve(context) async {
    if (priceIds.length == 0) {
      Scaffold.of(context)
          .showSnackBar(new SnackBar(content: Text("Choisir une option")));
      setState(() {
        wait = false;
      });
    } else if (count1 == priceIds.length) {
      Scaffold.of(context)
          .showSnackBar(new SnackBar(content: Text("Deja resérvé")));
      setState(() {
        wait = false;
      });
    } else {
      if (wait == false) {
        setState(() {
          wait = true;
        });

        String dateModif;
        dateModif =  hgf`[0];
        if (dates.length > 1) {
          for (int i = 1; i < dates.length; i++) {
            if (DateTime.parse(dates[i])
                .difference(DateTime.parse(dateModif))
                .inDays >
                0) dateModif = dates[i];
          }
        }

        makeReservationConf(widget._userId, widget._studentId, widget._token,
            priceIds.join(","))
            .then((val) {
          for (var i in listKey) {
            listmeals[0][i].forEach((val) {
              if (priceIds.contains(int.parse(val["pricemeal_id"])))
                setState(() {
                  val["is_student_reserved"] = true;
                  val["check"] = false;
                });
            });
          }
          priceIds = [];
          count1 = 0;
          count2 = 0;

          setState(() {
            check_all = false;
            wait = false;
          });
          /*for (var i in listKey) {
                        listmeals[0][i].forEach((val) {
                          setState(() {
                            val["check"] = false;
                          });
                        });
                      }
                    });*/
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.instance = ScreenUtil(width: 375, height: 812)..init(context);

    // TODO: implement build
    return Scaffold(
        appBar:
        // listKey.isNotEmpty
        //     ?
        AppBar(
          // titleSpacing: 0.0,
            elevation: 0.0,
            backgroundColor: Colors.white,
            leading: Container(
                padding: EdgeInsets.only(
                  left: 28.0,
                ),
                child: new Checkbox(
                  value: check_all,
                  onChanged: (value) {
                    change(value);
                  },
                )),
            actions: wait == true
            ? [CupertinoActivityIndicator(), Container(width: 24)]
                : <Widget>[
            RaisedButton(
            color: Colors.green[400],
            padding: EdgeInsets.all(0),
            onPressed: () {
              reserve(context);
            },
            child: Text(
              "Réserver",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500),
            )),
        RaisedButton(
            color: Colors.red,
            padding: EdgeInsets.all(0),
            child: Text(
              "Annuler",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600),
            ),
            onPressed: () {
              annuler();
            })
        ],
        titleSpacing: 2.0,
        title: Text(
          "Sélectionner tous",
          style: TextStyle(color: Colors.grey[600], fontSize: 12.0),
        ),
        bottom:
        // listKey.isNotEmpty
        //     ?
        preferredSize(ScreenUtil().setHeight(108.0))
      // : PreferredSize(preferredSize: Size.fromHeight(0.1)),
    )
    // : PreferredSize(
    //     preferredSize: Size.fromHeight(1),
    //     child: Container(width: 0.0, height: 0.0))

    /*elevation: 0,
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.white),
              bottom: preferredSize(20.0),*/
    ,
    floatingActionButton: FloatingActionButton(
    backgroundColor: Fonts.col_app,
    onPressed: () {
    /*

          [  widget._userId,
                        widget._studentId,
                        widget._token,
                        _formaterDate(date_debut),
                        _formaterDate(date_fin),sel_id]
           */

    filter_meal();
    },
    child: Icon(
    Icons.add,
    ),
    ),
    key: _scaffoldKey,
    body: loading
    ? Center(
    child:Container(child: Text("loading ==${loading}"),),
    )
        : listKey.isNotEmpty
    ? new ListView.builder(
    itemCount: listmeals[0].length,
    itemBuilder: (context, index) {
    return _builBatchList(listKey[index]);
    })
        : Center(child: Text("Aucune réservation !")),
    );
  }

  List<int> priceIds = [];
  List composantId = [];


  //List<bool> checklist = [];
  int count1 = 0;
  int count2 = 0;

  /*Widget _builReservationList(String dd) {
    Widget reservationCards;
    List<Map<String, dynamic>> vv = [];
      listmeals[0][dd].forEach((val) {
        vv.add(val);
      });

    if (vv.length > 0) {
      Container(
          child: reservationCards = Column(
              children: vv
                  .map((Map<String, dynamic> val) => Container(
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(width: 0.2))),
                      child: Slidable(
                        delegate: new SlidableDrawerDelegate(),
                        actionExtentRatio: 0.25,
                        child: Container(
                            padding: EdgeInsets.all(16.0),
                            child: Row(children: <Widget>[
                              // Text(val["pricemeal_id"].toString()),
                              val["is_student_reserved"] == true
                                  ? Icon(
                                      Icons.check,
                                      color: Colors.blue,
                                    )
                                  : Container(),
                              Text(
                                "${val["meal"]}",
                              )
                            ])),
                        /*CheckboxListTile(
                            activeColor: Colors.green,
                            controlAffinity: ListTileControlAffinity.leading,
                            value: val["is_student_reserved"],
                            onChanged: (value) {


                            },
                            secondary: Text("${val["price"]} DHS"),
                            title: Text(
                              "${val["meal"]}",
                            ))*/

                        secondaryActions: val["is_student_reserved"] == true
                            ? <Widget>[
                                new IconSlideAction(
                                  caption: 'Annuler',
                                  color: Colors.redAccent,
                                  icon: Icons.cancel,
                                  onTap: () {
                                    setState(() {
                                      String ticket =
                                          val["ticket_id"].toString();
                                      makeCancel(
                                              widget._userId,
                                              widget._studentId,
                                              widget._token,
                                              ticket)
                                          .then((_) {
                                        val["is_student_reserved"] = false;
                                      });
                                    });
                                  },
                                ),
                              ]
                            : <Widget>[
                                new IconSlideAction(
                                  caption: 'Réserver',
                                  color: Colors.green,
                                  icon: Icons.check_circle,
                                  onTap: () {
                                    print(val["pricemeal_id"].toString());

                                    makeReservationConf(
                                            widget._userId,
                                            widget._studentId,
                                            widget._token,
                                            val["pricemeal_id"].toString())
                                        .then((_) {
                                      if (reservationData["result"] == true) {
                                        val["is_student_reserved"] = true;
                                      }
                                    });

                                    /* setState(() {
                            String id =
                            val["pricemeal_id"].toString();
                            makeReservationConf(
                                widget._userId,
                                widget._studentId,
                                widget._token,
                                id)
                                .then((_) {
                              if (reservationData["result"] == true) {
                                val["is_student_reserved"] = true;
                              }
                            });
                          });*/
                                  },
                                ),
                              ],
                      )))
                  .toList()));
    } else {
      reservationCards = Container();
    }
    return reservationCards;
  }*/

  Widget _builBatchList(String dd) {

    print("dd  == ${dd}");
    Widget timeCards;
    List<MealCal> vv = [];
    listmeals[0][dd].forEach((val) {
      vv.add(val);

      i = listmeals[0][dd].indexOf(val);
    });

    if (vv.length > 0) {
      Container(
          child: timeCards = Container(
            padding: EdgeInsets.symmetric(horizontal: 13.w,vertical: 5.h),
            margin: EdgeInsets.symmetric(horizontal: 20.w,vertical: 5.h),
            decoration: BoxDecoration(
                color: Fonts.col_cl,
                border: Border.all(width: 1,color: Fonts.col_app_fon),
                borderRadius: BorderRadius.all(Radius.circular(18.r))
            ),

            // color: Colors.green,

            child: Column(
                children: vv
                    .map((MealCal val) => Container(
                  child: Column(children: <Widget>[
                    listmeals[0][dd].indexOf(val) == 0
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
                                  val.date ,
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
                              child: Icon(val.more_dtaills ? Icons.arrow_drop_up_outlined
                                  :
                              Icons.arrow_drop_down,size: 30.r,color: Fonts.col_app_fonn,),
                            ),
                            onTap: (){
                              setState(() {
                                if(val.more_dtaills == true){
                                  val.more_dtaills = false ;
                                  print(val.more_dtaills);
                                } else{
                                  val.more_dtaills = true ;
                                  print(val.more_dtaills);

                                }
                              });
                            },
                          )

                        ],
                      ),
                    )
                        : listmeals[0][dd][i].date ==
                        listmeals[0][dd][i - 1].date
                        ? Container(color: Fonts.col_cl,)
                        :
                    Container(
                      color: Color(0xffFAFAFA),
                      child: Row(
                        children: <Widget>[
                          Image.asset(
                            "images/appointment.png",
                            color: Fonts.col_app,
                            width: 18.0.w,
                            height: 18.0.h,
                          ),
                          Container(
                            width: 8.0.w,
                          ),
                          Container(
                            width: 4.0.w,
                          ),
                          new Text(
                            val.date,
                          )
                        ],
                      ),
                    ),
                    Slidable (
                      controller: ctrl,
                      //key: keys,
                      enabled: true,
                      actionPane: SlidableDrawerActionPane(),
                      // delegate: new SlidableDrawerDelegate(),
                      actionExtentRatio: 0.25,
                      secondaryActions: val.date == true
                          ? <Widget>[
                        new IconSlideAction(
                          caption: 'Annuler',
                          color: Fonts.col_app_red,
                          icon: Icons.cancel,
                          onTap: () {
                            setState(() {
                              String ticket =
                              val.ticket_id.toString();
                              makeCancel(
                                  widget._userId,
                                  widget._studentId,
                                  widget._token,
                                  ticket)
                                  .then((_) {
                                val.is_student_reserved = false;
                              });
                            });
                          },
                        ),
                      ]
                          : <Widget>[
                        new IconSlideAction(
                          caption: 'Réserver',
                          color: Colors.black,
                          icon: Icons.check_circle,
                          onTap: () {
                            makeReservationConf(
                                widget._userId,
                                widget._studentId,
                                widget._token,
                                val.pricemeal_id.toString())
                                .then((_) {
                              if (reservationData["result"] == true) {
                                val.is_student_reserved = true;
                              }
                            });

                            /* setState(() {
                                String id =
                                val["pricemeal_id"].toString();
                                makeReservationConf(
                                    widget._userId,
                                    widget._studentId,
                                    widget._token,
                                    id)
                                    .then((_) {
                                  if (reservationData["result"] == true) {
                                    val["is_student_reserved"] = true;
                                  }
                                });
                              });*/
                          },
                        ),
                      ],
                      child:
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(18.r)),
                            color: val.is_student_reserved
                                ? Fonts.col_green
                                : Fonts.col_cl,
                          ),


                          child: Container(
                              padding: EdgeInsets.only(top: 8.0.h),
                              decoration: BoxDecoration(),
                              child: Column(children: <Widget>[
                                Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    children: <Widget>[
                                      /*  activeColor: containsElement(val["index"])
                                        ? Colors.grey
                                        : Colors.green,*/
                                      /*IconButton(
                                                  padding: EdgeInsets.all(0.0),
                                                  onPressed: () {
                                                    Slidable.of(context)?.close();
                                                  },
                                                  icon: Icon(Icons.arrow_back),
                                                )*/
                                      isBefore(val.date)
                                          ? Container(
                                        width: 18.w,
                                        height: 18.h,
                                      )
                                          : InkWell(
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 18.w,
                                              height: 18.h,
                                              // padding: EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                  border: Border.all(color: Fonts.col_app_grey,width: 1.w),
                                                  borderRadius: BorderRadius.all(Radius.circular(4.r))
                                              ),
                                              child: val.check == true ?  Center(child: Icon(Icons.check,color: Fonts.col_app_grey,size: 15.r,)) : Container() ,
                                            ),
                                            Container(width: 13.w,),
                                            Row(
                                              children: <Widget>[
                                                // Image.asset(
                                                //   "images/dish.png",
                                                //   color: Fonts.col_app,
                                                //   width: 18.0.w,
                                                //   height: 18.0.h,
                                                // ),
                                                // Container(
                                                //   width: 8.0.w,
                                                // ),
                                                Text(
                                                  "${val.meal}",
                                                  style: TextStyle(
                                                      fontFamily: "Helvetica",
                                                      color:  Fonts.col_text,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 18.sp),
                                                ),
                                              ],
                                            ),
                                            // Expanded(
                                            //   child: Container(),
                                            // ),
                                            Container(
                                              width: 10.0.w,
                                            ),
                                            Text("${val.price} DHS",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color:  Fonts.col_app_fonn,
                                                    fontSize: 12.sp
                                                )),
                                            Container(
                                              width: 8.w,
                                            ),
                                          ],
                                        ),
                                        onTap: (){
                                          print(val);

                                          setState(() {
                                            if (val.check == false) {
                                              if (val.is_student_reserved == true) {
                                                count1 = count1 + 1;
                                                print(count1);
                                              } else {
                                                count2 = count2 + 1;
                                              }
                                              val.check = true;

                                              priceIds.add(int.parse(
                                                  val.pricemeal_id.toString()));
                                              if (!tikeckids.contains(val.ticket_id) &&
                                                  val.ticket_id
                                                      .toString() !=
                                                      "null") {
                                                tikeckids.add(
                                                    val.ticket_id);
                                              }
                                            } else {
                                              if (val.is_student_reserved) {
                                                count2 = count2 - 1;
                                              } else {
                                                count1 = count1 - 1;
                                              }

                                              val.check = false;
                                              priceIds.remove(
                                                  int.parse(val.pricemeal_id.toString())
                                              );
                                              if (tikeckids.contains(
                                                  val.ticket_id)) {
                                                tikeckids.remove(
                                                    val.ticket_id);
                                              }
                                            }
                                          });
                                        },
                                      ),

                                      Expanded(
                                        child: Container(),
                                      ),
                                      Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  width: 1.w, //
                                                  color: val.is_student_reserved ==
                                                      false
                                                      ? Fonts.col_app_red
                                                      : Fonts.col_green
                                                //                 <--- border width here
                                              ),
                                              borderRadius:
                                              BorderRadius.all(
                                                Radius.circular(80.0.r),
                                              )),
                                          padding: EdgeInsets.all(3.r),
                                          child: Center(
                                              child: Text(
                                                val.is_student_reserved
                                                    ? "R"
                                                    : "NR",
                                                style: TextStyle(
                                                    fontSize: 12.0.sp,
                                                    fontWeight: FontWeight.w900,
                                                    color:
                                                    val.is_student_reserved ==
                                                        false
                                                        ? Fonts.col_app_red
                                                        : Fonts.col_green
                                                ),
                                              ))),
                                      Container(width: 14.w)
                                    ]
                                ),
                                Container(
                                  height: 14.h,
                                ),

                                Container(
                                  // color: Colors.red,
                                  child:
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        // color: Colors.green,
                                        width: val.type_composant.length == 0  ? MediaQuery.of(context).size.width * 0
                                            :
                                        MediaQuery.of(context).size.width * 0.4,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            //Composants

                                            val.type_composant.length == 0 ?  Container() :
                                            Container(
                                              child: Row(children: [
                                                Container(height: 15.w,),
                                                Container(child: Text("Composants :",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12.sp,
                                                    color: Fonts.col_app_grey,
                                                    fontFamily: "Helvetica",
                                                  ),
                                                )
                                                ),

                                              ],
                                              ),
                                            ) ,
                                            Container(height: 10.w,),

                                            Column(
                                                children: val.type_composant.map<Widget>((result){
                                                  // List <Type_composant> vallll = List <Type_composant>.from(result.composants.map((type)=> Type_composant.fromDoc(type)).toList()) ;
                                                  return  Container(
                                                    margin: EdgeInsets.only(bottom:  10.h),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            // Container(width: 20.w,),
                                                            Container(child: Text(result.name +" :",
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.w100,
                                                                fontSize: 12.sp,
                                                                color: Fonts.col_app_grey,
                                                                fontFamily: "Helvetica",
                                                              ),
                                                            ),),
                                                            // Container(width: 15.w,),

                                                            Expanded(child: Container()),

                                                            /*new Container(
                                                               color: Colors.blue,
                                                                child: Container(
                                                                    padding: EdgeInsets.symmetric(vertical: 3.w,horizontal: 8.h),
                                                                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8.r)),
                                                                        border: Border.all(style: BorderStyle.solid,color: Fonts.border_col,width: 0.5)),
                                                                    height: 25.h,
                                                                    width: 200.w,
                                                                    alignment: Alignment.center,
                                                                    child: new FixDropDown(
                                                                        style: TextStyle(color: Colors.black),
                                                                        iconSize: 32.0,
                                                                        isDense: false,
                                                                        items: result.composants.map((value) {
                                                                          return new FixDropdownMenuItem(
                                                                            value: value,
                                                                            child: new Text(
                                                                              value.name,
                                                                              maxLines: 2,
                                                                              softWrap: true,
                                                                              style: TextStyle( color: Colors.black),
                                                                            ),
                                                                          );
                                                                        }).toList(),
                                                                        hint: new Text(
                                                                          composants_id != ""
                                                                              ? composants_id
                                                                              : "Plat",
                                                                          maxLines: 1,
                                                                          softWrap: true,
                                                                          style: new TextStyle(color: Colors.white),
                                                                        ),
                                                                        onChanged: (value) {
                                                                          setState(() {
                                                                            composants_id = value.name;
                                                                           // error = "";
                                                                          });
                                                                        })))*/

                                                            Container(
                                                              padding: EdgeInsets.symmetric(vertical: 3.w,horizontal: 8.h),
                                                              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8.r)),
                                                                  border: Border.all(style: BorderStyle.solid,color: Fonts.border_col,width: 0.5)),
                                                              height: 25.h,
                                                              width: 100.w,
                                                              alignment: Alignment.center,
                                                              child: DropdownButtonHideUnderline(
                                                                child: DropdownButton(
                                                                  hint: Text(result.name),

                                                                  value: composants_id,
                                                                  isExpanded: true,
                                                                  icon: const Icon(Icons.arrow_drop_down,color:Fonts.col_app_grey,),
                                                                  elevation: 0,

                                                                  style:  TextStyle(
                                                                    fontWeight: FontWeight.w500,
                                                                    fontSize: 11.sp,
                                                                    color: Fonts.col_app_grey,
                                                                    fontFamily: "Helvetica",
                                                                  ),
                                                                  onChanged: (newValue) {

                                                                    print("yessssssssss");
                                                                    print(newValue);
                                                                    /*setState(() {
                                                                      composants_id = newValue ;
                                                                    });*/
                                                                  },

                                                                  items: result.composants.map((value) {
                                                                    return DropdownMenuItem<String>(
                                                                      value: value.name ,
                                                                      child: Text(value.name,
                                                                        style: TextStyle(
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: 10.sp,
                                                                          color: Fonts.col_app_grey,
                                                                          fontFamily: "Helvetica",
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }).toList(),
                                                                ),
                                                              ),
                                                            ),

                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                  ;
                                                }).toList()
                                            ),

                                            //End Composants
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: val.type_repas.length == 0  ? MediaQuery.of(context).size.width * 0
                                            :
                                        MediaQuery.of(context).size.width * 0.4,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            //  Extra

                                            val.type_repas.length == 0 ?  Container() :
                                            Container(
                                              child: Row(children: [
                                                // Container(width: 20.w,),
                                                Container(
                                                  child: Row(children: [
                                                    Container(height: 15.w,),
                                                    Container(child: Text("Extra :",
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 12.sp,
                                                        color: Fonts.col_app_grey,
                                                        fontFamily: "Helvetica",
                                                      ),
                                                    )
                                                    ),

                                                  ],
                                                  ),
                                                ) ,

                                              ],
                                              ),
                                            ) ,
                                            Container(height: 10.w,),

                                            Container(
                                              // margin: EdgeInsets.only(left: 10),
                                              child:
                                              Column(
                                                children: val.type_repas.map<Widget>((type_repas){
                                                  // List <Type_repas> vallll = List <Type_repas>.from(val.map((type)=> Type_repas.fromDoc(type)).toList()) ;
                                                  print("**********");
                                                  print(val.check);
                                                  return Container(
                                                      padding: EdgeInsets.only(bottom: 10.h),

                                                      child: Row(
                                                        children: [
                                                          InkWell(
                                                            child: Container(
                                                              padding: EdgeInsets.symmetric(vertical: 5.h),
                                                              // color: Colors.red,
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                    width: 16.w,
                                                                    height: 16.h,
                                                                    // padding: EdgeInsets.all(4),
                                                                    decoration: BoxDecoration(
                                                                        border: Border.all(color: Fonts.col_app_grey,width: 1),
                                                                        borderRadius: BorderRadius.all(Radius.circular(4.r))
                                                                    ),
                                                                    child: type_repas.check == true ?  Center(child: Icon(Icons.check,color: Fonts.col_app_grey,size: 13.r,)) : Container() ,
                                                                  ),
                                                                  Container(width: 10.w,),
                                                                  // Container(
                                                                  //   width: 8.0,
                                                                  // ),
                                                                  Text(
                                                                    "${type_repas.name}",
                                                                    style: TextStyle(
                                                                      fontWeight: FontWeight.w100,
                                                                      fontSize: 12.sp,
                                                                      color: Fonts.col_app_grey,
                                                                      fontFamily: "Helvetica",
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    width: 10.0.w,
                                                                  ),
                                                                ],
                                                              ),
                                                              // color: Colors.red,
                                                            ),
                                                            onTap: (){
                                                              setState(() {
                                                                print("##########");

                                                                print(type_repas.check);

                                                                if(type_repas.check == false){
                                                                  type_repas.check = true;
                                                                  if(val.check == false){
                                                                    // val.check = true ;
                                                                    if (val.is_student_reserved ==
                                                                        true) {
                                                                      count1 = count1 + 1;
                                                                      print(count1);
                                                                    } else {
                                                                      count2 = count2 + 1;
                                                                    }
                                                                    val.check = true;

                                                                    mealcal.add({"MealCal" : "${int.parse(val.pricemeal_id.toString())}"},
                                                                    );

                                                                    priceIds.add(int.parse(
                                                                        val.pricemeal_id.toString()));
                                                                    if (!tikeckids.contains(val.ticket_id) &&
                                                                        val.ticket_id
                                                                            .toString() !=
                                                                            "null") {
                                                                      tikeckids.add(
                                                                          val.ticket_id);
                                                                    }
                                                                  }
                                                                  // composantId.add(int.parse(
                                                                  //     type_repas.id.toString()));
                                                                  composantId.add(
                                                                      {"pricemeal_id" : int.parse(
                                                                          val.pricemeal_id.toString()) ,
                                                                        "id_extra" : int.parse(
                                                                            type_repas.id.toString())});
                                                                  print(composantId);
                                                                  print("-----");
                                                                  print(priceIds);
                                                                } else{
                                                                  type_repas.check = false;
                                                                  composantId.remove(
                                                                      int.parse(type_repas.id.toString())
                                                                  );
                                                                  print(composantId);
                                                                  print("-----");
                                                                  print(priceIds);
                                                                }
                                                                print(type_repas.check);

                                                              });
                                                            },
                                                          ),
                                                          Expanded(child: Container()),
                                                          Text("${type_repas.price} DHS",
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.w800,
                                                                  color:  Fonts.col_app_fonn,
                                                                  fontSize: 12.sp
                                                              )
                                                          ),

                                                        ],
                                                      )
                                                  );
                                                }).toList(),

                                              ),
                                            ) ,

                                            // End Extra
                                          ],),
                                      )
                                    ],
                                  ),
                                ),
                                // Container(height: 10.h,),
                              ]
                              )
                          )
                      )

                      ,
                    ) ,

                    // listmeals[0][dd].indexOf(val) == 0
                    //     ?
                    val.meal == "diner " ?   Container() :  Divider(color: Fonts.col_app_grey,thickness: 0.5.r,)
                    //     : listmeals[0][dd][i].date ==
                    //     listmeals[0][dd][i - 1].date
                    //     ? Container()
                    //     :
                    // Divider(color: Fonts.col_app_red,thickness: 1,),

                  ]),
                ),
                )
                    .toList()),
          )
      );
    } else {
      timeCards = Container();
    }
    return timeCards;
  }
}
/*ListTile(
                        onTap: () {
                          getMealsDay(
                              widget._userId,
                              widget._studentId,
                              widget._token,
                              "${listKey[index]}",
                              "${addDays(listKey[index], 7)}");
                        },
                        leading: Icon(
                          Icons.date_range,
                          color: Colors.white,
                        ),
                        title: new Text(
                          "${_formatDate(listKey[index])}",
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
                        trailing: Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.white,
                        ),
                      ),*/
