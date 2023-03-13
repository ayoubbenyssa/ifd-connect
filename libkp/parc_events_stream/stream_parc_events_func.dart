import 'dart:convert';

import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/models/annonces.dart';
import 'package:ifdconnect/models/favorite.dart';
import 'package:ifdconnect/models/offers.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/search_apis.dart';

class StreamPostsFunctions {
  ParseServer parseFunctions = new ParseServer();

  urlpost(User user, String category, String type, String sector, skip, dep,
      dest, da, user_cov_id, cat, boutique, favorite, search, likepost) {
    var url = '';
    int number = DateTime.now().millisecondsSinceEpoch;

    if (favorite == true) {
      String id = user.id;
      url +=
          '"author":{"\$inQuery":{"where":{"objectId":"$id"},"className":"users"}}';
      return 'save_fav?limit=20&skip=$skip&count=1&where={$url}&include=post';
    }

    if (boutique == true && category == "Tous les produits") {
      url += '"type":"boutique"';
      return 'offers?limit=20&skip=$skip&count=1&where={$url}&include=partner&order=-createdDate';
    }
    if (boutique == true && category != "") {
      url += '"type":"boutique","sector":"$category"';
      return 'offers?limit=20&skip=$skip&count=1&where={$url}&include=partner&order=-createdDate';
    } else if (category != "" &&
        category != null &&
        category == "cov_emi" &&
        dep.toString() != "null" &&
        dep != "") {
      url +=
          '"type":"${category.toLowerCase()}","depart":"$dep","destination":{"\$regex": "$dest"},"time_dep":"$da","emi":true';
      return 'offers?limit=20&skip=$skip&count=1&where={$url}&include=author&include=author.user_formations,author.role&order=-boostn';
    } else if (category != "" &&
        category != null &&
        category == "cov_emi" &&
        user_cov_id.toString() != "null" &&
        user_cov_id.toString() != "") {
      url +=
          '"type":"${category.toLowerCase()}","author":{"\$inQuery":{"where":{"objectId":"$user_cov_id"},"className":"users"}}';
      return 'offers?limit=20&skip=$skip&count=1&where={$url}&include=author&include=author.user_formations,author.role&order=-createdAt';
    } else if (category != "" && category != null && category == "cov_emi") {
      url += '"type":"${category.toLowerCase()}","emi":true';

      return 'offers?limit=20&skip=$skip&count=1&where={$url}&include=author&include=author.user_formations,author.role&order=-boostn';
    } else if (category != "" &&
        category != null &&
        category == "promotion" &&
        sector != "" &&
        sector != null) {
      var kkey = user.communitykey;

      url +=
          '"type":"${category.toLowerCase()}","sector":"$sector","startDate":{"\$lte":$number},"endDate":{"\$gte":$number},"partner":{"\$inQuery":{"where":{"status":"1"},"className":"partners"}}';

      return 'offers?limit=20&skip=$skip&count=1&where={$url}&include=partner&order=-createdDate';
    } else if (category != "" && category != null && category == "promotion") {
      var kkey = user.communitykey;

      url +=
          '"type":"${category}","startDate":{"\$lte":$number},"endDate":{"\$gte":$number}';

      return 'offers?limit=20&skip=$skip&count=1&where={$url}&include=partner&order=-createdDate';
    } else if (likepost != "" && likepost.toString() != "null") {
      var url = jsonEncode({
        "post": {
          "\$inQuery": {
            "where": {"objectId": "$likepost"},
            "className": "offers"
          }
        }
      });
      return 'likes?limit=20&skip=$skip&where=$url&include=author,author.user_formations,author.role&order=-createdAt&count=1';
    } else if (category != "" && category != null) {
      var key = user.communitykey;

      int number = DateTime.now().millisecondsSinceEpoch;

      if (category == "event")
        url +=
            '"type":"${category.toLowerCase()}","active":1,"activatedDate":{"\$lte":$number}';
      else if (category == "news")
        url +=
            '"type":"${category.toLowerCase()}","active":1';
      else
        url +=
            '"type":"${category.toLowerCase()}","cat":"$cat","communitiesKey":"$key"';

      return 'offers?limit=20&skip=$skip&count=1&where={$url}&include=partner&order=-createdDate';
    } else if (type == "an" && user_cov_id.toString() != "null") {
      var qu = [
        {"type": "Mission_emi"},
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
        "active": 1
      });
      return 'offers?limit=20&skip=$skip&count=1&where=$url&include=author&include=author.user_formations,author.role&order=-boostn';
    } else if (type != "" && type != null) {
      url += '"type":"${type}","active":1,"emi":true';
      return 'offers?limit=20&skip=$skip&count=1&where={$url}&include=author&include=author.user_formations,author.role&order=-boostn';
    }
  }

  /*
  "partner":{"\$inQuery":{"where":{"order_partner":{"\$lte":0}},"className":"partners"}}
   */

  fetchposts(User user,
      {String category = "",
      String type = "",
      int skip = 0,
      sector,
      dep,
      dest,
      likepost,
      da,
      user_cov_id,
      cat,
      search,
      boutique,
      favorite}) async {
    var url = "";

    if (search != "" && search != null) {
      var resultsearch = await SearchApis.searchposts(search);

      var wherecondition = '"objectId":{"\$in":$resultsearch}';

      url =
          'users?limit=20&skip=$skip&count=1&where={$wherecondition,"emi":true,"active":1}&include=user_formations,role';
    } else {
      url = await urlpost(user, category, type, sector, skip, dep, dest, da,
          user_cov_id, cat, boutique, favorite, search, likepost);
    }
    var results = await parseFunctions.getparse(url + "&order=-createdAt");
    return data(category, type, results, favorite, search, likepost);
  }

  data(
    category,
    type,
    results,
    favorite,
    search,
    likepost,
    /*report, likes, favorite*/
  ) {
    if (results == "nointernet") return "nointernet";
    if (results == "error") return "error";
    if (results["count"] == 0) return "empty";
    if (results["results"].length > 0) {
      List postsItems = results['results'];

      if (search != "" && search != null) {
        return {
          'results': postsItems.map((raw) => new User.fromMap(raw)).toList(),
          'count': results['count']
        };
      }

      if (favorite == true) {
        return {
          'results':
              postsItems.map((raw) => new Favorite.fromMap(raw)).toList(),
          'count': results['count']
        };
      } else if (category != "" && category != null) {
        return {
          'results': postsItems.map((raw) => new Offers.fromMap(raw)).toList(),
          'count': results['count']
        };
      } else if (likepost != "" && likepost != null) {
        return {
          'results':
              postsItems.map((raw) => new User.fromMap(raw["author"])).toList(),
          'count': results['count']
        };
      } else if (type != "" && type != null) {
        return {
          'results': postsItems.map((raw) => new Offers.fromMap(raw)).toList(),
          'count': results['count']
        };
      }
    }
    return "nomoreresults";
  }
}
