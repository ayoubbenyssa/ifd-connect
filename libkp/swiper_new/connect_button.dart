import 'package:flutter/material.dart';
import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/services/Fonts.dart';




class ConnectButton extends StatefulWidget {
  ConnectButton(this.show_connect,this.id);
  var show_connect;
  var id;



  @override
  _ConnectButtonState createState() => _ConnectButtonState();
}

class _ConnectButtonState extends State<ConnectButton> {

  ParseServer parse_s = new ParseServer();



  connectedorno() async {
    var id = widget.id;
    var response = await parse_s.getparse('connect?where={"receive_req":"$id"}');

  }

  @override
  void initState() {
    super.initState();

    connectedorno();

  }





  @override
  Widget build(BuildContext context) {

    const Color loginGradientStart = Colors.cyan;
    const Color loginGradientEnd = Fonts.col_app;



    Widget lgn = Container(
      width: 146.0,
      height: 42.0,
      margin: new EdgeInsets.only(bottom: 4.0),

      child: MaterialButton(
        color: Fonts.col_app_green,
          highlightColor: Colors.transparent,
          splashColor: loginGradientEnd,
          //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 4.0),
            child: Text(
              "SE CONNECTER",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 14.0),
            ),
          ),
          onPressed: () {
            widget.show_connect();
          }),
    );


    return lgn;
  }
}
