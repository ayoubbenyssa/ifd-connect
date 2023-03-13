import 'dart:convert';

import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/reclamation/models/reclamation.dart';
import 'package:ifdconnect/reclamation/models/thematque.dart';
import 'package:ifdconnect/reclamation/models/type.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ReclamationProvider with ChangeNotifier {
  Thematique _selectedThematque;
  List<Thematique> _thematiques = [];
  List<TypeReclamation> _typesReclamation = [];
  List<String> _priorities = ["Faible", "Moyenne", "Elevé"];
  List<Reclamation> _reclamations = [];

  TypeReclamation _selectedReclamation;

  String _selectedPriority;

  BuildContext globalContext;
  final ParseServer _api = ParseServer();
  bool load_thematque = false;
  bool load = true;

  ReclamationProvider(BuildContext context,User user) {
    globalContext = context;
    _fetchThematiques();
    _fetchTypeReclamation();
    _fetchReclamations(user);
  }

  void _fetchReclamations(User user) async {
    String id = json.encode(user.id);
    final res = await _api
        .getparse('Reclamation?include=user,type,reclamation&order=-createdAt&where={"user":{"__type":"Pointer","className":"users","objectId":$id}}');

    if (res == "No") _thematiques = [];
    if (res == "error") _thematiques = [];
    List result = res["results"];

    _reclamations = result.map((e) => Reclamation.fromJson(e)).toList();
    load = false;
    notifyListeners();
  }

  void _fetchThematiques() async {
    final res = await _api.getparse("Thematique");

    if (res == "No") _thematiques = [];
    if (res == "error") _thematiques = [];
    List result = res["results"];

    _thematiques = result.map((e) => Thematique.fromMap(e)).toList();

    load_thematque = false;
    notifyListeners();
  }

  void _fetchTypeReclamation() async {
    final res = await _api.getparse("TypeReclamation");

    if (res == "No") _thematiques = [];
    if (res == "error") _thematiques = [];
    List result = res["results"];

    _typesReclamation = result.map((e) => TypeReclamation.fromMap(e)).toList();

    print("iuuuuuuuuu");
    print(_typesReclamation);

    load_thematque = false;
    notifyListeners();
  }

  void onChangeReclamation(type) {
    _selectedReclamation = type;
    notifyListeners();
  }

  void onChangeThematique(type) {
    _selectedThematque = type;
    notifyListeners();
  }

  void onChangePriority(pr) {
    _selectedPriority = pr;
    notifyListeners();
  }

  set tehmatiques(List<Thematique> them) {
    _thematiques = them;
    notifyListeners();
  }

  set typesReclamation(List<TypeReclamation> them) {
    _typesReclamation = them;
    notifyListeners();
  }

  String get selectedPriority => _selectedPriority;

  Thematique get selectedThematque => _selectedThematque;

  TypeReclamation get selectedReclamation => _selectedReclamation;

  List<String> get priorities => _priorities;

  List<Reclamation> get reclamations => _reclamations;

  List<Thematique> get listThematiques => _thematiques;

  List<TypeReclamation> get typesReclamation => _typesReclamation;
}
