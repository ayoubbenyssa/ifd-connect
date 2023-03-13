class Role {
  String id = "";
  String name = "";
  String type = "";

  String picture;

  bool check = false;

  Role({this.id, this.name, this.picture, this.check, this.type});

  factory Role.fromMap(var document) {
    return new Role(
        id: document["objectId"],
        name: document["name"],
        type: document["type"],
        picture: document["picture"].toString() == "null"
            ? "images/un.png"
            : document["picture"],
        check: false);
  }
}
