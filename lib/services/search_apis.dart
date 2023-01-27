import 'dart:convert';
import 'dart:io';

import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:http/http.dart' as clientHttp;

class SearchApis {

  static JsonDecoder _decoder = new JsonDecoder();
  ParseServer parseFunctions = new ParseServer();



  static searchposts_docss(String text) async {
    var json2 = new Map();
    json2 = {
      "from": 0,
      "size": 200,
      "query": {
        "multi_match": {
          //  "fuzziness": 1,
          "query": text.toLowerCase(),
          "boost": 3.0,
          "type": "phrase_prefix",
          "max_expansions": 1000,
          //  "use_dis_max": "true",
          "tie_breaker": 1,
          "prefix_length": 1,
          "fields": [
            "Name",
            "titre",
            "descrition",
            "tags",
            "autheur",
            "type_doc"
          ]
        }
      }
    };
    String urls = "https://search.emiconnect.tk/docs/doc/_search";
    String basicAuth = 'Basic ' +
        base64Encode(utf8.encode("admin_emi" + ':' + "Emi2021"));

    var responses = await clientHttp.post(urls,
        headers: {
          HttpHeaders.authorizationHeader: basicAuth,
          "content-type": "application/json; charset=utf-8"
        },
        body: json.encode(json2));


    if (responses.statusCode < 200 ||
        responses.body == null ||
        responses.statusCode >= 300) {
      return "error";
    } else {
      var postsContainer = _decoder.convert(responses.body);
      List<String> list = new List<String>();
      for (var item in postsContainer['hits']['hits']) {

        list.add('"' + item['_id'] + '"');
      }
      return list;
    }
  }

  static searchposts_posts(text) async {

    print("-------------------------------");

    print(text);
    var json2 = new Map();
    json2 = {
      "from": 0,
      "size": 200,
      "query": {
        "multi_match": {
          //  "fuzziness": 1,
          "query": text.toLowerCase(),
          "boost": 3.0,
          "type": "phrase_prefix",
          "max_expansions": 1000,
          //  "use_dis_max": "true",
          "tie_breaker": 1,
          "prefix_length": 1,
          "fields": ["category", "summary", "name", "description", "type","choix","cat"]
        }
      }
    };
    String urls = "https://search.emiconnect.tk/posts_raja/post/_search";

    String basicAuth = 'Basic ' +
        base64Encode(utf8.encode("admin_emi" + ':' + "Emi2021"));

    var responses = await clientHttp.post(urls,
        headers: {
          HttpHeaders.authorizationHeader: basicAuth,
          "content-type": "application/json; charset=utf-8"
        },
        body: json.encode(json2));


    if (responses.statusCode < 200 ||
        responses.body == null ||
        responses.statusCode >= 300) {
      return "error";
    } else {
      var postsContainer = _decoder.convert(responses.body);
      List<String> list = new List<String>();
      for (var item in postsContainer['hits']['hits']) {
        print("1234");
        print(item);
        list.add('"' + item['_id'] + '"');
      }
      return list;
    }
  }


  /*

  OR is spelled should
AND is spelled must
NOR is spelled should_not
Example:

You want to see all the items that are (round AND (red OR blue)):

{
    "query": {
        "bool": {
            "must": [
                {
                    "term": {"shape": "round"}
                },
                {
                    "bool": {
                        "should": [
                            {"term": {"color": "red"}},
                            {"term": {"color": "blue"}}
                        ]
                    }
                }
            ]
        }
    }
}
   */
  static searchposts_posts_filter(text,cat,type,choix) async {
    var json2 = new Map();
    json2 = {
      "from": 0,
      "size": 200,
      "query": {
        "multi_match": {
          //  "fuzziness": 1,
          "query": text.toLowerCase(),
          "boost": 3.0,
          "type": "phrase_prefix",
          "max_expansions": 1000,
          //  "use_dis_max": "true",
          "tie_breaker": 1,
          "prefix_length": 1,
          "fields": ["category", "summary", "name", "description", "type"]
        }
      }
    };
    String urls = "https://search.emiconnect.tk/posts_raja/post/_search";
    String basicAuth = 'Basic ' +
        base64Encode(utf8.encode("admin_emi" + ':' + "Emi2021"));

    var responses = await clientHttp.post(urls,
        headers: {
          HttpHeaders.authorizationHeader: basicAuth,
          "content-type": "application/json; charset=utf-8"
        },
        body: json.encode(json2));


    if (responses.statusCode < 200 ||
        responses.body == null ||
        responses.statusCode >= 300) {
      return "error";
    } else {
      var postsContainer = _decoder.convert(responses.body);
      List<String> list = new List<String>();
      for (var item in postsContainer['hits']['hits']) {

        list.add('"' + item['_id'] + '"');
      }
      return list;
    }
  }

  /* Future<List<User>> searchposts(String text) async {
    var json2 = new Map();

    if (text != "") {
      json2 = {
        "query": {
          "multi_match": {
            "query": text,
            "boost": 1.0,
            "max_expansions": 100,
            "use_dis_max": "true",
            "fuzziness": 1,
            "tie_breaker": 2,
            "prefix_length": 3,
            "fields": [
              "titre",
              "familyname",
              "firstname",
              "email",
              "organisme"
            ]
          }
        },
        "sort": [
          {"createdAt": "desc"}
        ]
      };
    } else {
      json2 = {
        "query": {"match_all": {}},
        "sort": [
          {"createdAt": "desc"}
        ]
      };
    }

    String jsonData2 = json.encode(json2);

    String urls =
        "https://search-wupee-gcpqucncgwkijnybrj6clgbkcy.us-east-1.es.amazonaws.com/posts/post/_search";

    var responses = await clientHttp.post(urls,
        headers: {
          "Content-Type": "applicaton/json",
        },
        body: jsonData2);

    var postsContainer = _decoder.convert(responses.body);

    var d = postsContainer['hits']['hits'];

    return d
        .map((contactRaw) => new User.fromMap(contactRaw["_source"]))
        .toList();
  }*/



  static searchentreprise(String text) async {
    var json2 = new Map();
    json2 = {
      "from": 0,
      "size": 200,
      "query": {
        "multi_match": {
          "query": text.toLowerCase(),
          "boost": 3.0,
          "max_expansions": 1000,
          // "use_dis_max": "true",
          //"fuzziness": 1,
          "tie_breaker": 1,
          "type": "phrase_prefix",
          "prefix_length": 1,
          "fields": [
            "username",
            "description"
          ]
        }
      }
    };
    String urls =
        "https://search.emiconnect.tk/cgembusiness/entreprise/_search";
    String basicAuth = 'Basic ' +
        base64Encode(utf8.encode("admin_emi" + ':' + "Emi2021"));

    var responses = await clientHttp.post(urls,
        headers: {
          HttpHeaders.authorizationHeader: basicAuth,
          "content-type": "application/json; charset=utf-8"
        },
        body: json.encode(json2));

    if (responses.statusCode < 200 ||
        responses.body == null ||
        responses.statusCode >= 300) {
      return "error";
    } else {
      var postsContainer = _decoder.convert(responses.body);
      List<String> list = new List<String>();
      for (var item in postsContainer['hits']['hits']) {
        list.add('"' + item["_id"] + '"');
      }
      return list;
    }
  }
  static searchposts(String text) async {
    print(
        "999999999999999999");
    var json2 = new Map();
    json2 = {
      "from": 0,
      "size": 200,
      "query": {
        "multi_match": {
          "query": text, //text.toLowerCase(),
          "boost": 3.0,
          "max_expansions": 1000,
          "type": "phrase_prefix",
          "tie_breaker": 1,
          "prefix_length": 1,
          "fields": [
            "objectId",
            "titre",
            "fullname",
            "firstname",
            "email",
            "organisme",
            "cmpetences",
            "community"
          ]
        }
      }
    };
    print("--------------------------------------------------------------");

    String urls = "https://search.emiconnect.tk/users_emi/user/_search";


    String basicAuth = 'Basic ' +
        base64Encode(utf8.encode("admin_emi" + ':' + "Emi2021"));

    var responses = await clientHttp.post(urls,
        headers: {
          HttpHeaders.authorizationHeader: basicAuth,
          "content-type": "application/json; charset=utf-8"
        },
        body: json.encode(json2));

    print("--------------------------------------------------------------");

    if (responses.statusCode < 200 ||
        responses.body == null ||
        responses.statusCode >= 300) {
      return "error";
    } else {
      var postsContainer = _decoder.convert(responses.body);
      List<String> list = new List<String>();
      for (var item in postsContainer['hits']['hits']) {
        list.add('"' + item['_id'] + '"');
      }
      return list;
    }
  }


  addPostByIdToSearch(idUser) async {
    var result;
    var posts = await parseFunctions.getparse(
        'users?where={"objectId":"$idUser"}&limit=2&order=-createdAt');
    if (posts == "error") {
      result = "error";
    } else {

      String basicAuth = 'Basic ' +
          base64Encode(utf8.encode("admin_emi" + ':' + "Emi2021"));


      if (posts["results"].length != 0) {
        for (var item in posts["results"]) {
          var jsonsearch = {
            "objectId": item['objectId'].toString(),
            "city": item['city'].toString(),
            "text": item['text'].toString(),
            "category": item['category'].toString(),
            "name": item['author1']["name"].toString(),
            "username": item['author1']["username"].toString(),
            "cuisine": item['cuisine'].toString(),
            "price": item['price'].toString(),
            "experience": item['experience'].toString(),
            "etabliss": item['etabliss'].toString(),
            "procedure": item['procedure'].toString(),
            "speciality": item['speciality'].toString(),
            "title": item['title'].toString(),
            "type": item['type'].toString(),
            "nomplace": item['nomplace'].toString(),
          };
          clientHttp.post(
            "https://search.emiconnect.tk/users_emi/user/" +
                item['objectId'].toString(),
            body: json.encode(jsonsearch), headers: {
            HttpHeaders.authorizationHeader: basicAuth,
          },);
        }
        result = true;
      }
    }
    return result;
  }

  addPostByIdToSearch2() async {
    var result;
    var posts = await parseFunctions.getparse('recipe?include=author&limit=1000');
    if (posts == "error") {
      result = "error";
    } else {
      String basicAuth = 'Basic ' +
          base64Encode(utf8.encode("admin_emi" + ':' + "Emi2021"));

      if (posts["results"].length != 0) {
        for (var item in posts["results"]) {
          var jsonsearch = {
            "objectId": item['objectId'].toString(),
            "city": item['city'].toString(),
            "text": item['text'].toString(),
            "category": item['category'].toString(),
            "name": item['author']["name"].toString(),
            "username": item['author']["username"].toString(),
            "cuisine": item['cuisine'].toString(),
            "price": item['price'].toString(),
            "experience": item['experience'].toString(),
            "etabliss": item['etabliss'].toString(),
            "procedure": item['procedure'].toString(),
            "speciality": item['speciality'].toString(),
            "title": item['title'].toString(),
            "type": item['type'].toString(),
            "nomplace": item['nomplace'].toString(),
          };
          // print(jsonsearch);
          // print(JSON.encode(jsonsearch));
          var k = await clientHttp.put(
              "https://search.emiconnect.tk/posts_raja/post/" +
                  item['objectId'].toString(),
              headers: {
                HttpHeaders.authorizationHeader: basicAuth,
                "content-type": "application/json; charset=utf-8"},
              body: json.encode(jsonsearch));
        }

        /*

          String basicAuth = 'Basic ' +
          base64Encode(utf8.encode("cgembusiness" + ':' + "cgembusiness"));

      var responses = await clientHttp.post(urls,
          headers: {
            HttpHeaders.authorizationHeader: basicAuth,
            "content-type": "application/json; charset=utf-8"
          },
          body: json.encode(json2));
         */
        result = true;
      }
    }
    return result;
  }




}