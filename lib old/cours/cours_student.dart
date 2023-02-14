import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:ifdconnect/cours/viseo_card.dart';
import 'package:ifdconnect/models/conference.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/services/cours_services.dart';

class CoursStudent extends StatefulWidget {
  CoursStudent(this.user, this.user_id, this.token, this.type, {Key key})
      : super(key: key);
  var user_id;
  var token;
  User user;
  String type;

  @override
  _CoursStudentState createState() => _CoursStudentState();
}

class _CoursStudentState extends State<CoursStudent> {
  List<Conference> confs = [];
  bool loading = true;
  DateTime date_filter = DateTime.now();

  get_cours() async {
    setState(() {
      loading = true;
    });
    List results = await ServicesCours.get_cours_student(widget.user_id,
        widget.token, date_filter); //DateTime(2021, 09, 10).toString()
    if (!this.mounted) return;
    setState(() {
      confs = results;
      loading = false;
      print(confs);
    });
  }

  @override
  void initState() {
    super.initState();
    get_cours();
  }

  get_datetpicker() async {
    DateTime newDateTime = await showRoundedDatePicker(
      context: context,

      // initialDatePickerMode: DatePickerMode.year,
      initialDate: DateTime.now(),
      //  theme: ThemeData(primarySwatch: Fonts.col_app),
    );
    if(newDateTime != null) {
      setState(() {
        date_filter = newDateTime;
      });
      get_cours();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Séance en ligne",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        bottom: new PreferredSize(
            preferredSize: new Size.fromHeight(60),
            child: InkWell(
              child: Container(
                margin: EdgeInsets.all(10),
                padding:
                    EdgeInsets.only(top: 10, bottom: 10, left: 8, right: 8),
                height: 60,
                width: MediaQuery.of(context).size.width * 0.94,
                decoration: new BoxDecoration(
                    //borderRadius: new BorderRadius.all(const Radius.circular(8.0)),
                    color: const Color(0xffd1e9ec),
                    borderRadius: new BorderRadius.circular(10.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_today_outlined),
                    Container(
                      width: 8,
                    ),
                    Text(
                      "Date de cours :",
                      style: TextStyle(color: Fonts.col_app_fon, fontSize: 18),
                    ),
                    Container(
                      width: 10,
                    ),
                    Text(
                      new DateFormat('yyyy-MM-dd').format(date_filter),
                      style: TextStyle(fontSize: 18),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Icon(Icons.arrow_forward_ios)
                  ],
                ),
              ),
              onTap: () {
                get_datetpicker();
              },
            )),
      ),
      body: loading == true
          ? Center(
              child: CupertinoActivityIndicator(),
            )
          : (confs.isEmpty &&
                  DateTime.now().month == date_filter.month &&
                  DateTime.now().day == date_filter.day)
              ? Center(
                  child: Container(
                      child: Text(
                  "Vous n'avez aucun cours aujoud'hui !",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )))
              : (confs.isEmpty)
                  ? Center(
                      child: Container(
                          child: Text(
                      "Aucun cours programmé pour ce jour !",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )))
                  : ListView(
                      children: confs
                          .map((e) => ViseoCard(
                              widget.user, e, widget.user_id, widget.type))
                          .toList()),
    );
  }
}
