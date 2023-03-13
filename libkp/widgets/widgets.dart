import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/widgets/ensuevisiblewhenfocus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Widgets {
  static BoxDecoration boxdecoration_container3() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: new Border.all(
            color: Fonts.border_col.withOpacity(0.5), width: 1.0),
        boxShadow: [
          BoxShadow(color: Fonts.col_grey.withOpacity(0.3), blurRadius: 4.0)
        ],
      ) /*new BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          border: new Border.all(color: Fonts.border_col, width: 0.5),
          boxShadow: [
            BoxShadow(color: Fonts.col_grey.withOpacity(0.6), blurRadius: 4.0)
          ])*/
      ;

  static Widget textfield_des1(
      name, focus, value, myController, type, validator,
      {obscure = false, submit}) {
    return TextFormField(
      style: new TextStyle(fontSize: 15.0, color: Colors.black),
      obscureText: obscure,
      controller: myController,
      maxLines: 2,
      focusNode: focus,
      autofocus: true,
      decoration: InputDecoration(
        //helperText: name,
        labelText: name,
        contentPadding: new EdgeInsets.all(8.0),
        hintText: name,
        hintStyle: new TextStyle(fontSize: 15.0, color: Colors.grey),
      ),
      keyboardType: type,
      validator: validator,
      onSaved: (val) {
        myController.text = val;
        submit();
      },
      onFieldSubmitted: (val) {
        myController.text = val;
        submit();
      },
    );
  }

  static load() => Padding(
      padding: EdgeInsets.all(16), child: new CupertinoActivityIndicator());

  static exitapp(context) async {
    await showDialog(
      context: context,
      builder: (_) => new AlertDialog(
          titlePadding: new EdgeInsets.all(0.0),
          contentPadding: new EdgeInsets.all(0.0),
          title: new Container(
              padding: new EdgeInsets.all(2.0),
              color: Colors.grey[300],
              child: new Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    new GestureDetector(
                      child: new Icon(Icons.close, color: Colors.grey[800]),
                      onTap: () {
                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
                      },
                    )
                    // new Text('Login'),
                  ])),
          content: new Container(
              color: Colors.grey[300],
              padding: new EdgeInsets.only(left: 8.0, right: 8.0),
              height: 230.0,
              child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //new Container(height: 8.0,),
                    Center(
                        child: new Text(
                      "Voulez vous quitter l'application?",
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey[800],
                      ),
                    )),
                    new Container(
                      height: 18.0,
                    ),
                    GestureDetector(
                        onTap: () {
                          exit(1);
                        },
                        child: new Image.asset(
                          "images/lo.png",
                          width: 50.0,
                          height: 50.0,
                          color: Colors.blue,
                        )),
                    new Container(
                      height: 12.0,
                    ),

                    new Container(
                      height: 16.0,
                    ),
                    new Divider(
                      color: Colors.grey,
                    ),
                    new FlatButton(
                        padding: EdgeInsets.all(8.0),
                        child: new Text(
                          "Quitter",
                          style: new TextStyle(
                              color: Colors.grey[800],
                              fontSize: 20.0,
                              fontFamily: "Helvetica",
                              fontWeight: FontWeight.w600),
                        ),
                        onPressed: () {
                          exit(1);
                        }),
                  ]))),
    );
  }

  static Widget avatar = new Container(
      padding: EdgeInsets.only(top: 12),
      child: new GestureDetector(
          onTap: () {},
          child: new Image.asset(
            "images/logo_last.png",
            width: 70.0,
            height: 70.0,
          )));

  static List<Color> kitGradients = [
    // new Color.fromRGBO(103, 218, 255, 1.0),
    // new Color.fromRGBO(3, 169, 244, 1.0),
    // new Color.fromRGBO(0, 122, 193, 1.0),
    Fonts.col_app,
    const Color(0xff3dc5fd),
  ];

  static List<Color> kitGradients1 = [
    // new Color.fromRGBO(103, 218, 255, 1.0),
    // new Color.fromRGBO(3, 169, 244, 1.0),
    // new Color.fromRGBO(0, 122, 193, 1.0),
    const Color(0xff0c81ce),
    const Color(0xff0c81ce),
  ];

  static void onLoading(context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => new Dialog(
              child: new Container(
                padding: new EdgeInsets.all(16.0),
                width: 40.0,
                color: Colors.transparent,
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    new RefreshProgressIndicator(),
                    new Container(height: 8.0),
                    new Text(
                      "En cours ..",
                      style: new TextStyle(
                        color: Fonts.col_app_fonn,
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }

  static BoxDecoration boxdecoration_background() => new BoxDecoration(
     /* image: new DecorationImage(
          fit: BoxFit.cover, image: new AssetImage("images/background.png"))*/);

  static Widget subtitle3(color) => new Text("Réinitialiser le mot de passe",
      style: new TextStyle(
          fontSize: 22.0, fontFamily: "Hbold",color: color));

  static Widget subtitle4(color) => new Text("Nous venons d'envoyer votre code d'authentification par e-mail ",
      style: new TextStyle(
          fontSize: 22.0, fontFamily: "Hbold",color: color));
  static Widget subtitle(color) => new Text("Login",
      style: new TextStyle(
          fontSize: 22.0, fontWeight: FontWeight.w800, color: color));
  static Widget subtitle5(color) => new Text("Créer un nouveau mot de passe",
      style: new TextStyle(
          fontSize: 22.0, fontFamily: "Hbold",color: color));
  static Widget subtitle2(color) => new Text("Créer un compte",
      style: new TextStyle(
          fontSize: 22.0, fontWeight: FontWeight.w800, color: color));

  static Widget textfield1(
    name,
    focus,
    value,
    myController,
    type,
    validator, {
    obscure = false,
  }) {
    return TextFormField(
      obscureText: obscure,
      controller: myController,
      focusNode: focus,
      decoration: InputDecoration(
        // border: InputBorder.none,
        contentPadding: new EdgeInsets.all(8.0),
        labelText: name,
        hintText: name,
        hintStyle: new TextStyle(
            fontSize: 18.0, fontWeight: FontWeight.w500, color: Colors.grey),
      ),
      keyboardType: type,
      validator: validator,
      onFieldSubmitted: (val) => value = val,
    );
  }

  static Widget textfield0(
    name,
    focus,
    value,
    myController,
    type, {
    obscure = false,
  }) {
    return TextFormField(
      style: new TextStyle(fontSize: 15.0, color: Colors.black),
      obscureText: obscure,
      controller: myController,
      focusNode: focus,
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: new EdgeInsets.all(8.0),
        hintText: name,
        hintStyle: new TextStyle(fontSize: 14.0, color: Colors.grey),
      ),
      keyboardType: type,
      onFieldSubmitted: (val) => value = val,
    );
  }

  static Widget textfield0_dec(
    name,
    focus,
    value,
    myController,
    type, {
    obscure = false,
  }) {
    return TextFormField(
      style: new TextStyle(fontSize: 15.0, color: Colors.black),
      obscureText: obscure,
      controller: myController,
      maxLines: 2,
      focusNode: focus,
      decoration: InputDecoration(
        enabledBorder: new OutlineInputBorder(
          // width: 0.0 produces a thin "hairline" border
          borderSide: new BorderSide(color: Colors.grey[200], width: 0.0),
        ),
        labelText: name,
        contentPadding: new EdgeInsets.all(8.0),
        hintText: name,
        hintStyle: new TextStyle(fontSize: 14.0, color: Colors.grey),
      ),
      keyboardType: type,
      onFieldSubmitted: (val) => value = val,
    );
  }

  static Widget textfield(name, focus, value, myController, type, validator,
      {obscure = false, submit}) {
    return TextFormField(
      style: new TextStyle(fontSize: 15.0, color: Colors.black),
      obscureText: obscure,
      controller: myController,
      focusNode: focus,
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: new EdgeInsets.all(8.0),
        hintText: name,
        hintStyle: new TextStyle(fontSize: 15.0, color: Colors.grey),
      ),
      keyboardType: type,
      validator: validator,
      onSaved: (val) {
        myController.text = val;
        submit();
      },
      onFieldSubmitted: (val) {
        myController.text = val;
        submit();
      },
    );
  }

  static Widget textfield_dec(name, focus, value, myController, type, validator,
      {obscure = false, submit, en = true}) {
    return TextFormField(
      enabled: en,
      style: new TextStyle(fontSize: 15.0, color: Colors.black),
      obscureText: obscure,
      controller: myController,
      focusNode: focus,
      decoration: InputDecoration(
        //helperText: name,
        labelText: name,
        contentPadding: new EdgeInsets.all(8.0),
        hintText: name,
        hintStyle: new TextStyle(fontSize: 15.0, color: Colors.grey),
      ),
      keyboardType: type,
      validator: validator,
      onSaved: (val) {
        myController.text = val;
        submit();
      },
      onFieldSubmitted: (val) {
        myController.text = val;
        submit();
      },
    );
  }

  static Widget textfield_des(name, focus, value, myController, type, validator,
      {obscure = false, submit}) {
    return TextFormField(
      style: new TextStyle(fontSize: 15.0, color: Colors.black),
      obscureText: obscure,
      controller: myController,
      maxLines: 3,
      focusNode: focus,
      decoration: InputDecoration(
        //helperText: name,
        labelText: name,
        contentPadding: new EdgeInsets.all(8.0),
        hintText: name,
        hintStyle: new TextStyle(fontSize: 15.0, color: Colors.grey),
      ),
      keyboardType: type,
      validator: validator,
      onSaved: (val) {
        myController.text = val;
        submit();
      },
      onFieldSubmitted: (val) {
        myController.text = val;
        submit();
      },
    );
  }
}
