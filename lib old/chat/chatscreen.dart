// Dart Imports
import 'dart:async';
import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';

// Package Imports
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:ifdconnect/chat/UserWidget.dart';
import 'package:ifdconnect/chat/chat_message.dart';
import 'package:ifdconnect/chat/database_messages.dart';
import 'package:ifdconnect/chat/message_data.dart';
import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/services/app_services.dart';
import 'package:ifdconnect/services/location_services.dart';
import 'package:ifdconnect/widgets/bottom_menu.dart';
import 'package:mime/mime.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen(this.myid, this.idOther, this.list_partners, this.goto, this.auth,
      this.analytics,
      {this.user, this.reload, Key key})
      : super(key: key);
  String idOther;
  String myid;
  var reload;
  User user;
  var list_partners;
  var goto;
  var analytics;
  var onLocaleChange;
  var auth;

  @override
  _ChatScreenState createState() => new _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  bool _isComposing = false;
  final TextEditingController _textController = new TextEditingController();

  bool show_textfield = true;
  Message msgMyId = new Message();
  Message msgidOther = new Message();
  Database database = new Database();
  DatabaseReference gMessagesDbRef, gMessagesDbRef_inv;
  String idLast = "";
  bool vu = false;
  DatabaseReference gMessagesDbRef2;
  DatabaseReference gMessagesDbRef3;
  bool isBlock = false;
  String document = "";
  User user_o;

  String getKey() => widget.myid + "_" + widget.idOther;

  String getKey1() => widget.idOther + "_" + widget.myid;
  bool show = false;

  messageviewedbyme() async {
    gMessagesDbRef3 = FirebaseDatabase.instance
        .reference()
        .child("lastm_medz")
        .child(getKey());
    var snapshot = await FirebaseDatabase.instance
        .reference()
        .child("lastm_medz")
        .child(getKey())
        .once();
    if (snapshot.value != null) {
      FirebaseDatabase.instance
          .reference()
          .child("lastm_medz")
          .child(getKey())
          .update({"vu_" + widget.myid: "0"});
      try {
        setState(() {
          idLast = snapshot.value["id_last"];
        });
      } catch (e) {}
    }
  }

  viewMessage(key) async {
    FirebaseDatabase.instance
        .reference()
        .child("lastm_medz/" + key + "/vu_" + widget.idOther)
        .onValue
        .listen((val) {
      var d = val.snapshot.value;

      if (d != null) {
        //Message lu
        if (d == "0") {
          try {
            setState(() {
              vu = true;
            });
          } catch (e) {}
        }
        //Message non lu
        else {
          try {
            setState(() {
              vu = false;
            });
          } catch (e) {}
        }
      }
    });
  }

  List list = new List();
  String my_name;
  bool uploading = false;
  bool uploading1 = false;

  var im = "";
  var lo = false;
  var error = "";
  List<String> images = new List<String>();
  FlutterSound flutterSound = new FlutterSound();

  @override
  initState() {
    print("--------------------------------------------------");
    print(widget.user.firstname);

    database.GetUserInfo(widget.idOther).then((User us) {
      try {
        user_o = us;

        setState(() {
          msgidOther.avatar = us.image;
          msgidOther.name =
              us.firstname?.toLowerCase() + " " + us.fullname.toUpperCase();
          msgidOther.idUser = us.auth_id;
        });
      } catch (e) {}
    });

    database.GetUserInfo(widget.myid).then((val) {
      try {
        setState(() {
          msgMyId.avatar = val.image;
          msgMyId.name =
              val.firstname?.toLowerCase() + " " + val.fullname.toUpperCase();
          msgMyId.idUser = widget.myid;
          my_name = val.token;
        });
      } catch (e) {}
    });
    gMessagesDbRef2 = FirebaseDatabase.instance
        .reference()
        .child("room_medz")
        .child(getKey());
    messageviewedbyme();
    viewMessage(getKey1());
    gMessagesDbRef = FirebaseDatabase.instance
        .reference()
        .child("message_medz")
        .child(getKey());
    gMessagesDbRef_inv = FirebaseDatabase.instance
        .reference()
        .child("message_medz")
        .child(getKey1());

    super.initState();
  }

  /*

  micro
   */
  bool _isRecording = false;
  bool _isPlaying = false;
  StreamSubscription _recorderSubscription;
  StreamSubscription _playerSubscription;
  String _recorderTxt = '00:00:00';
  String _playerTxt = '00:00:00';
  String path = "";
  StreamSubscription _dbPeakSubscription;
  String _path;

  String _fileName = '...';
  String _extension;
  bool _hasValidMime = false;

  var url = "";
  String addr = "";
  double lat, lng;
  String key = "AIzaSyCESijRK1ROlUvqjEEG6vtCyRoMjjClzpM";
  Map<dynamic, dynamic> result = new Map();

  void stopRecorder() async {
    try {
      String result = await flutterSound.stopRecorder();
      print('stopRecorder: $result');

      if (_recorderSubscription != null) {
        _recorderSubscription.cancel();
        _recorderSubscription = null;
      }
      if (_dbPeakSubscription != null) {
        _dbPeakSubscription.cancel();
        _dbPeakSubscription = null;
      }
    } catch (err) {
      print('stopRecorder error: $err');
    }

    this.setState(() {
      this._isRecording = false;
    });
  }

  void _onRecorderPreesed() async {
    print("record");
    try {
      String result = await flutterSound.startRecorder(
        // codec: t_CODEC.CODEC_AAC,
      );
      print('startRecorder: $result');

      _recorderSubscription = flutterSound.onRecorderStateChanged.listen((e) {
        DateTime date =
        new DateTime.fromMillisecondsSinceEpoch(e.currentPosition.toInt());
        String txt = DateFormat('mm:ss', 'en_US').format(date);
        this.setState(() {
          this._isRecording = true;
          this._recorderTxt = txt.substring(0, 5);
          this._path = result;
        });
      });
    } catch (err) {
      print('startRecorder error: $err');
      setState(() {
        this._isRecording = false;
      });
    }
  }

  void startRecorder() async {
    print("yessss");
    try {
      print("pkppkp");
      flutterSound = new FlutterSound();
      flutterSound.setSubscriptionDuration(0.01);
      path = await flutterSound.startRecorder();
      print('startRecorder: $path');

      _recorderSubscription = flutterSound.onRecorderStateChanged.listen((e) {
        // print("jdjdjdjjdjdjdjdj");
        // print(e);

        DateTime date =
        new DateTime.fromMillisecondsSinceEpoch(e.currentPosition.toInt());
        String txt = DateFormat('mm:ss:SS', 'en_US').format(date);

        this.setState(() {
          this._recorderTxt = txt.substring(0, 8);
        });
      });

      this.setState(() {
        this._isRecording = true;
      });
    } catch (err) {
      print('startRecorder error: $err');
    }
  }

  /*void stopRecorder() async {
    try {
      String result = await flutterSound.stopRecorder();
      print('stopRecorder: $result');

      File file;

      if (Platform.isIOS)
        file = new File(path.replaceAll("file://", ""));
      else
        file = new File(path);

      print(path);
      await save_audio(file);

      if (_recorderSubscription != null) {
        _recorderSubscription.cancel();
        _recorderSubscription = null;
      }

      this.setState(() {
        this._isRecording = false;
      });
    } catch (err) {
      print('stopRecorder error: $err');
    }
  }
*/

  /*

  micro
   */

  String progress = "";
  String progress_res = "";

  setProgress(progress) {
    setState(() {
      progress_res = progress;
    });

    print(4444);
    print(progress_res);
  }

  ParseServer ps = new ParseServer();

  save_file(File file, ext) async {
    setState(() {
      uploading1 = true;
      lo = false;
    });

    List<String> va = await ps.fileUpload(file, progress, setProgress, ext);

    //if (!mounted) return;
    _sendMessage(file: va[1], docname: va[0], text: "file");

    setState(() {
      /// images.add(va.toString());
      print(va.toString());

      ///im = va.toString();
      error = "";
      uploading1 = false;
      lo = true;
    });

    return true;
  }

  save_image(File image, ext) async {
    setState(() {
      uploading = true;
      lo = false;
    });

    int timestamp = new DateTime.now().millisecondsSinceEpoch;
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child("profile/img_" + timestamp.toString() + ext);
    var val = await storageReference.put(image).onComplete;
    var va = await val.ref.getDownloadURL();
    //if (!mounted) return;

    setState(() {
      images.add(va.toString());
      print(va.toString());
      im = va.toString();
      error = "";
      uploading = false;
      lo = true;
    });

    return true;
  }

  String audio_url = "";

  save_audio(File image) async {
    setState(() {
      uploading = true;
      lo = false;
    });

    int timestamp = new DateTime.now().millisecondsSinceEpoch;
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child("audio/img_" + timestamp.toString() + ".mp4");
    var val = await storageReference.put(image).onComplete;
    var va = await val.ref.getDownloadURL();
    //if (!mounted) return;
    await _sendMessage(audio: va.toString(), text: "text");

    setState(() {
      print(va.toString());
      audio_url = va.toString();

      error = "";
      uploading = false;
      lo = true;
    });

    return true;
  }

  gallery() async {
    Navigator.pop(context);

    images = [];
    var platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      File fil = await ImagePicker.pickImage(source: ImageSource.gallery);
      await _cropImage(fil);

      print("yessss");
      _sendMessage(imageUrl: images, text: "text");
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
    await save_image(compressedFile, ".jpg");
    return true;
  }

  _onRecordCancel() {
    stopRecorder();
  }

  ///image
  _handleCameraButtonPressed() async {
    Navigator.of(context).pop(true);
    images = [];

    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    await _cropImage(image);
    _sendMessage(imageUrl: images, text: "text");
  }



  _pickDocument() async {
    Navigator.of(context).pop(true);

    String result;
    try {
      setState(() {
        _path = '-';
        //  _pickFileInProgress = true;
      });
      FlutterDocumentPickerParams params = FlutterDocumentPickerParams(
        allowedFileExtensions: null,
        allowedUtiTypes: null,
        allowedMimeTypes:
        'application/pdf text/plain application/msword  application/vnd.ms-excel application/vnd.openxmlformats-officedocument.spreadsheetml.sheet '
            'application/vnd.ms-powerpoint application/vnd.openxmlformats-officedocument.presentationml.presentation'
            ' application/vnd.openxmlformats-officedocument.wordprocessingml.document application/vnd.openxmlformats-officedocument.wordprocessingml.template'
            .split(' ')
            .where((x) => x.isNotEmpty)
            .toList(),
      );

      result = await FlutterDocumentPicker.openDocument(params: params);
      String type = result.toString().split('.').last;

      save_file(new File(result), type);
    } catch (e) {
      result = 'Error: $e';
    } finally {}

    setState(() {
      _path = result;
    });
  }

  //bottom sheet
  open_bottomsheet() {
    showDialog(
        context: context,
        builder: (_) => new Dialog(
            child: new Container(
                height: 200.0,
                child: new Container(
                  // padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                    child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new ListTile(
                              dense: true,
                              leading: new Image.asset(
                                "images/camera.png",
                                width: 28.0,
                                height: 28.0,
                              ),
                              onTap: _handleCameraButtonPressed,
                              title: new Text(
                                "Camera",
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              )),
                          Container(
                              height: 1.0, width: 1000.0, color: Colors.grey[200]),
                          new ListTile(
                              dense: true,
                              leading: new Image.asset(
                                "images/gal.png",
                                width: 28.0,
                                height: 28.0,
                                color: Fonts.col_app_fonn,
                              ),
                              onTap: gallery,
                              title: new Text("Gallerie",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ))),
                          Container(
                              height: 1.0, width: 1000.0, color: Colors.grey[200]),
                          /* new ListTile(
                          dense: true,
                          leading: new Image.asset(
                            "images/lin.png",
                            width: 28.0,
                            height: 28.0,
                            color: Colors.blue[700],
                          ),
                          onTap: (){

                          },
                          title: new Text("Fichier",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0,
                              ))),*/
                          new ListTile(
                              dense: true,
                              leading: new Image.asset(
                                "images/link.png",
                                width: 28.0,
                                height: 28.0,
                                color: Fonts.col_app_fonn,
                              ),
                              onTap: () {
                                _pickDocument();
                              },
                              title: new Text("Document",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ))),
                          Container(
                              height: 1.0, width: 1000.0, color: Colors.grey[200]),
                          new ListTile(
                              dense: true,
                              leading: new Image.asset(
                                "images/location.png",
                                width: 28.0,
                                height: 28.0,
                                color: Fonts.col_app_fonn,
                              ),
                              onTap: () {
                                getLocation();
                              },
                              title: new Text("Position",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ))),
                        ])))));
  }

  /*
  map
   */

  var currentLocation = <String, double>{};
  var location = new Location();

  getLocation() async {
    Navigator.of(context).pop(true);
    try {
      currentLocation = await Location_service.getLocation();
      print(currentLocation);

      lat = currentLocation["latitude"];
      lng = currentLocation["longitude"];

      _sendMessage(text: "text", lat: lat, lng: lng);
    } on PlatformException {
      print("noooooo");

      setState(() {});
      // showInSnackBar("Veuillez activer votre GPS");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets() {
      return images
          .map((String file) => new Stack(children: <Widget>[
        new Container(
            padding: new EdgeInsets.all(4.0),
            width: 60.0,
            height: 60.0,
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
        // height: 100.0,
          child: new Row(
            //scrollDirection: Axis.horizontal,
              children: widgets()));
    }

    Future<bool> deleteConversation() async {
      return await showDialog<bool>(
        context: context,
        builder: (_) => new AlertDialog(
          title: const Text(''),
          content: new Text(
            "Supprimer",
            style: TextStyle(color: Fonts.col_app_fonn),
          ),
          actions: <Widget>[
            new FlatButton(
                child: new Text("Ok"),
                onPressed: () {
                  FirebaseDatabase.instance
                      .reference()
                      .child("message_medz")
                      .child(getKey())
                      .remove();
                  FirebaseDatabase.instance
                      .reference()
                      .child("lastm_medz")
                      .child(getKey1())
                      .remove();
                  FirebaseDatabase.instance
                      .reference()
                      .child("room_medz")
                      .child(getKey())
                      .update({
                    "lastmessage": "Aucun message",
                  });

                  Navigator.of(context).pop(false);
                }),
            new FlatButton(
              child: new Text("Annuler"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        ),
      ) ??
          false;
    }

    Future toggleblock(isBlock, myid, idOther) async {
      if (isBlock == true) {
        //blockFunctions.block(idOther, context);
        return false;
      } else {
        //blockFunctions.block(idOther, context);
        return true;
      }
    }

    _onSendRecord() async {
      stopRecorder();
      File recordFile = File(_path);
      /* bool isExist = await recordFile.exists();

      if (isExist) {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        StorageReference reference =
            FirebaseStorage.instance.ref().child(fileName);

        StorageUploadTask uploadTask = reference.putFile(recordFile);
        StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;

        storageTaskSnapshot.ref.getDownloadURL().then((recordUrl) async {
          print('download record File: $recordUrl');
          /*  _sendMessage(
              audio: recordUrl,
              text: "",
              recorderTime: _recorderTxt,
              type: "audio");*/

          await _sendMessage(audio: recordUrl.toString(), text: "text");

          setState(() {
            print(recordUrl.toString());
            audio_url = recordUrl.toString();

            error = "";
            uploading = false;
            lo = true;
          });
*/
      await save_audio(recordFile);
    }

    void showMenuSelection(String value) {
      if (value == "Delete") {
        deleteConversation();
      }
    }

    Widget _buildMsgBtn({Function onP}) {
      return Material(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 0.0),
          child: new IconButton(
            icon: new Image.asset(
              "images/send.png",
              width: 20.0,
              height: 20.0,
            ),
            color: Theme.of(context).accentColor,
            onPressed: () {
              onP();
            },
          ),
        ),
        color: Colors.white,
      );
    }

    Widget menusubscribe = new
  Container(
      decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.only(topRight: Radius.circular(39.r))
      ),
      child:   PopupMenuButton<String>(
          onSelected: showMenuSelection,
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            new PopupMenuItem<String>(
                value: "Delete",

                child: new ListTile(
                    title: new Text("Supprimer la conversation")))
          ]),
    );

    Widget _buildRecordingView() {
      return Container(
        padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(8).toDouble(),
          right: ScreenUtil().setWidth(8).toDouble(),
        ),
        height: 80,
        width: double.infinity,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.close,
                  color: Fonts.col_app_fonn,
                ),
                onPressed: _onRecordCancel),
            Container(
              width: 16,
            ),
            Container(
              child: Text(
                this._recorderTxt,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Fonts.col_app_fon,
                ),
              ),
            ),
            Expanded(
              child: Container(),
            ),
            _buildMsgBtn(onP: _onSendRecord)
          ],
        ),
      );
    }

    return WillPopScope(
        onWillPop: () {
          if (widget.goto) {
            print('ljljljl');
            Navigator.pushReplacement(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) => new BottomNavigation(
                        widget.auth,
                        null,
                        widget.user,
                        widget.list_partners,
                        false,
                        widget.analytics,
                        animate: true)));
          } else
            Navigator.of(context).pop(true);
        },
        child: new Scaffold(
          backgroundColor: Colors.white,
            appBar: new AppBar(
              // toolbarHeight: 50,

    // shape: RoundedRectangleBorder(
    // borderRadius: BorderRadius.only(
    //   topRight: Radius.circular(100.r)
    // )
    // ),
                elevation: 0.0,
                iconTheme: new IconThemeData(color: Colors.grey[800]),
              leading: Container(
                color: Colors.white,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Fonts.col_app,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
                centerTitle: true,

                // titleTextStyle: TextStyle(color: Colors.white),
                title:
                Container(
                  height: 80.h,
                  padding: EdgeInsets.all(0),
                  color: Colors.white,
                  child: new UserWidget(
                      msgidOther,
                      user_o,
                      widget.user,
                      widget.reload,
                      widget.list_partners,
                      widget.analytics,
                  ),
                ),
                backgroundColor: Fonts.col_app_green,
                titleSpacing: 0,
                actions: [menusubscribe]
            ),
            body: new Container(
                child: new Stack(children: <Widget>[
                  //La list est ici
                  /*  new ListView(children: <Widget>[
              ]),*/
                  new Container(
                    padding: new EdgeInsets.only(bottom: 76.0),
                    //color: Fonts.backcolor,
                    child: new FirebaseAnimatedList(
                      // defaultChild: new Center(child: new Text("..."),),
                      padding: new EdgeInsets.only(
                          top: 16.0, bottom: 16.0, left: 0.0, right: 0.0),
                      query: gMessagesDbRef,
                      sort: (a, b) =>
                          b.value['timestamp'].compareTo(a.value['timestamp']),
                      reverse: true,
                      itemBuilder: (_, DataSnapshot snap,
                          Animation<double> animation, int a) {
                        /*  FirebaseDatabase.instance
                            .reference()
                            .child("lastm_medz")
                            .child(getKey1())
                            .update({
                          "vu_" + widget.myid: "0",
                          // "id_last": widget.myid
                        });

                        FirebaseDatabase.instance
                            .reference()
                            .child("lastm_medz")
                            .child(getKey1())
                            .once()
                            .then((val) {
                          try {
                            setState(() {
                              idLast = val.value["id_last"];
                            });
                          } catch (e) {}
                        });*/

                        return new ChatMessage(
                          msg1: msgMyId,
                          msg2: msgidOther,
                          snapshot: snap,
                          animation: animation,
                        );
                      },
                      duration: new Duration(milliseconds: 1000),
                    ),
                  ),











                  Positioned(
                    bottom: 16.0,
                    left: 0,
                    right: 0,
                    child: _isRecording == true
                        ? SizedBox()
                        : Column(children: [
                      uploading
                          ? new RefreshProgressIndicator()
                          : Container(),
                      uploading1
                          ? new CircularPercentIndicator(
                        radius: 60.0,
                        // animation: true,
                        lineWidth: 5.0,
                        percent: double.parse(progress_res == ""
                            ? "0"
                            : progress_res
                            .split("%")[0]
                            .toString()) /
                            100,
                        center: new Text(progress_res.toString()),
                        progressColor: Fonts.col_app_fonn,
                      )
                          : Container(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 2.0),
                        decoration: BoxDecoration(
                            // color: Fonts.col_cl.withOpacity(0.6),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey[50],
                                  offset: Offset(0, 0),
                                  blurRadius: 6.0,
                                  spreadRadius: 4.0)
                            ]),
                        child: Row(
                          children: [
                            ///ButtonIcon(icon: Icons.image),
                            ///  SizedBox(width: 10.0),
                            /// ButtonIcon(icon: Icons.mic),
                            Container(
                              width: 8.0.w,
                            ),
                            // SizedBox(width: 10.0.w),

                            Expanded(
                              child: _isRecording == true
                                  ? Container()

                                  :
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 3.h),
                                decoration: BoxDecoration(
                                  color: Color(0xffEDEDED),
                                  // color: background,
                                  // boxShadow: softShadowsInvert,
                                    borderRadius:
                                    BorderRadius.circular(30.0.r)),
                                width: MediaQuery.of(context).size.width * 0.69.w,
                                child: Row(
                                  children: [
                                    Container(
                                        width: MediaQuery.of(context).size.width * 0.57.w,

                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.0.h),
                                        decoration: BoxDecoration(
                                          // color: Colors.red,
                                          // color: background,
                                          // boxShadow: softShadowsInvert,
                                            borderRadius:
                                            BorderRadius.circular(30.0)),
                                        child: TextField(
                                          controller: _textController,
                                          maxLines: ((_textController
                                              .text.length /
                                              25)
                                              .round() <
                                              6)
                                              ? ((_textController.text.length /
                                              25)
                                              .round() +
                                              1)
                                              : 6,
                                          keyboardType: TextInputType.multiline,
                                          onSubmitted:
                                          _isComposing ? null : null,
                                          decoration:
                                          new InputDecoration.collapsed(
                                              hintText: "Envoyer",
                                              hintStyle: new TextStyle(
                                                  fontSize: 17.0,
                                                  color: Colors.grey)),
                                          onChanged: (String text) {
                                            try {
                                              setState(() => _isComposing =
                                                  text.length > 0);
                                            } catch (e) {}
                                          },

                                          // See GitHub Issue https://github.com/flutter/flutter/issues/10006
                                        ) /*TextField(
                                                /*  expands: true,
                                    maxLines: null,
                                    minLines: null,*/

                                                onChanged: (String text) {
                                                  try {
                                                    setState(() => _isComposing =
                                                        text.length > 0);
                                                  } catch (e) {}
                                                },

                                                // See GitHub Issue https://github.com/flutter/flutter/issues/10006
                                                decoration: new InputDecoration
                                                    .collapsed(
                                                    hintText: _isRecording
                                                        ? this._recorderTxt
                                                        : "Ecrire votre texte ici",
                                                    hintStyle: new TextStyle(
                                                        fontSize: 17.0,
                                                        color: Colors.grey)),
                                                keyboardType: TextInputType.multiline,
                                                maxLines:  ((_textController.text.length / 25)
                                                    .round() <
                                                    6)
                                                    ? null
                                                    : 6,
                                                style: TextStyle(color: Colors.black, fontSize: 16.0),*/
                                      /* decoration: InputDecoration(
                                                    hintText: 'Aa',
                                                    hintStyle:
                                                    TextStyle(color: Colors.black.withOpacity(.6)),
                                                    filled: false,
                                                    border: InputBorder.none,
                                                    isDense: true,
                                                    contentPadding: EdgeInsets.symmetric(
                                                        horizontal: 6.0, vertical: 8.0))*/

                                    ),



                                    SizedBox(width: 10.0.w),

                                    GestureDetector(
                                      onTap: _isComposing
                                          ? () => _handleMessageSubmit(
                                          _textController.text)
                                          : null,
                                      child: CircleAvatar(
                                          radius: _isRecording ? 28.0.r : 17.0.r,
                                          backgroundColor: Fonts.col_app_green,
                                          child: new Image.asset(
                                            "images/send.png",
                                            width: 23.0.w,
                                            height: 22.0.h,
                                            color: Colors.white,
                                            //  width: _isRecording ? 40.0 : 22.0,
                                            //  height: _isRecording ? 40.0 : 22.0,
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(width: 12.0.w),


                            CircleAvatar(
                                backgroundColor: Fonts.col_app_green,
                                radius: 17.0.r,
                                child: new InkWell(
                                  onTap: () {
                                    open_bottomsheet();
                                  },
                                  child: new Image.asset(
                                    "images/link2.png",
                                    width: 19.0.w,
                                    height: 19.0.h,
                                    color: Colors.white,
                                  ),
                                )),
                            Container(
                              width: 2.0.w,
                            ),
                            GestureDetector(
                              onTap: _onRecorderPreesed,
                              /* onPanStart: (a) {
                                startRecorder();
                              },
                              onPanEnd: (b) {
                                stopRecorder();
                              },*/
                              child: CircleAvatar(
                                  radius: _isRecording ? 28.0.r : 17.0.r,
                                  backgroundColor: Fonts.col_app_green,
                                  child: new Image.asset(
                                    "images/microphone2.png",
                                    width: 23.0.w,
                                    height: 22.0.h,
                                    color: Colors.white,
                                    //  width: _isRecording ? 40.0 : 22.0,
                                    //  height: _isRecording ? 40.0 : 22.0,
                                  )),
                            ),



                            // new Container(
                            //   color:Fonts.col_app_green ,
                            //   child: new IconButton(
                            //     icon: new Image.asset(
                            //       "images/send.png",
                            //       width: 21.0.w,
                            //       height: 20.0.h,
                            //       color: Colors.white,
                            //     ),
                            //     color: Theme.of(context).accentColor,
                            //     onPressed: _isComposing
                            //         ? () => _handleMessageSubmit(
                            //         _textController.text)
                            //         : null,
                            //   ),
                            // )
                          ],
                        ),
                      )
                    ]),
                  ),

                  Positioned(
                      bottom: 16.h,
                      left: 0.w,
                      right: 0.w,
                      child: _isRecording ? _buildRecordingView() : SizedBox())
                ]))));
  }

  _sendMessage(
      {String text,
        List<String> imageUrl,
        String audio,
        String file,
        docname,
        lat,
        lng,
        address}) async {
    try {
      setState(() {
        show_textfield = true;
      });
    } catch (e) {}

    var lastmsg = "";

    if (imageUrl.toString() != "null") {
      lastmsg = "image";
      text = "";
    }
    if (audio != null) {
      lastmsg = "audio";
      text = "";
    }
    if (file != null) {
      lastmsg = "fichier";
    }
    if (lat.toString() != "null") {
      lastmsg = "location";
      text = "";
    }
    if (text != null) {
      lastmsg = text;
    }

    print("----------------------------------------------");
    print(imageUrl);

    gMessagesDbRef.push().set({
      'timestamp': ServerValue.timestamp,
      'messageText': text,
      'idUser': msgMyId.idUser,
      'imageUrl': imageUrl,
      'audio': audio,
      'file': file,
      'docname': docname,
      "lat": lat,
      "lng": lng,
      "address": address
    });

    gMessagesDbRef_inv.push().set({
      'timestamp': ServerValue.timestamp,
      'messageText': text,
      'idUser': msgMyId.idUser,
      'imageUrl': imageUrl,
      "audio": audio,
      "file": file,
      'docname': docname,
      "lat": lat,
      "lng": lng,
      "address": address
    });

    gMessagesDbRef2.set({
      "token": user_o.token,
      "name": msgMyId.name,
      "me": true,
      widget.myid: true,
      "lastmessage": lastmsg,
      "key": getKey(),
      "timestamp": ServerValue.timestamp /*new DateTime.now().toString()*/,
    });

    FirebaseDatabase.instance
        .reference()
        .child("room_medz")
        .child(getKey1())
        .set({
      "me": false,
      widget.idOther: true,
      "lastmessage": text,
      "key": getKey1(),
      "timestamp": ServerValue.timestamp /*new DateTime.now().toString()*/,
    });

    var gMessagesDbRe =
    FirebaseDatabase.instance.reference().child("notif_new_msg");
    gMessagesDbRe.update({user_o.auth_id: true});

    gMessagesDbRef3.set({
      "vu_" + widget.myid: "0",
      "vu_" + widget.idOther: "1",
      "id_last": widget.myid.toString()
    });

    FirebaseDatabase.instance
        .reference()
        .child("lastm_medz")
        .child(getKey1())
        .set({
      "vu_" + widget.myid: "0",
      "vu_" + widget.idOther: "1",
      "id_last": widget.myid.toString()
    });

    if (widget.reload.toString() != "null") {
      widget.reload();
    }
  }

  _handleMessageSubmit(String text) async {
    _textController.clear();
    try {
      setState(() => _isComposing = false);
    } catch (e) {}

    _sendMessage(text: text);
  }

/*
 '$widget.myid': true,
 '$widget.idOther':true,
 */

}

class ButtonIcon extends StatelessWidget {
  final IconData icon;
  final double borderRadius;
  final Function action;

  const ButtonIcon({Key key, this.icon, this.borderRadius = 8.0, this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Container(
          padding: EdgeInsets.all(6.0),
          decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(borderRadius)),
          child: Icon(
            icon,
            size: 18.0,
            color: Theme.of(context).primaryColor,
          )),
    );
  }
}
