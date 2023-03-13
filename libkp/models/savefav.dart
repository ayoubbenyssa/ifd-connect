import 'package:ifdconnect/func/parsefunc.dart';

class SaveFav {
  ParseServer parseFunctions = new ParseServer();

  String objectId;
  DateTime createdAt;
  var post;
  var author;

  SaveFav({this.objectId, this.createdAt, this.author, this.post});

  SaveFav.fromMap(Map<String, dynamic> map)
      : objectId = map['objectId'],
        createdAt = DateTime.parse(map['createdAt']),
        author = map['author'],
        post = map['post'];

  isliked(String idauthor, String idpost) async {
    if (idpost == null || idauthor == null) return false;
    var liked = await parseFunctions.getparse(
        'save_fav?where={"author":{"\$inQuery":{"where":{"objectId":"$idauthor"},"className":"users"}},"post":{"\$inQuery":{"where":{"objectId":"$idpost"},"className":"offers"}}}&count=1&limit=1');
    if (liked == "nointernet" || liked== "error") return false;
    if (liked["count"] > 0) return true;
    return false;
  }

  like(String idauthor, String idpost) async {

    if (idpost == null || idauthor == null) return false;
    var liked = await parseFunctions.getparse(
        'save_fav?where={"author":{"\$inQuery":{"where":{"objectId":"$idauthor"},"className":"users"}},"post":{"\$inQuery":{"where":{"objectId":"$idpost"},"className":"offers"}}}&count=1&limit=1');
    if (liked == "nointernet" || liked== "error") return liked;
    if (liked["results"].length == 0) {
      var jss = {
        "author": {"__type": "Pointer", "className": "users", "objectId": idauthor},
        "post": {"__type": "Pointer", "className": "offers", "objectId": idpost}
      };
      var a = await parseFunctions.postparse('save_fav', jss);
      print(a);

      return await updatenumberlikes(idpost, true);
    } else {
      for (var item in liked["results"]) {
        await parseFunctions.deleteparse("save_fav/" + item["objectId"]);
      }
      return updatenumberlikes(idpost, false);
    }
  }

  numberlikes(String idpost) async {
    var numberposts = await parseFunctions.getparse(
        'save_fav?where={"post":{"\$inQuery":{"where":{"objectId":"$idpost"},"className":"offers"}} }&count=1&limit=0');
    if (numberposts == "nointernet" || numberposts== "error") return "0";
    return numberposts["count"];
  }

  updatenumberlikes(String idpost, bool liked) async {
    var nmb = await numberlikes(idpost);
    if (nmb == "nointernet" || nmb== "error") return false;
    parseFunctions.putparse('offers/$idpost', {"numberlikes": nmb});
    return {"numberlikes": nmb, "isLiked": liked};
  }
}
