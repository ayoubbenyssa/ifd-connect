import 'package:ifdconnect/models/offers.dart';
import 'package:ifdconnect/models/reply.dart';
import 'package:ifdconnect/models/user.dart';

class Comment {
  var id;
  var idUser;
  var text;
  var imgUrl;
  bool show_reply;
  bool delete;
  var idPost;
  DateTime createdat;
  var updatedat;
  User author1;
  var post;
  Offers post2;
  List<Reply> replies;

  Comment(
      {this.id,
      this.idUser,
      this.text,
      this.replies,
        this.post2,
      this.author1,
      this.delete = false,
      this.imgUrl,
      this.idPost,
      this.show_reply,
      this.post,
      this.createdat,
      this.updatedat});

  Comment.fromMap(map)
      : text = map['text'].toString(),
        id = map['objectId'].toString(),
        show_reply = false,
        imgUrl = map['photo'].toString(),
        replies = map['replies'] == null
            ? List<Reply>.from([])
            : List<Reply>.from(
                map['replies'].map((reply) => Reply.fromMap(reply)).toList()),
        createdat = DateTime.parse(map['createdAt'].toString()),
        updatedat = map['updatedAt'].toString(),
        idUser = map['idUser'].toString(),
        idPost = map['idPost'].toString(),
        author1 = User.fromMap(map['author1']),
        post = map['post'];


  Comment.fromMap2(map)
      : text = map['text'].toString(),
        id = map['objectId'].toString(),
        show_reply = false,
        imgUrl = map['photo'].toString(),
        replies = map['replies'] == null
            ? List<Reply>.from([])
            : List<Reply>.from(
            map['replies'].map((reply) => Reply.fromMap(reply)).toList()),
        createdat = DateTime.parse(map['createdAt'].toString()),
        updatedat = map['updatedAt'].toString(),
        idUser = map['idUser'].toString(),
        idPost = map['idPost'].toString(),
        author1 = User.fromMap(map['author1']),
        post =Offers.fromMap( map['post']);
}
