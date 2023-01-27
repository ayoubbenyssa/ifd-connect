import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:ifdconnect/widgets/bottom_menu.dart';
import 'package:ifdconnect/widgets/custom_widgets/app_textfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/models/link1.dart';
import 'package:ifdconnect/models/offers.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/services/validators.dart';
import 'package:ifdconnect/services/youtube_service.dart';
import 'package:ifdconnect/widgets/fixdropdown.dart';
import 'package:ifdconnect/widgets/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class AddAnnonce extends StatefulWidget {
  AddAnnonce(
      this.user, this.auth, this.sign, this.list_partner, this.selectedValue,
      {this.an});

  User user;
  String selectedValue = "";
  var auth;
  var sign;
  Offers an;
  List list_partner;
  @override
  _AddAnnonceState createState() => _AddAnnonceState();
}

class _AddAnnonceState extends State<AddAnnonce> {
  List<String> _list = [
    "Offres Stages/Emplois",
    "Objets perdus",
  ];
  Link1 link1 = new Link1();

  String _platformVersion;
  final TextEditingController _link = new TextEditingController();

  // String selectedValue = "";
  ParseServer parse_s = new ParseServer();
  List<String> images = new List<String>();
  final _titlectrl = new TextEditingController();
  final _descctrl = new TextEditingController();
  final _adrctrl = new TextEditingController();
  FocusNode _titlefocus = new FocusNode();
  FocusNode _descfocus = new FocusNode();
  FocusNode _adrfocus = new FocusNode();
  var da = "";
  GetLinkData getlink = new GetLinkData();
  bool _isComposing1 = false;
  bool _isComposing2 = false;

  bool uploading = false;
  var im = "";
  var lo = false;
  var error = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool _autovalidate = false;
  List<String> items = new List<String>();

  save_image(image) async {
    setState(() {
      uploading = true;
      lo = false;
      _isComposing1 = true;
    });

    int timestamp = new DateTime.now().millisecondsSinceEpoch;
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child("profile/img_" + timestamp.toString() + ".jpg");
    StorageUploadTask uploadTask = storageReference.put(image);
    await storageReference.put(image).onComplete.then((val) {
      val.ref.getDownloadURL().then((val) {
        //if (!mounted) return;

        setState(() {
          images.add(val.toString());
          im = val.toString();
          error = "";
          uploading = false;
          lo = true;
        });
      });
    });
  }

  get_an() {
    if (widget.an.toString() != "null") {
      setState(() {
        for (String i in widget.an.pic) {
          images.add(i);
        }
        if (widget.an.pic.length > 0) {
          im = widget.an.pic[0];
        }

        _titlectrl.text = widget.an.title;
        da = widget.an.createdAt;
        print(widget.an.type.replaceAll("_emi", ""));

        widget.selectedValue = widget.an.type.replaceAll("_emi", "");
        _adrctrl.text = widget.an.address;
        _descctrl.text = widget.an.description;
      });
    }
  }

  @override
  initState() {
    super.initState();
    _adrctrl.text = widget.user.community;

    get_an();
  }

  showd() async {
    var a = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime.now().subtract(new Duration(days: 30)),
      lastDate: new DateTime.now().add(new Duration(days: 30)),
    );

    setState(() {
      da = a.toString().split(" ")[0];
      error = "";
    });
  }

  gallery() async {
    Navigator.pop(context);
    var platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion =
          await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        //images.add(i);
        File fil = platformVersion;
        _cropImage(fil);
      });
    } on PlatformException {
//      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  Future _cropImage(image) async {
    File compressedFile =
        await FlutterNativeImage.compressImage(image.path, quality: 60);
    save_image(compressedFile);
  }

  ///image
  _handleCameraButtonPressed() async {
    Navigator.of(context).pop(true);
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    _cropImage(image);
  }

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
                        color: Fonts.col_app_fonn,
                      ),
                    ),
                  ],
                ),
              ),
            ));

    // Navigator.pop(context); //pop dialog
    //  _handleSubmitted();
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(""),
          content: new Text(
              "Votre annonce est en cours de vérification par notre équipe, vous serez alerté par mail une fois publiée!"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
          ],
        );
      },
    );
  }

  confirm() async {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true;
    } // Start validating on every change.
    /* } else if (im == "") {
      setState(() {
        error = "S'il vous plait choisir une photo";
      });
    }*/
    else if (widget.selectedValue == "") {
      setState(() {
        error = "S'il vous plait choisir le type d'annonce";
      });
    } else {
      onLoading(context);

      if (widget.selectedValue.contains("_emi") == false)
        widget.selectedValue = widget.selectedValue + "_emi";

      var js = {
        "title": _titlectrl.text,
        "description": _descctrl.text,
        "time_an": da,
        "image": im,
        "pictures": images,
        "type": widget.selectedValue,
        "address": _adrctrl.text,
        "active": widget.an.toString()!= "null"?1: 0,
        "author": {
          "__type": "Pointer",
          "className": "users",
          "objectId": widget.user.id
        },
        "emi": true,
        "items": items.isEmpty ? null : items
      };

      if (widget.an.toString() == "null") {
        await parse_s.postparse('offers', js);

        Navigator.of(context, rootNavigator: true).pop('dialog');

        _showDialog();

        new Timer(new Duration(seconds: 3), () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => new BottomNavigation(
                      widget.auth, null, widget.user, [], false, null,
                      animate: true)),
              (Route<dynamic> route) => false);
        });

        /*  Routes.goto_home(context, widget.auth, widget.sign, widget.user,
            widget.analytics, widget.observer,widget.list_partner);*/
      } else {
        widget.an.description = _descctrl.text;
        widget.an.address = _adrctrl.text;
        widget.an.pic = images;
        widget.an.title = _titlectrl.text;
        await parse_s.putparse('offers/' + widget.an.objectId, js);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => new BottomNavigation(
                    widget.auth, null, widget.user, [], false, null,
                    animate: true)),
                (Route<dynamic> route) => false);
      }
    }
  }

  var textcat = new TextStyle(color: Colors.grey[700], fontSize: 12.0);

  getLinWidget() {
    if (items.length == 1) {
      return new GestureDetector(
          onTap: () {
            // _launched = _launch(post.link);
          },
          child: new Text(link1.url,
              style: new TextStyle(
                  wordSpacing: 1.0,
                  color: Colors.blue[700],
                  fontSize: 15.0,
                  fontWeight: FontWeight.w900)));
    } else {
      return new GestureDetector(
          onTap: () {
            //  _launched = _launch(items[0]);
          },
          child: new Container(
              child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                /* new Container(
                    padding: new EdgeInsets.only(left: 16.0, bottom: 8.0),
                    child: new Text(link1.title.toString(),
                        style: new TextStyle(color: Colors.grey[700]))),*/
                new SizedBox(
                    height: 200.0,
                    child: new Stack(
                      children: <Widget>[
                        new Positioned.fill(
                          child: new Image.network(
                            link1.image.toString(),
                            fit: BoxFit.cover,
                          ),
                        )
                      ],
                    )),
                new Container(
                    color: Colors.grey[200],
                    padding:
                        new EdgeInsets.only(left: 16.0, bottom: 8.0, top: 8.0),
                    child:
                        new Text(link1.description.toString(), style: textcat)),
                new Container(
                    width: 5000.0,
                    color: Colors.grey[200],
                    padding: new EdgeInsets.only(left: 16.0, bottom: 8.0),
                    child: new Text(link1.url.toString(),
                        style: new TextStyle(
                            color: Colors.grey[500], fontSize: 11.0)))
              ])));
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
                        onTap: gallery,
                        title: new Text("Photo depuis la gallerie")),
                  ])));
        });
  }

  @override
  Widget build(BuildContext context) {
    Validators val = new Validators(context: context);
    var style = new TextStyle(
        color: const Color(0xffeff2f7),
        fontSize: 14.0,
        fontWeight: FontWeight.w600);

    /* if(post.link != "")
    {
      print(items.length);
      if(items.length == 1)
      {
        linkw =  new GestureDetector(
            onTap: () {
              _launched = _launch(post.link);

            },
            child:new Text(post.link, style: new TextStyle(wordSpacing: 1.0 ,color: Colors.blue[700],
                fontSize: 15.0,
                fontWeight: FontWeight.w900)));
      }
      else {
        linkw =  new GestureDetector(
            onTap: () {
              _launched = _launch(items[0]);

            },
            child:new Container(child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                      padding: new EdgeInsets.only(left: 16.0, bottom: 8.0),
                      child: new Text(link1.title.toString(),
                          style: new TextStyle(color: Colors.grey[700]))),
                  new SizedBox(
                      height: 200.0,
                      child: new Stack(
                        children: <Widget>[
                          new Positioned.fill(
                            child: new Image.network(
                              link1.image.toString(),
                              fit: BoxFit.cover,
                            ),
                          )
                        ],
                      )),
                  new Container(color: Colors.grey[200],
                      padding: new EdgeInsets.only(
                          left: 16.0, bottom: 8.0, top: 8.0),
                      child: new Text(
                          link1.description.toString(), style: textcat)),
                  new Container(width: 5000.0,
                      color: Colors.grey[200],
                      padding: new EdgeInsets.only(left: 16.0, bottom: 8.0),
                      child: new Text(link1.url.toString(),
                          style: new TextStyle(
                              color: Colors.grey[500], fontSize: 11.0)))

                ])));
      }
    }*/

    Widget date_d = new InkWell(
      child: Container(
        padding: EdgeInsets.only(top: 10,left: 5.w,right: 5.h),
        // margin: EdgeInsets.only(top: 2.h),
        decoration: BoxDecoration(
          color: Fonts.colors_container,
          border: Border.all(color: Fonts.border_col),
          borderRadius: BorderRadius.all(Radius.circular(22.r))
        ),
        child: Center(
          child: new Column(
            children: <Widget>[
              new Row(
                children: <Widget>[
                  new Container(
                    width: 8.0,
                  ),
                  new Text(
                    "Date:",
                    style: new TextStyle(color: Colors.grey[600]),
                  ),
                  new Container(
                    width: 12.0,
                  ),
                  new Text(da == "" ? "" : da),
                  new Expanded(child: new Container()),
                  new Icon(Icons.arrow_drop_down)
                ],
              ),
              new Container(height: 12.0),
              // new Container(
              //   height: 1.2,
              //   width: 1000.0,
              //   color: Colors.grey,
              // )
            ],
          ),
        ),
      ),
      onTap: () {
        showd();
      },
    );

    Widget btn_log = new Container(
        height: 40.0,
        padding: new EdgeInsets.only(left: 6.0, right: 6.0),
        child: new Material(
            elevation: 0.0,
            shadowColor: Fonts.col_app_fon,
            borderRadius: new BorderRadius.circular(22.0.r),
            color: Fonts.col_app,

            /*decoration: new BoxDecoration(
            border: new Border.all(color: const Color(0xffeff2f7), width: 1.5),
            borderRadius: new BorderRadius.circular(6.0)),*/
            child: new MaterialButton(
                // color:  const Color(0xffa3bbf1),
                onPressed: () {
                  confirm();
                },
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // new Container(
                    //   width: 8.0,
                    // ),
                    //  new Container(height: 36.0,color: Colors.white,width: 1.5,),
                    // new Container(
                    //   width: 8.0,
                    // ),
                    new Text("CRÉER   ", style: style)
                  ],
                ))));

    List<Widget> widgets() {
      return images
          .map((String file) => new Stack(children: <Widget>[
                new Container(
                    padding: new EdgeInsets.all(4.0),
                    width: 90.0,
                    height: 90.0,
                    child: new Material(
                        borderRadius: new BorderRadius.circular(12.0),
                        shadowColor: Colors.white,
                        elevation: 3.0,
                        child: new Image.network(
                          file,
                          fit: BoxFit.cover,
                        ))),
                new Positioned(
                    top: 0.0,
                    right: 2.0,
                    child: new InkWell(
                      child: new CircleAvatar(
                          radius: 10.0,
                          backgroundColor: const Color(0xffff374e),
                          child: new Center(
                              child: new Icon(
                            Icons.close,
                            size: 18.0,
                            color: Colors.white,
                          ))),
                      onTap: () {
                        setState(() {
                          images.remove(file);
                        });
                      },
                    ))
              ]))
          .toList();
    }

    getpictues() {
      return im == ""
          ? new Container()
          : new Container(
              height: 100.0,
              child: new ListView(
                  scrollDirection: Axis.horizontal, children: widgets()));
    }

    addLinkdialog() async {
      return await showDialog<bool>(
            context: context,
            builder: (_) => new AlertDialog(
              title: Center(child: const Text('Ajouter un lien')),
              content: new Container(
                  height: 80.0,
                  child: new Column(children: <Widget>[

                    TextFieldWidget(
                      "Coller lien:",
                      null,
                      _link,
                      TextInputType.text,
                      // widget.user.bio,
                      null,
                      suffixIcon: "",
                    ),
                    // new TextFormField(
                    //     controller: _link,
                    //     autofocus: true,
                    //     keyboardType: TextInputType.text,
                    //     decoration: new InputDecoration(
                    //       hintText: 'Coller ici  comme http://www.google.com',
                    //       labelText: 'Coller lien:',
                    //     ))


                  ])),
              actions: <Widget>[
                new FlatButton(
                  child: const Text('OK'),
                  onPressed: () {
                    setState(() {
                      _isComposing2 = true;
                    });

                    GetLinkData.getLink(_link.text).then((vall) {
                      if (vall.length == 0) {
                        items = [];
                        setState(() {
                          // post.link = _link.text;
                          items.add(_link.text + ",");
                        });
                      } else {
                        setState(() {
                          items = [];
                          // post.type = "4";
                          // post.link = _link.text;
                          link1.title = vall['title'];
                          link1.image = vall['image'];
                          link1.url = vall['url'];
                          link1.description = vall['description'];

                          _titlectrl.text = vall['title'];
                          _descctrl.text = vall['description'];

                          items.add(link1.url);
                          items.add(link1.image);
                          items.add(link1.title);
                          items.add(link1.description);
                        });
                      }
                    });
                    Navigator.of(context).pop(false);
                  },
                ),
                new FlatButton(
                  child: const Text('Annuler'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            ),
          ) ??
          false;
    }

    Widget link = new InkWell(
      child: Container(
        decoration: BoxDecoration(
          color: Fonts.colors_container ,
          borderRadius: BorderRadius.all(Radius.circular(22.r)),
          border: Border.all(color: Fonts.border_col)
        ),
        child: new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                new Container(
                  width: 8.0,
                ),
                new Text(
                  "Vidéo:",
                  style: new TextStyle(color: Colors.grey[600]),
                ),
                new Container(
                  width: 12.0,
                ),
                uploading ? new RefreshProgressIndicator() : new Container(),

                /*new Container(
                        color: Colors.grey,
                        width: 70.0,
                        height: 70.0,
                        child: new Image.network(
                          im,
                          width: 70.0,
                          height: 70.0,
                          fit: BoxFit.cover,
                        ),
                      )*/

                new Expanded(child: new Container()),
                new FlatButton(
                  onPressed: () {
                    addLinkdialog();
                    // open_bottomsheet();
                  },
                  child: new Text(
                    "AJOUTER UN LIEN",
                    style: new TextStyle(
                      fontSize: 12.sp,
                      color: Fonts.col_app_red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ],
            ),
            // new Container(
            //   height: 1.2,
            //   width: 1000.0,
            //   color: Colors.grey,
            // ),
          ],
        ),
      ),
      onTap: () {},
    );

    Widget pht = new InkWell(
      child: Container(
        decoration: BoxDecoration(
            color: Fonts.colors_container ,
            borderRadius: BorderRadius.all(Radius.circular(22.r)),
            border: Border.all(color: Fonts.border_col)
        ),
        child: new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                new Container(
                  width: 8.0,
                ),
                new Text(
                  "Photo:",
                  style: new TextStyle(color: Colors.grey[600]),
                ),
                new Container(
                  width: 12.0,
                ),
                uploading ? new RefreshProgressIndicator() : new Container(),

                /*new Container(
                        color: Colors.grey,
                        width: 70.0,
                        height: 70.0,
                        child: new Image.network(
                          im,
                          width: 70.0,
                          height: 70.0,
                          fit: BoxFit.cover,
                        ),
                      )*/

                new Expanded(child: new Container()),
                new FlatButton(
                  onPressed: () {
                    open_bottomsheet();
                  },
                  child: new Text(
                    "AJOUTER UNE PHOTO",
                    style: new TextStyle(
                      fontSize: 12.sp,
                      color:  Fonts.col_app_red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ],
            ),
            // new Container(
            //   height: 1.2,
            //   width: 1000.0,
            //   color: Colors.grey,
            // ),
          ],
        ),
      ),
      onTap: () {},
    );

    Widget drop_down = new Container(
        color: Fonts.col_app,
        height: 60.0.h,
        child: Container(
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.only(left: 16.0, right: 8.0),
            decoration: new BoxDecoration(
              color: Fonts.col_app,
              border: new Border.all(color: Colors.white, width: 1.0),
              borderRadius: new BorderRadius.circular(10.0.r),
            ),
            child: new FixDropDown(
              elevation: 1,
                style: TextStyle(color: Colors.black),
                iconSize: 32.0,
                isDense: false,
                items: _list.map((String value) {
                  return new FixDropdownMenuItem(
                    value: value,
                    child: new Text(
                      value,
                      maxLines: 2,
                      softWrap: true,
                    ),
                  );
                }).toList(),
                hint: new Text(
                  widget.selectedValue != ""
                      ? widget.selectedValue
                      : "Type d'annonces",
                  maxLines: 1,
                  softWrap: true,
                  style: new TextStyle(color: Colors.white),
                ),
                onChanged: (String value) {
                  setState(() {
                    widget.selectedValue = value;
                    error = "";
                  });
                })));

    Widget title = TextFieldWidget(
      widget.selectedValue == "Général" ? "Exprimez vous" : "Titre",
      _titlefocus,
      _titlectrl,
      TextInputType.text,
      // widget.user.bio,
      val.titrre,
      suffixIcon: "",
    );

    // Widgets.textfield_dec(
    //     widget.selectedValue == "Général" ? "Exprimez vous" : "Titre",
    //     _titlefocus,
    //     "",
    //     _titlectrl,
    //     TextInputType.text,
    //     val.titrre);

    Widget desc = widget.selectedValue == "Général"
        ? Container()
        :
    TextFieldWidget(
      "Descriprion",
      _descfocus,
      _descctrl,
      TextInputType.text,
      // widget.user.bio,
      null,
      suffixIcon: "",
    );
    // Widgets.textfield_des(
    //         "Descriprion",
    //     _descfocus,
    //     "",
    //     _descctrl,
    //     TextInputType.text,
    //     null
    // );

    Widget adrr = widget.selectedValue == "Général"
        ? Container()
        :

    TextFieldWidget(
      "Adresse",
      _adrfocus,
      _adrctrl,
      TextInputType.text,
      // widget.user.bio,
      null,
      suffixIcon: "",
    );
    // Widgets.textfield_dec(
    //         "Adresse",
    //     _adrfocus,
    //     "",
    //     _adrctrl,
    //     TextInputType.text,
    //     null
    // );

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: new AppBar(

          iconTheme: IconThemeData(color: Colors.white),

          title: new Text(widget.an.toString() != "null"
              ? "Modifier l'annonce"
              : "Publier une annonce",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w100,
                fontSize: 18.0.sp),
          ),
          elevation: 0.0,
        ),
        body: new Form(
            key: _formKey,
            autovalidate: _autovalidate,
            //onWillPop: _warnUserAboutInvalidData,
            child: new Column(children: <Widget>[
              drop_down,

              Container(
                height: 30.h,
                  color: Fonts.col_app,
                  child: ClipRRect(
                      borderRadius: BorderRadius.only(topRight : Radius.circular(39.r)),

                      child: Container(
                        color: Colors.white,
            ))
              ),
              Container(
                // margin: EdgeInsets.symmetric(horizontal: 10.w),
                child: new Expanded(
                  child: new ListView(

                    padding: new EdgeInsets.symmetric(vertical: 6.h,horizontal: 20.w),
                    children: <Widget>[
                      new Container(height: 16.0),
                      title,
                      widget.selectedValue == "Général"
                          ? Container()
                          : new Container(height: 24.0),
                      widget.selectedValue == "Général" ? Container() : date_d,
                      new Container(height: 8.0),
                      adrr,
                      widget.selectedValue == "Général"
                          ? Container()
                          : new Container(height: 8.0),
                      desc,
                      widget.selectedValue == "Général"
                          ? Container()
                          : new Container(height: 24.0),
                      _isComposing2 ? Container() : pht,
                      new Container(height: 16.0),
                      getpictues(),
                      _isComposing1
                          ? Container()
                          : widget.selectedValue == "Général"
                              ? link
                              : Container(),
                      link1.description.toString() == "null"
                          ? Container()
                          : getLinWidget(),
                      new Center(
                        child: new Text(
                          error,
                          style: new TextStyle(
                              color: Colors.red[900],
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      new Container(height: 16.0),
                      btn_log
                    ],
                  ),
                ),
              )
            ])));
  }
}
