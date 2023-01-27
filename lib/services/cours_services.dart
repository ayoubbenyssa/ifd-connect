import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ifdconnect/config/config.dart';
import 'package:ifdconnect/models/conference.dart';

class ServicesCours {
  static get_cours_student(student_id, token, date) async {
    final param = {
      "user_id": "$student_id", //user_id
      "auth_token": "$token",
      "date": date.toString()
    };

    print(student_id);
    print(token);

    final response = await http.post(
      "${Config.url_api}/online_meeting_rooms",
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
