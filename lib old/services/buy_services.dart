import 'package:ifdconnect/func/parsefunc.dart';

class BuyServices {
  ParseServer parseFunctions = new ParseServer();

  String objectId;
  DateTime createdAt;
  var post;
  var author;

  BuyServices({this.objectId, this.createdAt, this.author, this.post});

  BuyServices.fromMap(Map<String, dynamic> map)
      : objectId = map['objectId'],
        createdAt = DateTime.parse(map['createdAt']),
        author = map['author'],
        post = map['post'];

  isliked(String idauthor, String idpost) async {
    if (idpost == null || idauthor == null) return false;
    var liked = await parseFunctions.getparse(
        'buy?where={"author":{"\$inQuery":{"where":{"objectId":"$idauthor"},"className":"users"}},"post":{"\$inQuery":{"where":{"objectId":"$idpost"},"className":"offers"}}}&count=1&limit=1');
    if (liked == "nointernet" || liked == "error") return false;
    if (liked["count"] > 0) return true;
    return false;
  }

  like(String idauthor, String idpost, dte) async {
    if (idpost == null || idauthor == null) return false;
    var liked = await parseFunctions.getparse(
        'buy?where={"author":{"\$inQuery":{"where":{"objectId":"$idauthor"},"className":"users"}},"post":{"\$inQuery":{"where":{"objectId":"$idpost"},"className":"offers"}}}&limit=1');

    if (liked == "nointernet" || liked == "error") return "error";

    print("*****************************************************************************************************************************************");
    print(liked);

    if (liked["results"].length == 0) {
      return false;
    } else {

       // await parseFunctions.deleteparse("buy/" + liked["results"]["objectId"]);

      return liked;
    }
  }

  /* var jss = {
        "author": {
          "__type": "Pointer",
          "className": "users",
          "objectId": idauthor
        },
        "post": {
          "__type": "Pointer",
          "className": "offers",
          "objectId": idpost,
          "dte": dte.toString()
        }
      };
      var a = await parseFunctions.postparse('buy', jss);*/

  numberlikes(String idpost) async {
    var numberposts = await parseFunctions.getparse(
        'buy?where={"post":{"\$inQuery":{"where":{"objectId":"$idpost"},"className":"offers"}} }&count=1&limit=0');
    if (numberposts == "nointernet" || numberposts == "error") return "0";
    return numberposts["count"];
  }

  updatenumberlikes(String idpost, bool liked, id, dte) async {
    var nmb = await numberlikes(idpost);
    if (nmb == "nointernet" || nmb == "error") return false;
    parseFunctions.putparse('offers/$idpost', {"numberlikes": nmb});
    return {"numberlikes": nmb, "isLiked": liked, "id": id, "dte": dte};
  }
}
