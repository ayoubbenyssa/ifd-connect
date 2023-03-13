import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';


class NoGps extends StatefulWidget {
  NoGps(this.getLoc, this.getl);

  var getLoc;
  bool getl;

  @override
  _NoGpsState createState() => _NoGpsState();
}

class _NoGpsState extends State<NoGps> {


  ///jihad
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  //  Permission.requestSinglePermission(PermissionName.Location);

  }


  var currentLocation = <String, double>{};
  Map<String, double> _startLocation;
  Map<String, double> _currentLocation;
  Location _location = new Location();
  Map<String, double> location;



  @override
  Widget build(BuildContext context) {
    return  new Container(
        decoration: new BoxDecoration(
        color: Colors.grey[300],
        image: new DecorationImage(
        fit: BoxFit.cover,
        colorFilter: new ColorFilter.mode(
        Colors.grey.withOpacity(0.6), BlendMode.dstATop),
    image: new AssetImage("images/bac.jpg"))),
    child:Center(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
                child: new GestureDetector(
                    onTap: () {},
                    child: new Image.asset(
                      "images/logo.png",
                      width: 120.0,
                      height: 120.0,
                    ))),
            Container(
                padding: EdgeInsets.only(left: 12, right: 12),
                width: MediaQuery.of(context).size.width * 0.95,
                child: new Text(
                  "Pour savoir qui vous croisez, nous avons besoin de savoir où vous êtes!! "
                      "Autorisez Ahlan à accéder à votre position pour profiter de la carte dynamique "
                      "et repérer les professionnels à proximité!",
                  textAlign: TextAlign.justify,
                )),
            new Container(
              height: 24.0,
            ),
            new Image.asset(
              "images/no-gps.png",
              color: Colors.blue[700],
              height: 110.0,
              width: 110.0,
            ),
            new Container(
              height: 24.0,
            ),
            Container(
                width: MediaQuery.of(context).size.width * 0.95,
                child: new RaisedButton(
                    color: Colors.grey[50],
                    elevation: 4.0,
                    onPressed: () {
                      print("kokjokp");
                      ///jihad
                     // Permission.requestSinglePermission(PermissionName.Location);

                      //Permission.openSettings();
                    },
                    child: new Text(
                      "Vérifier les permissions",
                      style: TextStyle(color: Colors.blue[600]),
                    ))),

            Container(
                width: MediaQuery.of(context).size.width * 0.95,
                child: new RaisedButton(
                    color: Colors.grey[50],
                    elevation: 4.0,
                    onPressed: () async{
                     //await Permission.requestSinglePermission(PermissionName.Location);

                      widget.getLoc();
                    },
                    child: new Text(
                      "Actualiser",
                      style: TextStyle(color: Colors.blue[600]),
                    ))),

          ],
        )));
  }
}
