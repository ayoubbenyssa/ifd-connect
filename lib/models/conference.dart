
class Conference {
  String attendeePW;
  String meetingID;
  var moderatorPW;
  String name;
  var url;
  DateTime date;
  String user_name;
  bool check = false;
  var is_published;
  var userid;
  var welcome_msg;

  /**
      "tte_id":12280,
      "is_active":true,
      "randomize_meetingid":true
   */

  Conference(
      {
      this.attendeePW,
      this.meetingID,
      this.name,
        this.is_published,
      this.moderatorPW,
      this.url,
      this.date,
        this.welcome_msg,
        this.userid,
      this.user_name});

  factory Conference.fromDoc(document,createdBy) {
    print("-----");
    print(document["user_id"]);
    return new Conference(
        attendeePW: document["attendee_password"],
        date: DateTime.parse(document["scheduled_on"]),
        meetingID: document["meetingid"],
        userid: document["user_id"],
        welcome_msg: document["welcome_msg"],
        is_published: document["is_published"],
        name: document["name"],
        moderatorPW: document["moderator_password"],
        user_name: createdBy.toString());
  }
}
