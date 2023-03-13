class Thematique {
  var objectId;
  var name;
  bool check;

  Thematique({this.objectId, this.name, this.check});

  Thematique.fromMap(map)
      : objectId = map['objectId'].toString(),
        name = map['name'].toString(),
        check = false;
}
