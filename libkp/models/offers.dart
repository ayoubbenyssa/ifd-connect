import 'package:ifdconnect/models/option.dart';
import 'package:intl/intl.dart';
import 'package:ifdconnect/models/partner.dart';
import 'package:ifdconnect/models/user.dart';

class Offers {
  var objectId;
  var type = "";
  var address = "";
  var createdDate = "";
  var description = "";
  var endDate;
  String link_id;

  var initialPrice = "";
  var latLng = "";
  var name = "";
  var partnerKey = "";
  var quantity = "";
  var rate = "";
  var sellingPrice = "";
  String startDate = "";
  var rating;
  var title;
  int length_option;
  List<dynamic> options = [];

  var numb;

  var count_r;
  var summary = "";
  var urlVideo = "";
  List pic;
  var updatedAt = "";
  static var formatter = new DateFormat('yyyy-MM-dd');
  var dis;
  var created;
  var liked;
  var numberlikes;
  User author;
  var aut;
  Partner partner;
  int nboost;
  int count = 0;
  User author1;
  var create;
  var delete = false;
  var isLiked = false;
  var likesCount = 0;
  String numbercommenttext = "";

  String from_place;
  String to_place;
  String price;
  String date_cov;
  String nb_places;
  List station;
  var hour_d;
  var createdAt;
  var lat;
  var dte;
  var lng;
  var image;
  var views;
  List items;

  Offers(
      {this.objectId,
      this.type,
      this.dte,
      this.address,
      this.createdDate,
      this.description,
      this.endDate,
      this.initialPrice,
      this.price,
      this.latLng,
      this.views,
      this.created,
      this.options,
      this.count,
      this.create,
      this.name,
      this.author1,
      this.updatedAt,
      this.partnerKey,
        this.link_id,
      this.quantity,
      this.to_place,
      this.rating,
      this.nb_places,
      this.rate,
      this.count_r,
      this.partner,
      this.author,
      this.date_cov,
      this.title,
      this.station,
      this.startDate,
      this.sellingPrice,
      this.summary,
      this.lat,
      this.lng,
      this.image,
      this.hour_d,
      this.urlVideo,
      this.from_place,
      this.createdAt,
      this.pic});

  Offers.fromMap(Map<String, dynamic> document)
      : objectId = document["objectId"],
        hour_d = document["hour_d"],
        lat = document["lat"],
        lng = document["lng"],
        image = document["image"],
        items = document["items"],
        link_id = document["link"],

      options = document["options"].toString() == "null"
            ? []
            : document["options"]
                .map((val) => new Option.fromMap(val))
                .toList(),
        title = document["title"],
        from_place = document["depart"],
        nboost = document["boostn"],
        views = document["views"].toString() == "null" ? 0 : document["views"],
        count = document["count"].toString() == "null" ? 0 : document["count"],
        rating =
            document["rating"].toString() == "null" ? 0 : document["rating"],
        author1 = document["author"].toString() == "null"
            ? null
            : new User.fromMap(document["author"]),
        price = document["price"],
        to_place = document["destination"],
        date_cov = document["time_dep"],
        station = document["station"],
        createdAt = document["createdAt"],
        created = document["createdDate"],
        nb_places = document["nb_place"],
        numberlikes = document["numberlikes"].toString(),
        pic = document["pictures"],
        type = document["type"],
        dte = document["time_an"],
        updatedAt = document["updatedAt"],
        create = DateTime.parse(document["createdAt"]),
        address = document["address"],
        count_r =
            document["count_r"].toString() == "null" ? 0 : document["count_r"],
        createdDate = document["createdDate"].toString(),
        description = document["description"],
        endDate =
            document["endDate"].toString() == "null" ? "" : document["endDate"],
        initialPrice = document["initialPrice"].toString(),
        latLng = document["latLng"].toString(),
        name = document["name"],
        partnerKey = document["partnerKey"],
        quantity = document["quantity"].toString(),
        rate = document["rate"].toString(),
        startDate = formatter.format(DateTime.parse(document["createdAt"])),
        sellingPrice = document["sellingPrice"].toString(),
        summary = document["summary"].toString(),
        urlVideo = document["urlVideo"].toString(),
        aut = document["author"].toString(),
        partner = document["partner"].toString() == "null"
            ? null
            : new Partner.fromMap(document["partner"]),
        author = document["author"].toString() == "null"
            ? null
            : new User.fromMap(document["author"]);
}
