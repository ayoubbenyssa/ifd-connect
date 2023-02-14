import 'package:ifdconnect/func/parsefunc.dart';

class ParticipateServices {
  ParseServer parseFunctions = new ParseServer();

  String objectId;
  DateTime createdAt;
  var post;
  var author;

  ParticipateServices({this.objectId, this.createdAt, this.author, this.post});

  ParticipateServices.fromMap(Map<String, dynamic> map)
      : objectId = map['objectId'],
        createdAt = DateTime.parse(map['createdAt']),
        author = map['author'],
        post = map['post'];

  isliked(String idauthor, String idpost) async {
    if (idpost == null || idauthor == null) return false;
    var liked = await parseFunctions.getparse(
        'participate?where={"author":{"\$inQuery":{"where":{"objectId":"$idauthor"},"className":"users"}},"post":{"\$inQuery":{"where":{"objectId":"$idpost"},"className":"offers"}}}&count=1&limit=1');
    if (liked == "nointernet" || liked== "error") return false;
    if (liked["count"] > 0) return true;
    return false;
  }

  like(String idauthor, String idpost,tel) async {

    if (idpost == null || idauthor == null) return false;
    var liked = await parseFunctions.getparse(
        'participate?where={"author":{"\$inQuery":{"where":{"objectId":"$idauthor"},"className":"users"}},"post":{"\$inQuery":{"where":{"objectId":"$idpost"},"className":"offers"}}}&count=1&limit=1');
    if (liked == "nointernet" || liked== "error") return liked;
    if (liked["results"].length == 0) {
      var jss = {
        "author": {"__type": "Pointer", "className": "users", "objectId": idauthor},
        "post": {"__type": "Pointer", "className": "offers", "objectId": idpost},
        "tel":tel
      };
      var a = await parseFunctions.postparse('participate', jss);

      return await updatenumberlikes(idpost, true);
    } else {
      for (var item in liked["results"]) {
        await parseFunctions.deleteparse("participate/" + item["objectId"]);
      }
      return updatenumberlikes(idpost, false);
    }
  }

  numberlikes(String idpost) async {
    var numberposts = await parseFunctions.getparse(
        'participate?where={"post":{"\$inQuery":{"where":{"objectId":"$idpost"},"className":"offers"}} }&count=1&limit=0');
    if (numberposts == "nointernet" || numberposts== "error") return "0";
    return numberposts["count"];
  }

  updatenumberlikes(String idpost, bool liked) async {
    var nmb = await numberlikes(idpost);
    if (nmb == "nointernet" || nmb== "error") return false;
    parseFunctions.putparse('offers/$idpost', {"participatenumb": nmb});
    return {"participatenumb": nmb, "isLiked": liked};
  }
}
