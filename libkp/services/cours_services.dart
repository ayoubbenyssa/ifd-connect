import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ifdconnect/models/conference.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServicesCours {
  static get_cours_student(student_id, token, date) async {
    final param = {
      "user_id": "$student_id", //user_id
      "auth_token": "$token",
      "date": date.toString()
    };

    print(student_id);
    print(token);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.post(
      "${prefs.getString('api_url')}/online_meeting_rooms",
      body: param,
    );

    var data = json.decode(response.body);
    print(data);
    // List res = data["rooms"];
    List res = data["result"];
    return res
        .map((var contactRaw) =>
            new Conference.fromDoc(contactRaw["online_meeting_room"], data["rooms"][res.indexOf(contactRaw)]["created_by"]))
        .toList();

  }
}
