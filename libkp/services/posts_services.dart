
import 'dart:convert';

import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/models/offers.dart';
import 'package:ifdconnect/models/user.dart';

class PostsServices{

  static ParseServer parseFunctions = new ParseServer();



  static get_sondage_by_id(objectId, User user, skip) async {
    var url = '"active":1,"objectId":"' + objectId + '"';
    var ur =
        'offers?limit=5&skip=$skip&where={$url}&include=author&include=author.user_formations,author.role&order=-createdAt&include=options&include=options.users';
    var getoffers = await parseFunctions.getparse(ur);
    List res = getoffers["results"];

    return {
      "results":
      res.map((var contactRaw) => new Offers.fromMap(contactRaw)).toList(),
      "count": getoffers["count"]
    };
  }

  static get_pub_type(skip, type, user) async {
    var url;

    ///bF5sYMjQIM
    if (type == "event" ||
        type == "promotion" ||
        type == "news" ||
        type == "boutique_online") {


      if (type == "news") {
        var qq = [
          {"type": "news","active":1},
          {
            "author": {
              "\$inQuery": {
                "where": {"objectId": "bF5sYMjQIM", "active": 1},
                "className": "users"
              }
            }
          }
        ];

        url = jsonEncode({"\$or": qq});
      } else
        url = json.encode({"type": "$type","active":1});
    } else {
      url = jsonEncode({
        "type": "$type",
        "active": 1
      });
    }

    var ur =
        'offers?limit=30&skip=$skip&where=$url&include=author&include=author.user_formations,author.role&order=-boostn&order=-createdAt&include=partner&include=options&include=options.users';

    var getoffers = await parseFunctions.getparse(ur);
    List res = getoffers["results"];


    return {
      "results":
      res.map((var contactRaw) => new Offers.fromMap(contactRaw)).toList(),
      "count": getoffers["count"]
    };
  }



  static get_recent_friend_pub(my_id,skip) async{
    var qu = [
      {"type": "Mission_emi"},
      {"type": "Hébergement_emi"},
      {"type": "Achat / Vente_emi"},
      {"type": "Objets perdus_emi"},
      {"type": "Général_emi"},
    ];


    var qq = [
      // { "objectId":  {"\$select":{"query":{"className":"connect","where":{"send_requ":{"\$eq":"$my_id"},"accepted":true}},"key":"receive_req"}}},
      {"objectId": "$my_id"}
    ];



    var url = jsonEncode({
      "\$or": qu,
      /*  "author": {
        "\$inQuery": {
          "where": {
            "\$or":qq
          },
          "className": "users"
        }
      },*/
      "active":1
    });
    var ur =  'offers?limit=10&skip=$skip&count=1&where=$url&include=author&include=author.user_formations,author.role&order=-boostn&order=-createdAt';



    var getoffers = await parseFunctions.getparse(ur);
    List res =  getoffers["results"];
    return {"results":res.map((var contactRaw) => new Offers.fromMap(contactRaw))
        .toList(),"count":getoffers["count"]};
  }


  static get_recent_others_pub(my_id,skip) async{
    var qu = [
      {"type": "Mission_emi"},
      {"type": "Hébergement_emi"},
      {"type": "Achat / Vente_emi"},
      {"type": "Objets perdus_emi"},
      {"type": "Général_emi"},

    ];


    var url = jsonEncode({
      "\$or": qu,
      "author": {
        "\$inQuery": {
          "where": {"objectId":  {"\$dontSelect":{"query":{"className":"connect","where":{"send_requ":{"\$eq":"$my_id"},"accepted":true}},"key":"receive_req"}}     },
          "className": "users"
        }
      },
      "active":1
    });
    var ur =  'offers?limit=10&skip=$skip&count=1&where=$url&include=author&include=author.user_formations,author.role&order=-boostn&order=-createdAt';

    var getoffers = await parseFunctions.getparse(ur);
    List res =  getoffers["results"];
    return {"results":res.map((var contactRaw) => new Offers.fromMap(contactRaw))
        .toList(),"count":getoffers["count"]};
  }


  static get_events(User user,skip) async {
   // var kkey = user.communitykey;
    int number = DateTime.now().millisecondsSinceEpoch;


    var tpe  = [
      {
        "type":"event"
      },
      {
        "type":"promotion"
      },
      {
        "type":"news"
      },
      {
        "type":"boutique"
      }
    ];



    var url = json.encode({
      "\$or": tpe,
      // "raja":true,
      //"communitiesKey":"$kkey",
      "startDate":{"\$lte":DateTime.now().millisecondsSinceEpoch},
      "endDate":{"\$gte":DateTime.now().millisecondsSinceEpoch}//,
      // "partner":{"\$inQuery":{"where":{"sponsored": 1,"status":"1"},"className":"partners"}}
    });


    var ur= 'offers?limit=20&skip=$skip&count=1&where=$url&include=partner&order=-createdAt';
    print("jojopjpojopjopjopjopjopjopjopjopjpo");
    print(ur);


    /* var  url =
        '"type":"event","communitiesKey":"$kkey","activatedDate":{"\$lte":$number},"partner":{"\$inQuery":{"where":{"sponsored": 1,"status":"1"},"className":"partners"}}';
    var ur= 'offers?limit=5&skip=$skip&count=1&where={$url}&include=partner&order=-createdAt';*/

    var getoffers = await parseFunctions.getparse(ur);
    List res =  getoffers["results"];

    return {"results":res.map((var contactRaw) => new Offers.fromMap(contactRaw))
        .toList(),"count":getoffers["count"]};

  }


  static get_news(User user,skip) async {
   // var kkey = user.communitykey;
    int number = DateTime.now().millisecondsSinceEpoch;
    var  url =
        '"type":"news","active":1';
    var ur= 'offers?limit=5&skip=$skip&count=1&where={$url}&include=partner&order=-createdAt';

    var getoffers = await parseFunctions.getparse(ur);
    List res =  getoffers["results"];


    return {"results":res.map((var contactRaw) => new Offers.fromMap(contactRaw))
        .toList(),"count":getoffers["count"]};
  }


  static get_promo(User user,skip) async {
   // var kkey = user.communitykey;
    int number = DateTime.now().millisecondsSinceEpoch;
    var  url =
        '"type":"promotion","partner":{"\$inQuery":{"where":{"status":"1"},"className":"partners"}}';
    var ur= 'offers?limit=5&skip=$skip&count=1&where={$url}&include=partner&order=-createdAt';
    var getoffers = await parseFunctions.getparse(ur);
    List res =  getoffers["results"];

    return {"results":res.map((var contactRaw) => new Offers.fromMap(contactRaw))
        .toList(),"count":getoffers["count"]};
  }




  static get_cov(User user,skip) async {
   // var kkey = user.communitykey;
    int number = DateTime.now().millisecondsSinceEpoch;
    var  url = '"type":"cov_emi"';
    var ur= 'offers?limit=5&skip=$skip&count=1&where={$url}&include=author&include=author.user_formations,author.role&order=-boostn&order=-createdAt';
    var getoffers = await parseFunctions.getparse(ur);
    List res =  getoffers["results"];

    return {"results":res.map((var contactRaw) => new Offers.fromMap(contactRaw))
        .toList(),"count":getoffers["count"]};
  }




  static get_shop(User user,skip) async {
    var kkey = user.communitykey;
    int number = DateTime.now().millisecondsSinceEpoch;
    var url = '"type":"boutique"';

    var ur='offers?limit=20&skip=$skip&count=1&where={$url}&include=partner&order=-createdAt';
    var getoffers = await parseFunctions.getparse(ur);
    List res =  getoffers["results"];
    return {"results":res.map((var contactRaw) => new Offers.fromMap(contactRaw))
        .toList(),"count":getoffers["count"]};

  }

/*

     var kkey = user.communitykey;

      url +=
      '"type":"${category.toLowerCase()}","sector":"$sector","communitiesKey":"$kkey","startDate":{"\$lte":$number},"endDate":{"\$gte":$number}';


      return 'offers?limit=20&skip=$skip&count=1&where={$url}&include=partner';
 */

  urlpost(User user, String category, String type, String sector, skip, dep,
      dest, da, user_cov_id, cat, boutique, favorite) {
    var url = '';
    int number = DateTime.now().millisecondsSinceEpoch;

    if (favorite == true) {

      String id = user.id;
      url += '"author":{"\$inQuery":{"where":{"objectId":"$id"},"className":"users"}}';
      return 'save_fav?limit=20&skip=$skip&count=1&where={$url}&include=post';
    }

    if (boutique == true && category == "Tous les produits") {
      url += '"type":"boutique"';
      return 'offers?limit=20&skip=$skip&count=1&where={$url}&include=partner';
    }
    if (boutique == true && category != "") {
      url += '"type":"boutique","sector":"$category"';
      return 'offers?limit=20&skip=$skip&count=1&where={$url}&include=partner';
    }
    else if (category != "" &&
        category != null &&
        category == "cov_emi" &&
        dep.toString() != "null" &&
        dep != "") {
      url +=
      '"type":"${category.toLowerCase()}","depart":"$dep","destination":{"\$regex": "$dest"},"time_dep":"$da"';
      return 'offers?limit=20&skip=$skip&count=1&where={$url}&include=author&include=author.user_formations,author.role&order=-boostn&order=-createdAt';
    } else if (category != "" &&
        category != null &&
        category == "cov_emi" &&
        user_cov_id.toString() != "null" &&
        user_cov_id.toString() != "") {
      url +=
      '"type":"${category.toLowerCase()}","author":{"\$inQuery":{"where":{"objectId":"$user_cov_id"},"className":"users"}}';
      return 'offers?limit=20&skip=$skip&count=1&where={$url}&include=author&include=author.user_formations,author.role&order=-createdAt';
    } else if (category != "" && category != null && category == "cov_emi") {
      url += '"type":"${category.toLowerCase()}"';


      return 'offers?limit=20&skip=$skip&count=1&where={$url}&include=author&include=author.user_formations,author.role&order=-boostn&order=-createdAt';
    } else if (category != "" &&
        category != null &&
        category == "promotion" &&
        sector != "" &&
        sector != null) {
    //  var kkey = user.communitykey;

      url +=
      '"type":"${category.toLowerCase()}","sector":"$sector","startDate":{"\$lte":$number},"endDate":{"\$gte":$number}';


      return 'offers?limit=20&skip=$skip&count=1&where={$url}&include=partner';
    } else if (category != "" && category != null && category == "promotion") {
    //  var kkey = user.communitykey;

      url += '"type":"${category}","startDate":{"\$lte":$number},"endDate":{"\$gte":$number}';

      return 'offers?limit=20&skip=$skip&count=1&where={$url}&include=partner';
    } else if (category != "" && category != null) {

      //var key = user.communitykey;


      int number = DateTime.now().millisecondsSinceEpoch;

      if(category == "event")
        url +=
        '"type":"${category.toLowerCase()}","active":1,"activatedDate":{"\$lte":$number}';
      else if(category == "news")
        url +=
        '"type":"${category.toLowerCase()}","active":1';
      else
        url +=
        '"type":"${category.toLowerCase()}","active":1';


      return 'offers?limit=20&skip=$skip&count=1&where={$url}&include=partner';
    } else if (type == "an" && user_cov_id.toString() != "null") {
      var qu = [
        {"type": "Mission_emi"},
        {"type": "Hébergement_emi"},
        {"type": "Achat / Vente_emi"},
        {"type": "Objets perdus_emi"}
      ];
      var url = jsonEncode({
        "\$or": qu,
        "author": {
          "\$inQuery": {
            "where": {"objectId": "$user_cov_id"},
            "className": "users"
          }
        },
        "active":1
      });
      return 'offers?limit=20&skip=$skip&count=1&where=$url&include=author&include=author.user_formations,author.role&order=-boostn';
    } else if (type != "" && type != null) {
      url += '"type":"${type}","active":1';
      return 'offers?limit=20&skip=$skip&count=1&where={$url}&include=author&include=author.user_formations,author.role&order=-boostn';
    }
  }

}


/*





import 'dart:convert';

import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/models/offers.dart';
import 'package:ifdconnect/models/user.dart';

class PostsServices{

  static ParseServer parseFunctions = new ParseServer();



  static get_recent_friend_pub(my_id,skip) async{
    var qu = [
      {"type": "Mission"},
      {"type": "Hébergement"},
      {"type": "Achat / Vente"},
      {"type": "Objets perdus"}
    ];


    /*

     var qu1 = [
    {"objectId":  {"\$select":{"query":{"className":"connect","where":{"send_requ":{"\$eq":"$my_id"},"accepted":true}},"key":"receive_req"}}},
    {"objectId":  {"\$dontSelect":{"query":{"className":"connect","where":{"send_requ":{"\$eq":"$my_id"},"accepted":true}},"key":"receive_req"}}}
    ];
     */
    var url = jsonEncode({
      "\$or": qu,
          "author": {
        "\$inQuery": {
          "where": {"objectId":  {"\$select":{"query":{"className":"connect","where":{"send_requ":{"\$eq":"$my_id"},"accepted":true}},"key":"receive_req"}}     },
          "className": "users"
        }
      },
      "active":1
    });
    var ur =  'offers?limit=10&skip=$skip&count=1&where=$url&include=author&order=-boostn';

   var getoffers = await parseFunctions.getparse(ur);
    List res =  getoffers["results"];
    return {"results":res.map((var contactRaw) => new Offers.fromMap(contactRaw))
        .toList(),"count":getoffers["count"]};
  }



  static get_recent_others_pub(my_id,skip) async{
    var qu = [
      {"type": "Mission"},
      {"type": "Hébergement"},
      {"type": "Achat / Vente"},
      {"type": "Objets perdus"}
    ];


    /*

     var qu1 = [
    {"objectId":  {"\$select":{"query":{"className":"connect","where":{"send_requ":{"\$eq":"$my_id"},"accepted":true}},"key":"receive_req"}}},
    {"objectId":  {"\$dontSelect":{"query":{"className":"connect","where":{"send_requ":{"\$eq":"$my_id"},"accepted":true}},"key":"receive_req"}}}
    ];
     */
    var url = jsonEncode({
      "\$or": qu,
      "author": {
        "\$inQuery": {
          "where": {"objectId":  {"\$dontSelect":{"query":{"className":"connect","where":{"send_requ":{"\$eq":"$my_id"},"accepted":true}},"key":"receive_req"}}     },
          "className": "users"
        }
      },
      "active":1
    });
    var ur =  'offers?limit=10&skip=$skip&count=1&where=$url&include=author&order=-boostn';

    var getoffers = await parseFunctions.getparse(ur);
    List res =  getoffers["results"];
    return {"results":res.map((var contactRaw) => new Offers.fromMap(contactRaw))
        .toList(),"count":getoffers["count"]};
  }


  static get_events(User user,skip) async {
    var kkey = user.communitykey;
    int number = DateTime.now().millisecondsSinceEpoch;


    var  url =
        '"type":"event","communitiesKey":"$kkey","activatedDate":{"\$lte":$number},"eventDate":{"\$gte":$number}';
    var ur= 'offers?limit=5&skip=$skip&count=1&where={$url}&include=partner&order=-createdAt';
    var getoffers = await parseFunctions.getparse(ur);
    List res =  getoffers["results"];

    return {"results":res.map((var contactRaw) => new Offers.fromMap(contactRaw))
        .toList(),"count":getoffers["count"]};

}


/*


   var res = json.encode({
      "\$or": search,
      "active":1,
      "id":{"\$dontSelect":{"query":{"className":"block","where":{"userS":{"\$eq":"$id"}}},"key":"blockedS"}},
      "idblock":{"\$dontSelect":{"query":{"className":"block","where":{"blockedS":{"\$eq":"$id"}}},"key":"userS"}},
      "medz":true
    });

 */

  static get_news(User user,skip) async {
    var kkey = user.communitykey;



    var tpe  = [
      {
        "type":"event"
      },
      {
        "type":"promotion"
      },
      {
        "type":"news"
      }
    ];



    var url = json.encode({
      "\$or": tpe,
      "communitiesKey":"$kkey",
      "startDate":{"\$lte":DateTime.now().millisecondsSinceEpoch},
      "endDate":{"\$gte":DateTime.now().millisecondsSinceEpoch}
    });


    var ur= 'offers?limit=15&skip=$skip&count=1&where=$url&include=partner&order=-createdAt';

    var getoffers = await parseFunctions.getparse(ur);
    List res =  getoffers["results"];


    return {"results":res.map((var contactRaw) => new Offers.fromMap(contactRaw))
        .toList(),"count":getoffers["count"]};
  }


  static get_promo(User user,skip) async {
    var kkey = user.communitykey;
    int number = DateTime.now().millisecondsSinceEpoch;
    var  url =
        '"type":"promotion","communitiesKey":"$kkey"';
    var ur= 'offers?limit=5&skip=$skip&count=1&where={$url}&include=partner';
    var getoffers = await parseFunctions.getparse(ur);
    List res =  getoffers["results"];

    return {"results":res.map((var contactRaw) => new Offers.fromMap(contactRaw))
        .toList(),"count":getoffers["count"]};
  }




  static get_cov(User user,skip) async {
    var kkey = user.communitykey;
    int number = DateTime.now().millisecondsSinceEpoch;
    var  url =
        '"type":"cov"';
    var ur= 'offers?limit=5&skip=$skip&count=1&where={$url}&include=author';
    var getoffers = await parseFunctions.getparse(ur);
    List res =  getoffers["results"];

    return {"results":res.map((var contactRaw) => new Offers.fromMap(contactRaw))
        .toList(),"count":getoffers["count"]};
  }




  static get_shop(User user,skip) async {
    var kkey = user.communitykey;
    int number = DateTime.now().millisecondsSinceEpoch;
   var url = '"type":"boutique"';

    var ur='offers?limit=20&skip=$skip&count=1&where={$url}&include=partner&order=-createdAt';
    var getoffers = await parseFunctions.getparse(ur);
    List res =  getoffers["results"];
    return {"results":res.map((var contactRaw) => new Offers.fromMap(contactRaw))
        .toList(),"count":getoffers["count"]};

  }

/*

     var kkey = user.communitykey;

      url +=
      '"type":"${category.toLowerCase()}","sector":"$sector","communitiesKey":"$kkey","startDate":{"\$lte":$number},"endDate":{"\$gte":$number}';


      return 'offers?limit=20&skip=$skip&count=1&where={$url}&include=partner';
 */

  urlpost(User user, String category, String type, String sector, skip, dep,
      dest, da, user_cov_id, cat, boutique, favorite) {
    var url = '';
    int number = DateTime.now().millisecondsSinceEpoch;

    if (favorite == true) {

      String id = user.id;
      url += '"author":{"\$inQuery":{"where":{"objectId":"$id"},"className":"users"}}';
      return 'save_fav?limit=20&skip=$skip&count=1&where={$url}&include=post';
    }

    if (boutique == true && category == "Tous les produits") {
      url += '"type":"boutique"';
      return 'offers?limit=20&skip=$skip&count=1&where={$url}&include=partner';
    }
    if (boutique == true && category != "") {
      url += '"type":"boutique","sector":"$category"';
      return 'offers?limit=20&skip=$skip&count=1&where={$url}&include=partner';
    }
    else if (category != "" &&
        category != null &&
        category == "cov" &&
        dep.toString() != "null" &&
        dep != "") {
      url +=
      '"type":"${category.toLowerCase()}","depart":"$dep","destination":{"\$regex": "$dest"},"time_dep":"$da","medz":true';
      return 'offers?limit=20&skip=$skip&count=1&where={$url}&include=author&order=-boostn';
    } else if (category != "" &&
        category != null &&
        category == "cov" &&
        user_cov_id.toString() != "null" &&
        user_cov_id.toString() != "") {
      url +=
      '"type":"${category.toLowerCase()}","author":{"\$inQuery":{"where":{"objectId":"$user_cov_id"},"className":"users"}}';
      return 'offers?limit=20&skip=$skip&count=1&where={$url}&include=author&order=-createdAt';
    } else if (category != "" && category != null && category == "cov") {
      url += '"type":"${category.toLowerCase()}","medz":true';


      return 'offers?limit=20&skip=$skip&count=1&where={$url}&include=author&order=-boostn';
    } else if (category != "" &&
        category != null &&
        category == "promotion" &&
        sector != "" &&
        sector != null) {
      var kkey = user.communitykey;

      url +=
      '"type":"${category.toLowerCase()}","sector":"$sector","communitiesKey":"$kkey","startDate":{"\$lte":$number},"endDate":{"\$gte":$number}';


      return 'offers?limit=20&skip=$skip&count=1&where={$url}&include=partner';
    } else if (category != "" && category != null && category == "promotion") {
      var kkey = user.communitykey;

      url += '"type":"${category}","communitiesKey":"$kkey","startDate":{"\$lte":$number},"endDate":{"\$gte":$number}';

      return 'offers?limit=20&skip=$skip&count=1&where={$url}&include=partner';
    } else if (category != "" && category != null) {

      var key = user.communitykey;


      int number = DateTime.now().millisecondsSinceEpoch;

      if(category == "event")
        url +=
        '"type":"${category.toLowerCase()}","cat":"$cat","communitiesKey":"$key","activatedDate":{"\$lte":$number}';
      else if(category == "news")
        url +=
        '"type":"${category.toLowerCase()}","cat":"$cat","communitiesKey":"$key","startDate":{"\$lte":$number},"endDate":{"\$gte":$number}';
      else
        url +=
        '"type":"${category.toLowerCase()}","cat":"$cat","communitiesKey":"$key"';


      return 'offers?limit=20&skip=$skip&count=1&where={$url}&include=partner';
    } else if (type == "an" && user_cov_id.toString() != "null") {
      var qu = [
        {"type": "Mission"},
        {"type": "Hébergement"},
        {"type": "Achat / Vente"},
        {"type": "Objets perdus"}
      ];
      var url = jsonEncode({
        "\$or": qu,
        "author": {
          "\$inQuery": {
            "where": {"objectId": "$user_cov_id"},
            "className": "users"
          }
        },
        "active":1
      });
      return 'offers?limit=20&skip=$skip&count=1&where=$url&include=author&order=-boostn';
    } else if (type != "" && type != null) {
      url += '"type":"${type}","active":1,"medz":true';
      return 'offers?limit=20&skip=$skip&count=1&where={$url}&include=author&order=-boostn';
    }
  }






}
 */