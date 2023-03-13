class TypeReclamation {
  var objectId;
  var name;
  bool check;

  TypeReclamation({this.objectId, this.name, this.check});

  TypeReclamation.fromMap(map)
      : objectId = map['objectId'].toString(),
        name = map['name'].toString(),
        check = false;
}
