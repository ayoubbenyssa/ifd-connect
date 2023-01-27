import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ifdconnect/campus//login/LoginPage.dart';
import 'package:ifdconnect/campus/employee/emploiDuTemp/Time_tables.dart';
import 'package:ifdconnect/campus/employee/notes_absence/Batch_List.dart';
import 'package:http/http.dart' as http;
import 'package:ifdconnect/config/config.dart';
import 'dart:convert';

import 'package:ifdconnect/services/Fonts.dart';

class ProfHome extends StatefulWidget {
  final int _userId;
  final int _employeeId;
  final int _token;
  static String routeName = "/homePage";
  bool chef_dept;

  ProfHome(this._userId, this._employeeId, this._token, this.chef_dept);
  @override
  State<StatefulWidget> createState() {
    return new _ProfHomeState();
  }
}

class _ProfHomeState extends State<ProfHome> {
  var data;

  logout() async {
   /* Navigator.push(
        context, MaterialPageRoute(builder: (context) => Login(null, null,false,false,null)));*/
  }

  //init state function
  @override
  void initState() {
    //getSessionParams();
    super.initState();
  }

  int _currentIndex = 0;
  List<Widget> _children;
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<http.Response> profile(int user_id, int employee_id, int token) async {
    final param = {
      "user_id": "$user_id",
      "employee_id": "$employee_id",
      "auth_token": "$token",
    };

    final profileData = await http.post(
      "${Config.url_api}/profile_employee",
      body: param,
    );
    setState(() {
      data = json.decode(profileData.body);
    });

    return profileData;
  }

  void _showDialog() {
    profile(widget._userId, widget._employeeId, widget._token).then((_){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage("${data["employee"]["employee"]["picture"]}"),
              ),
              title: Text("${data["employee"]["employee"]["full_name"]}"),
              subtitle: Text("${data["employee"]["employee"]["email"]}"),
            ),
            content: new Text("Département : ${data["employee"]["employee"]["department"]}"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Fermé"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    });
    // flutter defined function

  }

  @override
  Widget build(BuildContext context) {
    _children = [
      BatchesPage(widget._userId, widget._employeeId, widget._token, widget.chef_dept),
      TimeTableEmployee(widget._userId, widget._employeeId, widget._token),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                logout();
              }),
          IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                _showDialog();
              }),

        ],
        leading: Icon(Icons.home),
        title: Text('Campus',style: TextStyle(color: Colors.white),),
        elevation: 0.0,
      ),
      body: _children[_currentIndex], // new
      bottomNavigationBar: BottomNavigationBar(

        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped,
        // new
        currentIndex: _currentIndex, // new
        items: [
          new BottomNavigationBarItem(
              icon: Icon(Icons.school,
                  color: _currentIndex != 0 ? Colors.grey : Fonts.col_app),
              title: Text('Notes et Absences',
                  style: TextStyle(
                      color: _currentIndex != 0 ? Colors.grey : Fonts.col_app))),
          new BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today,
                  color: _currentIndex != 1 ? Colors.grey : Fonts.col_app),
              title: Text('Emploi du temps',
                  style: TextStyle(
                      color: _currentIndex != 1 ? Colors.grey : Fonts.col_app))),
        ],
      ),
    );
  }
}
