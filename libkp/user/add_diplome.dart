import 'package:flutter/material.dart';
import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/user/formations.dart';

class AddDiplome extends StatefulWidget {
  AddDiplome(this.user, {Key key}) : super(key: key);
  User user;

  @override
  _AddDiplomeState createState() => _AddDiplomeState();
}

class _AddDiplomeState extends State<AddDiplome> {
  DateTime date_dip = DateTime.now();
  DateTime _selectedDate = DateTime(DateTime.now().year);
  ParseServer parse_s = new ParseServer();

  year_picker() async {
    var a = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choisir l'année"),
          content: Container(
            // Need to use container to add size constraint.
            width: 300,
            height: 300,
            child: YearPicker(
              firstDate: DateTime(DateTime.now().year - 100, 1),
              lastDate: DateTime(DateTime.now().year + 100, 1),
              initialDate: DateTime.now(),
              // save the selected date to _selectedDate DateTime variable.
              // It's used to set the previous selected date when
              // re-showing the dialog.
              selectedDate: _selectedDate,
              onChanged: (DateTime dateTime) {
                // close the dialog when year is selected.

                Navigator.pop(context, dateTime);

                // Do something with the dateTime selected.
                // Remember that you need to use dateTime.year to get the year
              },
            ),
          ),
        );
      },
    );
    if (!this.mounted) return;

    if (a != null) {
      setState(() {
        _selectedDate = a;
        print(_selectedDate.year);
      });
    }

  }

  final GlobalKey<FormState> _autre_formation = GlobalKey();
  Map<String, String> info_dipome = {
    'nom diplome': '',
    'annee': '',
    'filie de formation': '',
  };

  var nom = TextEditingController();

  var nom_dipl = TextEditingController();

  var filier_de_formation = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Container(),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close))
          ],
        ),
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        "Diplôme : ",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
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
                          hintText: "Diplôme:  ",
                          labelStyle:
                              TextStyle(fontSize: 13, color: Colors.black),
                          border: InputBorder.none,
                        ),
                        // onSaved: (value) {
                        //   info_dipome['nom diplome'] = value.toString();
                        // },
                        controller: nom_dipl,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null) {
                            return 'Entrer la formation';
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      child: Text(
                        "Annèe : ",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 5, right: 5, top: 10, bottom: 10),
                        margin: EdgeInsets.only(top: 5),
                        // width: 100,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          // border: Border.all(color:Color.fromRGBO(208, 207, 207, 1) )
                        ),
                        child: Text(_selectedDate.year.toString()),
                      ),
                      onTap: () {
                        year_picker();
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      child: Text(
                        "Fillière de formation : ",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
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
                      // width: 130,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        // border: Border.all(color:Color.fromRGBO(208, 207, 207, 1) )
                      ),
                      child: TextFormField(
                        // key: _formKey_fillier,
                        decoration: InputDecoration(
                          hintText: "Filiére de formation ",
                          labelStyle:
                              TextStyle(fontSize: 13, color: Colors.black),
                          border: InputBorder.none,
                        ),
                        controller: filier_de_formation,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null) {
                            return 'Entrer la  Fillière ';
                          }
                        },
                      ),
                    ),
                    Center(
                        child: RaisedButton(
                            color: Fonts.col_app,
                            child: Text(
                              "Ajouter la formation",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              var res =
                                  await parse_s.postparse("User_formation", {
                                "name": nom_dipl.text,
                                "filliere": filier_de_formation.text,
                                "year": _selectedDate.year.toString()
                              });

                              print(res);

                              Formation formation = Formation(
                                  name: nom_dipl.text,
                                  objectId: res["objectId"],
                                  filliere: filier_de_formation.text,
                                  year: _selectedDate.year.toString());

                              var a = await parse_s
                                  .putparse("users/" + widget.user.id, {
                                "user_formations": {
                                  "__op": "AddUnique",
                                  "objects": [
                                    {
                                      "__type": "Pointer",
                                      "className": "User_formation",
                                      "objectId": res["objectId"]
                                    }
                                  ]
                                }
                              });
                              print(a);

                              nom_dipl.clear();
                              filier_de_formation.clear();

                              Navigator.pop(context, formation);
                            })),
                  ],
                ))));
  }
}
