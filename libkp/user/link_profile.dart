import 'package:flutter/material.dart';
import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/validators.dart';
import 'package:ifdconnect/widgets/widgets.dart';

class Link_profile extends StatefulWidget {
  Link_profile(this.user,this.type);

  User user;
  String type="";


  @override
  _InfoUser1State createState() => _InfoUser1State();
}

class _InfoUser1State extends State<Link_profile> {
  FocusNode _linkfocus = new FocusNode();
  final _linkctrl = new TextEditingController();
  var ic ;

  ParseServer parse_s = new ParseServer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  if(widget.type == "linkedin"){
    _linkctrl.text = widget.user.linkedin_link;
    ic = "images/linked.png";
  }
  else if(widget.type =="instagram"){
   _linkctrl.text = widget.user.instargram_link;
   ic = "images/instagram.png";
  }
  else {
    _linkctrl.text = widget.user.twitter_link;
    ic = "images/twitter.png";
  }

  }



  @override
  Widget build(BuildContext context) {
    Validators val = new Validators(context: context);


    Widget bio = Widgets.textfield0_dec(
      "Votre profil "+widget.type.toString(),
      _linkfocus,
      widget.user.bio,
      _linkctrl,
      TextInputType.text,

    );

/*
 linkedin_link: document['linkedin_link']== "null"?"":document['linkedin_link'],
      instargram_link: document['instagram_link']== "null"?"":document['instagram_link'],
      twitter_link: document['twitter_link']== "null"?"":document['twitter_link'],

 */

    return  new WillPopScope(onWillPop: (){
      Navigator.pop(context,widget.user);
    },child: Scaffold(
        appBar: new AppBar(
          title: new Text("Profil "+ widget.type.toString()),
          actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.check),
                onPressed: () async {

                  var js;

                  if(widget.type == "linkedin") {
                     widget.user.linkedin_link = _linkctrl.text ;
                    js = {
                      "linkedin_link":widget.user.linkedin_link
                    };
                  }
                  else if(widget.type =="instagram") {
                    widget.user.instargram_link=  _linkctrl.text;
                    js = {
                      "instagram_link":_linkctrl.text
                    };
                  }
                  else {
                    widget.user.twitter_link = _linkctrl.text ;
                    js = {
                      "twitter_link":_linkctrl.text
                    };
                  }



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
              new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                new Image.asset(ic,width: 40.0,height: 40.0,),
                new Container(width: 16.0,),
                new Container(width:260.0,child:bio)
              ],)
            ],
          ),
        )));
  }
}
