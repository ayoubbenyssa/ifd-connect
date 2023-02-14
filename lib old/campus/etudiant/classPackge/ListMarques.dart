import 'Marque.dart';

class ListMarques {
  final List<Marque> marques;

  ListMarques({
    this.marques,
  });

  factory ListMarques.fromJson(List<dynamic> parsedJson) {
    List<Marque> marques = new List<Marque>();
    marques = parsedJson.map((i) => Marque.fromJson(i)).toList();

    return new ListMarques(marques: marques);
  }
}
