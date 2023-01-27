import 'dart:convert';

import 'package:ifdconnect/models/role.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/models/user_response.dart';
import 'package:ifdconnect/app/config/config_url.dart';

import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:http/http.dart' as clientHttp;

class FilterUsersRepository {
  Future<UserResponse> filterr_users(String case_filter, User user,
      {double lat, double long, Role title}) async {
    QueryBuilder<ParseObject> query;

    switch (case_filter) {
      case "near":
        query = QueryBuilder<ParseObject>(ParseObject('users'))
          ..whereNear('location',
              ParseGeoPoint(longitude: user.lng, latitude: user.lat))
          ..whereEqualTo('active', 1)
          ..includeObject(["role_user", "user_formations"]);
        ;
        break;

      case "newer":
        query = QueryBuilder<ParseObject>(ParseObject('users'))
          ..orderByDescending('createdAt')
          ..whereEqualTo('active', 1)
          ..includeObject(["role_user", "user_formations"]);

        ;
        break;
      case "older":
        query = QueryBuilder<ParseObject>(ParseObject('users'))
          ..orderByDescending('createdAt')
          ..whereEqualTo('active', 1)
          ..includeObject(["role_user", "user_formations"]);
        ;
        break;
      case "title":
        query = QueryBuilder<ParseObject>(ParseObject('users'))
              ..orderByDescending('createdAt')
              ..whereEqualTo('active', 1)
              ..whereMatchesQuery(
                  "role_user",
                  QueryBuilder<ParseObject>(ParseObject('role'))
                    ..whereEqualTo('objectId', title.id))
              /*..whereMatchesKeyInQuery(
                  "role_user",
                  "objectId",
                  QueryBuilder<ParseObject>(ParseObject('role'))
                    ..whereEqualTo('objectId', title.id))*/
              ..includeObject(["role_user", "user_formations"])

            /* ..whereMatchesQuery(
              "title",
              "objectId",
              QueryBuilder<ParseObject>(ParseObject('Title'))
                ..whereEqualTo('objectId', title.id))*/
            ;
        break;

      case "service":
        query = QueryBuilder<ParseObject>(ParseObject('users'))
          /* ..whereMatchesKeyInQuery(
              "service",
              "objectId",
              QueryBuilder<ParseObject>(ParseObject('Service'))
                ..whereEqualTo('objectId', service.id))*/
          ..includeObject(["title", "role_user", "user_formations"]);
        break;
    }

    final ParseResponse apiResponse = await query.query();

    if (apiResponse.success && apiResponse.results != null) {
      List<User> users =
          apiResponse.results.map((e) => User.fromMap(e)).toList();
      return UserResponse(message: 'success', responseCode: 1, user: users);
    } else {
      return UserResponse(user: [], responseCode: 0, message: "failure");
    }
  }
}
