
import 'package:ifdconnect/models/user.dart';

class Reply {
  var id;
  var text;
  bool delete;
  var idPost;
  DateTime createdat;
  var updatedat;
  User author1;

  Reply(
      {this.id,
        this.text,
        this.author1,
        this.delete= false,
        this.idPost,
        this.createdat,
        this.updatedat});
  Reply.fromMap(map)
      : text = map['text'].toString(),
        id = map['objectId'].toString(),
        createdat =  DateTime.parse(map['createdAt'].toString()),
        updatedat = map['updatedAt'].toString(),
        idPost = map['idPost'].toString(),
        author1 = User.fromMap(map['author1']);
}
