import 'package:flutter/material.dart';
import 'package:ifdconnect/campus/etudiant/home/Accueil.dart';
import 'package:ifdconnect/config/config.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Meals extends StatefulWidget {
  final List data;
  final int _userId;
  final int _studentId;
  final int _token;

  Meals(this.data, this._userId, this._studentId, this._token);

  @override
  _MealsState createState() => _MealsState();
}

class _MealsState extends State<Meals> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var dataRestoBill;
  var reservationData;
  SharedPreferences prefs;


  Future<http.Response> makeReservation(
      int user_id, int student_id, int token, String pmIds) async {
    prefs = await SharedPreferences.getInstance();

    final param = {
      "user_id": "$user_id",
      "student_id": "$student_id",
      "auth_token": "$token",
      "pm_ids": "$pmIds",
    };

    final restoData = await http.post(
      "${"${prefs.getString('api_url')}"}/resto_bill",
      body: param,
    );
    setState(() {
      dataRestoBill = json.decode(restoData.body);
    });

    return restoData;
  }

  Future<http.Response> makeReservationConf(
      int user_id, int student_id, int token, String pmIds) async {
    prefs = await SharedPreferences.getInstance();

    final param = {
      "user_id": "$user_id",
      "student_id": "$student_id",
      "auth_token": "$token",
      "pm_ids": "$pmIds",
    };

    final restoData = await http.post(
      "${"${prefs.getString('api_url')}"}/make_reservation",
      body: param,
    );
    setState(() {
      reservationData = json.decode(restoData.body);
    });

    if (reservationData["result"] == true) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EtudiantHome(null,
                  widget._userId, widget._studentId, widget._token)));
    } else {
      _showDialog();
    }

    return restoData;
  }

  void _showDialogConfirmation() {
    makeReservation(widget._userId, widget._studentId, widget._token,
            priceIds.join(","))
        .then((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text("Confirmation !"),
            content: Container(
              height: 100.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                      "Le prix total du réservation : ${dataRestoBill["total_price"]} DHS "),
                  Text(""),
                  Text(
                      "Votre solde actuel : ${dataRestoBill["current_amount"]} DHS "),
                ],
              ),
            ),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog

              new FlatButton(
                child: new Text(
                  "Annuler",
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),

              new FlatButton(
                child: new Text(
                  "Confirmer",
                ),
                onPressed: () {
                  makeReservationConf(widget._userId, widget._studentId,
                      widget._token, priceIds.join(","));
                },
              ),
            ],
          );
        },
      );
    });
    // flutter defined function
  }

  //show dialog solde insuffisant

  void _showDialog() {
    makeReservation(widget._userId, widget._studentId, widget._token,
            priceIds.join(","))
        .then((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text(
              "OUPS !",
              style: TextStyle(color: Colors.red),
            ),
            content: Text(
                "Votre solde est insuffisant pour effectuer cette operation"),
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
    });
    // flutter defined function
  }

  String listToString(List idList) {
    String ids = "";
    for (var i in idList) {
      ids += "$i,";
    }
    return ids;
  }

  String _formatDate(String date) {
    String day = DateTime.parse(date).day.toString();
    String month = DateTime.parse(date).month.toString();
    String year = DateTime.parse(date).year.toString();
    String m = int.parse(month) < 10 ? "0$month" : "$month";

    return "$m/$year";
  }

  List meals = [];
  List listmeals = [];
  bool loading = true;
  var date;
  var mealsmap = {};

  getMeals() {
    for (var i = 0; i < widget.data.length; i++) {
      for (var key in widget.data[i].keys) {
        meals = [];
        for (var j = 0; j < widget.data[i][key].length; j++) {
          String d = int.parse(key) < 10 ? "0$key" : "$key";
          date = widget.data[i][key][j]["start_date"];
          var meal = {
            "meal": "${widget.data[i][key][j]["meal"]}",
            "price": "${widget.data[i][key][j]["price"]}",
            "check": false,
            "pricemeal_id": "${widget.data[i][key][j]["pricemeal_id"]}",
          };

          meals.add(meal);
        }

        mealsmap["$date"] = meals;
      } //end for key

    } //end for i
    listmeals.add(mealsmap);
    getKey();
    loading = false;
  }

  List listKey = [];

  getKey() {
    for (var k in listmeals[0].keys) {
      listKey.add(k);
    }
  }

  @override
  void initState() {
    getMeals();
    super.initState();
  }

  _showSnackBar() {
    final snackBar = new SnackBar(
      content: new Text("Choisir d'abord des repas ..."),
      duration: new Duration(seconds: 3),
    );
    //How to display Snackbar ?
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return loading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            key: _scaffoldKey,
            body: new ListView.builder(
                itemCount: listmeals[0].length,
                itemBuilder: (context, index) {
                  return new StickyHeader(
                    header: new Container(
                      height: 50.0,
                      color: Color(0xff4eb1e1),
                      //Colors.lightGreen,
                      padding: new EdgeInsets.symmetric(horizontal: 16.0),
                      alignment: Alignment.centerLeft,
                      child: new Text(
                        "${listKey[index]}",
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
                    ),
                    content:
                        new Container(child: _builBatchList(listKey[index])),
                  );
                }),
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text("Liste des repas"),
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (priceIds.isNotEmpty) {
                      _showDialogConfirmation();
                    } else
                      _showSnackBar();
                  },
                )
              ],
            ),
          );
  }

  List<int> priceIds = [];

  Widget _builBatchList(String dd) {
    Widget timeCards;
    List<Map<String, dynamic>> vv = [];
    listmeals[0][dd].forEach((val) {
      vv.add(val);
    });

    if (vv.length > 0) {
      Container(
          child: timeCards = Column(
              children: vv
                  .map((Map<String, dynamic> val) => Container(
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(width: 0.2))),
                      child: CheckboxListTile(
                          value: val["check"],
                          onChanged: (value) {
                            setState(() {
                              if (val["check"] == false) {
                                val["check"] = true;
                                priceIds.add(int.parse(val["pricemeal_id"]));
                              } else {
                                val["check"] = false;
                                priceIds.remove(int.parse(val["pricemeal_id"]));
                              }
                            });
                          },
                          title: Text(
                            "${val["meal"]} (${val["price"]} DHS)",
                          ))))
                  .toList()));
    } else {
      timeCards = Container();
    }
    return timeCards;
  }
}
