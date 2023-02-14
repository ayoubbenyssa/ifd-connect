import 'package:ifdconnect/models/Mealcal.dart';

class MealList{

  var date ;
  List<MealCal> mealcal ;
  bool check ;




  MealList({
    this.date,
    this.mealcal,
    this.check ,

  });

  factory MealList.fromDoc(Map<String,dynamic> document) {
    print("test print 0 ");
    print(document["${document.keys}"]);
    // for (var key in data["result"][i].keys) {
    for (var key in document.keys) {
      for (var j = 0; j < document[key].length; j++) {
        return new  MealList(
            date: key,
            mealcal : document[key][j] == null?[]:(document[key][j]).map((var element) => MealCal.fromDoc(element)).toList(),
            check:  false,
    );
      }
      }

  }

}