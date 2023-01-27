class Composants{

  var id ;
  String name;
  Composants({
    this.name,
    this.id

  });



  factory Composants.fromDoc(Map<String,dynamic> document) {

    return new  Composants(
      name: document["name"],
      id: document["id"],
    );
  }

}