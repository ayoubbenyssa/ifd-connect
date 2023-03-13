import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ifdconnect/models/classe.dart';
import 'package:ifdconnect/models/detail.dart';
import 'package:ifdconnect/models/student.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Absence_repository {
  get_details_seances(
      User prof, Student student, DateTime date, batch_id) async {
//
    final param = {
      "user_id": "${prof.user_id}",
      "employee_id": "${prof.employee_id}",
      "auth_token": "${prof.token_user}",
      "date": date.toString(),
      "student_id": "${student.student_id}",
      "batch_id": "${batch_id}"
    };
    print("------------------");

    print(param);

    print("------------------");


    /**
        "date"
        "student_id"

     */

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final profileData = await http.post(
      "${prefs.getString('api_url')}/list_ttes_by_day",
      body: param,
    );
    print("param");
    print(param);
    print("param");


    var data = json.decode(profileData.body);
    print("@@@@@@@@@@@@@@@@@@@@@@@");
    print(data);
    print("--------------------");

    // return List<Detail>.from(data.map((i) => Detail.fromMap(i)).toList());
    return data ;
  }

  classe_list(User user) async {
    final param = {
      "user_id": "${user.user_id}",
      "employee_id": "${user.employee_id}",
      "auth_token": "${user.token_user}",
    };

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final profileData = await http.post(
      "${prefs.getString('api_url')}/list_batches",
      body: param,
    );

    print(profileData.body);

    var data = json.decode(profileData.body)["result"];
    print(data);
    return List<Classe>.from(data.map((i) => Classe.fromMap(i)).toList());
  }

  students_list(User user, var batch_id) async {
    final param = {
      "user_id": "${user.user_id}",
      "employee_id": "${user.employee_id}",
      "auth_token": "${user.token_user}",
      "batch_id": "${batch_id}",
    };

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final profileData = await http.post(
      "${prefs.getString('api_url')}/list_students",
      body: param,
    );

    var data = json.decode(profileData.body)["result"]["students"];
    for (var i in data) {
      print(i);
    }
    return List<Student>.from(
        data.map((i) => Student.fromMap(i["student"])).toList());
  }

  /**
      ${prefs.getString('api_url')}/add_attendance
      Params :


      "tte_ids"  ===> si un array des entrées choisies

   */

  add_absence(params) async {
//

  final param = params/*{
    "user_id": "${prof.user_id}",
    "employee_id": "${prof.employee_id}",
    "auth_token": "${prof.token_user}",
    "date": date.toString(),
    "student_id": "${student.student_id}",
    "batch_id": "${batch_id}",
    "tte_ids": ids
  }*/;
  print("add_absence");
  print(json.encode(param));
  print("add_absence -----------------------------------------");

  SharedPreferences prefs = await SharedPreferences.getInstance();
  final profileData = await http.post(
      "${prefs.getString('api_url')}/add_attendance",
        headers: {
          "Content-type": "application/json"
        },
      body: json.encode(param)
    );

    print(profileData.body);

  }

  delete_attendence(id,user_id,employee_id,auth_token,date,student_id,batch_id) async {
//

    final ids = id/*{
    "user_id": "${prof.user_id}",
    "employee_id": "${prof.employee_id}",
    "auth_token": "${prof.token_user}",
    "date": date.toString(),
    "student_id": "${student.student_id}",
    "batch_id": "${batch_id}",
    "tte_ids": ids
  }*/;
  final  params = {
    "id":"$ids",
    "user_id":"$user_id",
    "employee_id":"$employee_id",
    "auth_token":"$auth_token",
    "date":"$date",
    "student_id":"$student_id",
    "batch_id":"$batch_id",

  };
    print("delete_attendence");
    print(json.encode(params));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final profileData = await http.post(
      "${prefs.getString('api_url')}/delete_attendance",
        headers: {
          "Content-type": "application/json"
        },
      body: json.encode(params)
    );
print("@@@@@");
    print(profileData.body);

  }



}
