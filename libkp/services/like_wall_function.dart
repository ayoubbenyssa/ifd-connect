import 'package:ifdconnect/func/parsefunc.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LikeFunctions {
  ParseServer parseFunctions = new ParseServer();


  isliked(objectId,idUser) async {

    var liked = await parseFunctions.getparse(
        'likes1?where={"idPost":"$objectId","idUser":"$idUser"}&count=1&limit=0');
    if (liked == "nointernet" || liked == "error") return false;
    if (liked["count"] > 0) return true;
    return false;
  }

  like(idpost, context, idUser) async {


    var result;
    var liked = await parseFunctions.getparse('likes1?where={"idPost":"$idpost","idUser":"$idUser"}');
    if (liked == "nointernet") return "nointernet";
    if (liked == "error") {
      result = "error";
    } else {


      if (liked["results"].length == 0) {

        var jss = {
          "idPost": idpost,
          "idUser": idUser,
        };
        parseFunctions.postparse('likes1', jss);
         /*parseFunctions.putparse(
            "offers/$idpost", {"numberlikes": });*/
        result = true;



      } else {
        for (var item in liked["results"]) {
          await parseFunctions.deleteparse("likes1/" + item["objectId"]);
        }
        result = false;
      }
      var number = await numberLikes(idpost);
      parseFunctions.putparse(
          "offers/$idpost", {"numberlikes": number});
      var isLiked = await isliked(idpost,idUser);

      return {"numberLikes": number, "isLiked": isLiked};
    }

    return result;
  }

  numberLikes(idPost) async {
    var numberlikes = await parseFunctions
        .getparse('offers?where={"objectId":"$idPost"}&count=1&limit=0');
    if (numberlikes == "nointernet") return "nointernet";
    if (numberlikes == "error") return "error";
    return numberlikes["numberlikes"];
  }
}
