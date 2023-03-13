
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ifdconnect/campus/etudiant/classPackge/Etudiant.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CampusServices {

  Etudiant etudiant = new Etudiant();
  var data;

  Future profile_etud(int user_id, int student_id, int token) async {
    final param = jsonEncode(<String, Object>{
      "user_id": "$user_id",
      "student_id": "$student_id",
      "auth_token": "$token",
    });

    print("user_id $user_id");
    print("employee_id: $student_id");
    print("auth_token $token");


    // final profileData = await http.get(
    //   "${prefs.getString('api_url')}/profile?user_id=${user_id}&student_id=${student_id}&auth_token=${token}",
    //   headers: { "Content-type": "application/json" },
    // );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final profileData = await http.post(
      "${prefs.getString('api_url')}/profile",
      headers: { "Content-type": "application/json" },
      body: param,
    );


    print("_____________");
    print(profileData.body);


    data = json.decode(profileData.body);

    if(data["status"] == false)
      return false ;
    else
      return  new Etudiant.fromJson(data["student"]["student"]);
  }


  Future profile_emp(int user_id, int student_id, int token) async {

    final param = {
      "user_id": "$user_id",
      "employee_id": "$student_id",
      "auth_token": "$token",
    };

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final profileData = await http.post(
      "${prefs.getString('api_url')}/profile_employee",
      body: param,
    );

    data = json.decode(profileData.body);
    if(data["status"] == false)
      return false ;
    else
      return  data;
  }

}