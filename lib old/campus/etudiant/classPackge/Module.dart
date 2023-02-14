import 'Element.dart';

class Module {
  final String haverage;
  final String average;
  final List<Smodules> elements;
  final String decision;
  final String name;

  Module(
      {this.haverage, this.average, this.elements, this.decision, this.name});

  factory Module.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['detail'] as List;
    List<Smodules> elementsList =
    list.map((i) => Smodules.fromJson(i)).toList();

    return Module(
        haverage: parsedJson["haverage"].toString(),
        average: parsedJson["average"].toString(),
        elements: elementsList,
        decision: parsedJson["decision"],
        name: parsedJson["name"]);
  }
}


