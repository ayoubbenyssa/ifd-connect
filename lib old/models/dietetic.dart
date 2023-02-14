

class Dietetic {
  String id;
  String name;
  String type;
  String  description;
  String image;

  String picture;


  Dietetic.fromMap(Map<String, dynamic> map)
      : id = map["objectId"],
        type = map["type"],
        description = map["description"],
        image = map["image"],
        picture = map["picture"],
      name = map["name"];
}
