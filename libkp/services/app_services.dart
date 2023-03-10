import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/models/offers.dart';
import 'package:ifdconnect/services/remote_config_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as clientHttp ;


class AppServices {
  static ParseServer parse_s = new ParseServer();

  final JsonDecoder _decoder = new JsonDecoder();


  // String urlclasse = "http://217.182.139.190:1344/parse/classes/";
  // String urlParse = "http://217.182.139.190:1344/parse/";


  static hasArabicCharacters(String text) {
    var regex = new RegExp(
        "[\u0600-\u06ff]|[\u0750-\u077f]|[\ufb50-\ufc3f]|[\ufe70-\ufefc]");

    return regex.hasMatch(text);
  }

  // paramsparsejson() {
  //   return {
  //     "X-Parse-Application-Id": "EAAe32wHSy9jc1LFN3G56",
  //     "Content-Type": 'applicaton/json',
  //     'X-Parse-Master-Key': 'iavconnect123456789'
  //   };
  // }

  // paramsparsenojson() {
  //
  //   return {
  //     "X-Parse-Application-Id": "EAAe32wHSy9jc1LFN3G56",
  //     'X-Parse-Master-Key': 'iavconnect123456789'
  //   };
  // }

  initializeRemoteConfig() async {
    RemoteConfigService _remoteConfigService;
    _remoteConfigService = await RemoteConfigService.getInstance();
    await _remoteConfigService.initialize();
    print(_remoteConfigService.getUrl.toString());

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('api_url', _remoteConfigService.getUrl);
    prefs.setString('url_parce', _remoteConfigService.geturl_parce);
    prefs.setString('urlclasse', _remoteConfigService.geturlclasse);
    prefs.setString('"appId_parce"', _remoteConfigService.getappId_parce);
    prefs.setString('Parse_Id', _remoteConfigService.getParse_Id);
    prefs.setString('Parse_Key', _remoteConfigService.getParse_Key);
    prefs.setString('Content_type', _remoteConfigService.getContent_type);
  }

  SharedPreferences prefs;

  uploadparse(geturl,File dat, classe) async {

    List<int> data = await dat.readAsBytes();
    var results;
    initializeRemoteConfig();
    prefs = await SharedPreferences.getInstance();
      var url = Uri.parse(Uri.encodeFull(prefs.getString('url_parce') + geturl));
      var response =
      await clientHttp.post(url, headers: prefs.getString('paramsparsejson') as Map<String, dynamic> , body: data);
      String jsonBody = response.body;
      var statusCode = response.statusCode;
      if (statusCode < 200 || jsonBody == null || statusCode >= 300) {
        results = "error";
      } else {
        var postsContainer = _decoder.convert(jsonBody);
        /*  var data2 =
        JSON.encode({"photo": postsContainer['url'], "classe": classe});
        clientHttp.post(url2, headers: paramsparsenojson(), body: data2);*/
        results = postsContainer["url"];
      }

    return results;
  }


  static go_webview1(url,text,context){
    Navigator.push(context,
        new MaterialPageRoute<String>(
            builder: (BuildContext context) {
              return Scaffold(
                appBar:AppBar(title: Text(text),),
                body: WebView(
                  initialUrl: url,
                  javascriptMode: JavascriptMode.unrestricted,

                ),);
            }));
  }

  static go_webview(url,context){
    Navigator.push(context,
        new MaterialPageRoute<String>(
            builder: (BuildContext context) {
              return Scaffold(
                appBar:AppBar(title: Text(""),),
                body: WebView(
                  initialUrl: url,
                  javascriptMode: JavascriptMode.unrestricted,

                ),);
            }));
  }

  static matchUrl(value) {
    RegExp regExp = new RegExp(
        r'(http|ftp|https):\/\/[\w\-_]+(\.[\w\-_]+)+([\w\-\.,@?^=%&amp;:/~\+#]*[\w\-\@?^=%&amp;/~\+#])?');
    return regExp.hasMatch(value);
  }

  static fetchpostsnearby(distance, lat, lng) async {
    var wherecondition = "";

    wherecondition +=
        '"location": {"\$nearSphere": { "__type": "GeoPoint","latitude": $lat, "longitude": $lng },"\$maxDistanceInKilometers": $distance},"emi":true';

    var url = 'offers?limit=120&include=author&include=author.user_formations,author.role&';
    url = url + 'where={$wherecondition}';
    var results = await parse_s.getparse(url);
    if (results == "nointernet") return "nointernet";
    if (results == "error") return "error";
    if (results["count"] == 0) return "empty";
    if (results["results"].length > 0) {
      List postsItems = results['results'];
      return postsItems.map((raw) => new Offers.fromMap(raw)).toList();
    }
    return [];
  }
}
