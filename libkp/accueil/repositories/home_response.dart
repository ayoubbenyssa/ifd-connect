import 'package:flutter/material.dart';
import 'package:ifdconnect/accueil/models/categoy_preview.dart';
import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/models/offers.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

import 'package:shared_preferences/shared_preferences.dart';

class HomeRepository {
  /*Future<List<Title>> titles_list() async {
    QueryBuilder<ParseObject> query;

    query = QueryBuilder<ParseObject>(ParseObject("Title"))
      ..setLimit(50)
      ..setAmountToSkip(0);
    final ParseResponse apiResponse = await query.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results.map((e) => Title.fromMap(e)).toList();
    } else
      return [];
  }*/

  Future<HomeResponse> get_posts_by_type(String type, int skip, String class_db,
      User user, bool isnext, String category_video) async {
    QueryBuilder<ParseObject> query;

    if (type == "")
      query = QueryBuilder<ParseObject>(ParseObject(class_db))
        ..setLimit(15)
        ..orderByDescending("createdAt")
        ..includeObject(["author", "partner"])
        ..setAmountToSkip(skip);
    else if (category_video != "" && category_video != "all") {
      QueryBuilder<ParseObject> query_1 =
          QueryBuilder<ParseObject>(ParseObject('VideoCategory'))
            ..whereEqualTo('objectId', category_video);

      query = QueryBuilder<ParseObject>(ParseObject(class_db))
        ..whereEqualTo("type", type)
        ..whereMatchesKeyInQuery("videoCategory", "objectId", query_1)
        ..setLimit(15)
        ..orderByDescending("createdAt")
        ..includeObject(["author", "partner"])
        ..setAmountToSkip(skip);
    } else {
      query = QueryBuilder<ParseObject>(ParseObject(class_db))
        ..whereEqualTo("type", type)
        ..includeObject(["author", "partner", "options", "options.users"])
        ..setLimit(15)
        ..orderByDescending("createdAt")
        ..setAmountToSkip(skip);
    }

    final ParseResponse apiResponse = await query.query();

    if (apiResponse.success && apiResponse.results != null) {
      List<Offers> offs =
          apiResponse.results.map((e) => Offers.fromMap(e)).toList();

      return HomeResponse(
          responseCode: 200,
          message: "Success",
          publications:
              apiResponse.results.map((e) => Offers.fromMap(e)).toList());
    } else {
      return HomeResponse(
          responseCode: 0, message: null, publications: [], isnext: isnext);
      ;
    }
  }
  static ParseServer parse_s = new ParseServer();


  static Future<HomeResponse> get_events() async {
    String url = 'offers?where={"type":"event"}&order=-createdAt&include=partner';
    var getcity = await parse_s.getparse(url);
    if (getcity == "No")
      return HomeResponse(responseCode: 0, message: null, publications: []);
    if (getcity == "error")
      return HomeResponse(responseCode: 0, message: null, publications: []);
    List res = getcity["results"];

    List<Offers> offs = res.map((e) => Offers.fromMap(e)).toList();

    return HomeResponse(
        responseCode: 200, message: "Success", publications: offs);
  }



  static Future<HomeResponse> get_posts() async {
    String url = 'offers?where={"type":"news"}&order=-createdAt&include=partner';
    var getcity = await parse_s.getparse(url);
    if (getcity == "No")
      return HomeResponse(responseCode: 0, message: null, publications: []);
    if (getcity == "error")
      return HomeResponse(responseCode: 0, message: null, publications: []);
    List res = getcity["results"];
    /* return res.map((var contactRaw) => new Partner.fromMap(contactRaw))
        .toList();*/

    List<Offers> offs = res.map((e) => Offers.fromMap(e)).toList();

    return HomeResponse(
        responseCode: 200, message: "Success", publications: offs);
  }

  Future<HomeResponse> get_posts_by_type_user(
      String id_user, String type, int skip, String class_db) async {
    QueryBuilder<ParseObject> query;

    QueryBuilder<ParseObject> calendarQuery =
        QueryBuilder<ParseObject>(ParseObject('_User'))
          ..whereEqualTo('objectId', id_user);

    query = QueryBuilder<ParseObject>(ParseObject(class_db))
      ..whereEqualTo("type", type)
      ..whereMatchesKeyInQuery("author", "objectId", calendarQuery)
      ..includeObject(["user", "options", "options.users"])
      ..setLimit(30)
      ..setAmountToSkip(skip);

    final ParseResponse apiResponse = await query.query();

    if (apiResponse.success && apiResponse.results != null) {
      // print(apiResponse.results.map((e) => Publication.fromMap(e)).toList());
      return HomeResponse(
          responseCode: 200,
          message: "Success",
          publications:
              apiResponse.results.map((e) => Offers.fromMap(e)).toList());
    } else {
      return HomeResponse(responseCode: 0, message: null, publications: []);
      ;
    }
  }

  /*static Future<List<Offers>> get_Videos_byid(String id) async {
    QueryBuilder<ParseObject> query;

    QueryBuilder<ParseObject> query_1 =
        QueryBuilder<ParseObject>(ParseObject('VideoCategory'))
          ..whereEqualTo('objectId', id);

    query = QueryBuilder<ParseObject>(ParseObject("offers"))
      ..whereEqualTo("type", "videotheque")
      ..whereMatchesKeyInQuery("videoCategory", "objectId", query_1)
      ..includeObject(["author", "partner"])
      ..setLimit(5)
      ..setAmountToSkip(0);
    final ParseResponse apiResponse = await query.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results.map((e) => Offers.fromMap(e)).toList();
    } else {
      return [];
    }
  }*/

  static Future<HomeResponse> get_allVideos(all) async {
    String url = 'offers?where={"type":"videotheque"}&order=-createdAt&include=partner,author';
    var getcity = await parse_s.getparse(url);
    if (getcity == "No")
      return HomeResponse(responseCode: 0, message: null, publications: []);
    if (getcity == "error")
      return HomeResponse(responseCode: 0, message: null, publications: []);
    List res = getcity["results"];
    /* return res.map((var contactRaw) => new Partner.fromMap(contactRaw))
        .toList();*/

    List<Offers> offs = res.map((e) => Offers.fromMap(e)).toList();

    return HomeResponse(
        responseCode: 200, message: "Success", publications: offs);
  }


  static Future<HomeResponse> get_3Videos(all) async {
    String url = 'offers?where={"type":"videotheque"}&order=-createdAt&include=partner,author&limit=5';
    var getcity = await parse_s.getparse(url);
    if (getcity == "No")
      return HomeResponse(responseCode: 0, message: null, publications: []);
    if (getcity == "error")
      return HomeResponse(responseCode: 0, message: null, publications: []);
    List res = getcity["results"];
    /* return res.map((var contactRaw) => new Partner.fromMap(contactRaw))
        .toList();*/

    List<Offers> offs = res.map((e) => Offers.fromMap(e)).toList();

    return HomeResponse(
        responseCode: 200, message: "Success", publications: offs);
  }


  /* static Future<List<Offers>> get_3Videos(String id) async {
    QueryBuilder<ParseObject> query;

    query = QueryBuilder<ParseObject>(ParseObject("offers"))
      ..whereEqualTo("type", "videotheque")
      ..includeObject(["author", "partner"])
      ..setLimit(3)
      ..setAmountToSkip(0)
      ..orderByDescending("createdAt");
    final ParseResponse apiResponse = await query.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results.map((e) => Offers.fromMap(e)).toList();
    } else {
      return [];
    }
  }*/

  /**
   * Categories
   */
  static Future<List<CategoryVideos>> get_category_Videos() async {
    QueryBuilder<ParseObject> query;

    query = QueryBuilder<ParseObject>(ParseObject("VideoCategory"));

    final ParseResponse apiResponse = await query.query();

    if (apiResponse.success && apiResponse.results != null) {
      // print(apiResponse.results.map((e) => Publication.fromMap(e)).toList());

      return apiResponse.results.map((e) => CategoryVideos.fromMap(e)).toList();
    } else {
      return [];
      ;
    }
  }
}

class HomeResponse {
  final int responseCode;
  final String message;
  final List<Offers> publications;
  bool isnext;

  HomeResponse({
    @required this.responseCode,
    @required this.message,
    @required this.isnext,
    @required this.publications,
  });
}
