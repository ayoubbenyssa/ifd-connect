import 'package:flutter/material.dart';
import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/services/validators.dart';
import 'package:ifdconnect/user/myprofile.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ifdconnect/widgets/custom_widgets/app_textfield.dart';
import 'package:ifdconnect/widgets/widgets.dart';

class AddVote extends StatefulWidget {
  AddVote(this.user,{this.type});

  User user;
  var type;


  @override
  _AddVoteState createState() => _AddVoteState();
}

class _AddVoteState extends State<AddVote> {
  // String selectedValue = "";
  ScrollController scrollController = new ScrollController();

  ParseServer parse_s = new ParseServer();
  final _descctrl = new TextEditingController();
  FocusNode _descfocus = new FocusNode();
  FocusNode _qfocus = new FocusNode();

  int active=0;
  bool _autovalidate = false;
  bool uploading = false;
  var im = "";
  var lo = false;
  var error = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  List<TextEditingController> txted = new List<TextEditingController>();
  List<FocusNode> focuss = new List<FocusNode>();

  List<String> ids = new List<String>();

  List<bool> show = new List<bool>();
  Validators val = new Validators();

  bool sho = false;
  bool load = false;

  //FocusNode _focus = new FocusNode();

  int count = 1;
  List lst = [];




  Widget desc() =>
      TextFieldWidget(
        "Votre question",
        _descfocus,
        _descctrl,
        TextInputType.text,
        // widget.user.bio,
        val.validatedesc,
        suffixIcon: "",
      );
  //     Widgets.textfield_des1(
  //     "Votre question",
  // _descfocus,
  // "",
  // _descctrl,
  // TextInputType.text,
  // val.validatedesc
  // );


  // Widget enregistrer = new Container(
  //     height: 40.0,
  //     padding: new EdgeInsets.only(left: 6.0, right: 6.0),
  //     child: new Material(
  //         elevation: 0.0,
  //         shadowColor: Fonts.col_app_fon,
  //         borderRadius: new BorderRadius.circular(22.0.r),
  //         color: Fonts.col_app,
  //
  //         /*decoration: new BoxDecoration(
  //           border: new Border.all(color: const Color(0xffeff2f7), width: 1.5),
  //           borderRadius: new BorderRadius.circular(6.0)),*/
  //         child: new MaterialButton(
  //           // color:  const Color(0xffa3bbf1),
  //             onPressed: () {
  //               confirm();
  //             },
  //             child: new Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: <Widget>[
  //                 // new Container(
  //                 //   width: 8.0,
  //                 // ),
  //                 //  new Container(height: 36.0,color: Colors.white,width: 1.5,),
  //                 // new Container(
  //                 //   width: 8.0,
  //                 // ),
  //                 new Text("", style: style)
  //               ],
  //             ))));



  Widget answers_field(controller, focus, i) => new Padding(
      padding: new EdgeInsets.only(bottom: 16.0),
      child: new Container(
        width: ScreenUtil().setWidth(240.0),
        //name, focus, value, myController, type, validator,
        child: Widgets.textfield("Option  " + i.toString(), _qfocus, "",
            controller, TextInputType.text, val.validatedesc),
      ));

  List<Widget> children() => new List.generate(count, (int i) {
    print(sho);

    txted.add(new TextEditingController());
    focuss.add(new FocusNode());

    show.add(false);
    return show[i] == true
        ? Container()
        : sho == true && i < count - 1
        ? Card(
        elevation: 2.0,
        borderOnForeground: true,
        child: Container(
          // width: MediaQuery.of(context).size.width * 0.98,
            child: Row(children: <Widget>[
              Container(
                  width: MediaQuery.of(context).size.width * 0.55,
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    txted[i].text,
                    style: TextStyle(
                        color: load == true
                            ? Colors.grey[400]
                            : Colors.black),
                  )),
              IconButton(
                  icon: Icon(
                    Icons.close,
                    color:
                    load == true ? Colors.red[100] : Colors.red,
                  ),
                  onPressed: () async {
                    setState(() {
                      load = true;
                    });

                    await parse_s.deleteparse("options/" + ids[i]);
                    setState(() {
                      load = true;
                      show[i] = true;
                      ids.removeAt(i);
                      print(i);
                      //count= count-1;
                    });
                  })
            ])))
        : answers_field(txted[i], focuss[i], i + 1);
  });

  @override
  Widget build(BuildContext context) {

    var ht = ScreenUtil().setHeight(14.0);

    return Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: new Text(
            "Publier un sondage",
            style: TextStyle(fontSize: 15.sp,color: Colors.white),
          ),
          elevation: 0.0,
          // actions: <Widget>[
          //   new InkWell(
          //     onTap: () async {
          //       Widgets.onLoading(context);
          //
          //       for (var i in ids) {
          //         lst.add({
          //           "__type": "Pointer",
          //           "className": "options",
          //           "objectId": i
          //         });
          //       }
          //       var js = {
          //         "title": _descctrl.text,
          //         "type": "sondage",
          //         "active": 1,
          //         "author": {
          //           "__type": "Pointer",
          //           "className": "users",
          //           "objectId": widget.user.id
          //         },
          //         "options": {"__op": "AddUnique", "objects": lst}
          //       };
          //
          //       await parse_s.postparse('offers', js);
          //       Navigator.of(context, rootNavigator: true).pop('dialog');
          //       Navigator.pop(context);
          //     },
          //     child: new Container(
          //       padding: EdgeInsets.all(4.0),
          //       margin: EdgeInsets.all(4.0),
          //       //width: 100.0,
          //       height: 15.0.h,
          //       decoration: new BoxDecoration(
          //         border: new Border.all(color: Colors.white, width: 2.0.w),
          //         borderRadius: new BorderRadius.circular(10.0.r),
          //       ),
          //       child: new Center(
          //         child: new Text(
          //          "Enregistrer",
          //           style: new TextStyle(fontSize: 15.0.sp, color: Colors.white),
          //         ),
          //       ),
          //     ),
          //   ),
          // ],
        ),
        backgroundColor: Colors.white,
        body: new Form(

            key: _formKey,
            autovalidate: _autovalidate,
            //onWillPop: _warnUserAboutInvalidData,

            child: Column(
              children: [
                Container(
                    height: 30.h,
                    color: Fonts.col_app,
                    child: ClipRRect(
                        borderRadius: BorderRadius.only(topRight : Radius.circular(39.r)),

                        child: Container(
                          color: Colors.white,
                        ))),
                Expanded(
                  child: new ListView(
                      controller: scrollController,
                      padding: new EdgeInsets.symmetric(vertical: 6.h,horizontal: 20.w),
                      children: <Widget>[
                        new Container(height: ht),
                        desc(),
                        new Container(height: ht),
                        Row(
                          children: [
                            SizedBox(width: 10.w,),
                            new Text(
                              "Options: ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.sp),
                            ),
                          ],
                        ),
                        new Container(height: ht * 2),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            new Column(children: children()),
                            new Expanded(child: new Container()),
                            new Padding(
                                padding: new EdgeInsets.only(top: 18.0),
                                child: new GestureDetector(
                                    child: new Container(
                                        padding: const EdgeInsets.all(0.5),
                                        // borde width
                                        decoration: new BoxDecoration(
                                          color: Colors.black, // border color
                                          shape: BoxShape.circle,
                                        ),
                                        child: new CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: 16.0.r,
                                          child: new Icon(
                                            Icons.add,
                                            color: Fonts.col_app,
                                            size: 28.0,
                                          ),
                                        )),
                                    onTap: () async {
                                      final FormState form = _formKey.currentState;
                                      if (!form.validate()) {
                                        _autovalidate = true;
                                      } else {
                                        setState(() {
                                          load = true;
                                          sho = true;
                                        });

                                        var js = {
                                          "title": txted[count - 1].text,
                                          "users": [],
                                        };
                                        await parse_s
                                            .postparse('options', js)
                                            .then((val) {
                                          print(val);
                                          ids.add(val["objectId"]);
                                        });

                                        setState(() {
                                          load = false;
                                        });
                                        setState(() {
                                          count = count + 1;
                                        });
                                        scrollController.animateTo(70.0,
                                            curve: Curves.easeOut,
                                            duration: const Duration(seconds: 1));
                                      }
                                      /*setState(() {
                                        count = count + 1;
                                      });*/
                                    })),
                            SizedBox(width: 10.w,)
                          ],
                        ),

                        SizedBox(height: 50.h,),

                        Container(
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
                                    onPressed: () async {
                                      Widgets.onLoading(context);

                                      for (var i in ids) {
                                        lst.add({
                                          "__type": "Pointer",
                                          "className": "options",
                                          "objectId": i
                                        });
                                      }
                                      var js = {
                                        "title": _descctrl.text,
                                        "type": "sondage",
                                        "active": 1,
                                        "author": {
                                          "__type": "Pointer",
                                          "className": "users",
                                          "objectId": widget.user.id
                                        },
                                        "options": {"__op": "AddUnique", "objects": lst}
                                      };

                                      await parse_s.postparse('offers', js);
                                      Navigator.of(context, rootNavigator: true).pop('dialog');
                                      Navigator.pop(context);
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
                                        new Text("Enregistrer", style: TextStyle(
                                            color: const Color(0xffeff2f7),
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600))
                                      ],
                                    )))),

                        // InkWell(
                        //   onTap: () async {
                        //     Widgets.onLoading(context);
                        //
                        //     for (var i in ids) {
                        //       lst.add({
                        //         "__type": "Pointer",
                        //         "className": "options",
                        //         "objectId": i
                        //       });
                        //     }
                        //     var js = {
                        //       "title": _descctrl.text,
                        //       "type": "sondage",
                        //       "active": 1,
                        //       "author": {
                        //         "__type": "Pointer",
                        //         "className": "users",
                        //         "objectId": widget.user.id
                        //       },
                        //       "options": {"__op": "AddUnique", "objects": lst}
                        //     };
                        //
                        //     await parse_s.postparse('offers', js);
                        //     Navigator.of(context, rootNavigator: true).pop('dialog');
                        //     Navigator.pop(context);
                        //   },
                        //   child: new Container(
                        //     padding: EdgeInsets.all(4.0),
                        //     margin: EdgeInsets.all(4.0),
                        //     //width: 100.0,
                        //     height: 15.0.h,
                        //     decoration: new BoxDecoration(
                        //       border: new Border.all(color: Colors.red, width: 2.0.w),
                        //       borderRadius: new BorderRadius.circular(10.0.r),
                        //     ),
                        //     child: new Center(
                        //       child: new Text(
                        //         "Enregistrer",
                        //         style: new TextStyle(fontSize: 15.0.sp, color: Colors.black),
                        //       ),
                        //     ),
                        //   ),
                        // ),

                      ]
                  ),
                ),
              ],
            )));
  }
}
