import 'package:flutter/material.dart';
import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/validators.dart';
import 'package:ifdconnect/widgets/widgets.dart';

class Bio extends StatefulWidget {
  Bio(this.user);

  User user;

  @override
  _InfoUser1State createState() => _InfoUser1State();
}

class _InfoUser1State extends State<Bio> {
  final _bioctrl = new TextEditingController();
  FocusNode _biofocus = new FocusNode();

  ParseServer parse_s = new ParseServer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    _bioctrl.text = widget.user.bio;
  }



  @override
  Widget build(BuildContext context) {
    Validators val = new Validators(context: context);


    Widget bio = Widgets.textfield0_dec(
      "Présentez vous en quelques mots",
      _biofocus,
      widget.user.bio,
      _bioctrl,
      TextInputType.text,

    );



    return  new WillPopScope(onWillPop: (){
      Navigator.pop(context,widget.user);
    },child:Scaffold(
        appBar: new AppBar(
          title: new Text("Profil"),
          actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.check),
                onPressed: () async {
                  widget.user.bio = _bioctrl.text;
                  var js = {
                  "bio":widget.user.bio
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
             bio
            ],
          ),
        )));
  }
}
