import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:ifdconnect/func/users_info.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/widgets/widgets.dart';

class Conditions extends StatefulWidget {
  @override
  _Potique_ConditionsState createState() => _Potique_ConditionsState();
}

class _Potique_ConditionsState extends State<Conditions> {
  Usernfo user_inf = new Usernfo();
  String text = "";

  get_politiques() async {
    var a = await user_inf.get_conditions();
    setState(() {
      text = a["text"];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_politiques();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          "Conditions générales d'utilisation",
          style: TextStyle(fontSize: 13.0),
        ),
      ),
      body: new SingleChildScrollView(
        child: new Container(
            padding: EdgeInsets.all(12.0),
            child: text == ""
                ? Padding(
                padding: EdgeInsets.all(16),child:  Widgets.load())
                : HtmlWidget(
                    text.toString().replaceAll(RegExp(r'(\\n)+'), ''),

                  )),
      ),
    );
  }
}
