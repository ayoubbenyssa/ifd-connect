

import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/models/connect.dart';

class Connect {

  static ParseServer parse_s = new ParseServer();



  static inser_request(my_id, id_other,accept)  async{
    parse_s.postparse('connect', {
      "send_requ": my_id,
       "key_id":my_id+"_"+id_other,
      "receive_req": id_other,
      "receivedd": {
        "__type": "Pointer",
        "className": "users",
        "objectId": id_other
      },
      "sendd": {
        "__type": "Pointer",
        "className": "users",
        "objectId": my_id
      },
      "accepted":accept
    });
  }



  static update_request(id_connect)  async{
    parse_s.putparse('connect/'+id_connect, {
      "accepted":true,
      "year": new DateTime.now().year,
      "monthYear": new  DateTime.now().month.toString() +"-"+ new  DateTime.now().year.toString()
    });
  }






  static get_request_user(myid,his_id) async {


    String url = 'connect?where={"receive_req":"$myid","send_requ":"$his_id","accepted":false}&include=sendd';
    var getcity = await parse_s.getparse(url);
    if (getcity == "No Internet") return "No Internet";
    if (getcity == "error") return "error";
    List res =  getcity["results"];


    return res.map((contactRaw) => new ConnectModel.fromMap(contactRaw))
        .toList();

  }

  static get_request_user2(myid,his_id) async {


    String url = 'connect?where={"receive_req":"$myid","send_requ":"$his_id","accepted":true}&include=sendd';
    var getcity = await parse_s.getparse(url);
    if (getcity == "No Internet") return "No Internet";
    if (getcity == "error") return "error";
    List res =  getcity["results"];


    return res.map((contactRaw) => new ConnectModel.fromMap(contactRaw))
        .toList();

  }



  static get_list_connect_all(myid) async {
    String url = 'connect?where={"receive_req":"$myid","accepted":false}&include=sendd&count=1';
    var getcity = await parse_s.getparse(url);
    if (getcity == "No Internet") return "No Internet";
    if (getcity == "error") return "error";

    List res =  getcity["results"];




    return {"count":getcity["count"],"res":res.map((contactRaw) => new ConnectModel.fromMap(contactRaw))
        .toList()};

  }


  static get_list_connect(myid) async {
    String url = 'connect?where={"receive_req":"$myid","accepted":false}&include=sendd&limit=3&count=1';
    var getcity = await parse_s.getparse(url);
    if (getcity == "No Internet") return "No Internet";
    if (getcity == "error") return "error";

    List res =  getcity["results"];



        return {"count":getcity["count"],"res":res.map((contactRaw) => new ConnectModel.fromMap(contactRaw))
        .toList()};

  }




}