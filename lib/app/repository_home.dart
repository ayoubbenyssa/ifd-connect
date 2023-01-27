import 'package:ifdconnect/models/role.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomeRepository {

  Future<List<Role>> titles_list() async {
    QueryBuilder<ParseObject> query;

    query = QueryBuilder<ParseObject>(ParseObject("role"))
      ..setLimit(50)
      ..setAmountToSkip(0);
    final ParseResponse apiResponse = await query.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results.map((e) => Role.fromMap(e)).toList();
    } else
      return [];
  }


}
