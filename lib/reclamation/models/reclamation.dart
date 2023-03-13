import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/reclamation/models/thematque.dart';
import 'package:ifdconnect/reclamation/models/type.dart';

class Reclamation {
  String objectId;
  Thematique thematique;
  TypeReclamation type;
  String description;
  String priority;
  User user;
  DateTime createdAt;

  Reclamation(
      {this.objectId,
      this.thematique,
      this.type,
      this.description,
      this.priority,
      this.createdAt,
      this.user});

  Reclamation.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'];
    thematique = json['thematique'] != null
        ? new Thematique.fromMap(json['thematique'])
        : null;
    createdAt = DateTime.parse(json['createdAt'].toString());

    type =
        json['type'] != null ? new TypeReclamation.fromMap(json['type']) : null;
    description = json['description'];
    priority = json['priority'];
    user = json['user'] != null ? new User.fromMap(json['user']) : null;
  }
}
