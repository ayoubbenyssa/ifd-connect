import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'dart:convert';

class Formmule extends StatefulWidget {
  const Formmule({Key key}) : super(key: key);

  @override
  _FormmuleState createState() => _FormmuleState();
}

class NumberList {
  String number;
  int index;

  NumberList({this.index, this.number});
}

class _FormmuleState extends State<Formmule> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<FormState> _formKey_adresse = GlobalKey();
  final GlobalKey<FormState> _formKey_tell = GlobalKey();
  final GlobalKey<FormState> _formKey_email = GlobalKey();
  final GlobalKey<FormState> _formKey_adresse_emplois = GlobalKey();
  final GlobalKey<FormState> _formKey_diplom = GlobalKey();
  final GlobalKey<FormState> _formKey_dialoge = GlobalKey();
  final GlobalKey<FormState> _autre_formation = GlobalKey();

  final GlobalKey<FormState> _formKey_fillier = GlobalKey();

  Widget Add_diplome() {
    return AlertDialog(
      key: _formKey_dialoge,
      content: SingleChildScrollView(
        child: Container(
          height: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  "Diplôme  : ",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                padding: EdgeInsets.only(
                  left: 5,
                  right: 5,
                ),
                margin: EdgeInsets.only(top: 10),
                height: 30,
                // width: 130,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  // border: Border.all(color:Color.fromRGBO(208, 207, 207, 1) )
                ),
                child: TextFormField(
                  // key: _formKey_diplom,
                  maxLines: 1,

                  decoration: InputDecoration(
                    hintText: "Diplôme ...",
                    labelStyle: TextStyle(fontSize: 13, color: Colors.black),
                    border: InputBorder.none,
                  ),
                  // onSaved: (value) {
                  //   info_dipome['nom diplome'] = value.toString();
                  // },
                  controller: nom_dipl,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null) {
                      return 'Entre un Diplôme';
                    }
                  },
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                child: Text(
                  "Année  : ",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              InkWell(
                child: Container(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  margin: EdgeInsets.only(top: 5),
                  height: 30,
                  // width: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    // border: Border.all(color:Color.fromRGBO(208, 207, 207, 1) )
                  ),
                  child: Text("${_selectedDate.year}"),
                ),
                onTap: year_picker,
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                child: Text(
                  "Filier de Fotmation  : ",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                padding: EdgeInsets.only(left: 15, right: 5),
                margin: EdgeInsets.only(
                  top: 5,
                ),
                height: 30,
                // width: 130,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  // border: Border.all(color:Color.fromRGBO(208, 207, 207, 1) )
                ),
                child: TextFormField(
                  key: _formKey_fillier,
                  decoration: InputDecoration(
                    hintText: "Filiére de formation ",
                    labelStyle: TextStyle(fontSize: 13, color: Colors.black),
                    border: InputBorder.none,
                  ),
                  controller: filier_de_formation,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null) {
                      return 'Entre Filiére de formation ';
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        FlatButton(
            onPressed: () {
              print("@@@@@@@@@@@@@");

              setState(() {
                nom_deplom.add(nom_dipl.text);
                annee.add(_selectedDate.year.toString());
                filier.add(filier_de_formation.text);
                nom_dipl.clear();
                filier_de_formation.clear();
              });
              print("@@@@@@@@@@@@@");
              print(nom_deplom);
              print(annee);
              print(filier);
              print("@@@@@@@@@@@@@");
              Navigator.of(context).pop();
            },
            child: Container(
                padding:
                    EdgeInsets.only(left: 30, right: 30, bottom: 15, top: 15),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(44, 165, 184, 1),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Text(
                  "Ok",
                  style: TextStyle(color: Colors.white),
                ))),
        FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Container(
                padding:
                    EdgeInsets.only(left: 30, right: 30, bottom: 15, top: 15),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Text(
                  "fermer",
                  style: TextStyle(color: Colors.black),
                ))),
      ],
    );
  }

  List<String> nom_deplom = [];
  List<String> annee = [];
  List<String> filier = [];

  Map<String, String> info_dipome = {
    'nom diplome': '',
    'annee': '',
    'filie de formation': '',
  };
  var nom = TextEditingController();

  var nom_dipl = TextEditingController();

  var filier_de_formation = TextEditingController();

  var Adresse_Actuelle = TextEditingController();

  var tell = TextEditingController();

  var email_pro = TextEditingController();

  var autre_formation = TextEditingController();

  var Adresse_emploi = TextEditingController();

  DateTime date_naiss = DateTime.now();

  String selected_secteur = 'Public';
  String selected_domain = 'Agricol';
  int id = 1;
  int id_domaine = 1;

  List<NumberList> secteur = [
    NumberList(
      index: 1,
      number: "Public",
    ),
    NumberList(
      index: 2,
      number: "Privé",
    ),
  ];
  List<NumberList> demaine = [
    NumberList(
      index: 1,
      number: "Agricol",
    ),
    NumberList(
      index: 2,
      number: "Non Agricol",
    ),
  ];

  void _datePicker() {
    showDatePicker(
            context: context,
            initialDate: date_naiss,
            firstDate: DateTime(DateTime.now().year - 80, DateTime.now().month,
                DateTime.now().day, DateTime.now().hour, DateTime.now().minute),
            lastDate: DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day, DateTime.now().hour, DateTime.now().minute))
        .then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        date_naiss = value;
      });
    });
  }

  DateTime date_dip = DateTime.now();
  DateTime _selectedDate = DateTime(DateTime.now().year);

  year_picker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Year"),
          content: Container(
            // Need to use container to add size constraint.
            width: 300,
            height: 300,
            child: YearPicker(
              firstDate: DateTime(DateTime.now().year - 100, 1),
              lastDate: DateTime(DateTime.now().year, 1),
              initialDate: DateTime.now(),
              // save the selected date to _selectedDate DateTime variable.
              // It's used to set the previous selected date when
              // re-showing the dialog.
              selectedDate: _selectedDate,
              onChanged: (DateTime dateTime) {
                // close the dialog when year is selected.
                setState(() {
                  _selectedDate = dateTime;
                  Add_diplome();
                });
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );
  }

  Widget information_deplome() {
    return Container();
  }

  Widget title(title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 2),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          color: Color(0xff00b5d5),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Center(
          child: Text(
        title,
        style: TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
      )),
    );
  }

  Widget sub_title(title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 20),
      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      child: Text(
        title,
        style: TextStyle(color: Colors.black, fontSize: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("formulaire d'inscription"),
        backgroundColor: Color(0xff00b5d5),
      ),
      body: Form(
        child: Container(
          padding: EdgeInsets.all(15),
          margin: EdgeInsets.only(bottom: 5),
          child: ListView(
            children: [
              title("information personnelle"),
              sub_title("Nom et Prenom  :"),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: TextFormField(
                  key: _formKey,
                  decoration: InputDecoration(
                    labelText: "Votre nom et Prénom",
                    labelStyle: TextStyle(fontSize: 13, color: Colors.blue),
                    border: InputBorder.none,
                  ),
                  controller: nom,
                  keyboardType: TextInputType.text,
                ),
              ),
              sub_title("Date de naissance  :"),
              Container(
                alignment: Alignment.center,
                // margin: EdgeInsets.all(7) ,
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Row(
                  children: [
                    IconButton(
                        icon: Icon(
                          Icons.calendar_today_outlined,
                          size: 20,
                        ),
                        onPressed: _datePicker),
                    Text("${DateFormat.yMd().format(date_naiss)}"),
                  ],
                ),
              ),
              sub_title("Adresse Actuelle  :"),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: TextFormField(
                  key: _formKey_adresse,
                  decoration: InputDecoration(
                    labelText: "Votre Adresse Actuelle",
                    labelStyle: TextStyle(fontSize: 13, color: Colors.blue),
                    border: InputBorder.none,
                  ),
                  controller: Adresse_Actuelle,
                  keyboardType: TextInputType.text,
                ),
              ),
              sub_title("Contact :"),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: TextFormField(
                  key: _formKey_tell,
                  decoration: InputDecoration(
                    labelText: "0600000000",
                    labelStyle: TextStyle(fontSize: 13, color: Colors.blue),
                    border: InputBorder.none,
                  ),
                  controller: tell,
                  keyboardType: TextInputType.number,
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                margin: EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  // border: Border.all(color:Color.fromRGBO(208, 207, 207, 1) )
                ),
                child: TextFormField(
                  key: _formKey_email,
                  decoration: InputDecoration(
                    labelText: "Monnom@Exemple.com",
                    labelStyle: TextStyle(fontSize: 13, color: Colors.blue),
                    border: InputBorder.none,
                  ),
                  controller: email_pro,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              title("Emploi actuel"),
              sub_title("Secteur :"),
              Container(
                // height: 150.0,
                child: Column(
                  children: secteur
                      .map((data) => RadioListTile(
                            title: Text(
                              "${data.number}",
                              style: TextStyle(fontSize: 13),
                            ),
                            groupValue: id,
                            value: data.index,
                            onChanged: (val) {
                              setState(() {
                                selected_secteur = data.number;
                                id = data.index;
                              });
                            },
                          ))
                      .toList(),
                ),
              ),
              sub_title("Domaine d'activité :"),
              Container(
                // height: 150.0,
                child: Column(
                  children: demaine
                      .map((data) => RadioListTile(
                            title: Text("${data.number}"),
                            groupValue: id_domaine,
                            value: data.index,
                            onChanged: (val) {
                              setState(() {
                                selected_domain = data.number;
                                id_domaine = data.index;
                              });
                            },
                          ))
                      .toList(),
                ),
              ),
              sub_title("Adresse :"),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                margin: EdgeInsets.only(top: 12, left: 30, right: 30),
                // height: 44.h,
                // width: 354.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  // border: Border.all(color:Color.fromRGBO(208, 207, 207, 1) )
                ),
                child: TextFormField(
                  key: _formKey_adresse_emplois,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: "Adresse ",
                    labelStyle: TextStyle(fontSize: 13, color: Colors.blue),
                    border: InputBorder.none,
                  ),
                  controller: Adresse_emploi,
                  keyboardType: TextInputType.text,
                ),
              ),
              title("Formation"),
              sub_title("Année d'obtentien de diplôme"),
              SizedBox(
                height: 15,
              ),
              Container(
                  height: annee.length == 0 ? 50 : 150,
                  child: annee.length == 0
                      ? Container(
                          child: Center(
                              child: Text(
                            "Ajouter un formation",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                        )
                      : ListView.builder(
                          itemCount: annee.length,
                          itemBuilder: (_, index) {
                            return Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                // border: Border.all(color:Color.fromRGBO(208, 207, 207, 1) )
                              ),
                              child: Column(
                                children: [
                                  Container(
                                      height: 20,
                                      child: Row(
                                        children: [
                                          Container(
                                            child: Text(
                                              "Diplôme  :",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Container(
                                              child:
                                                  Text("${nom_deplom[index]}")),
                                        ],
                                      )),
                                  Container(
                                      height: 20,
                                      child: Row(
                                        children: [
                                          Container(
                                            child: Text("année  :",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15)),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Container(
                                              child: Text("${annee[index]}")),
                                        ],
                                      )),
                                  Container(
                                      height: 20,
                                      child: Row(
                                        children: [
                                          Container(
                                            child: Text(
                                                "Filiér de Formation  :",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15)),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Container(
                                              child: Text("${filier[index]}")),
                                        ],
                                      )),
                                  // Divider(color: Colors.red,height: 2,),
                                  SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
                            );
                          })),
              Container(
                child: CircleAvatar(
                  radius: 20,
                  child: IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Add_diplome();
                            });
                      },
                      icon: Icon(
                        Icons.add,
                        color: Colors.red,
                      )),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              sub_title("Autres Formation  :"),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                margin: EdgeInsets.only(top: 12, left: 30, right: 30),
                // height: 44.h,
                // width: 354.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  // border: Border.all(color:Color.fromRGBO(208, 207, 207, 1) )
                ),
                child: TextFormField(
                  key: _autre_formation,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: "Autre formation ",
                    labelStyle: TextStyle(fontSize: 13, color: Colors.blue),
                    border: InputBorder.none,
                  ),
                  controller: autre_formation,
                  keyboardType: TextInputType.text,
                ),
              ),
              IconButton(
                  icon: Icon(
                    Icons.save,
                    size: 20,
                  ),
                  onPressed: () {
                    print("${nom.text}");
                    print("${date_naiss}");
                    print("${Adresse_Actuelle.text}");
                    print("${tell.text}");
                    print("${email_pro.text}");
                    print("${selected_secteur}");
                    print("${selected_domain}");
                    print("${Adresse_emploi.text}");

                    print("${autre_formation.text}");
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
