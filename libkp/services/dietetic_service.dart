


import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/models/dietetic.dart';

class Dietetic_Services{


  static ParseServer parse_s = new ParseServer();


  static get_list_diet() async {
    String url = 'dietetic?where={"display":"1"}';
    var getcity = await parse_s.getparse(url);
    if (getcity == "No Internet") return "No Internet";
    if (getcity == "error") return "error";
    List res =  getcity["results"];
    return res.map((var contactRaw) => new Dietetic.fromMap(contactRaw))
        .toList();
  }



  static get_video() async {
    String url = 'video_dietetic';
    var getcity = await parse_s.getparse(url);
    if (getcity == "No Internet") return "No Internet";
    if (getcity == "error") return "error";
    List res =  getcity["results"];
    return res[0];
  }





}