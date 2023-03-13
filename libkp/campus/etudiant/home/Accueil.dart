import 'package:flutter/material.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ifdconnect/campus/etudiant/releve/Modules.dart';
import 'package:ifdconnect/campus/login/LoginPage.dart';
import 'package:ifdconnect/campus/etudiant/classPackge/Etudiant.dart';
import 'package:ifdconnect/campus/etudiant/absences/AbsencesPage.dart';
import 'package:ifdconnect/campus/etudiant/news/News.dart';
import 'package:ifdconnect/campus/etudiant/emploiDuTemp/Time_tables.dart';

class EtudiantHome extends StatefulWidget {
  final int _userId;
  final int _studentId;
  final int _token;
  static String routeName = "/homePage";
  User user;

  EtudiantHome(this.user, this._userId, this._studentId, this._token);

  @override
  State<StatefulWidget> createState() {
    return new _EtudiantHomeState();
  }
}

class _EtudiantHomeState extends State<EtudiantHome> {
  Etudiant etudiant = new Etudiant();
  var data;

  logout() async {}

  /*getSessionParams() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getInt("user_id");
      _studentId = prefs.getInt("student_id");
      _token = prefs.getInt("auth_token");
    });
  }*/

  //profile function
  Future<http.Response> profile(int user_id, int student_id, int token) async {
    final param = {
      "user_id": "$user_id",
      "student_id": "$student_id",
      "auth_token": "$token",
    };
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final profileData = await http.post(
      "${prefs.getString('api_url')}/profile",
      body: param,
    );
    setState(() {
      data = json.decode(profileData.body);
      etudiant = new Etudiant.fromJson(data["student"]["student"]);
    });

    return profileData;
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

  void _showDialog() {
    profile(widget._userId, widget._studentId, widget._token).then((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: ListTile(
              leading: CircleAvatar(
                maxRadius: 30,
                backgroundImage: NetworkImage("${etudiant.picture}"),
              ),
              title: Text("${etudiant.last_name} ${etudiant.first_name}"),
              subtitle: Text("${etudiant.email}"),
            ),
            content: new Text("Filière : ${etudiant.school_field}"),
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
      MyHomePageNote(
          'Les notes', widget._userId, widget._studentId, widget._token),
      NewsPage(widget._userId, widget._studentId, widget._token, widget.user.employee_id),
      AbsencePage(
          widget.user, widget._userId, widget._studentId, widget._token),
      TimeTable(widget._userId, widget._studentId, widget._token),
    ];
    return Scaffold(
      appBar: AppBar(
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
              })
        ],
        leading: Icon(Icons.home),
        title: Text(
          'Campus',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0.0,
      ),
      body: _children[_currentIndex], // new
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped,
        // new
        currentIndex: _currentIndex, // new
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.school,
                color: _currentIndex != 0 ? Colors.grey : Fonts.col_app),
            title: Text(
              'Modules',
              style: TextStyle(
                  color: _currentIndex != 0 ? Colors.grey : Fonts.col_app),
            ),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.book,
                color: _currentIndex != 1 ? Colors.grey : Fonts.col_app),
            title: Text('News',
                style: TextStyle(
                    color: _currentIndex != 1 ? Colors.grey : Fonts.col_app)),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.library_books,
                color: _currentIndex != 2 ? Colors.grey : Fonts.col_app),
            title: Text('Absences',
                style: TextStyle(
                    color: _currentIndex != 2 ? Colors.grey : Fonts.col_app)),
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today,
                  color: _currentIndex != 3 ? Colors.grey : Fonts.col_app),
              title: Text('E.T',
                  style: TextStyle(
                      color:
                          _currentIndex != 3 ? Colors.grey : Fonts.col_app))),
        ],
      ),
    );
  }
}
