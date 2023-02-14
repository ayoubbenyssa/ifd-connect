import 'package:flutter/material.dart';
import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/services/validators.dart';
import 'package:ifdconnect/widgets/custom_widgets/app_textfield.dart';
import 'package:ifdconnect/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


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


    Widget bio =
    TextFieldWidget(
      "Présentez vous en quelques mots",
      _biofocus,
      _bioctrl,
      TextInputType.text,
      null,
      suffixIcon: "",
    );
    // Widgets.textfield0_dec(
    //   "Présentez vous en quelques mots",
    //   _biofocus,
    //   widget.user.bio,
    //   _bioctrl,
    //   TextInputType.text,
    //
    // );



    return  new WillPopScope(onWillPop: (){
      Navigator.pop(context,widget.user);
    },child:Scaffold(
        appBar: new AppBar(
          elevation: 0,
          leading: Container(),
          title: Container(
            padding: const EdgeInsets.only(top: 10,bottom:10),
            color: Fonts.col_app,
            child: Row(
              children: [
                Container(width: 7.w,),
                Padding(
                  padding: const EdgeInsets.only(top: 10,bottom:10),
                  child: Text(
                    "Profil",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w100,
                        fontSize: 18.0.sp),
                  ),
                ),

              ],

            ),
          ),          actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.check,color: Colors.white,),
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
        body:
        Container(
            color: Fonts.col_app,
            child: ClipRRect(
                borderRadius: BorderRadius.only(topRight : Radius.circular(39.r)),

                child: Container(
                    color: Colors.white,
        child :
        Center(
          child: new ListView(
            padding: new EdgeInsets.all(16.0),
            children: <Widget>[
              new Container(
                height: 16.0.h,
              ),
             bio
            ],
          ),
        )
    )))
    )
    );
  }
}
