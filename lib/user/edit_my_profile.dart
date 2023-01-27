import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as clientHttp;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong/latlong.dart';
import 'package:ifdconnect/campus/login/LoginPage.dart';
import 'package:ifdconnect/communities/communities.dart';
import 'package:ifdconnect/inactive/inactive_widget.dart';
import 'package:ifdconnect/login/inactive.dart';
import 'package:ifdconnect/models/alphabets.dart';
import 'package:ifdconnect/models/community.dart';
import 'package:ifdconnect/user/phonewidget.dart';
import 'package:ifdconnect/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/models/user.dart';

import 'package:photo_view/photo_view.dart';
import 'package:ifdconnect/pages/conditions.dart';
import 'package:ifdconnect/pages/politique.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/user/bio.dart';
import 'package:ifdconnect/user/competences.dart';
import 'package:ifdconnect/user/link_profile.dart';
import 'package:ifdconnect/user/name_info_user.dart';
import 'package:ifdconnect/user/objectifs.dart';
import 'package:ifdconnect/user/organisme_title.dart';
import 'package:ifdconnect/widgets/arc_clip.dart';
import 'package:ifdconnect/widgets/bottom_menu.dart';

enum AppBarBehavior { normal, pinned, floating, snapping }

class EditMyProfile extends StatefulWidget {
  EditMyProfile(this.auth, this.sign, this.lat, this.lng, this.list_partner,
      this.community, this.analytics);

  var auth;
  var sign;
  var lat;
  var lng;
  bool show_myprofile = true;
  List list_partner;
  Community community;

  var analytics;

  @override
  _Details_userState createState() => _Details_userState();
}

class _Details_userState extends State<EditMyProfile>
    with TickerProviderStateMixin {
  AnimationController _containerController;
  bool uploading = false;
  User user = new User();
  double _appBarHeight = 240.0;
  AppBarBehavior _appBarBehavior = AppBarBehavior.pinned;
  Animation<double> width;
  Animation<double> heigth;
  Distance distance = new Distance();
  ParseServer parse_s = new ParseServer();
  final _phonecontroller = new TextEditingController();
  FocusNode _focusphone = new FocusNode();
  bool val1 = false;
  String type = "";
  bool val2 = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  bool val = true;

  get_user_info() async {
    user.image =
        "https://res.cloudinary.com/dgxctjlpx/image/upload/v1591701242/Capture_d_e%CC%81cran_2020-06-09_a%CC%80_10.30.25_ncvtv6.png";
    user.anne_exp = "";
    user.cmpetences = [];
    user.bio = "";
    // user.date_naissance = ;
    user.sexe = "";
    user.titre = "";
    user.organisme = "";
    user.phone = "";
    user.email = "";
    user.firstname = "";
    user.fullname = "";
    user.linkedin_link = "";
    user.community = "";
    user.block_list = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var my_id = prefs.getString("id");

    // User us =   await  user_info.getuserdata(my_id);  //if (!mounted) return;

    var response = await parse_s.getparse(
        'users?where={"objectId":"$my_id"}&include=user_formations,role');
    User us = new User.fromMap(response["results"][0]);

    Map<String, dynamic> map = new Map<String, dynamic>();
    map["online"] = true;
    map["offline"] = "";
    map["last_active"] = 0;

    await Firestore.instance
        .collection('users')
        .document(user.auth_id)
        .setData(map);

    if (!this.mounted) return;

    setState(() {
      user = us;
      if (user.image.toString() == "null") {
        String alpha = user.firstname[0].toString().toLowerCase();
        setState(() {
          user.image = Alphabets.list[0][alpha];
        });
      }
      // user.image = user.image;

      _phonecontroller.text = user.phone;
      type = user.sexe;
    });
  }

  save_image(image) async {
    setState(() {
      uploading = true;
    });

    int timestamp = new DateTime.now().millisecondsSinceEpoch;
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child("profile/img_" + timestamp.toString() + ".jpg");
    StorageUploadTask uploadTask = storageReference.put(image);
    await storageReference.put(image).onComplete.then((val) {
      val.ref.getDownloadURL().then((val) {
        var js = {
          "photoUrl": val.toString(),
        };
        parse_s.putparse("users/" + user.id, js);

        if (!mounted) return;

        setState(() {
          user.image = val.toString();
          uploading = false;
        });
      });
    });
  }

  Community community = null;

  make_user_online() async {
    Map<String, dynamic> map = new Map<String, dynamic>();
    map["online"] = true;
    map["offline"] = "";

    map["last_active"] = 0;
    await Firestore.instance
        .collection('users')
        .document(user.auth_id)
        .updateData(map);

    FirebaseDatabase.instance
        .reference()
        .child("status")
        .update({user.auth_id: true});
    FirebaseDatabase.instance
        .reference()
        .child("status")
        .onDisconnect()
        .update({user.auth_id: false});
  }

  getOnlineUser() async {
    DocumentSnapshot a = await Firestore.instance
        .collection('users')
        .document(user.auth_id)
        .get();

    if (a.data.toString() != "null") {
      if (a.data["offline"].toString() == "offline") {
        setState(() {
          user.online = false;
          user.offline = "offline";
          val = false;
        });
      } else
        setState(() {
          val = true;
        });
    }
  }

  Future _cropImage(image) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
    );
    if (croppedFile != null) {
      image = croppedFile;
      //ImageProperties properties = await FlutterNativeImage.getImageProperties(image.path);
      File compressedFile =
          await FlutterNativeImage.compressImage(image.path, quality: 70);
      save_image(compressedFile);
    }
  }

  @override
  void initState() {
    if (widget.community.toString() != "null") {
      print("jdfopjfojdopjopdjpodjdopjdopjdopjdopjopjdopjopj");
      community = widget.community;
    }
    get_user_info().then((_) {
      user.online = false;
      getOnlineUser();
      user.list = [];
      user.list_obj = [];

      if (user.objectif != null) {
        for (var i in user.objectif) {
          user.list_obj.add(i);
        }
      }

      if (user.cmpetences != null) {
        for (var i in user.cmpetences) {
          user.list.add(i);
        }
      }

      print(user.lat);
      print(user.lng);
    });

    _containerController = new AnimationController(
        duration: new Duration(milliseconds: 2000), vsync: this);
    super.initState();
    width = new Tween<double>(
      begin: 180.0,
      end: 180.0,
    ).animate(
      new CurvedAnimation(
        parent: _containerController,
        curve: Curves.ease,
      ),
    );
    heigth = new Tween<double>(
      begin: 180.0,
      end: 180.0,
    ).animate(
      new CurvedAnimation(
        parent: _containerController,
        curve: Curves.ease,
      ),
    );
    heigth.addListener(() {
      setState(() {
        if (heigth.isCompleted) {}
      });
    });
    _containerController.forward();
  }

  @override
  void dispose() {
    _containerController.dispose();
    super.dispose();
  }

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

  /*

    Calculate  tyhe distance between the community and the user
     */

  go_home() async {
    String token = await _firebaseMessaging.getToken();

    await Firestore.instance
        .collection('user_notifications')
        .document(user.auth_id)
        .setData({
      "my_token": token,
      "name": user.firstname + "  " + user.fullname,
      "image": user.image
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("active", "true");

    String tk = await _firebaseMessaging.getToken();

    var js = {
      "active": 1,
      "emi": true,
      "token": tk,
    };

    var jsonsearch = {
      "objectId": user.id,
      "firstname": user.firstname,
      "fullname": user.fullname,
      "email": user.email,
      "phone": user.phone,
      "organisme": user.organisme,
      "titre": user.titre,
      "cmpetences": user.cmpetences,
      "community": user.community
    };
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode("admin_emi" + ':' + "Emi2021"));

    clientHttp.post(
        "https://search.emiconnect.tk/users_emi/user/" + user.id.toString(),
        headers: {
          "Content-type": "application/json",
          HttpHeaders.authorizationHeader: basicAuth,
        },
        body: json.encode(jsonsearch));

    var resp = await parse_s.putparse("users/" + user.id, js);

    var uid = user.auth_id;
    var response = await parse_s
        .getparse('users?where={"id1":"$uid"}&include=user_formations,role');
    prefs.setString("user", json.encode(response["results"][0]));
    var kkey = user.auth_id + "_" + "2KBobG7nPuTayJMav48zo2bTKxe2";
    DatabaseReference gMessagesDbRef2 =
        FirebaseDatabase.instance.reference().child("room_medz").child(kkey);
    gMessagesDbRef2.set({
      "token": token,
      "name": user.firstname + " " + user.fullname,
      user.auth_id: true,
      "lastmessage": "Bienvenue",
      "key": kkey,
      "timestamp": ServerValue.timestamp /*new DateTime.now().toString()*/,
    });

    Navigator.pushReplacement(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => new BottomNavigation(
                widget.auth,
                widget.sign,
                user,
                widget.list_partner,
                true,
                widget.analytics)));
    /*


    Navigator.pushReplacement(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) =>
            new InactiveWidget([], null,widget.chng,user.id)));
     */
    /*Navigator.pushReplacement(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => new BottomNavigation(
                widget.auth, widget.sign, user, widget.list_partner, true,widget.analytics)));*/
  }

  verify_role() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String my_id = prefs.getString("id");

    var role = prefs.getString("role");

    print("-----------------8888888888--------------------");

    if (prefs.getString("role").toString() != "null") {
      go_home();
    } else {
      Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
              builder: (BuildContext context) => new InactiveWidget(
                    [],
                    user.id,
                  )));
    }
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
                        onTap: _handleCameraButtonPressed,
                        title: new Text("Prendre une photo")),
                    new ListTile(
                        onTap: _handleGalleryButtonPressed,
                        title: new Text("Photo depuis la gallerie")),
                  ])));
        });
  }

  @override
  Widget build(BuildContext context) {
    /*Widget gsm = Widgets.textfield0(
      "GSM",
      _focusphone,
      user.phone,
      _phonecontroller,
      TextInputType.phone,
    );*/

    var divider = new Container(
      color: Colors.grey[300],
      width: 10000.0,
      height: 1.0,
    );

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
                      Center(child: Widgets.load()),
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

    void showInSnackBar(String value) {
      _scaffoldKey.currentState
          .showSnackBar(new SnackBar(content: new Text(value)));
    }

    applyChanges() async {
      if (user.titre.toString() == "null" || user.titre == "") {
        showInSnackBar("S'il vous plait entrer le titre ");
      } else {
        onLoading(context);
        Navigator.pop(context);
        verify_role();
      }
    }

    Widget a(text) => new Container(
          padding: new EdgeInsets.all(6.0),
          //  width: 150.0,
          //alignment: Alignment.center,
          decoration: new BoxDecoration(
            border: new Border.all(color: Colors.blue, width: 1.0),
            color: Colors.transparent,
            borderRadius: new BorderRadius.circular(8.0),
          ),
          child: new Text(
            "#" + text,
            style: new TextStyle(color: Colors.blue),
          ),
        );

    edit_name() async {
      User us = await Navigator.push(context,
          new MaterialPageRoute(builder: (BuildContext context) {
        return new InfoUser1(user);
      }));

      setState(() {
        user = us;
      });
    }

    edit_titre() async {
      User us = await Navigator.push(context,
          new MaterialPageRoute(builder: (BuildContext context) {
        return new OrganismeTitle(user);
      }));

      setState(() {
        user = us;
      });
    }

    edit_comp() async {
      User us = await Navigator.push(context,
          new MaterialPageRoute(builder: (BuildContext context) {
        return new Cmpetences(user);
      }));

      setState(() {
        user = us;
      });
    }

    edit_link(type) async {
      //
      User us = await Navigator.push(context,
          new MaterialPageRoute(builder: (BuildContext context) {
        return new Link_profile(user, type);
      }));

      setState(() {
        user = us;
      });
    }

    edit_bio() async {
      User us = await Navigator.push(context,
          new MaterialPageRoute(builder: (BuildContext context) {
        return new Bio(user);
      }));

      setState(() {
        user = us;
      });
    }

    make_user_offline() async {
      Map<String, dynamic> map = new Map<String, dynamic>();
      map["online"] = false;
      map["last_active"] = new DateTime.now().millisecondsSinceEpoch;
      map["offline"] = "offline";

      Firestore.instance
          .collection('users')
          .document(user.auth_id)
          .updateData(map);

      FirebaseDatabase.instance
          .reference()
          .child("status")
          .update({user.auth_id: false});

      FirebaseDatabase.instance
          .reference()
          .child("status")
          .update({user.auth_id: false});
    }

    edit_num() async {
      User us = await Navigator.push(context,
          new MaterialPageRoute(builder: (BuildContext context) {
        return new PhoneWidget(user);
      }));

      setState(() {
        user = us;
      });
    }

    edit_phone() {}

    editwidget(colors, tap) {
      return new InkWell(
          child: new Container(
              /*decoration: new BoxDecoration(
                boxShadow: [
                  new BoxShadow(
                    color: colors,
                    offset: new Offset(0.0, 0.8),
                    blurRadius: 30.0,
                  ),
                ],
              ),*/
              child: new Icon(
            Icons.edit,
            color: colors,
          )),
          onTap: () {
            tap();

            // open_bottomsheet();
          });
    }

    Widget phone_widget = new Row(
      children: <Widget>[
        new Text("Numéro de téléphone:"),
        new Expanded(child: new Container()),
        editwidget(Fonts.col_app, edit_phone)
      ],
    );

    save_niveau(va) {
      var js = {
        "niveau": va,
      };

      parse_s.putparse("users/" + user.id, js);
    }

    /*CardSettingsListPicker _buildCardSettingsListPicker_Type() {
      return CardSettingsListPicker(
        //initialValue: widget.user.niveau,
        label: '',
        labelAlign: TextAlign.center,
        contentAlign: TextAlign.center,
        hintText: "Choisir le niveau d'étude",
        //  autovalidate: _autoValidate,
        options: <String>['Bac + 2', 'Bac + 3', 'Bac + 5', 'Autre'],

        onSaved: (value) => save_niveau(value),
        // onChanged: (value) => _showSnackBar('Type', value),
      );
    }*/

    /* CardSettings _buildPortraitLayout() {
      return CardSettings(
        cardElevation: 1.0,
          padding: 4.0,
          children: <Widget>[
            _buildCardSettingsListPicker_Type()

          ]);
    }*/

    Widget sexe_widget = new Container(
        child: ExpansionTile(
            //backgroundColor: Colors.grey[100],
            title: new Container(
                // color: Colors.grey[100],
                child: new Row(
              children: <Widget>[
                new Image.asset(
                  "images/eq.png",
                  width: 20.0,
                  height: 20.0,
                ),
                new Container(
                  width: 12.0,
                ),
                new Row(children: <Widget>[
                  new Container(
                      child: new Text(
                    "Sexe: ",
                    style: new TextStyle(fontSize: 15.0),
                  )),
                  new Container(width: 12.0),
                  new Text("$type",
                      style:
                          new TextStyle(fontSize: 12.0, color: Colors.black)),
                ]),
              ],
            )),
            children: [
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text("Homme"),
              new Checkbox(
                value: val1,
                onChanged: (bool value) {
                  setState(() {
                    val1 = value;
                    val2 = !value;
                    type = "Homme";
                  });
                },
              ),
              new Container(width: 16.0),
              new Text("Femme"),
              new Checkbox(
                value: val2,
                onChanged: (bool value) {
                  setState(() {
                    val2 = value;
                    val1 = !value;
                    type = "Femme";
                  });
                },
              )
            ],
          ),
        ]));

    Widget page = new Container(
      color: Colors.grey[50],
      child: new Container(
        color: Colors.transparent,
        child: new Container(
          //alignment: Alignment.center,

          decoration: new BoxDecoration(
            color: Colors.white,
            // borderRadius: new BorderRadius.circular(10.0),
          ),
          child: new Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: <Widget>[
              new CustomScrollView(
                shrinkWrap: false,
                slivers: <Widget>[
                  new SliverAppBar(
                    backgroundColor: Colors.transparent,
                    automaticallyImplyLeading: false,
                    elevation: 0.0,
                    forceElevated: true,
                    expandedHeight: _appBarHeight,
                    /*pinned: _appBarBehavior == AppBarBehavior.pinned,
                    floating: _appBarBehavior == AppBarBehavior.floating ||
                        _appBarBehavior == AppBarBehavior.snapping,
                    snap: _appBarBehavior == AppBarBehavior.snapping,*/
                    flexibleSpace: new FlexibleSpaceBar(
                      title: new Row(children: <Widget>[
                        new Expanded(child: new Container()),
                        new IconButton(
                            icon: new Icon(Icons.check), onPressed: () {})
                      ]),
                      background: ClipPath(
                          clipper: new ArcClipper2(),
                          child: new Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              new Container(
                                width: width.value,
                                height: _appBarHeight,
                                decoration: new BoxDecoration(
                                  image: new DecorationImage(
                                    image:
                                        new NetworkImage(user.image.toString()),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: new Container(
                                    decoration: new BoxDecoration(
                                      color: Colors.grey[800],
                                      image: new DecorationImage(
                                        fit: BoxFit.cover,
                                        colorFilter: new ColorFilter.mode(
                                            Colors.black.withOpacity(0.3),
                                            BlendMode.dstATop),
                                        image: new NetworkImage(
                                          user.image.toString(),
                                        ),
                                      ),
                                    ),
                                    child: new Column(children: <Widget>[
                                      new Row(
                                        children: <Widget>[
                                          new Expanded(child: new Container()),
                                        ],
                                      ),
                                      new Container(
                                        height: 16.0,
                                      ),
                                      new Container(
                                          child: new Stack(children: [
                                        new Center(
                                            child: new Container(
                                          child: new CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                user.image.toString()),
                                            radius: 45.0,
                                          ),
                                        )),
                                        new Positioned(
                                            bottom: 0.0,
                                            //bottom: 8.0,
                                            left: 46.0,
                                            right: -8.0,
                                            child: new CircleAvatar(
                                                radius: 20.0,
                                                backgroundColor: Fonts.col_app,
                                                child: new IconButton(
                                                    color: Colors.grey[100],
                                                    icon: new Icon(
                                                      Icons.edit,
                                                      color: Colors.white,
                                                    ),
                                                    onPressed: () {
                                                      open_bottomsheet();
                                                    }))),
                                        uploading
                                            ? new Positioned(
                                                top: 8.0,
                                                //bottom: 8.0,
                                                left: 8.0,
                                                right: 8.0,
                                                child: new Center(
                                                    child: new CircularProgressIndicator(
                                                        // backgroundColor: Colors.grey,
                                                        //value: 16.0,
                                                        )))
                                            : new Container()
                                      ])),
                                      new Container(
                                        height: 8.0,
                                      ),
                                      new Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            new Container(width: 28.0),
                                            new Expanded(
                                                child: new Center(
                                                    child: new Text(
                                              user.age.toString() != "" &&
                                                      user.age.toString() !=
                                                          "null"
                                                  ? user.fullname.toString() +
                                                      " " +
                                                      user.firstname
                                                          .toString() +
                                                      ", " +
                                                      user.age.toString() +
                                                      " ans"
                                                  : user.fullname.toString() +
                                                      " " +
                                                      user.firstname.toString(),
                                              style: new TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17.0,
                                                  fontWeight: FontWeight.w600),
                                            ))),
                                            editwidget(Colors.white, edit_name),
                                          ]),
                                      new Container(
                                        height: 6.0,
                                      ),
                                      new Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            new Container(width: 28.0),
                                            new Expanded(
                                                child: new Center(
                                                    child: new Text(
                                                        user.titre.toString() !=
                                                                    "null" &&
                                                                user.titre.toString() !=
                                                                    ""
                                                            ? user.titre
                                                            : "Ajouter le titre",
                                                        style: new TextStyle(
                                                            color: user.titre.toString() !=
                                                                        "null" &&
                                                                    user.titre.toString() !=
                                                                        ""
                                                                ? Colors
                                                                    .grey[400]
                                                                : Colors
                                                                    .red[200],
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight.w600),
                                                        textAlign: TextAlign.center))),
                                            editwidget(
                                                Colors.white, edit_titre),
                                          ]),
                                      new Container(
                                        height: 6.0,
                                      ),
                                      new Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            new Center(
                                                child: new Text(
                                              user.community.toString(),
                                              style: new TextStyle(
                                                  color: Colors.grey[200],
                                                  fontSize: 17.0,
                                                  fontWeight: FontWeight.w400),
                                            )),
                                            new Container(
                                              height: 4.0,
                                            ),
                                          ])
                                    ])),
                              ),
                            ],
                          )),
                    ),
                  ),
                  new SliverList(
                    delegate: new SliverChildListDelegate(<Widget>[
                      new Container(height: 12.0),

                      new Container(height: 8.0),
                      new Container(
                        height: 1.0,
                        width: 1000.0,
                        color: Colors.grey[300],
                      ),
                      new Container(height: 12.0),

                      /* Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[

                            Text("Niveau d'étude:",style: new TextStyle(
                                color: Colors.grey[800],
                                fontWeight: FontWeight.w600)),
                            Container(width: 8),
                            //jiji


                          ]),*/

                      //_buildPortraitLayout(),

                      Container(
                        height: 12,
                      ),

                      new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Center(
                                child: new Text("Numéro de téléphone",
                                    style: new TextStyle(
                                        color: Colors.grey[800],
                                        fontWeight: FontWeight.w600))),
                            new Container(width: 12.0),
                            editwidget(Fonts.col_app, edit_num)
                          ]),

                      user.phone != "" && user.phone.toString() != "null"
                          ? Container(
                              height: 12,
                            )
                          : Container(),

                      user.phone != "" && user.phone.toString() != "null"
                          ? Center(
                              child: new Container(
                              // padding:
                              // new EdgeInsets.only(left: 16.0, right: 16.0),
                              // width: 300.0,
                              child: new Text(user.phone.toString(),
                                  style: TextStyle(color: Colors.grey[800])),
                            ))
                          : new Container(
                              child: new Center(
                                child: new Text(
                                  "Ajouter votre numéro de téléphone ..",
                                  style: new TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),

                      Container(
                        height: 8,
                      ),
                      new Container(
                        height: 1.0,
                        width: 1000.0,
                        color: Colors.grey[300],
                      ),
                      Container(
                        height: 8,
                      ),

                      new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Center(
                                child: new Text("COMPETENCES",
                                    style: new TextStyle(
                                        color: Colors.grey[800],
                                        fontWeight: FontWeight.w600))),
                            new Container(width: 12.0),
                            editwidget(Fonts.col_app, edit_comp)
                          ]),
                      new Container(height: 12.0),
                      user.list != null && user.list.isNotEmpty
                          ? new Center(
                              child: new Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  spacing: 4.0,
                                  runSpacing: 4.0,
                                  children: user.list.map((String item) {
                                    return a(item);
                                  }).toList()))
                          : new Container(
                              padding:
                                  new EdgeInsets.only(top: 16.0, bottom: 24.0),
                              child: new Center(
                                child: new Text(
                                  "Aucune compétence n'a été mentionnée",
                                  style: new TextStyle(
                                      color: Colors.grey[500], fontSize: 16.0),
                                ),
                              ))
                      /* new Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: <Widget>[

                              a("PHP"),
                              a("#CSS"),
                              a("#Javascript")
                            ],
                          )*/
                      ,
                      new Container(
                        height: 14.0,
                      ),
                      new Container(
                        height: 1.0,
                        width: 1000.0,
                        color: Colors.grey[300],
                      ),
                      new Container(
                        height: 12.0,
                      ),

                      new Container(
                        height: 12.0,
                      ),
                      new Container(
                        height: 1.0,
                        width: 1000.0,
                        color: Colors.grey[300],
                      ),
                      new Container(
                        height: 12.0,
                      ),

                      new Container(height: 8.0),
                      sexe_widget,

                      Container(
                        height: 8,
                      ),
                      new Container(
                        height: 1.0,
                        width: 1000.0,
                        color: Colors.grey[300],
                      ),
                      Container(
                        height: 8,
                      ),

                      Container(
                        height: 12,
                      ),
                      new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Center(
                                child: new Text("Curriculum Vitae ",
                                    style: new TextStyle(
                                        color: Colors.grey[800],
                                        fontWeight: FontWeight.w600))),
                            new Container(width: 12.0),
                            editwidget(Fonts.col_app, edit_bio)
                          ]),
                      new Container(
                        height: 8.0,
                      ),
                      user.bio != "" && user.bio.toString() != "null"
                          ? new Container(
                              padding:
                                  new EdgeInsets.only(left: 4.0, right: 4.0),
                              width: 300.0,
                              child: new Text(user.bio.toString()),
                            )
                          : new Container(
                              child: new Center(
                                child: new Text(
                                  "Ajouter une description ..",
                                  style: new TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                      new Container(height: 8.0),
                      new Container(
                        height: 1.0,
                        width: 1000.0,
                        color: Colors.grey[300],
                      ),
                      new Container(height: 14.0),
                      new GestureDetector(
                          onTap: () {},
                          child: new Row(
                            children: <Widget>[
                              new Container(
                                width: 12.0,
                              ),
                              new Image.asset(
                                "images/linked.png",
                                width: 60.0,
                                height: 60.0,
                              ),
                              new Container(
                                width: 12.0,
                              ),
                              user.linkedin_link != "" &&
                                      user.linkedin_link.toString() != "null"
                                  ? new Center(
                                      child: new Container(
                                          width: 180.0,
                                          child: new Text(
                                            user.linkedin_link.toString(),
                                            style: new TextStyle(
                                                color: Colors.grey[600]),
                                          )))
                                  : new Text(
                                      "Profil Linkedin:",
                                      style: new TextStyle(
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.w600),
                                    ),
                              new Expanded(child: Container()),
                              new InkWell(
                                  child: new Container(
                                      padding: new EdgeInsets.all(16.0),
                                      decoration: new BoxDecoration(
                                        boxShadow: [
                                          new BoxShadow(
                                            color: Fonts.col_app_shadow,
                                            offset: new Offset(0.0, 0.8),
                                            blurRadius: 30.0,
                                          ),
                                        ],
                                      ),
                                      child: new Icon(
                                        Icons.edit,
                                        color: Fonts.col_app,
                                      )),
                                  onTap: () {
                                    edit_link("linkedin");

                                    // open_bottomsheet();
                                  }),
                            ],
                          )),
                      new Container(height: 14.0),
                      new GestureDetector(
                          onTap: () {},
                          child: new Row(
                            children: <Widget>[
                              new Container(
                                width: 12.0,
                              ),
                              new Image.asset(
                                "images/instagram.png",
                                width: 60.0,
                                height: 60.0,
                              ),
                              new Container(
                                width: 12.0,
                              ),
                              user.instargram_link != "" &&
                                      user.instargram_link.toString() != "null"
                                  ? new Center(
                                      child: new Text(
                                      user.instargram_link.toString(),
                                      style: new TextStyle(
                                          color: Colors.grey[600]),
                                    ))
                                  : new Text(
                                      "Profile Instagram:",
                                      style: new TextStyle(
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.w600),
                                    ),
                              new Expanded(child: Container()),
                              new InkWell(
                                  child: new Container(
                                      padding: new EdgeInsets.all(16.0),
                                      decoration: new BoxDecoration(
                                        boxShadow: [
                                          new BoxShadow(
                                            color: Fonts.col_app_shadow,
                                            offset: new Offset(0.0, 0.8),
                                            blurRadius: 30.0,
                                          ),
                                        ],
                                      ),
                                      child: new Icon(
                                        Icons.edit,
                                        color: Fonts.col_app,
                                      )),
                                  onTap: () {
                                    edit_link("instagram");

                                    // open_bottomsheet();
                                  }),
                            ],
                          )),
                      new Container(height: 14.0),
                      new GestureDetector(
                          onTap: () {},
                          child: new Row(
                            children: <Widget>[
                              new Container(
                                width: 12.0,
                              ),
                              new Image.asset(
                                "images/twitter.png",
                                width: 60.0,
                                height: 60.0,
                              ),
                              new Container(
                                width: 12.0,
                              ),
                              user.twitter_link != "" &&
                                      user.twitter_link.toString() != "null"
                                  ? new Center(
                                      child: new Text(
                                      user.twitter_link.toString(),
                                      style: new TextStyle(
                                          color: Colors.grey[600]),
                                    ))
                                  : new Text(
                                      "Profile Twitter:",
                                      style: new TextStyle(
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.w600),
                                    ),
                              new Expanded(child: Container()),
                              new InkWell(
                                  child: new Container(
                                      padding: new EdgeInsets.all(16.0),
                                      decoration: new BoxDecoration(
                                        boxShadow: [
                                          new BoxShadow(
                                            color: Fonts.col_app_shadow,
                                            offset: new Offset(0.0, 0.8),
                                            blurRadius: 30.0,
                                          ),
                                        ],
                                      ),
                                      child: new Icon(
                                        Icons.edit,
                                        color: Fonts.col_app,
                                      )),
                                  onTap: () {
                                    edit_link("twitter");

                                    // open_bottomsheet();
                                  }),
                            ],
                          )),
                      new Container(
                        height: 12.0,
                      ),
                      divider,
                      new Center(
                          child: new Container(
                              padding: new EdgeInsets.only(
                                  top: 16.0,
                                  left: 8.0,
                                  right: 8.0,
                                  bottom: 16.0),
                              // color: Colors.grey[100],
                              child: new Text(
                                "Paramètres:",
                                style: new TextStyle(
                                    color: Colors.grey[800],
                                    fontWeight: FontWeight.bold),
                              ))),
                      divider,
                      new Container(
                        color: Colors.grey[50],
                        padding: new EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
                        // color: Colors.grey[100],
                        child: new Row(
                          children: <Widget>[
                            new Text(
                              "Je veux être visible :",
                              style: new TextStyle(fontSize: 15.0),
                            ),
                            new Expanded(child: new Container(width: 12.0)),
                            new Switch(
                              value: val,
                              onChanged: (bool value) {
                                setState(() {
                                  val = value;
                                });

                                if (val) {
                                  make_user_online();
                                } else {
                                  make_user_offline();
                                }
                              },
                            )
                          ],
                        ),
                      ),
                      divider,
                      new Container(
                        color: Colors.grey[50],

                        padding: new EdgeInsets.only(
                          bottom: 4.0,
                          top: 4.0,
                          left: 8.0,
                          right: 8.0,
                        ),
                        // color: Colors.grey[100],
                        child: new Row(
                          children: <Widget>[
                            new Text("Je veux recevoir des notifications :"),
                            new Expanded(child: new Container(width: 12.0)),
                            new Switch(value: true, onChanged: (val) {})
                          ],
                        ),
                      ),
                      divider,
                      new InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        new Potique()));
                          },
                          child: new Container(
                            color: Colors.grey[50],
                            padding: new EdgeInsets.only(
                              top: 12.0,
                              bottom: 12.0,
                              left: 8.0,
                              right: 8.0,
                            ),
                            // color: Colors.grey[100],
                            child: new Row(
                              children: <Widget>[
                                new Text("Politique de confidentialité :"),
                                new Expanded(child: new Container(width: 12.0)),
                                new Icon(Icons.arrow_right)
                              ],
                            ),
                          )),
                      divider,
                      new InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        new Conditions()));
                          },
                          child: new Container(
                            color: Colors.grey[50],

                            padding: new EdgeInsets.only(
                              top: 12.0,
                              bottom: 12.0,
                              left: 8.0,
                              right: 8.0,
                            ),
                            // color: Colors.grey[100],
                            child: new Row(
                              children: <Widget>[
                                new Text(
                                    "Conditions générales d'utilisations:"),
                                new Expanded(child: new Container(width: 12.0)),
                                new Icon(Icons.arrow_right)
                              ],
                            ),
                          ))
                    ]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    return WillPopScope(
        onWillPop: () {
          Widgets.exitapp(context);
        },
        child: new Scaffold(
          key: _scaffoldKey,
          appBar: new AppBar(
            elevation: 1.0,
            title: new Text("Profil"),
            actions: <Widget>[
              new IconButton(
                  icon: new Icon(Icons.check),
                  onPressed: () async {
                    /* if (tapped) {
                  }*/
                    applyChanges();
                  })
            ],
          ),
          body: page,
        ));
  }

/*
*/
}

/*


 */
class FullScreenWrapper extends StatelessWidget {
  final ImageProvider imageProvider;
  final Widget loadingChild;
  final Color backgroundColor;
  final dynamic minScale;
  final dynamic maxScale;

  FullScreenWrapper(
      {this.imageProvider,
      this.loadingChild,
      this.backgroundColor,
      this.minScale,
      this.maxScale});

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.black,
          actions: <Widget>[
            new IconButton(
                icon: new Icon(
                  Icons.close,
                  color: Colors.grey[50],
                  size: 26.0,
                ),
                onPressed: () {
                  Navigator.pop(context);
                })
          ],
        ),
        backgroundColor: Colors.black87,
        body: new Container(
            constraints: BoxConstraints.expand(
              height: MediaQuery.of(context).size.height,
            ),
            child: new PhotoView(
              imageProvider: imageProvider,
              //backgroundColor: backgroundColor,
              minScale: minScale,
              maxScale: maxScale,
            )));
  }
}
