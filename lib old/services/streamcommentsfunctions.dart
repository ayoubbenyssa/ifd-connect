

import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/models/comment.dart';

class StreamCommentsFunctions {
  ParseServer parseFunctions = new ParseServer();
  fetchcomments({skip = 0, idPost, created = ""}) async {
    var url = "";
    var limitcondition = "&limit=20&skip=$skip&count=1";
    var wherecondition = '';
    var order = "&order=createdAt";
    if (created != '')
      wherecondition +=
      '"createdAt":{"\$lte":{"__type":"Date","iso":"$created"}},';
    url = 'comments1?&include=author1&include=author1.user_formations,author1.role';
    wherecondition +=
    '"idPost":"$idPost","author":{"\$inQuery":{"where":{"objectId":{"\$exists":true}},"className":"users"}}';

    if (wherecondition != "")
      wherecondition = "&where={" + wherecondition + "}";
    var results = await parseFunctions
        .getparse(url + limitcondition + order + wherecondition);
    if (results == "nointernet") return "nointernet";
    if (results == "error") return "error";
    if (results["count"] == 0) return "empty";
    if (results["results"].length > 0) {
      List commentsItems = results['results'];
      return {
        'results':  commentsItems.map((raw) => new Comment.fromMap(raw)).toList(),
        'count': results['count']
      };
    }
    return "nomoreresults";
  }
}
