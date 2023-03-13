
import 'package:intl/intl.dart';

class Partner {

  var objectId;
  var address = "";
  var createdDate = "";
  var description = "";
  var email ="";

  var name = "";
  var logo = "";
  var sellingPrice = "";
  String directName = "" ;
 var managerName="";
 var partnerKey="";
 bool liked = false;
 var numberlikes;
 bool wait = false;
 var cnt="";
  bool begin = true;
  String phone="";





  Partner({
    this.objectId,
    this.directName,
    this.address,
    this.createdDate,
    this.description,
    this.name,
    this.phone,
    this.logo,
    this.email,
    this.partnerKey
  });



  Partner.fromMap(Map<String, dynamic> document)
      :
        objectId = document["objectId"].toString(),
        phone = document["phoneNumber"].toString(),
        directName = document["directName"].toString(),
        address = document["address"].toString(),
        partnerKey = document["partnerKey"].toString(),
      createdDate = document["createdDate"].toString(),
        description = document["description"].toString(),
        name = document["name"].toString(),
        managerName = document["managerName"].toString(),
        email = document["email"].toString(),
        logo = document["logo"].toString()
  ;







}