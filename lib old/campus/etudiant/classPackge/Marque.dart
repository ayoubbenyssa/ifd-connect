import 'Module.dart';


class Marque {
  final int semestre;
  final List<Module> modules;

  Marque({this.semestre, this.modules});

  factory Marque.fromJson(Map<String, dynamic> json) {
    var list = json['modules'] as List;
    List<Module> modulesList = list.map((i) => Module.fromJson(i)).toList();

    return Marque(semestre: json["semestre"], modules: modulesList);
  }
}
