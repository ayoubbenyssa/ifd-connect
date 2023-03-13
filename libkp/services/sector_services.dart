

import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/models/category_shop.dart';
import 'package:ifdconnect/models/sector.dart';

class SectorsServices {

static   ParseServer parseFunctions = new ParseServer();


   static get_list_sectors() async {
    String url = 'sectors?order=ord';
    var sect = await parseFunctions.getparse(url);
    if (sect == "No Internet") return "No Internet";
    if (sect == "error") return "error";
    List res =  sect["results"];
    return res.map((var contactRaw) => new Sector.fromMap(contactRaw))
        .toList();
  }



static get_list_category() async {

  String url = 'categories_shop';
  var sect = await parseFunctions.getparse(url);
  if (sect == "No Internet") return "No Internet";
  if (sect == "error") return "error";
  List res =  sect["results"];
  return res.map((var contactRaw) => new CategoryShop.fromMap(contactRaw))
      .toList();
}


}