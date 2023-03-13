import 'dart:async';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ifdconnect/services/app_services.dart';
import 'package:ifdconnect/widgets/custom_widgets/app_textfield.dart';
import 'package:ifdconnect/widgets/custom_widgets/primary_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:ifdconnect/login/login_w.dart';
import 'package:ifdconnect/models/alphabets.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/pages/conditions.dart';
import 'package:ifdconnect/pages/politique.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/services/auth.dart';
import 'package:ifdconnect/services/block.dart';
import 'package:ifdconnect/services/login_services.dart';
import 'package:ifdconnect/services/validators.dart';
import 'package:ifdconnect/widgets/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Register extends StatefulWidget {
  Register(this.infouser, {this.auth, this.onSignedIn});

  var list_partner;
  var analytics;
  BaseAuth auth;
  VoidCallback onSignedIn;
  InfoUser infouser;

  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;
  FocusNode _focuspassword = new FocusNode();
  FocusNode _focusemail = new FocusNode();
  FocusNode _focusname = new FocusNode();
  FocusNode _focustitre = new FocusNode();
  FocusNode _focusorganise = new FocusNode();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool uploading = false;
  AppServices appservices = AppServices();
  ParseServer parse_s = new ParseServer();
  String img = "";
  var photo;

  FocusNode _focuspre = new FocusNode();
  FocusNode _focusphone = new FocusNode();
  FocusNode _focusconfirm = new FocusNode();
  final _confirmcontroller = new TextEditingController();
  bool _isChecked = false;
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      new GlobalKey<FormFieldState<String>>();
  String _authHint = '';
  final _passcontroller = new TextEditingController();
  final _titrecontroller = new TextEditingController();
  final _organismecontroller = new TextEditingController();

  final _emailcontroller = new TextEditingController();
  final _namecontroller = new TextEditingController();
  final _precontroller = new TextEditingController();
  final _phonecontroller = new TextEditingController();
  User user = new User();
  var deviceSize;
  var clr = Colors.grey[600];

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

/*
"Merci de votre inscription, vous devez choisir votre communauté à
l'étape suivante. Vous êtes autorisé à faire partie d'une seule communauté,
et une vérification de votre position gps et exigé pour valider votre appartenance à la communauté choisie."
 */

  void onLoading(context) {
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
                        color: Fonts.col_app_fon,
                      ),
                    ),
                  ],
                ),
              ),
            ));

    // Navigator.pop(context); //pop dialog
    //  _handleSubmitted();
  }

  String validateMobile(String value) {
    /*if (value.length <= 0)
      return "Siil vous plait entrz le numéro de téléphonne";
    else*/
    /* if (value.length > 0 && value.length != 10 && value.length != 12)
      return 'Le numéro de téléphone n est pas valid ( 06 ** ** ** **)';
   else if (value.length > 0 &&
        !value.startsWith("06") &&
        !value.startsWith("07") &&
        !value.startsWith("08") &&
        value[0] != "+") return 'Le numéro de téléphone n est pas valid';
*/
    return null;
  }

  var lat, lng;

//Position position;

  var currentLocation = <String, double>{};
  var location = new Location();

  _handleCameraButtonPressed() async {
    Navigator.of(context).pop(true);
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    _cropImage(image);
  }

  _handleGalleryButtonPressed() async {
    Navigator.of(context).pop(true);
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    _cropImage(image);
  }

  Future _cropImage(image) async {
    File compressedFile =
        await FlutterNativeImage.compressImage(image.path, quality: 60);
    await save_image(compressedFile);
  }

  open_bottomsheet() {
    showModalBottomSheet<bool>(
        context: context,
        builder: (BuildContext context) {
          return new Container(
              height: 112.0,
              child: new Container(
                  // padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                  child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                    new ListTile(
                        onTap: () {
                          _handleCameraButtonPressed();
                        },
                        title: new Text("Prendre une photo")),
                    new ListTile(
                        onTap: () {
                          _handleGalleryButtonPressed();
                        },
                        title: new Text("Photo depuis la galerie")),
                  ])));
        });
  }

  save_image(image) async {
    setState(() {
      uploading = true;
    });

    photo = await appservices.uploadparse("files/image.jpg", image, "image");

    setState(() {
      img = photo.toString();
    });

    /* var js = {
      "piece": photo.toString(),
    };
    parse_s.putparse("users/" + widget.id, js);
*/
    if (!mounted) return;

    setState(() {
      uploading = false;
    });
  }

  void _handleSubmitted() async {
    // await getLocation();

    print(widget.infouser.role.id);
    print(img);

    if (_isChecked.toString() == "false") {
    } else if (img == "" && widget.infouser.role.id == "9UHbnUrotk") {
      setState(() {
        showInSnackBar("S'il vous plait joindre votre diplome");
      });
    } else {
      final FormState form = _formKey.currentState;
      if (!form.validate()) {
        _autovalidate = true; // Start validating on every change.
        showInSnackBar("Veuillez corriger les erreurs en rouge");
      } else {
        //form.save();
        print("<3");

        onLoading(context);
        try {
          AuthResult userId = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: _emailcontroller.text, password: _passcontroller.text);

          print("<3");

          String alpha = _precontroller.text[0].toString().toLowerCase();
          await Block.insert_block(
              userId.user.uid, userId.user.uid, null, null);

          print(widget.infouser);

          await RegisterService.insert_user(
              _precontroller.text,
              _namecontroller.text,
              _emailcontroller.text,
              context,
              userId.user.uid,
              Alphabets.list[0][alpha],
              _titrecontroller.text,
              _organismecontroller.text,
              widget.auth,
              widget.onSignedIn,
              widget.list_partner,
              widget.analytics,
              // type_user: widget.infouser.role.name,
              infouser: widget.infouser,
              phone: _phonecontroller.text,
              diplome: img,
              lat: lat,
              lng: lng);
        } catch (e) {
          print(e.toString());
          Navigator.pop(context);
          print('Error: $e');

          if (Platform.isIOS) {
            if (e.details ==
                "The email address is already in use by another account.") {
              setState(() {
                _authHint = "Cet email est utilisé par un autre compte";
              });
            } else if (e.message ==
                "The email address is already in use by another account.") {
              setState(() {
                _authHint = "Cet email est utilisé par un autre compte";
              });
            }
          } else {
            if (e.message.toString() ==
                "The email address is already in use by another account.") {
              setState(() {
                _authHint = "Cet email est déja utilisé par un autre compte";
              });
            }
          }
        }
      }
    }
  }

  _onChecked(value) {
    setState(() {
      _isChecked = value;
    });
    if (_isChecked.toString() == "false") {
      setState(() {
        clr = Colors.grey[600];
      });
    } else {
      setState(() {
        clr = Fonts.col_app_fon;
      });
    }

    if (value == true)
      setState(() {
        value = false;
      });
    else
      setState(() {
        value = true;
      });
  }

  check() => new Checkbox(
        activeColor: Colors.grey,
        value: _isChecked,
        onChanged: (bool value) {
          _onChecked(value);
        },
      );

  get_info() {
    if (widget.infouser != null) {
      _emailcontroller.text = widget.infouser.email;
      _namecontroller.text = widget.infouser.last_name;
      _precontroller.text = widget.infouser.first_name;
      _phonecontroller.text = widget.infouser.phone;
      _passcontroller.text = widget.infouser.password;
      _confirmcontroller.text = widget.infouser.password;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    get_info();
  }

  @override
  Widget build(BuildContext context) {
    Validators val = new Validators(context: context);

    Widget hintText() {
      return _authHint == ""
          ? new Container()
          : new Container(
              //height: 80.0,
              padding: const EdgeInsets.all(16.0),
              child: new Text(_authHint,
                  key: new Key('hint'),
                  style: new TextStyle(fontSize: 14.0, color: Colors.red[700]),
                  textAlign: TextAlign.center));
    }

    Widget email = TextFieldWidget(
      "Email",
      _focusemail,
      _emailcontroller,
      TextInputType.emailAddress,
      val.validateEmail,
      suffixIcon: "",
    ) /*new Container(
        decoration: new BoxDecoration(
            border: new Border.all(color: Colors.grey, width: 1.0),
            borderRadius: new BorderRadius.circular(12.0)),
        child: Widgets.textfield("Email", _focusemail, user.email,
            _emailcontroller, TextInputType.emailAddress, val.validateEmail))*/
        ;

    Widget Nom = TextFieldWidget(
      "Nom",
      _focusname,
      _namecontroller,
      TextInputType.text,
      val.validatename,
      suffixIcon: "",
    ) /*new Container(
        decoration: new BoxDecoration(
            border: new Border.all(color: Colors.grey, width: 1.0),
            borderRadius: new BorderRadius.circular(12.0)),
        child: Widgets.textfield("Nom", _focusname, user.fullname,
            _namecontroller, TextInputType.text, val.validatename))*/
        ;

    Widget prenom = TextFieldWidget(
      "Prénom",
      _focuspre,
      _precontroller,
      TextInputType.text,
      val.validatename,
      suffixIcon: "",
    ) /*new Container(
        decoration: new BoxDecoration(
            border: new Border.all(color: Colors.grey, width: 1.0),
            borderRadius: new BorderRadius.circular(12.0)),
        child: Widgets.textfield("Prenom", _focuspre, user.prenom,
            _precontroller, TextInputType.text, val.validatename))*/
        ;

    Widget phone = TextFieldWidget(
      "GSM ( 06 ** ** ** **)",
      _focusphone,
      _phonecontroller,
      TextInputType.phone,
      validateMobile,
      suffixIcon: "",
    ) /*new Container(
        decoration: new BoxDecoration(
            border: new Border.all(color: Colors.grey, width: 1.0),
            borderRadius: new BorderRadius.circular(12.0)),
        child: Widgets.textfield("GSM ( 06 ** ** ** **)", _focusphone,
            user.phone, _phonecontroller, TextInputType.phone, validateMobile))*/
        ;

    Widget password = new TextFormField(
        style: new TextStyle(fontSize: 15.0, color: Colors.black),
        focusNode: _focuspassword,
        obscureText: true,
        controller: _passcontroller,
        validator: val.validatePassword,
        key: _passwordFieldKey,
        decoration: InputDecoration(
          contentPadding:
              new EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 10.h),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 5.0),
          ),
          // border: InputBorder.none,
          //contentPadding: new EdgeInsets.all(8.0),
          hintText: "Mot de passe",

          fillColor: Fonts.col_cl,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.r)),
            borderSide: BorderSide(width: 1, color: Fonts.border_col),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.r)),
            borderSide: BorderSide(width: 1, color: Fonts.border_col),
          ),
          // hintText: name,
          hintStyle: Fonts.sub_title,
        ),
        onFieldSubmitted: (String value) {
          setState(() {
            user.password = value;
          });
        });

    String _validatePassword2(String value) {
      final FormFieldState<String> passwordField =
          _passwordFieldKey.currentState;
      if (passwordField.value == null || passwordField.value.isEmpty)
        return "Les mots de passe saisis ne correspondent pas";
      if (passwordField.value != value)
        return "Les mots de passe saisis ne correspondent pas";
      return null;
    }

    Widget confirmpassword = TextFieldWidget(
      "Confirmer le mot de passe",
      _focusconfirm,
      _confirmcontroller,
      TextInputType.text,
      _validatePassword2,
      suffixIcon: "",
      obscure: true,
    ) /*Widgets.textfield(
        "Confirmer le mot de passe",
        _focusconfirm,
        user.confirm,
        _confirmcontroller,
        TextInputType.text,
        _validatePassword2,
        obscure: true)*/
        ;

    var style = new TextStyle(
        color: const Color(0xffeff2f7),
        fontSize: 20.0,
        fontWeight: FontWeight.w500);

    Widget btn_log =     Container(
        width: MediaQuery.of(context).size.width * 0.76,
        // height: ScreenUtil().setHeight(50),
        padding: new EdgeInsets.only(left: 12.0, right: 12.0),
        child: PrimaryButton(
          disabledColor: Fonts.col_grey,
          fonsize: 14.5.sp,
          icon: "",
          prefix: Container(),
          color: clr,
          text: "Confirmer",
          isLoading: false,
          onTap: ()  {
            _handleSubmitted();
          },
        )
    );/*new Padding(
        padding: new EdgeInsets.only(left: 36.0, right: 36.0),
        child: new Material(
            elevation: 12.0,
            shadowColor: clr,
            borderRadius: new BorderRadius.circular(12.0),
            color: clr,

            /*decoration: new BoxDecoration(
            border: new Border.all(color: const Color(0xffeff2f7), width: 1.5),
            borderRadius: new BorderRadius.circular(6.0)),*/
            child: new MaterialButton(
                // color:  const Color(0xffa3bbf1),
                onPressed: () {
                  _handleSubmitted();
                },
                child: new Text("Confirmer", style: style))))*/;
    deviceSize = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
        key: _scaffoldKey,
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                  child: Image.asset(
                "assets/images/logo.png",
                height: MediaQuery.of(context).size.height * 0.11,
                fit: BoxFit.cover,
              )),
              Container(
                height: 12,
              ),
              Center(
                  child: Image.asset(
                "assets/images/ifd.png",
                width: 180.w,
              )),
              Expanded(
                  child: new Form(
                      key: _formKey,
                      autovalidate: _autovalidate,
                      //onWillPop: _warnUserAboutInvalidData,
                      child: new Container(
                          padding: new EdgeInsets.all(12.0),
                          child: new ListView(children: <Widget>[
                            widget.infouser.first_name != null
                                ? IgnorePointer(child: Nom)
                                : Nom,
                            new Container(height: 8.0),
                            widget.infouser.first_name != null
                                ? IgnorePointer(child: prenom)
                                : prenom,
                            new Container(height: 8.0),
                            phone,
                            new Container(height: 8.0),
                            email,
                            new Container(height: 8.0),
                            widget.infouser.first_name != null
                                ? Container()
                                : password,
                            new Container(height: 8.0),
                            widget.infouser.first_name != null
                                ? Container()
                                : confirmpassword,
                            new Container(height: 8.0),

                            widget.infouser.role.id == "9UHbnUrotk"
                                ? InkWell(
                                    child: new Container(
                                        height: 46.h,
                                        decoration: new BoxDecoration(
                                          border: new Border.all(
                                              color: Fonts.col_app_fon,
                                              width: 1.0),
                                          borderRadius:
                                              new BorderRadius.circular(
                                                  32.0.sp),
                                        ),
                                        padding: new EdgeInsets.only(
                                            left: 16.0,
                                            right: 16.0,
                                            top: 4.h,
                                            bottom: 4.h),
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              "Joindre ici votre diplome",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Fonts.col_app_fon,
                                                  fontFamily: "Hbold",
                                                  fontSize: 16.0.sp),
                                            ),
                                            Expanded(child: Container()),
                                            Image.asset(
                                              "images/join.png",
                                              height: 24,
                                            ),
                                          ],
                                        )),
                                    onTap: () {
                                      open_bottomsheet();
                                    },
                                  )
                                : Container(),

                            /* id_spec == "KLTFsdCfQP"
                  ? Container(
                  padding: new EdgeInsets.only(left: 16.0, right: 16.0),
                  child: title)
                  : Container(),*/
                            Container(
                              height: 8.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                img.toString() == ""
                                    ? new Container()
                                    : Container(
                                        padding: EdgeInsets.only(top: 8),
                                        height: 50,
                                        width: 50,
                                        child: new SizedBox(
                                            height: 50.0,
                                            width: 50,
                                            child: new Stack(
                                              children: <Widget>[
                                                new Positioned.fill(
                                                  child: new Image.network(
                                                    img.toString(),
                                                    height: 50.0,
                                                    width: 50,
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                              ],
                                            ))),
                              ],
                            ),
                            new Container(height: 8.0),
                            new Row(
                              children: <Widget>[
                                check(),
                                new Container(
                                    width: 290.0.w,
                                    child: new RichText(
                                      text: new TextSpan(
                                        text: "J'accèpte les ",
                                        style: new TextStyle(
                                            color: Fonts.col_app_grey,
                                            fontSize: 11.sp),
                                        children: <TextSpan>[
                                          new TextSpan(
                                              recognizer: new TapGestureRecognizer()
                                                ..onTap = () => Navigator.push(
                                                    context,
                                                    new MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            new Conditions())),
                                              text: "conditions d'utilisation",
                                              style: new TextStyle(
                                                  fontFamily: "Hbold",
                                                  fontSize: 11.sp,
                                                  color: Fonts.col_app)),
                                          new TextSpan(text: ' et la '),
                                          new TextSpan(
                                              recognizer: new TapGestureRecognizer()
                                                ..onTap = () => Navigator.push(
                                                    context,
                                                    new MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            new Potique())),
                                              text:
                                                  "politique de confidentialité",
                                              style: new TextStyle(
                                                  fontFamily: "Hbold",
                                                  fontSize: 11.sp,
                                                  color: Fonts.col_app)),
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                            hintText(),
                            Container(
                              height: 10.h,
                            ),
                            btn_log,
                            Container(
                              height: 10,
                            )
                          ]))))
            ]));
  }
}
