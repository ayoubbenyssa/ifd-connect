
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ifdconnect/func/parsefunc.dart';

class CommentFunctions {
  ParseServer parseFunctions = new ParseServer();
  insertComment(text, idPost, imageURL, idauthor, idcategory,id_user, context) async {


    var js = {
      "idPost": idPost.toString(),
      "idUser": id_user.toString(),
      "text": text.toString(),
      "photo": imageURL,
      "author1": {
        "__type": "Pointer",
        "className": "users",
        "objectId": id_user
      },
      "post": {
        "__type": "Pointer",
        "className": "offers",
        "objectId": idPost
      }
    };
    var response = await parseFunctions.postparse("comments1", js);

    if (response == "nointernet") return "nointernet";
    if (response == "error") return "error";
    return true;

    // notificationfunctions.insertnotificationspost(idPost, prefs.getString("id"), idauthor, idcategory, response["createdAt"], "yes", prefs.getString("name"));
  }

  editComment(val, id) async {
    var response = await parseFunctions.putparse("comments1/$id", {"text": val});
    if (response == "nointernet") return "nointernet";
    if (response == "error") return "error";
    return true;
  }

  deletecomment(id, idpost, idauthor) async {
    var response = await parseFunctions.deleteparse('comments1/$id');
    if (response == "nointernet") return "nointernet";
    if (response == "error") return "error";
    //notificationfunctions.updatadecommentsnotifications(idpost);
    return true;
  }

  numberComments(idPost) async {
    var numberposts = await parseFunctions
        .getparse('comments1?where={"idPost": "$idPost" }&count=1&limit=0');
    if (numberposts == "nointernet" || numberposts == "error") return "0";
    return numberposts["count"];
  }
}