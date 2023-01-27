class Session {
  final int status;
  final int user_id;
  final int student_id;
  final int auth_token;

  Session({this.status, this.user_id, this.student_id, this.auth_token});

  factory Session.fromJson(Map<String, dynamic> parsedJson) {
    return Session(
      status: parsedJson["status"],
      user_id: parsedJson["user_id"],
      student_id: parsedJson["student_id"],
      auth_token: parsedJson["auth_token"],
    );
  }
}
