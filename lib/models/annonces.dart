import 'package:intl/intl.dart';
import 'package:ifdconnect/models/user.dart';

class Annonces {
  var objectId;
  var type = "";
  var address = "";
  var createdDate = "";
  var description = "";
  var title = "";
  var image = "";
  List pics;
  User author;
  var dte;
  var count = 0;
  var views = 0;

  Annonces(
      {this.objectId,
      this.type,
      this.address,
      this.createdDate,
      this.image,
      this.description,
      this.count,
      this.dte,
      this.author});

  Annonces.fromMap(Map<String, dynamic> document)
      : objectId = document["objectId"],
        type = document["type"],
        dte = document["time_an"],
        count = document["count"].toString() == "null" ? 0 : document["count"],
        views = document["views"].toString() == "null" ? 0 : document["views"],
      pics = document["pictures"],
        image = document["image"],
        title = document["title"],
        address = document["address"],
        createdDate = document["time_an"].toString(),
        description = document["description"],
        author = new User.fromMap(document["author1"]);
}
