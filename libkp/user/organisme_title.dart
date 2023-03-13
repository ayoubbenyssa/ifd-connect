import 'package:flutter/material.dart';
import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/validators.dart';
import 'package:ifdconnect/widgets/widgets.dart';

class OrganismeTitle extends StatefulWidget {
  OrganismeTitle(this.user);

  User user;

  @override
  _InfoUser1State createState() => _InfoUser1State();
}

class _InfoUser1State extends State<OrganismeTitle> {
  ParseServer parse_s = new ParseServer();
  final _organiismectrl = new TextEditingController();
  final _titrectrl = new TextEditingController();
  FocusNode _titrefocus = new FocusNode();
  FocusNode _organismefocus = new FocusNode();
  FocusNode _anfocus = new FocusNode();
  final _anctrl = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool _autovalidate = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _organiismectrl.text = widget.user.organisme;
    _titrectrl.text = widget.user.titre;
    _anctrl.text = widget.user.anne_exp;
  }

  @override
  Widget build(BuildContext context) {
    Validators val = new Validators(context: context);

    Widget titre = Widgets.textfield_dec("Titre de votre profil", _titrefocus,
        widget.user.titre, _titrectrl, TextInputType.text, val.valprofile);

    Widget organisme = Widgets.textfield_dec(
        "Organisme actuel",
        _organismefocus,
        widget.user.organisme,
        _organiismectrl,
        TextInputType.text,
        val.valorganisme);

    Widget an = Widgets.textfield0_dec(
      "Annèes d'expérience",
      _anfocus,
      widget.user.anne_exp,
      _anctrl,
      TextInputType.number,
    );

    return new WillPopScope(onWillPop: (){
      Navigator.pop(context,widget.user);
    },child:Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text("Profil"),
          actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.check),
                onPressed: () async {
                  final FormState form = _formKey.currentState;
                  if (!form.validate()) {
                    _autovalidate = true; // Start validating on every change.
                  } else {
                    widget.user.organisme = _organiismectrl.text;
                    widget.user.titre = _titrectrl.text;
                    widget.user.anne_exp = _anctrl.text;

                    var js = {
                      "organisme": _organiismectrl.text,
                      "titre": _titrectrl.text,
                      "anne_exp": _anctrl.text,
                    };

                    await parse_s.putparse("users/" + widget.user.id, js);

                    Navigator.pop(context, widget.user);
                  }
                })
          ],
        ),
        body: Center(
            child: new Form(
          key: _formKey,
          autovalidate: _autovalidate,
          //onWillPop: _warnUserAboutInvalidData,
          child: new ListView(
            padding: new EdgeInsets.all(16.0),
            children: <Widget>[
              new Container(
                height: 16.0,
              ),
              titre,
              new Container(
                height: 16.0,
              ),
              organisme,
              new Container(
                height: 16.0,
              ),
              an
            ],
          ),
        ))));
  }
}
