


import 'package:ifdconnect/models/user.dart';

class ConnectModel {

  String objectId;
  var author;

  ConnectModel({
    this.objectId,
    this.author
});

  ConnectModel.fromMap(Map<String, dynamic> document):
      objectId = document["objectId"].toString(),
      author =  document["sendd"];


}