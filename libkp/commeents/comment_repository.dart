import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/models/comment.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommentsRepository {
  ParseServer parseFunctions = new ParseServer();

  Future<CommentsResponse> get(String postId) async {
    /*  print("jijiya");
    print(postId);

    QueryBuilder<ParseObject> query =
        QueryBuilder<ParseObject>(ParseObject("comments1"))
          ..whereEqualTo("idPost", postId)
          ..includeObject(["author1", "post"])
          ..setLimit(180)
          ..setAmountToSkip(0);

    final ParseResponse apiResponse = await query.query();
    print(apiResponse.results);
*/

    var url = "";
    // var limitcondition = "&limit=20&skip=$skip";

    url =
        'comments1?include=author1,replies,replies.author1,author1.user_formations,author1.role&where={"idPost":"$postId"}&order=-createdAt';
    var results = await parseFunctions.getparse(url);
    if (results == "nointernet")
      CommentsResponse(
          responseCode: 1, message: "Aucun commentaire", comments: []);
   else if (results == "error")
      return CommentsResponse(
          responseCode: 1, message: "Aucun commentaire", comments: []);
   else  if (results["results"].length >= 0) {
      List commentsItems = results['results'];

      return CommentsResponse(
          responseCode: 200,
          message: "Success",
          comments: results['results'].isEmpty
              ? List<Comment>.from([])
              : commentsItems.map((raw) => new Comment.fromMap(raw)).toList());
      /* } else {
      return CommentsResponse(
          responseCode: 1, message: "Aucun commentaire", comments: []);*/

    }
  }

  Future<String> postReply(String id_comment,
      {@required String postId, @required String content}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString("id");

    var insert_comment;

    insert_comment = ParseObject('Reply')
      ..set('text', content)
      ..set('idPost', postId)
      ..set('author1', (ParseObject("users")..objectId = id).toPointer());

    ParseResponse a = await insert_comment.save();

    print(a.result["objectId"]);
    var insertt = ParseObject('comments1')
      ..objectId = id_comment
      ..setAddUnique('replies',
          ParseObject("Reply")..set("objectId", "${a.result["objectId"]}"));
    ParseResponse ress = await insertt.save();

    if (a.success == true) {
      return a.result["objectId"];
    } else
      return null;
  }

  Future<String> post(String type,
      {@required String postId, @required String content, String id}) async {
    /*SharedPreferences prefs = await SharedPreferences.getInstance();
    String id =  prefs.getString("id");*/

    var insert_comment;

    insert_comment = ParseObject('comments1')
      ..set('text', content)
      ..set('idUser', id)
      ..set('idPost', postId)
      ..set('post', (ParseObject("offers")..objectId = postId).toPointer())
      ..set('author1', (ParseObject("users")..objectId = id).toPointer());

    ParseResponse a = await insert_comment.save();


    if (a.success == true) {
      return a.result["objectId"];
    } else
      return null;
  }

  delete_like(String id, {String post_type}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String myid = prefs.getString("id");

    QueryBuilder<ParseObject> userQuery =
        QueryBuilder<ParseObject>(ParseObject('_User'))
          ..whereEqualTo('objectId', myid);

    QueryBuilder<ParseObject> query;
    QueryBuilder<ParseObject> postQuery;

    if (post_type != "Album" && post_type != "Video") post_type = "Publication";

    postQuery = QueryBuilder<ParseObject>(ParseObject(post_type))
      ..whereEqualTo('objectId', id);
    query = QueryBuilder<ParseObject>(ParseObject("Like"))
      ..whereMatchesKeyInQuery("user", "objectId", userQuery)
      ..whereMatchesKeyInQuery(post_type.toLowerCase(), "objectId", postQuery)
      ..includeObject(["user"])
      ..setLimit(1)
      ..setAmountToSkip(0);

    final ParseResponse apiResponse = await query.query();
    String id_like = apiResponse.results[0]["objectId"];
    print(id_like);
    ParseObject obj =
        (await ParseObject('Like').getObject(id_like)).results.first;
    var res = await obj.delete();

    print(res);
  }

  Future<bool> post_like({@required String postId, String post_type}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString("id");

    var insert_like;

    if (post_type == "Album")
      insert_like = ParseObject('Like')
        ..set('album', (ParseObject("Album")..objectId = postId).toPointer())
        ..set('user', (ParseObject("_User")..objectId = id).toPointer());
    else if (post_type == "Video")
      insert_like = ParseObject('Like')
        ..set('video', (ParseObject("Video")..objectId = postId).toPointer())
        ..set('user', (ParseObject("_User")..objectId = id).toPointer());
    else
      insert_like = ParseObject('Like')
        ..set('publication',
            (ParseObject("Publication")..objectId = postId).toPointer())
        ..set('user', (ParseObject("_User")..objectId = id).toPointer());

    ParseResponse a = await insert_like.save();

    if (a.success == true) {
      return true;
    } else
      return null;
  }

  Future<CommentsResponse> _getComments(String postId) async {
    QueryBuilder<ParseObject> getcommentQuery =
        QueryBuilder<ParseObject>(ParseObject('Publication'))
          ..whereEqualTo('objectId', postId);

    QueryBuilder<ParseObject> query =
        QueryBuilder<ParseObject>(ParseObject("Comment"))
          ..whereMatchesKeyInQuery("publication", "objectId", getcommentQuery)
          ..includeObject(["user"])
          ..setLimit(80)
          ..setAmountToSkip(0);

    final ParseResponse apiResponse = await query.query();
    if (apiResponse.success && apiResponse.results != null) {
      return CommentsResponse(
          responseCode: 200,
          message: "Success",
          comments:
              apiResponse.results.map((e) => Comment.fromMap(e)).toList());
    } else {
      return CommentsResponse(responseCode: 0, message: null, comments: []);
      ;
    }
  }
}

class CommentsResponse {
  final int responseCode;
  final String message;
  final List<Comment> comments;

  CommentsResponse({
    @required this.responseCode,
    @required this.message,
    @required this.comments,
  });
}
