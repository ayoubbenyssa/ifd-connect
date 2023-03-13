import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:ifdconnect/config/config.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:ifdconnect/campus/shared/fixdropdown.dart';
import 'package:ifdconnect/models/meal.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'all_meals_calendar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ListMeals extends StatefulWidget {
  final int _userId;
  final int _studentId;
  final int _token;
  List<Meal> list;
  DateTime date_debut;
  DateTime date_fin;

  ListMeals(this._userId, this._studentId, this._token, this.list);

  @override
  _ListMealsState createState() => _ListMealsState();
}

class _ListMealsState extends State<ListMeals> {
  var data;
  InputType inputType = InputType.date;
  bool editable = true;

  String dateD;
  final _formKey = GlobalKey<FormState>();

  final formats = {
    InputType.both: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
    InputType.date: DateFormat('yyyy-MM-dd'),
    InputType.time: DateFormat("HH:mm"),
  };
  SharedPreferences prefs;


  String _formaterDate(DateTime dd) {
    var formatter = new DateFormat('yyyy-MM-dd');
    return formatter.format(dd);
  }

  Future<http.Response> getMeals(int user_id, int student_id, int token,
      String start_date, String end_date) async {
    prefs = await SharedPreferences.getInstance();

    final param = {
      "user_id": "$user_id",
      "student_id": "$student_id",
      "auth_token": "$token",
      "start_date": "$start_date",
      "end_date": "$end_date",
      "meal_id": "$sel_id"
    };

    final mealsData = await http.post(
      "${"${prefs.getString('api_url')}"}/all_meals_calendar",
      body: param,
    );
    setState(() {
      data = json.decode(mealsData.body);
    });

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AllMealsCalendar(
                data, widget._userId, widget._studentId, widget._token)));

    return mealsData;
  }

  String selectedValue = "";
  String name_repas ;
  String sel_id = "all";

  Widget drop_down() => new Container(
      // color: Colors.red,
      // width: 700.0.w,
      height: 45.0.h,
      child: Container(
          // margin: const EdgeInsets.all(8.0),
          // padding:  EdgeInsets.only(left: 7.0.w, right: 7.0.w),
          decoration: new BoxDecoration(
            color: Fonts.col_cl,
            border: new Border.all(color: Fonts.border_col, width: 0.5.w),
            borderRadius: new BorderRadius.circular(22.0.r),
          ),
          child: new FixDropDown(

              iconSize: 35.0.r,
              isDense: false,
              items: widget.list.map((Meal value) {
                return new FixDropdownMenuItem(
                  value: value,
                  child: new Text(
                    value.name.toString(),
                    maxLines: 2,
                    softWrap: true,
                  ),
                );
              }).toList(),
              hint: new Text(
                selectedValue != "" ? selectedValue : "Choisir un repas",
                maxLines: 1,
                softWrap: true,
                style: new TextStyle(color: Fonts.col_grey , fontSize: 18.sp ,fontWeight: FontWeight.bold),
              ),
              onChanged: (Meal value) {
                setState(() {
                  selectedValue = value.name;
                  name_repas = value.name ;
                  print("${name_repas}");
                  print("${selectedValue}");

                  print("${value.id}");

                  sel_id = value.id.toString();
                });
              })));

  @override
  Widget build(BuildContext context) => Container(
      margin: EdgeInsets.only(top: 0),
      padding: EdgeInsets.only(top: 0),
      height: 220.0.h,
      child: Scaffold(
          backgroundColor: Colors.transparent,
          //appBar: AppBar(title: Text("test")),
          body: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                drop_down(),
                SizedBox(height: 10.0.h),
                Container(
                  height: 45.h,
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  decoration: new BoxDecoration(
                    color: Fonts.col_cl,
                    border: new Border.all(color: Fonts.border_col, width: 0.5.w),
                    borderRadius: new BorderRadius.circular(22.0.r),
                  ),
                  child: DateTimePickerFormField(
                    validator: (value) {
                      if (value == null) {
                        return 'Il faut choisir une date';
                      }
                    },
                    inputType: inputType,
                    initialDate: new DateTime.now().add(new Duration(days: 1)),
                    firstDate: new DateTime.now(),
                    format: formats[inputType],
                    editable: editable,
                    decoration: InputDecoration(
                        border: InputBorder.none,

                        labelStyle: TextStyle(
                        color: Fonts.col_grey ,fontWeight: FontWeight.bold , fontSize: 17.sp
                      ),
                        labelText: 'Date de début'/*,
                        hasFloatingPlaceholder: false*/),
                    onChanged: (dt) => setState(() => widget.date_debut = dt),
                  ),
                ),
                SizedBox(height: 12.0.h),
                Container(
                  height: 45.h,

                  padding: EdgeInsets.symmetric(horizontal: 5.w),

                  decoration: new BoxDecoration(
                    color: Fonts.col_cl,
                    border: new Border.all(color: Fonts.border_col, width: 0.5.w),
                    borderRadius: new BorderRadius.circular(22.0.r),
                  ),
                  child: DateTimePickerFormField(

                    validator: (value) {
                      if (value == null) {
                        return 'Il faut choisir une date';
                      }
                      if (value.isBefore(widget.date_debut)) {
                        return 'Choisir une autre date';
                      }
                    },
                    inputType: inputType,
                    initialDate: new DateTime.now().add(new Duration(days: 1)),
                    firstDate: new DateTime.now(),
                    format: formats[inputType],
                    editable: editable,
                    decoration: InputDecoration(
                        border: InputBorder.none,

                        labelStyle: TextStyle(
                            color: Fonts.col_grey ,fontWeight: FontWeight.bold , fontSize: 17.sp
                        ),
                        labelText: 'Date de Fin'/*,
                        hasFloatingPlaceholder: false*/),
                    onChanged: (dt) => setState(() => widget.date_fin = dt),
                  ),
                ),
                SizedBox(height: 16.0),
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 30.w),
                  child: RaisedButton(
                    elevation: 0.0,
                    child: Text(
                      "OK",
                      style: TextStyle(color: Colors.white),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.r)),
                    color: Fonts.col_app,
                    onPressed: () {

                      if (_formKey.currentState.validate()) {
                        Navigator.pop(context, [
                          widget._userId,
                          widget._studentId,
                          widget._token,
                          _formaterDate(widget.date_debut),
                          _formaterDate(widget.date_fin),
                          sel_id,
                          name_repas
                        ]);
                        /*getMeals(
                            widget._userId,
                            widget._studentId,
                            widget._token,
                            _formaterDate(date_debut),
                            _formaterDate(date_fin));*/
                      }
                    },
                  ),
                ),
              ],
            ),
          )));
}
