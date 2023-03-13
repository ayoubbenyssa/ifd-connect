import 'package:flutter/material.dart';
import 'package:ifdconnect/widgets/arc_clipper.dart';
import 'package:ifdconnect/widgets/widgets.dart';

class LoginBackground extends StatelessWidget {
  var grad;

  final showIcon;
  final image;

  LoginBackground(this.grad,{this.showIcon = true, this.image});

  Widget topHalf(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return new Flexible(
      flex: 2,
      child: ClipPath(
        clipper: new ArcClipper(),
        child: Stack(
          children: <Widget>[
           new Container(
                  decoration: new BoxDecoration(
                      gradient: new LinearGradient(
                    colors: grad,
                  )),
                ),
    new Padding(
    padding: new EdgeInsets.only(bottom: 140.0),
    child: showIcon
                ? new Center(
                    child: SizedBox(
                        height: deviceSize.height / 8,
                        width: deviceSize.width / 2,
                        child: Widgets.avatar),
                  )
                : new Container(
                    width: double.infinity,
                    child: image != null
                        ? Image.network(
                            image,
                            fit: BoxFit.cover,
                          )
                        : new Container()))
          ],
        ),
      ),
    );
  }

  final bottomHalf = new Flexible(
    flex: 3,
    child: new Container(),
  );

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[topHalf(context), bottomHalf],
    );
  }
}
