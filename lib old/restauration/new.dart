import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ifdconnect/config/config.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:intl/intl.dart';
import 'package:ifdconnect/models/meal.dart';
import 'package:ifdconnect/restauration/Resto.dart';

import 'package:sticky_headers/sticky_headers.dart';

class MesReservation extends StatefulWidget {
  final int _userId;
  final int _studentId;
  final int _token;

  MesReservation(this._userId, this._studentId, this._token);

  @override
  _MesReservationState createState() => _MesReservationState();
}

class _MesReservationState extends State<MesReservation> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var reservationData;
  var dataDay;
  var data;
  List meals = [];
  List listmeals = [];
  bool loading = true;
  String date;
  var mealsmap = new SplayTreeMap<String, Object>();
  List<int> mealsTrue = [];
  int index = 1;
  List listKey = [];
  List<Meal> _list = [];
  SlidableController ctrl;
  bool wait = false;


  List<int> tikeckids = [];
  Key keys;

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
    });

    return reservationsData;
  }

  Future<List<Meal>> get_meals(int user_id, int student_id, int token) async {
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
    if (this.mounted) {
      setState(() {
        list = json.decode(reservationsData.body)["meals"];
      });
    }

    return list.map((contactRaw) => new Meal.fromDoc(contactRaw)).toList();
  }

  //service pour réserver un repas
  Future<http.Response> makeReservationConf(
      int user_id, int student_id, int token, String pmIds) async {
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
                  color: Colors.blue,
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

  Future<http.Response> getMealsDay(int user_id, int student_id, int token,
      String start_date, String end_date) async {
    final param = {
      "user_id": "$user_id",
      "student_id": "$student_id",
      "auth_token": "$token",
      "start_date": "$start_date",
      "end_date": "$end_date",
    };

    final mealsData = await http.post(
      "${Config.url_api}/all_meals_calendar",
      body: param,
    );
    setState(() {
      dataDay = json.decode(mealsData.body);
    });

    /* Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AllMealsCalendar(
                dataDay, widget._userId, widget._studentId, widget._token)));*/

    return mealsData;
  }

  Future<http.Response> getMeals(int user_id, int student_id, int token,
      String start_date, String end_date) async {
    final param = {
      "user_id": "$user_id",
      "student_id": "$student_id",
      "auth_token": "$token",
      "start_date": "$start_date",
      "end_date": "$end_date",
      "meal_id": "all"
    };

    final mealsData = await http.post(
      "${Config.url_api}/all_meals_calendar",
      body: param,
    );
    if (this.mounted)
      setState(() {
        data = json.decode(mealsData.body);
      });

    print("jijijihj");
    print(mealsData.body);

    return mealsData;
  }

  getMealsCal() {
    for (var i = 0; i < data["result"].length; i++) {
      for (var key in data["result"][i].keys) {
        meals = [];
        for (var j = 0; j < data["result"][i][key].length; j++) {
          date = data["result"][i][key][j]["start_date"];
          List test = [];
          mealsTrue = [];
          test.add(data["result"][i][key][j]["ticket"]);
          var meal = {
            "index": index,
            "check": false,
            "meal": "${data["result"][i][key][j]["meal"]}",
            "price": "${data["result"][i][key][j]["price"]}",
            "is_student_reserved": data["result"][i][key][j]
                ["is_student_reserved"],
            "pricemeal_id": "${data["result"][i][key][j]["pricemeal_id"]}",
            "ticket_id": test[0].isNotEmpty
                ? data["result"][i][key][j]["ticket"]["resto_ticket"]["id"]
                : "null"
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

  getKey() {
    for (var k in listmeals[0].keys) {
      listKey.add(k);
    }
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
    String today = DateTime.now().add(new Duration(days: 1)).toString();

    getMeals(
            widget._userId,
            widget._studentId,
            widget._token,
            new DateFormat('yyyy-MM-dd')
                .format(new DateTime.now().add(new Duration(days: 1))),
            addDays(today, 160))
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

  _showDialogDate() async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => new AlertDialog(
              title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    Text(
                      "La période du réservation : ",
                      style: TextStyle(color: Colors.blue),
                    )
                  ]),
              content: ListMeals(
                  widget._userId, widget._studentId, widget._token, this._list),
            ));
  }

  // flutter defined function
  bool check_all = false;

  filter_meal() async {
    setState(() {
      loading = true;
    });

    List a = await _showDialogDate();

    await get__Meals(a[0], a[1], a[2], a[3], a[4], a[5]);
    await getMealsCal();

    setState(() {
      loading = false;
    });
  }

  change(value) {
    if (value == true) {
      setState(() {
        check_all = true;
      });
      for (var i in listKey) {
        listmeals[0][i].forEach((val) {
          setState(() {
            val["check"] = true;
          });
          if (!priceIds.contains(int.parse(val["pricemeal_id"]))) {
            priceIds.add(int.parse(val["pricemeal_id"]));
          }

          if (!tikeckids.contains(val["ticket_id"]) &&
              val["ticket_id"].toString() != "null") {
            tikeckids.add(val["ticket_id"]);
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
            val["check"] = false;
          });
          if (priceIds.contains(int.parse(val["pricemeal_id"]))) {
            priceIds.remove(int.parse(val["pricemeal_id"]));
          }

          if (tikeckids.contains(val["ticket_id"])) {
            tikeckids.remove(val["ticket_id"]);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: listKey.isNotEmpty
          ? AppBar(
              // titleSpacing: 0.0,
              elevation: 0.0,
              backgroundColor: Colors.grey[200],
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
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      if (priceIds.length == 0) {
                        Scaffold.of(context).showSnackBar(new SnackBar(
                            content: new Text("Choisir une option")));
                      } else if (count1 == priceIds.length) {
                        Scaffold.of(context).showSnackBar(
                            new SnackBar(content: new Text("Deja resérvé")));
                      } else if (count2 == priceIds.length) {
                        Scaffold.of(context).showSnackBar(new SnackBar(
                            content: new Text("Deja non résérvé")));
                      } else {
                        setState(() {
                          wait = true;
                        });
                        makeReservationConf(widget._userId, widget._studentId,
                                widget._token, priceIds.join(","))
                            .then((val) {
                          for (var i in listKey) {
                            listmeals[0][i].forEach((val) {
                              if (priceIds
                                  .contains(int.parse(val["pricemeal_id"])))
                                setState(() {
                                  val["is_student_reserved"] = true;
                                  val["check"] = false;
                                });
                            });

                            setState(() {
                              wait = true;
                            });
                          }
                          priceIds = [];
                          count1 = 0;
                          count2 = 0;
                          setState(() {
                            check_all = false;
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
                    },
                    child: Text(
                      "Réserver",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600),
                    )),
                FlatButton(
                    child: Text(
                      "Annuler",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600),
                    ),
                    onPressed: () {
                      /* if (priceIds.length == 0) {
    Scaffold.of(context).showSnackBar(
    new SnackBar(content: new Text("Choisir une option")));
    } else {*/
                      if (priceIds.length == 0) {
                        Scaffold.of(context).showSnackBar(new SnackBar(
                            content: new Text("Choisir une option")));
                      } else {
                        makeCancel(widget._userId, widget._studentId,
                                widget._token, tikeckids.join(","))
                            .then((_) {
                          for (var i in listKey) {
                            listmeals[0][i].forEach((val) {
                              if (priceIds
                                  .contains(int.parse(val["pricemeal_id"])))
                                setState(() {
                                  val["is_student_reserved"] = false;
                                  val["check"] = false;
                                });
                            });
                          }

                          priceIds = [];
                          setState(() {
                            check_all = false;
                          });
                        });
                      }
                    })
              ],
              title: Text(
                "Sélectionner tous",
                style: TextStyle(color: Colors.grey[600], fontSize: 15.0),
              ))
          : AppBar(
              elevation: 0,
              backgroundColor: Colors.grey[50],
            ),
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
              child: CircularProgressIndicator(),
            )
          : listKey.isNotEmpty
              ? new ListView.builder(
                  itemCount: listmeals[0].length,
                  itemBuilder: (context, index) {
                    return new StickyHeader(
                      header: InkWell(
                        onTap: () {
                          /* getMealsDay(
                      widget._userId,
                      widget._studentId,
                      widget._token,
                      "${listKey[index]}",
                      "${addDays(listKey[index], 7)}");*/
                        },
                        child: _builBatchList(listKey[index]),
                      ),
                      content: new Container(
                          child:
                              Container() /*child: _builReservationList(listKey[index])*/),
                    );
                  })
              : Center(child: Text("Aucune réservation")),
    );
  }

  List<int> priceIds = [];

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

  List<Map<String, dynamic>> vv = [];

  Widget _builBatchList(String dd) {
    Widget timeCards;
    listmeals[0][dd].forEach((val) {
      vv.add(val);
    });

    if (vv.length > 0) {
      Container(
          child: timeCards = Column(
              children: vv
                  .map((Map<String, dynamic> val) =>
                      new Stack(children: <Widget>[
                        Slidable(
                            controller: ctrl,

                            //key: keys,
                            enabled: true,
                            actionPane: SlidableDrawerActionPane(),
                            // delegate: new SlidableDrawerDelegate(),
                            actionExtentRatio: 0.25,
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
                                        makeReservationConf(
                                                widget._userId,
                                                widget._studentId,
                                                widget._token,
                                                val["pricemeal_id"].toString())
                                            .then((_) {
                                          if (reservationData["result"] ==
                                              true) {
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
                            child: Card(
                                elevation: 8.0,
                                child: Container(
                                    padding: EdgeInsets.only(top: 8.0),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(width: 0.2))),
                                    child: Column(children: <Widget>[
                                      CheckboxListTile(

                                          /*  activeColor: containsElement(val["index"])
                                    ? Colors.grey
                                    : Colors.green,*/
                                          secondary: IconButton(
                                            padding: EdgeInsets.all(8.0),
                                            onPressed: () {
                                              Slidable.of(context)?.close();
                                            },
                                            icon: Icon(Icons.arrow_back),
                                          ),
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          value: val["check"],
                                          dense: true,
                                          onChanged: (value) {
                                            setState(() {
                                              if (val["check"] == false) {
                                                val["check"] = true;

                                                if (val[
                                                    "is_student_reserved"]) {
                                                  count1 = count1 + 1;
                                                } else {
                                                  count2 = count2 + 1;
                                                }

                                                priceIds.add(int.parse(
                                                    val["pricemeal_id"]));
                                                if (!tikeckids.contains(
                                                        val["ticket_id"]) &&
                                                    val["ticket_id"]
                                                            .toString() !=
                                                        "null") {
                                                  tikeckids
                                                      .add(val["ticket_id"]);
                                                }
                                              } else {
                                                val["check"] = false;
                                                priceIds.remove(int.parse(
                                                    val["pricemeal_id"]));

                                                if (tikeckids.contains(
                                                    val["ticket_id"])) {
                                                  tikeckids
                                                      .remove(val["ticket_id"]);
                                                }
                                              }
                                            });
                                          },
                                          title: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Image.asset(
                                                    "images/appointment.png",
                                                    color: Colors.blue[700],
                                                    width: 24.0,
                                                    height: 24.0,
                                                  ),
                                                  Container(
                                                    width: 8.0,
                                                  ),
                                                  Text(
                                                    "Date:",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Container(
                                                    width: 4.0,
                                                  ),
                                                  new Text(
                                                    "${_formatDate(dd.toString())}",
                                                  )
                                                ],
                                              ),
                                              Container(
                                                height: 12.0,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Image.asset(
                                                    "images/dish.png",
                                                    color: Colors.blue[700],
                                                    width: 24.0,
                                                    height: 24.0,
                                                  ),
                                                  Container(
                                                    width: 8.0,
                                                  ),
                                                  Text(
                                                    "Type de repas:",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Container(
                                                    width: 4.0,
                                                  ),
                                                  Text(
                                                    "${val["meal"]}",
                                                  )
                                                ],
                                              ),
                                              Container(
                                                height: 12.0,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Image.asset(
                                                    "images/coin.png",
                                                    color: Colors.blue[600],
                                                    width: 22.0,
                                                    height: 22.0,
                                                  ),
                                                  Container(
                                                    width: 10.0,
                                                  ),
                                                  Text(
                                                    "Prix:",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Container(
                                                    width: 4.0,
                                                  ),
                                                  Text("${val["price"]} DHS"),
                                                ],
                                              ),
                                            ],
                                          )),
                                      Container(
                                          padding: EdgeInsets.only(
                                              right: 8.0, bottom: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              Text(
                                                val["is_student_reserved"]
                                                    ? "Réservé"
                                                    : "Non réservé",
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    color:
                                                        val["is_student_reserved"]
                                                            ? Colors.pink[900]
                                                            : Colors
                                                                .green[600]),
                                              )
                                            ],
                                          )),
                                    ])))),
                      ]))
                  .toList()));
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
