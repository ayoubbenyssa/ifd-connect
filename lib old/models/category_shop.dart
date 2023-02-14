class CategoryShop {
  String id;
  String name;
  String picture;

  CategoryShop(this.id, this.name, this.picture);

  CategoryShop.fromMap(Map<String, dynamic> map)
      : id = map["objectId"],
        name = map["name"],
        picture = map["picture"];
}
