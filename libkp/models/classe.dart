import 'package:ifdconnect/models/offers.dart';
import 'package:ifdconnect/models/reply.dart';
import 'package:ifdconnect/models/user.dart';

class Classe {
  var batch_id;
  var name;
  bool check;

  Classe({this.batch_id, this.name, this.check});

  Classe.fromMap(map)
      : name = map['batch_name'].toString(),
        batch_id = map['batch_id'].toString(),
        check = false;
}
