import 'package:flutter/material.dart';
import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/user/add_diplome.dart';

class Formations extends StatefulWidget {
  Formations(this.user, {Key key}) : super(key: key);
  User user;

  @override
  _FormationsState createState() => _FormationsState();
}

class _FormationsState extends State<Formations> {
  ParseServer parse_s = new ParseServer();

  Add_diplome() async {
    Formation form = await Navigator.push(context,
        new MaterialPageRoute(builder: (BuildContext context) {
      return new AddDiplome(widget.user);
    }));

    if (form != null) {
      setState(() {
        widget.user.formations.add(form);
      });
    }
    /* return AlertDialog(
      // key: _formKey_dialoge,
      content: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.53,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  "Diplôme : ",
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
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              ShowYear("${_selectedDate.year}", year_picker),
              SizedBox(
                height: 15,
              ),
              Container(
                child: Text(
                  "Fillière de formation : ",
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
                    labelStyle: TextStyle(fontSize: 13, color: Colors.black),
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
            ],
          ),
        ),
      ),
      actions: [
        FlatButton(
            onPressed: () async {
              var res = await parse_s.postparse("User_formation", {
                "name": nom_dipl.text,
                "filliere": filier_de_formation.text,
                "year": _selectedDate.year.toString()
              });

              setState(() {
                widget.user.formations.add(Formation(
                    name: nom_dipl.text,
                    objectId: res["objectId"],
                    filliere: filier_de_formation.text,
                    year: _selectedDate.year.toString()));
              });

              parse_s.putparse("users/" + widget.user.id, {
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

              nom_dipl.clear();
              filier_de_formation.clear();

              /*

    var js = {
      "users": {
        "__op": "AddUnique",
        "objects": [
          {
            "__type": "Pointer",
            "className": "users",
            "objectId": widget.user.id
          }
        ]
      }
    };
               */

              Navigator.of(context).pop();
            },
            child: Container(
                padding:
                EdgeInsets.only(left: 30, right: 30, bottom: 15, top: 15),
                decoration: BoxDecoration(
                    color: Fonts.col_app,
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
                  "Annuler",
                  style: TextStyle(color: Colors.black),
                ))),
      ],
    );*/
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () {
          Navigator.pop(context, widget.user);
        },
        child: Scaffold(
          appBar: AppBar(title: Text('Formations')),
          body: ListView(
            children: [
              Container(
                child: Center(
                    child: RaisedButton(
                        child: Text(
                          "Ajouter une formation",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            side: BorderSide(
                                width: 0.1, style: BorderStyle.solid)),
                        color: Fonts.col_app_green,
                        onPressed: () {
                          Add_diplome();

                          /* showDialog(
                              context: context,
                              builder: (context) {
                                return Add_diplome();
                              });*/
                        })),
              ),
              Column(
                  children: widget.user.formations
                      .map((Formation e) => Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              // border: Border.all(color:Color.fromRGBO(208, 207, 207, 1) )
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    new InkWell(
                                      child: new Image.asset(
                                          "images/delete.png",
                                          color: Colors.red[700],
                                          width: 22.0,
                                          height: 22.0),
                                      onTap: () async {
                                        await showDialog<String>(
                                              context: context,
                                              builder: (_) => new AlertDialog(
                                                title: const Text(''),
                                                content: const Text(
                                                    'Voulez vous supprimer cette formation ?'),
                                                actions: <Widget>[
                                                  new FlatButton(
                                                      child: const Text('Ok'),
                                                      onPressed: () async {
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pop('dialog');

                                                        /****
                                                 *
                                                 * Suppression
                                                 *
                                                 *
                                                 *
                                                 */

                                                        setState(() {
                                                          widget.user.formations
                                                              .remove(e);
                                                        });
                                                        var res = await parse_s
                                                            .deleteparse(
                                                                "User_formation/" +
                                                                    e.objectId);

                                                        parse_s.putparse(
                                                            "users/" +
                                                                widget.user.id,
                                                            {
                                                              "user_formations":
                                                                  {
                                                                "__op":
                                                                    "Remove",
                                                                "objects": [
                                                                  {
                                                                    "__type":
                                                                        "Pointer",
                                                                    "className":
                                                                        "User_formation",
                                                                    "objectId":
                                                                        e.objectId
                                                                  }
                                                                ]
                                                              }
                                                            });
                                                      }),
                                                  new FlatButton(
                                                    child: const Text('Cancel'),
                                                    onPressed: () {
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop('dialog');
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ) ??
                                            false;

                                        //  rt.gotocomment(context, widget.news, widget.news.author["objectId"],false,false);
                                      },
                                    )
                                  ],
                                ),
                                Container(
                                    height: 20,
                                    child: Row(
                                      children: [
                                        Container(
                                          child: Text(
                                            "Diplôme :",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Container(child: Text("${e.name}")),
                                      ],
                                    )),
                                Container(
                                    child: Row(
                                  children: [
                                    Container(
                                      child: Text("annèe :",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15)),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Container(child: Text("${e.year}")),
                                  ],
                                )),
                                Container(
                                    child: Row(
                                  children: [
                                    Container(
                                      child: Text("Fillière de Formation :",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15)),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Container(child: Text("${e.filliere}")),
                                  ],
                                )),
                                // Divider(color: Colors.red,height: 2,),
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ))
                      .toList())
            ],
          ),
        ));
  }
}

class Formation {
  String name;
  String year;
  String filliere;
  String objectId;

  Formation({this.name, this.filliere, this.year, this.objectId});

  Formation.fromMap(document)
      : objectId = document["objectId"].toString(),
        name = document["name"],
        filliere = document["filliere"],
        year = document["year"];
}
