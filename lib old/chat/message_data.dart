class Message {
  //String id;
  String lastmessage = "";
  DateTime timestamp;
  String nameUser = "";
  String idUser = "";
  String photoURL = "";
  String key = "";
  String idOther = "";
  String imageURL = "";
  String name = "";
  String avatar =
      "";
  String text = "";

  Message({this.lastmessage, timestamp});
  Message.fromMap(Map<String, dynamic> map)
      : lastmessage = "${map['lastmessage']}",
        name = "${map['senderName']}",
        avatar = "${map['senderPhotoUrl']}",
        key = "${map['key']}",
        text = "${map['text']}",
        timestamp = DateTime.parse("${map['timestamp']}"),
        imageURL = "${map['imageUrl']}";
}

class Message2 {
  //String id;
  String lastmessage;
  DateTime timestamp;
  String nameUser = "";
  String idUser = "";
  String photoURL = "";
  String key = "";
  String idOther = "";
  String imageURL = "";
  String name = "";
  String avatar = "";
  String text = "";

  Message2({this.lastmessage, timestamp});
  Message2.fromMap(Map<String, dynamic> map)
      : name = "${map['senderName']}",
        avatar = "${map['senderPhotoUrl']}",
        text = "${map['text']}",
        imageURL = "${map['imageUrl']}";
}
