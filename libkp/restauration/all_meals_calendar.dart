import 'package:flutter/material.dart';
import 'package:ifdconnect/campus/etudiant/home/Accueil.dart';
import 'package:ifdconnect/config/config.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sticky_headers/sticky_headers.dart';
import "dart:collection";
import 'package:http/http.dart' as http;
import 'dart:convert';

class AllMealsCalendar extends StatefulWidget {
  final int _userId;
  final int _studentId;
  final int _token;
  var data;

  AllMealsCalendar(this.data, this._userId, this._studentId, this._token);

  @override
  _AllMealsCalendarState createState() => _AllMealsCalendarState();
}

class _AllMealsCalendarState extends State<AllMealsCalendar> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List meals = [];
  List listmeals = [];
  bool loading = true;
  String date;
  var mealsmap = new SplayTreeMap<String, Object>();
  List<int> mealsTrue = [];
  int index = 1;

  //*******************************************************
  getMealsCal() {
    for (var i = 0; i < widget.data["result"].length; i++) {
      for (var key in widget.data["result"][i].keys) {
        meals = [];
        for (var j = 0; j < widget.data["result"][i][key].length; j++) {
          String d = int.parse(key) < 10 ? "0$key" : "$key";
          date = widget.data["result"][i][key][j]["start_date"];

          var meal = {
            "index": index,
            "meal": "${widget.data["result"][i][key][j]["meal"]}",
            "price": "${widget.data["result"][i][key][j]["price"]}",
            "is_student_reserved": widget.data["result"][i][key][j]
                ["is_student_reserved"],
            "pricemeal_id":
                "${widget.data["result"][i][key][j]["pricemeal_id"]}",
          };
          if (meal["is_student_reserved"] == true) {
            mealsTrue.add(index);
          }
          index++;
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
    getMealsCal();
    super.initState();
  }

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
      Navigator.pop(context);
    } else {
      _showDialog();
    }

    return restoData;
  }

  void _showDialogConfirmation() {
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

    // flutter defined function
  }

  //show dialog solde insuffisant

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
                  "Le prix total du réservation : ${dataRestoBill["total_price"]} DHS "),
              Text(""),
              Text(
                  "Votre solde actuel : ${dataRestoBill["current_amount"]} DHS "),
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

  _showSnackBar1() {
    final snackBar = new SnackBar(
      content: new Text("Choisir d'abord un repas ..."),
      duration: new Duration(seconds: 3),
    );
    //How to display Snackbar ?
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  _showSnackBar2() {
    final snackBar = new SnackBar(
      content: new Text("Vous avez déjà réservé ce repas."),
      duration: new Duration(seconds: 3),
    );
    //How to display Snackbar ?
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  bool containsElement(int id) {
    for (var i = 0; i < mealsTrue.length; i++) {
      if (id == mealsTrue[i]) return true;
    }
    return false;
  }

  //fonction pour adapter format d'affichage d'une date
  String _formatDate(String date) {
    String day = DateTime.parse(date).day.toString();
    String month = DateTime.parse(date).month.toString();
    String year = DateTime.parse(date).year.toString();
    String m = int.parse(month) < 10 ? "0$month" : "$month";
    String d = int.parse(day) < 10 ? "0$day" : "$day";

    return "$d/$m/$year";
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
            appBar: AppBar(
              title: Text("Liste des repas"),
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (priceIds.isNotEmpty) {
                      makeReservation(widget._userId, widget._studentId,
                              widget._token, priceIds.join(","))
                          .then((_) {
                        dataRestoBill["total_price"] >
                                dataRestoBill["current_amount"]
                            ? _showDialog()
                            : _showDialogConfirmation();
                      });
                    } else
                      _showSnackBar1();
                  },
                )
              ],
            ),
            body: listKey.isNotEmpty
                ? new ListView.builder(
                    itemCount: listmeals[0].length,
                    itemBuilder: (context, index) {
                      return /*new StickyHeader(
                        header: new Container(
                          height: 50.0,
                          color: Color(0xff4eb1e1), //Colors.lightGreen,
                          padding: new EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.centerLeft,
                          child: new Text(
                            "${_formatDate(listKey[index])}",
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.0),
                          ),
                        ),
                        content:*/
                          new Container(
                        child: _builBatchList(listKey[index]),
                      );
                    })
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.restaurant_menu,
                          color: Colors.blueGrey,
                          size: 50.0,
                        ),
                        Text(
                          "Aucun Repas",
                          style: TextStyle(color: Colors.blueGrey),
                        )
                      ],
                    ),
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
                  .map((Map<String, dynamic> val) => Card(
                      elevation: 8.0,
                      child: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(width: 0.2))),
                          child: Column(children: <Widget>[
                            CheckboxListTile(
                                activeColor: containsElement(val["index"])
                                    ? Colors.grey
                                    : Colors.green,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                value: val["is_student_reserved"],
                                onChanged: (value) {
                                  setState(() {
                                    if (!containsElement(val["index"])) {
                                      if (val["is_student_reserved"] == false) {
                                        val["is_student_reserved"] = true;
                                        priceIds.add(
                                            int.parse(val["pricemeal_id"]));
                                      } else {
                                        val["is_student_reserved"] = false;
                                        priceIds.remove(
                                            int.parse(val["pricemeal_id"]));
                                      }
                                    } else {
                                      _showSnackBar2();
                                    }
                                  });
                                },
                                title: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(

                                      children: <Widget>[

                                        Image.asset(
                                          "images/appointment.png",
                                          color: Fonts.col_app,
                                          width: 24.0,
                                          height: 24.0,
                                        ),
                                        Container(
                                          width: 8.0,
                                        ),

                                        Text("Date:",style: TextStyle(fontWeight: FontWeight.bold),),

                                        Container(
                                          width: 4.0,
                                        ),
                                        new Text(
                                          "${_formatDate(date)}",
                                        )
                                      ],
                                    ),
                                    Container(height: 12.0,),
                                    Row(

                                      children: <Widget>[

                                        Image.asset(
                                          "images/dish.png",
                                          color: Fonts.col_app,
                                          width: 24.0,
                                          height: 24.0,
                                        ),
                                        Container(
                                          width: 8.0,
                                        ),

                                        Text("Type de repas:",style: TextStyle(fontWeight: FontWeight.bold),),

                                        Container(
                                          width: 4.0,
                                        ),
                                        Text(
                                          "${val["meal"]}",
                                        )
                                      ],
                                    ),
                                    Container(height: 12.0,),
                                    Row(
                                      children: <Widget>[
                                        Image.asset(
                                          "images/coin.png",
                                          color: Fonts.col_app,
                                          width: 22.0,
                                          height: 22.0,
                                        ),
                                        Container(
                                          width: 10.0,
                                        ),

                                        Text("Prix:",style: TextStyle(fontWeight: FontWeight.bold),),

                                        Container(
                                          width: 4.0,
                                        ),
                                        Text("${val["price"]} DHS"),
                                      ],
                                    )
                                  ],
                                )),
                          ]))))
                  .toList()));
    } else {
      timeCards = Container();
    }
    return timeCards;
  }
}
