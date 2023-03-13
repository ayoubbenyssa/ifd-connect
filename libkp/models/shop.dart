
class Shop{

  var objectId;
  var address = "";
  var description = "";
  var initialPrice ="";
  var latLng = "";
  var name = "";
  var partnerKey = "";
  List pic;
  var dis ;
  var liked;

  Shop({
    this.objectId,
    this.address,
    this.description,
    this.initialPrice,
    this.latLng,
    this.name,
    this.partnerKey,
    this.pic
  });



  Shop.fromMap(Map<String, dynamic> document)
      : objectId = document["objectId"],
        pic = document["pictures"],
        address = document["address"],
        description = document["description"],
        initialPrice = document["initialPrice"].toString(),
        latLng = document["latLng"].toString(),
        name = document["name"],
        partnerKey = document["partnerKey"]
  ;





}