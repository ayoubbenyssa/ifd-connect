import 'package:flutter/material.dart';
import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/widgets/ensuevisiblewhenfocus.dart';


class Cmpetences extends StatefulWidget {
  Cmpetences(this.user);
  User user;


  @override
  _CmpetencesState createState() => _CmpetencesState();
}

class _CmpetencesState extends State<Cmpetences> {
  FocusNode _cfoucs = new FocusNode();
  final _cctrl = new TextEditingController();
  List<String> cmptes = [];
  ParseServer parse_s = new ParseServer();



  deleted(item) {
    setState(() {
      cmptes.remove(item);
    });
  }




  void initState() {
    super.initState();
    if (widget.user.cmpetences.isNotEmpty) {
      for (var i in widget.user.cmpetences) {
        cmptes.add(i);
      }
    }

  }

  add_skill(){
    if (_cctrl.text != "") {
      setState(() {
        cmptes.add(_cctrl.text);
        _cctrl.text = "";
      });
    }
  }



  @override
  Widget build(BuildContext context) {


    Widget cmp = new EnsureVisibleWhenFocused(
        focusNode: _cfoucs,
        child: TextFormField(
          style: new TextStyle(fontSize: 15.0, color: Colors.black),
          controller: _cctrl,
          focusNode: _cfoucs,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: new EdgeInsets.all(8.0),
            hintText: "Entrer ici une compétence",
            hintStyle: new TextStyle(fontSize: 15.0, color: Colors.grey),
          ),
          keyboardType: TextInputType.text,
          onFieldSubmitted: (val) {
            if (_cctrl.text != "") {
              setState(() {
                cmptes.add(_cctrl.text);
                _cctrl.text = "";
              });
            }
          },
        ));


    return  new WillPopScope(onWillPop: (){


      Navigator.pop(context,widget.user);
    },child:Scaffold(
      appBar: new AppBar(
        title: new Text("Profil"),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.check),
              onPressed: () async {

                widget.user.list = [];
                widget.user.cmpetences = [];

                if (cmptes.isNotEmpty) {
                  for (var i in cmptes) {
                    widget.user.cmpetences.add(i);
                    widget.user.list.add(i);
                  }
                }

                var js = {
                  "competences": cmptes,
                };
                await parse_s.putparse("users/" + widget.user.id, js);

                Navigator.pop(context, widget.user);
              })
        ],
      ),
      body: new ListView(
        padding: new EdgeInsets.all(16.0),
        children: <Widget>[

          new Row(mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Container(padding: new EdgeInsets.only(left: 8.0,right: 8.0),width: 240.0,child:  cmp),
              new Expanded(child: new Container()),
              new Container(child:  new InkWell(onTap: (){
                add_skill();
              },child:  new Container(
                padding: new EdgeInsets.only(top: 4.0, bottom: 4.0),
                width: 70.0,
                alignment: Alignment.center,
                decoration: new BoxDecoration(
                  border: new Border.all(color: Fonts.col_app, width: 1.0),
                  color: Fonts.col_app_shadow,
                  borderRadius: new BorderRadius.circular(8.0),
                ),
                child: new Text(
                  "Ajouter",
                  style: new TextStyle(color:Fonts.col_app),
                ),
              ),))
            ],),

          new Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              spacing: 2.0,
              children: cmptes.map((String item) {
                return new Container(
                    child:new Chip(

                  backgroundColor: Colors.grey[300],
                  //padding: new EdgeInsets.only(left: 4.0,right: 4.0),
                  deleteIconColor: Fonts.col_app,
                  label: new Text(item),
                  onDeleted: () {
                    deleted(item);
                  },
                ));
              }).toList())


        ],
      ),


    ));
  }
}

/*

   new Row(mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                           new Container(padding: new EdgeInsets.only(left: 8.0,right: 8.0),width: 240.0,child:  cmp),
                            new Expanded(child: new Container()),
                           new Container(child:  new RaisedButton(onPressed: (){
                              add_skill();
                            },child: new Text("Ajouter"),))
                          ],)  ,
                            new Wrap(
                                crossAxisAlignment: WrapCrossAlignment.start,
                                spacing: 2.0,
                                children: cmptes.map((String item) {
                                  return new Chip(
                                    backgroundColor: Colors.grey[300],
                                    //padding: new EdgeInsets.only(left: 4.0,right: 4.0),
                                    deleteIconColor: Colors.purpleAccent,
                                    label: new Text(item),
                                    onDeleted: () {
                                      deleted(item);
                                    },
                                  );
                                }).toList())
                          ],

 */