import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ifdconnect/config/config.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'Resto.dart';

class AllMyReservation extends StatefulWidget {
  final int _userId;
  final int _studentId;
  final int _token;

  AllMyReservation(this._userId, this._studentId, this._token);

  @override
  _AllReservationState createState() => _AllReservationState();
}

class _AllReservationState extends State<AllMyReservation> {
  var data;
  bool loading = true;

  Future<http.Response> allReservation(
      int user_id, int student_id, int token) async {
    final param = {
      "user_id": "$user_id",
      "student_id": "$student_id",
      "auth_token": "$token",
    };

    final reservationsData = await http.post(
      "${Config.url_api}/all_reservations",
      body: param,
    );
    setState(() {
      data = json.decode(reservationsData.body);
    });

    return reservationsData;
  }

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

  List reservations = [];

  getReservations() {
    print(data["result"]);

    for (var keyReservation in data["result"].keys) {
      for (var keyTicket in data["result"][keyReservation].keys) {
        var reservation = {
          "meal": "${data["result"][keyReservation][keyTicket][0]["meal"]}",
          "price": "${data["result"][keyReservation][keyTicket][0]["price"]}",
          "reservation_id":
              "${data["result"][keyReservation][keyTicket][0]["reservation_id"]}",
          "check": false,
          "ticket_id": "$keyTicket",
          "date":
              "${data["result"][keyReservation][keyTicket][0]["start_date"]}",
        };
        reservations.add(reservation);
      }
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    allReservation(widget._userId, widget._studentId, widget._token).then((_) {
      getReservations();
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

  Widget _buildNewsList() {
    Widget moduleItems;
    if (reservations.length > 0) {
      moduleItems = ListView.builder(
        itemBuilder: (context, index) {
          return new Slidable(
            // delegate: new SlidableDrawerDelegate(),
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            child: new Container(
              color: Colors.white,
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(style: BorderStyle.solid, width: 0.2))),
                child: new ListTile(
                  title: new Text(
                      "${reservations[index]["meal"]} (${reservations[index]["price"]} DHS)"),
                  subtitle: new Text(
                      'Réservé pour : ${_formatDate(reservations[index]["date"])} '),
                ),
              ),
            ),
            secondaryActions: <Widget>[
              new IconSlideAction(
                caption: 'Annuler',
                color: Colors.red,
                icon: Icons.cancel,
                onTap: () {
                  setState(() {
                    String ticket = reservations[index]["ticket_id"];
                    reservations.removeAt(index);
                    makeCancel(widget._userId, widget._studentId, widget._token,
                        ticket);
                  });
                },
              ),
            ],
          );
        },
        itemCount: reservations.length,
      );
    } else {
      moduleItems = Container();
    }
    return moduleItems;
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ],
              ),
              Text(
                "La période du réservation : ",
                style: TextStyle(                    color: Fonts.col_app,
                ),
              )
            ],
          ),
          content:
              ListMeals(widget._userId, widget._studentId, widget._token, []),
        );
      },
    );

    // flutter defined function
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Fonts.col_app,
          onPressed: () {
            _showDialog();
          },
          child: Icon(
            Icons.add,
          ),
        ),
        body: loading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: <Widget>[
                  Expanded(
                    child: _buildNewsList(),
                  )
                ],
              ));
  }
}
