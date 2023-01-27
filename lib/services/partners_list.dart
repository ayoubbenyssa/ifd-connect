import 'dart:convert';
import 'package:ifdconnect/accueil/models/gallery.dart';
import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/models/objectif.dart';
import 'package:ifdconnect/models/partner.dart';
import 'package:ifdconnect/models/shop.dart';





class PartnersList{
  static ParseServer parse_s = new ParseServer();


  static get_list_album() async {
    //,"sponsored":1
    String url = 'album_types?order=ordre';
    var getcity = await parse_s.getparse(url);
    if (getcity == "No") return "No";
    if (getcity == "error") return "error";
    List res = getcity["results"];
    return res.map((var contactRaw) => new Album.fromMap(contactRaw)).toList();
  }


  static get_list_gallery(id) async {
    //,"sponsored":1
    String url = 'gallery?order=-createdAt&where={"type":{"\$inQuery":{"where":{"objectId":"$id"},"className":"album_types"}}}';
    var getcity = await parse_s.getparse(url);
    if (getcity == "No") return "No";
    if (getcity == "error") return "error";
    List res = getcity["results"];
    return res
        .map((var contactRaw) => new Gallery.fromDoc(contactRaw))
        .toList();
  }



  static get_6list_gallery() async {
    String url = 'gallery?order=-createdAt&limit=7';
    var getcity = await parse_s.getparse(url);
    if (getcity == "No") return "No";
    if (getcity == "error") return "error";
    List res = getcity["results"];
    return res
        .map((var contactRaw) => new Gallery.fromDoc(contactRaw))
        .toList();
  }

  static get_list_partners() async {//,"sponsored":1
    String url = 'partners?where={"status":"1","sponsored":1}&order=-createdAt';
    var getcity = await parse_s.getparse(url);
    if (getcity == "No") return "No";
    if (getcity == "error") return "error";
    List res =  getcity["results"];
    return res.map((var contactRaw) => new Partner.fromMap(contactRaw))
        .toList();
  }


  static get_objectifs() async {
    String url = 'objectifs1';
    var getcity = await parse_s.getparse(url);

    if (getcity == "No Internet") return "No Internet";
    if (getcity == "error") return "error";
    List res =  getcity["results"];
    return res.map((var contactRaw) => new Objectif.fromDoc(contactRaw))
        .toList();
  }


  static get_list_shop(id,objectId) async {

    String url ="";
    if(id.toString() == "null")
      {
     url = 'offers?where={"partnerKey":"$objectId","type":"shop"}';
      }else {
      url =
      'offers?where= {"\$or":[{"partnerKey":{"\$eq":"$id"}},{"partnerKey":{"\$eq":"$objectId"}}],"type":"shop"}';
    }
    var getcity = await parse_s.getparse(url);
    if (getcity == "No Internet") return "No Internet";
    if (getcity == "error") return "error";
    List res =  getcity["results"];
    return res.map((var contactRaw) => new Shop.fromMap(contactRaw))
        .toList();
  }



  static getShp_details(id,objectId) async {
    String url = 'shops?where= {"\$or":[{"partnerKey":{"\$eq":"$id"}},{"partnerKey":{"\$eq":"$objectId"}}]}';
    var getcity = await parse_s.getparse(url);
    if (getcity == "No Internet") return "No Internet";
    if (getcity == "error") return "error";
    var res =  getcity["results"][0];
    return new Shop.fromMap(res);

  }




}