import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as clientHttp ;


class GetLinkData{

  static JsonDecoder _decoder = new JsonDecoder();

  static Future getLink(String url) async {
    String _apiURL =  "https://l-models.appspot.com/ogp?url=$url";
    var response = await clientHttp.get(_apiURL);
    final String jsonBody = response.body;
    final statusCode = response.statusCode;
    if(statusCode < 200 || statusCode >= 300 || jsonBody == null) {
    }

    final postsContainer = _decoder.convert(jsonBody);
    var lin = postsContainer['result'];
    return lin;
//    return lin.map((contactRaw) => new Link1.fromMap(contactRaw)).toList();
  }

}