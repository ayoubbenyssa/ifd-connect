

import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as clientHttp;
import 'package:connectivity/connectivity.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as clientHttp;
import 'package:connectivity/connectivity.dart';
import 'package:path/path.dart' as fileUtil;
import 'package:shared_preferences/shared_preferences.dart';

class ParseServer
{

  Future<String> readResponseAsString(HttpClientResponse response) {
    var completer = new Completer<String>();
    var contents = new StringBuffer();
    response.transform(utf8.decoder).listen((String data) {
      contents.write(data);
    }, onDone: () => completer.complete(contents.toString()));
    return completer.future;
  }
  static bool trustSelfSigned = true;

  static HttpClient getHttpClient() {

    HttpClient httpClient = new HttpClient()
      ..connectionTimeout = const Duration(seconds: 10)
      ..badCertificateCallback =
      ((X509Certificate cert, String host, int port) => trustSelfSigned);

    return httpClient;
  }

  Future<List<String>> fileUpload(
      File file,
      progress,
      upload,
      ext
      /* OnUploadProgressCallback onUploadProgress*/
      ) async {
    assert(file != null);

    final url = 'https://api20.santeconnect.ma/parse/files/aa.'+ext;

    final fileStream = file.openRead();

    int totalByteLength = file.lengthSync();

    final httpClient = getHttpClient();

    final request = await httpClient.postUrl(Uri.parse(url));

    // request.headers.set(HttpHeaders.contentTypeHeader, ContentType.binary);
    request.headers.add("Content-Type", "applicaton/json");
    request.headers.add("X-Parse-Application-Id", "santeconnect");
    request.headers
        .add('X-Parse-Master-Key', 'santeconnect12345678888888-0ed5f89f718b');

    request.headers.add("filename", fileUtil.basename(file.path));

    // request.add(file.readAsBytesSync());
    request.contentLength = totalByteLength;

    int byteCount = 0;
    Stream<List<int>> streamUpload = fileStream.transform(
      new StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          byteCount += data.length;

          /* if (onUploadProgress != null) {
            onUploadProgress(byteCount, totalByteLength);
            // CALL STATUS CALLBACK;
          }
*/
          progress = (byteCount / totalByteLength * 100).toStringAsFixed(0) + "%";
          upload(progress);
          sink.add(data);
        },
        handleError: (error, stack, sink) {
        },
        handleDone: (sink) {
          sink.close();
          // UPLOAD DONE;
        },
      ),
    );

    await request.addStream(streamUpload);

    final httpResponse = await request.close();
    // print(await readResponseAsString(httpResponse));

    var i = json.decode( await readResponseAsString(httpResponse));


    return await [i["name"],i["url"]];
  }



  isconnectedfunction() async {
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  /**
   * http://217.182.139.190:1344/parse
      iavconnect123456
      iavconnect123456789

   */

  final JsonDecoder _decoder = new JsonDecoder();
  // String urlclasse = "http://217.182.139.190:1344/parse/classes/";
  // String urlParse = "http://217.182.139.190:1344/parse/";
  SharedPreferences prefs;



  paramsparsejson(String id_parce, String Content_type , String master_key) {

    return {
      "X-Parse-Application-Id": id_parce,
      "Content-Type": Content_type,
      'X-Parse-Master-Key': master_key
      // "X-Parse-Application-Id": "EAAe32wHSy9jc1LFN3G56",
      // "Content-Type": 'applicaton/json',
      // 'X-Parse-Master-Key': 'iavconnect123456789'
    };
  }

  paramsparsenojson(String id_parce , String master_key) {
    return {

      // "X-Parse-Application-Id": "EAAe32wHSy9jc1LFN3G56",
      // 'X-Parse-Master-Key': 'iavconnect123456789'
      "X-Parse-Application-Id": id_parce,
      'X-Parse-Master-Key': master_key
    };
  }


  putparse(geturl, data) async {
    var con = await isconnectedfunction();
     prefs = await SharedPreferences.getInstance();

    var results;
    if (con) {
      data = json.encode(data);
      prefs = await SharedPreferences.getInstance();
      var url = Uri.parse(Uri.encodeFull(prefs.getString('urlclasse') + geturl));

      var response = await clientHttp.put(url, headers: paramsparsejson(prefs.get('Parse_Id'),prefs.get('Content_type'), prefs.get('Parse_Key')) , body: data);
      String jsonBody = response.body;


      var statusCode = response.statusCode;

      if (statusCode < 200 || jsonBody == null || statusCode >= 300) {
        results = "error";
      } else {
        var postsContainer = _decoder.convert(jsonBody);
        results = postsContainer;
      }
    } else {
      results = "nointernet";
    }
    return results;
  }


  postparse2(geturl, data) async {
    var con = await isconnectedfunction();
    prefs = await SharedPreferences.getInstance();

    var results;
    if (con) {
      data = json.encode(data);
      var url = Uri.parse(Uri.encodeFull(prefs.getString('urlclasse') + geturl));
      var response =
      await clientHttp.post(url, headers: paramsparsejson(prefs.get('Parse_Id'),prefs.get('Content_type'), prefs.get('Parse_Key')) , body: data);
      String jsonBody = response.body;
      var statusCode = response.statusCode;
      if (statusCode < 200 || jsonBody == null || statusCode >= 300) {
        results = "error";
      } else {
        var postsContainer = _decoder.convert(jsonBody);
        results = postsContainer;
      }
    } else {
      results = "nointernet";
    }
    return results;
  }



  getparselogin(geturl) async {
    var con = await isconnectedfunction();
    prefs = await SharedPreferences.getInstance();

    var results;
    if (con) {
      var url = Uri.parse(Uri.encodeFull(prefs.getString('url_parce') + geturl));

      print(prefs.getString('url_parce') + geturl);

      var response = await clientHttp.get(url, headers: prefs.getString('paramsparsenojson') as Map);
      String jsonBody = response.body;

      var statusCode = response.statusCode;
      if (statusCode < 200 || jsonBody == null || statusCode >= 300) {
        results = "error";
      } else {
        results = jsonBody;
      }
    } else {
      results = "nointernet";
    }
    return results;
  }





  getparse(geturl) async {

    prefs = await SharedPreferences.getInstance();

    var con = true;
    var results;
    print("++++=");
    print("**********************************");
    print(prefs.getString('urlclasse'));
    if (con) {
      var url = Uri.parse(Uri.encodeFull("${prefs.getString('urlclasse')}" + geturl));

      var paramsparsenojsonn = prefs.get('Parse_Key');

      var response;

      try {

        response = await clientHttp.get(url, headers: paramsparsenojson(prefs.get('Parse_Id'), prefs.get('Parse_Key')));

      }
      catch(e)
      {

        return "No";
      }

      String jsonBody = response.body;
      var statusCode = response.statusCode;


      if (statusCode < 200 || jsonBody == null || statusCode >= 300) {
        results = "error";
      } else {
        var postsContainer = _decoder.convert(jsonBody);


        // if (postsContainer["count"].toString() != "" ||
        //     postsContainer["error"].toString() != "") results = "errorquery";
        results = postsContainer;
      }
    } else {
      results = "No";
    }
    return results;
  }

  postparse(geturl, data) async {
    prefs = await SharedPreferences.getInstance();
    var con = await isconnectedfunction();
    var results;
    if (con) {
      data = json.encode(data);
      var url = Uri.parse(Uri.encodeFull(prefs.getString('urlclasse') + geturl));
      var response =
      await clientHttp.post(url, headers: paramsparsejson(prefs.get('Parse_Id'),prefs.get('Content_type'), prefs.get('Parse_Key')), body: data);
      String jsonBody = response.body;
      var statusCode = response.statusCode;
      if (statusCode < 200 || jsonBody == null || statusCode >= 300) {
        results = "error";
      } else {
        var postsContainer = _decoder.convert(jsonBody);
        results = postsContainer;
      }
    } else {
      results = "nointernet";
    }
    return results;
  }

  deleteparse(geturl) async {

    prefs = await SharedPreferences.getInstance();
    var con =  await isconnectedfunction();
    var results;
    if (con) {
      var url = Uri.parse(Uri.encodeFull("${prefs.getString('urlclasse')}" + geturl));
      var response = await clientHttp.delete(url, headers: paramsparsenojson(prefs.get('Parse_Id'), prefs.get('Parse_Key')));
      String jsonBody = response.body;
      var statusCode = response.statusCode;
      if (statusCode < 200 || jsonBody == null || statusCode >= 300) {
        results = "error";
      } else {
        var postsContainer = _decoder.convert(jsonBody);
        results = postsContainer.length == 0;
      }
    } else {
      results = "nointernet";
    }
    return results;
  }

  postparselogin(geturl, data) async {

    prefs = await SharedPreferences.getInstance();
    var con = await  isconnectedfunction();
    // var con = true;
    var results;
    if (con) {
      data = json.encode(data);
      var url = Uri.parse(Uri.encodeFull(prefs.getString('url_parce') + geturl));
      var response =
      await clientHttp.post(url, headers: paramsparsejson(prefs.get('Parse_Id'),prefs.get('Content_type'), prefs.get('Parse_Key')), body: data);
      String jsonBody = response.body;
      var statusCode = response.statusCode;
      if (statusCode < 200 || jsonBody == null || statusCode >= 300) {
        results = "error";
      } else {
        var postsContainer = _decoder.convert(jsonBody);
        results = postsContainer;
      }
    } else {
      results = "nointernet";
    }
    return results;
  }

  /*

    get_publications() async {
    var ref = FirebaseDatabase.instance.reference();
    ref.child('offers').onValue.listen((evt) {
      if (evt.snapshot.value == null) {

      }
      DataSnapshot data = evt.snapshot;
      var keys = data.value.keys;
      var todo = data.value;
      for (var key in keys) {
        print("jiyaaaaaa");
        var type = todo[key]["type"];
        var address = todo[key]["address"];
        var createdDate = todo[key]["createdDate"];
        var description = todo[key]["description"];
        var endDate = todo[key]["endDate"];
        var initialPrice = todo[key]["initialPrice"];
        var latLng = todo[key]["latLng"];
        var name = todo[key]["name"];
        var partnerKey = todo[key]["partnerKey"];
        var quantity = todo[key]["quantity"];
        var rate = todo[key]["rate"];
        var sellingPrice = todo[key]["sellingPrice"];
        var startDate = todo[key]["startDate"];
        var summary = todo[key]["summary"];
        var urlVideo = todo[key]["urlVideo"];

        print("reeeeeeeeesssssssssssssssssssssss");

        print(todo[key]["latLng"].toString().split(";"));
        String tl = "0.0";
        String lg = "0.0";

/*if(todo[key]["latLng"].toString().split(";").isEmpty)
  {

  }
  else {
  print(todo[key]["latLng"].toString().split(";")[1]);
  //tl = todo[key]["latLng"].toString().split(";")[0];
  //lg = todo[key]["latLng"].toString().split(";")[1];
  }*/

          //
           //


        var pic;
        var a = todo[key]["pictures"];
        if( todo[key]["pictures"].toString() != "null")
          {
            if(todo[key]["pictures"][0] == null) {
              for (var ky in todo[key]["pictures"].keys) {
                pic = todo[key]["pictures"][ky]["url"];
              }
            }
              else {
               pic = todo[key]["pictures"][0]["url"];

            }

            var js = {
              "type": type,
              "address": address,
              "createdDate": createdDate,
              "description":  description,
              "endDate": endDate,
              "initialPrice":  initialPrice,
              "latLng": latLng.toString(),
              "name": name,
              "partnerKey": partnerKey,
              "quantity": quantity,
              "rate": rate,
              "sellingPrice": sellingPrice,
              "startDate":  startDate,
              "summary":summary,
              "pictures":[pic],
              "urlVideo":urlVideo

            };


            parse_s.postparse("offers/", js);


          //  print(todo[key]["pictures"][0]);

          }
          else {

        }
      }
    });
  }
   */

}
/*

  getUsers() async {
    var response = await parse_s.getparse('users/');

    print(response["results"]);

    for (var i in response["results"]) {
      User user = new User.fromMap(i);
      var js = {
        "linkedin_link": user.linkedin_link,
        "firstname": user.firstname,
        "familyname": user.fullname,
        "photoUrl": user.image,
        "id": user.auth_id,
        "organisme": user.organisme,
        "titre": user.titre,
        "phone": user.phone,
        "email": user.email,
        "sexe": user.sexe,
        "communityName": user.community,
        "communityKey": user.communitykey,
        "active": user.active,
        "location": {
          "__type": "GeoPoint",
          "latitude": double.parse(user.lat),
          "longitude": double.parse(user.lng),
        },
        "lat": double.parse(user.lat),
        "lng": double.parse(user.lng),
        "age": user.age,
        "anne_exp": user.anne_exp,
        "bio": user.bio,
        "competences": user.cmpetences,
        "objectif": user.objectif
      };

      parse_s.postparse2("users/", js);
    }
  }

  get_publications() async {
    var ref = FirebaseDatabase.instance.reference();
    ref.child('offers').onValue.listen((evt) {
      if (evt.snapshot.value == null) {}
      DataSnapshot data = evt.snapshot;
      var keys = data.value.keys;
      var todo = data.value;
      for (var key in keys) {
        print("jiyaaaaaa");
        var type = todo[key]["type"];
        var address = todo[key]["address"];
        var createdDate = todo[key]["createdDate"];
        var description = todo[key]["description"];
        var endDate = todo[key]["endDate"];
        var initialPrice = todo[key]["initialPrice"];
        var latLng = todo[key]["latLng"];
        var name = todo[key]["name"];
        var partnerKey = todo[key]["partnerKey"];
        var quantity = todo[key]["quantity"];
        var rate = todo[key]["rate"];
        var sellingPrice = todo[key]["sellingPrice"];
        var startDate = todo[key]["startDate"];
        var summary = todo[key]["summary"];
        var urlVideo = todo[key]["urlVideo"];

        print("reeeeeeeeesssssssssssssssssssssss");

        print(todo[key]["latLng"].toString().split(";"));
        String tl = "0.0";
        String lg = "0.0";

/*if(todo[key]["latLng"].toString().split(";").isEmpty)
  {

  }
  else {
  print(todo[key]["latLng"].toString().split(";")[1]);
  //tl = todo[key]["latLng"].toString().split(";")[0];
  //lg = todo[key]["latLng"].toString().split(";")[1];
  }*/

        //
        //

        var pic;
        var a = todo[key]["pictures"];
        if (todo[key]["pictures"].toString() != "null") {
          if (todo[key]["pictures"][0] == null) {
            for (var ky in todo[key]["pictures"].keys) {
              pic = todo[key]["pictures"][ky]["url"];
            }
          } else {
            pic = todo[key]["pictures"][0]["url"];
          }

          var js = {
            "type": type,
            "address": address,
            "createdDate": createdDate,
            "description": description,
            "endDate": endDate,
            "initialPrice": initialPrice,
            "latLng": latLng.toString(),
            "name": name,
            "partnerKey": partnerKey,
            "quantity": quantity,
            "rate": rate,
            "sellingPrice": sellingPrice,
            "startDate": startDate,
            "summary": summary,
            "pictures": [pic],
            "urlVideo": urlVideo
          };

          parse_s.postparse("offers/", js);

          //  print(todo[key]["pictures"][0]);

        } else {}
      }
    });
  }

 */

/*


delete
 var res = await parse_s.getparse('users');
    List sp = res["results"];
    List<User> usrs =
        sp.map((var contactRaw) => new User.fromMap(contactRaw)).toList();

    for(int i=0;i<usrs.length;i++)
      {
        if(usrs[i].createdAt.toString().split(":")[0] == "2018-09-17T14")
          {
            parse_s.deleteparse("users/"+usrs[i].id);
          }

      }



























  getuserfirebase() async {
    var lat;
    var lng;
    var community;
    var community_key;
    int i = 0;

    var ref = FirebaseDatabase.instance.reference();
    ref.child('users').onValue.listen((evt) {
      if (evt.snapshot.value == null) {}
      DataSnapshot data = evt.snapshot;
      var keys = data.value.keys;
      var todo = data.value;
      for (var key in keys) {
        // print(todo[key]);
        if (todo[key]["proffession"].toString() != "null" &&
            todo[key]["proffession"].toString() != "" &&
            todo[key]["communityKey"].toString() != "null" &&
            todo[key]["communityKey"].toString() != "") {
          if (todo[key]["communityKey"].toString() == "-KuoilMdyXSDNHklJMNq") {
            lat = 33.52656678471135;
            lng = -6.718695169287116;
            community = "Casanearshore";
            community_key = todo[key]["communityKey"].toString();
          } else if (todo[key]["communityKey"].toString() ==
              "-KvOZ5XC9hcQmOKrY_is") {
            lat = 33.99074658524094;
            lng = -7.641858840943883;
            community = "Technopolis Rabat";
            community_key = todo[key]["communityKey"].toString();
          }

         String letter = todo[key]["firstname"].toString().toLowerCase()[0];
          var pic;
          var a = todo[key]["pictures"];
          if (todo[key]["pictures"].toString() != "null") {
              for (var ky in todo[key]["pictures"].keys) {
                pic = todo[key]["pictures"][ky]["url"];
               //
              }
          }

          if(pic.toString() == "null")
            {
              pic = Alphabets.list[0][letter];
             // print(letter);
            }


         /* Map<String, dynamic> map = new Map<String, dynamic>();
          map["online"] = false;
          map["last_active"] = todo[key]["lastConnection"];
          Firestore.instance.collection('users').document(widget.user.auth_id).updateData(map);

          FirebaseDatabase.instance
              .reference()
              .child("status")
              .update({
            todo[key]["uid"]: false
          });

          FirebaseDatabase.instance
              .reference()
              .child("status")
              .update({
            todo[key]["uid"]: false
          });
*/

          var js = {
            "linkedin_link": "",
            "firstname": todo[key]["firstname"],
            "familyname": todo[key]["lastname"],
            "photoUrl": pic,
            "id": todo[key]["uid"],
            "organisme": todo[key]["company"],
            "titre": todo[key]["proffession"],
            "phone": todo[key]["gsm"],
            "email": todo[key]["email"],
            "sexe":todo[key]["gender"],
            "communityName": community,
            "communityKey": community_key,
            "active": 1,
            "location": {
              "__type": "GeoPoint",
              "latitude": lat,
              "longitude": lng,
            },
            "lat": lat,
            "lng": lng,
            "age": "",
            "anne_exp": "",
            "bio": "",
            "competences": [],
            "objectif": []
          };

          parse_s.postparse2("users/", js);


          //Here insert query

        } else {}
        /* var active = todo[key]["active"];
          var company = todo[key]["company"];
          var email = todo[key]["email"];
          var firstname = todo[key]["firstname"];
          var lastname = todo[key]["lastname"];
          var gender = todo[key]["gender"];
          var gsm = todo[key]["gsm"];
          var uid = todo[key]["uid"];
          var pro = todo[key]["proffession"];
            print(active + " " + company + " " + email + " " + firstname + " " +
              lastname + " " + gender + " " + gsm + " " + uid + " " + pro);
*/

        // print(todo[key]["latLng"].toString().split(";"));
        //String tl = "0.0";
        //String lg = "0.0";
      }
    });
  }

 */



/*get_publications() async {
    var ref = FirebaseDatabase.instance.reference();
    ref.child('partners').onValue.listen((evt) {
      if (evt.snapshot.value == null) {

      }
      DataSnapshot data = evt.snapshot;
      var keys = data.value.keys;
      var todo = data.value;
      for (var key in keys) {
        print("jiyaaaaaa");
        var name = todo[key]["name"];
        var address = todo[key]["address"];
        var createdDate = todo[key]["createdDate"];
        var description = todo[key]["description"];
        var endDate = todo[key]["endDate"];
        var diretName = todo[key]["directorName"];
        var email = todo[key]["email"];
        var managerName = todo[key]["managername"];


          var js = {

            "address": address,
            "createdDate": createdDate,
            "description":  description,
            "endDate": endDate,
            "directName":  diretName,
            "email": email.toString(),
            "name": name,
            "managerName": managerName,
            "logo": todo[key]["logo"]["url"],


          };


          parse_s.postparse("partners/", js);


          //  print(todo[key]["pictures"][0]);

        }


    });

      updateoffers() async {
    var response = await parse_s.getparse('block?limit=200');

    print(response["results"]);

    for (var i in response["results"]) {
      //Offers user = new Offers.fromMap(i);

/*
  parse_s.postparse('block', {
      "userS": my_id,
      "blockedS": id_other,
      "blocked": {
        "__type": "Pointer",
        "className": "users",
        "objectId": id_other
      },
      "user": {
        "__type": "Pointer",
        "className": "users",
        "objectId": my_id
      }
    });


 */

      print("ji---------------------------------------------");

      print(i["userS"]);
      var id1 = i["userS"];
      var id2 = i["blockedS"];

      var response1 = await parse_s.getparse('users?where={"id":"$id1"}');
      var response2 = await parse_s.getparse('users?where={"id":"$id2"}');

      User user1 = new User.fromMap(response1["results"][0]);
      User user2 = new User.fromMap(response2["results"][0]);

      parse_s.putparse('block/' + i["objectId"], {
        "blockedd": {
          "__type": "Pointer",
          "className": "users",
          "objectId": user1.id
        },
        "userd": {
          "__type": "Pointer",
          "className": "users",
          "objectId": user2.id
        }
      });

      /*  if(user.partnerKey.toString() != "null" && user.partnerKey.toString() != "") {
        if (user.partnerKey == "-KyQ8xR5iCqiJ6g5V27y") {
          print("yeyeeeyey");

          idd = "jGA1c8k7gk";
          var js = {
            "partner": {
              "__type": "Pointer",
              "className": "partners",
              "objectId": idd
            }
          };

          parse_s.putparse("offers/" + user.objectId, js);
        }
        else if (user.partnerKey == "-L0BRkUWUip6j01ArsJN") {
          idd = "jGA1c8k7gk";
          var js = {
            "partner": {
              "__type": "Pointer",
              "className": "partners",
              "objectId": idd
            }
          };

          parse_s.putparse("offers/" + user.objectId, js);
        }
        else if (user.partnerKey == "-KyQ8xR5iCqiJ6g5V27y") {
          idd = "dm8ZGkrnJ6";
          var js = {
            "partner": {
              "__type": "Pointer",
              "className": "partners",
              "objectId": idd
            }
          };

          parse_s.putparse("offers/" + user.objectId, js);
        }
        else if (user.partnerKey == "-L0L4Paf2pd0StAwheZa") {
          idd = "EMhewiQLl5";
          var js = {
            "partner": {
              "__type": "Pointer",
              "className": "partners",
              "objectId": idd
            }
          };

          parse_s.putparse("offers/" + user.objectId, js);
        }
      }*/

    }
  }

  _sendAnalyticsEvent() async {
    await widget.analytics.logEvent(
      name: 'aaaaaaa',
      parameters: <String, dynamic>{
        'string': 'string',
        'int': 42,
        'long': 12345678910,
        'double': 42.0,
        'bool': true,
      },
    );
    print("yessssssssssss");
    // setMessage('logEvent succeeded');
  }
  }*/
