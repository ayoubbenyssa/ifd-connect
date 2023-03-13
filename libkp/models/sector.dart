class Sector {
  String id;
  String name;
  String nme;


  Sector(this.id, this.name,this.nme);

  Sector.fromMap(Map<String, dynamic> map)
      : id = map["objectId"],
         nme = map["nme"],
        name = map["name"];
}
