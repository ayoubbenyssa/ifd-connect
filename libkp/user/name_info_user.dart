import 'package:flutter/material.dart';
import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/validators.dart';
import 'package:ifdconnect/widgets/widgets.dart';

class InfoUser1 extends StatefulWidget {
  InfoUser1(this.user);

  User user;

  @override
  _InfoUser1State createState() => _InfoUser1State();
}

class _InfoUser1State extends State<InfoUser1> {
  final _namecontroller = new TextEditingController();
  final _firstctrl = new TextEditingController();
  final _agectrl = new TextEditingController();
  FocusNode _focusfullname = new FocusNode();
  FocusNode _firstfouc = new FocusNode();
  FocusNode _agefocus = new FocusNode();

  ParseServer parse_s = new ParseServer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _namecontroller.text = widget.user.fullname;
    _firstctrl.text = widget.user.firstname;
    _agectrl.text = widget.user.age;
  }

  @override
  Widget build(BuildContext context) {
    Validators val = new Validators(context: context);

    Widget npm = Widgets.textfield_dec(
        "Nom",
        _focusfullname,
        widget.user.fullname,
        _namecontroller,
        TextInputType.text,
        val.validatename);

    Widget first = Widgets.textfield_dec(
        "Prénom",
        _firstfouc,
        widget.user.firstname,
        _firstctrl,
        TextInputType.text,
        val.validatename);

    Widget age = Widgets.textfield0(
        "L'age", _agefocus, widget.user.age, _agectrl, TextInputType.number);

    return  new WillPopScope(onWillPop: (){
      Navigator.pop(context,widget.user);
    },child:Scaffold(
        appBar: new AppBar(
          title: new Text("Profil"),
          actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.check),
                onPressed: () async {
                  widget.user.fullname = _namecontroller.text;
                  widget.user.firstname = _firstctrl.text;
                  widget.user.age = _agectrl.text;

                  var js = {
                    "firstname": _namecontroller.text,
                    "familyname": _firstctrl.text,
                    "age": _agectrl.text
                  };

                  await parse_s.putparse("users/" + widget.user.id, js);

                  Navigator.pop(context, widget.user);
                })
          ],
        ),
        body: Center(
          child: new ListView(
            padding: new EdgeInsets.all(16.0),
            children: <Widget>[
              new Container(
                height: 16.0,
              ),
              npm,
              new Container(
                height: 16.0,
              ),
              first,
              new Container(
                height: 16.0,
              ),
              age
            ],
          ),
        )));
  }
}
