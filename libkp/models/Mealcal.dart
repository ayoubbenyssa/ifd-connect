import 'package:ifdconnect/models/type_composant.dart';
import 'package:ifdconnect/models/type_ropa.dart';

class MealOneItem {
  String date;

  List<MealCal> meals;

  static List reservations = [];
  static List annulations = [];

  MealOneItem({this.date, this.meals});

  factory MealOneItem.fromDoc(String date, document) {
    return new MealOneItem(
        date: date,
        meals: List<MealCal>.from(
            document.map((value) => MealCal.fromDoc(value)).toList()));
  }
}

class MealCal {
  String date;

  // var id;
  // String name;
  bool is_student_reserved;

  String meal;

  List ticket;

  List<Type_composant> type_composant;

  var pricemeal_id;

  List<Type_repas> type_repas;

  bool check;

  bool more_dtaills;

  var price;

  var ticket_id;

  bool show = false;

  MealCal(
      {this.type_composant,
      this.is_student_reserved,
      this.meal,
      this.pricemeal_id,
      this.show = true,
      this.ticket,
      this.type_repas,
      this.date,
      this.check,
      this.price,
      this.ticket_id,
      this.more_dtaills});

  factory MealCal.fromDoc(Map<String, dynamic> document) {
    if(document["type_repas"].length>0){
      print('hala');
      print(document["pricemeal_id"]);
      print(document["type_repas"]);
    }
    // print('hala');
    // document["type_repas"];
    // print(document);
    return new MealCal(
      is_student_reserved: document["is_student_reserved"],
      meal: document["meal"],
      show: true,
      ticket: [],
      type_composant: document["type_composant"] == null
          ? []
          : (document["type_composant"] as List)
              .map((var element) => Type_composant.fromDoc(element))
              .toList(),
      pricemeal_id: document["pricemeal_id"],
      type_repas: document["type_repas"] == null
          ? []
          : (document["type_repas"] as List)
              .map((var element) => Type_repas.fromDoc(element))
              .toList(),
      date: document["start_date"],
      price: document["price"],
      check: false,
      // ticket_id: document["ticket_id"],
      ticket_id: !document["is_student_reserved"]? null : document["ticket"]["resto_ticket"]["id"],
      more_dtaills: true,
    );
  }
}
