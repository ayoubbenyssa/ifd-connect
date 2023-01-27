import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/block.dart';
import 'package:ifdconnect/services/location_services.dart';
import 'package:ifdconnect/user/details_user.dart';

class UserSearchWidget extends StatefulWidget {
  UserSearchWidget(this.user_me, this.user,this.list,this.analytics);

  User user;
  User user_me;
  var list;
  var analytics;


  @override
  _UserSearchWidgetState createState() => _UserSearchWidgetState();
}

class _UserSearchWidgetState extends State<UserSearchWidget> {
  block_user() async {
    await Block.insert_block(widget.user_me.auth_id, widget.user.auth_id,
        widget.user_me, widget.user.id);
    await Block.insert_block(widget.user.auth_id, widget.user_me.auth_id,
        widget.user.id, widget.user_me.id);
  }


  Distance distance = new Distance();
  var currentLocation = <String, double>{};
  var location = new Location();
  var lat, lng;

  getLOcation() async {
    currentLocation = await Location_service.getLocation();

    lat = currentLocation["latitude"];
    lng = currentLocation["longitude"];

    widget.user.dis = distance
        .as(
        LengthUnit.Kilometer,
        new LatLng(double.parse(widget.user.lat),
            double.parse(widget.user.lng)),
        new LatLng(lat, lng))
        .toString() +
        " Km(s)";
  }



  @override
  Widget build(BuildContext context) {
    return new InkWell(

      child: new Column(children: <Widget>[
        new Container(
          padding: new EdgeInsets.all(8.0),
          height: 80.0,
          child: new Material(
            elevation: 1.0,
            borderRadius: new BorderRadius.circular(8.0),
            child:  new Row(
            children: <Widget>[

              Container(width: 8,),
              new ClipOval(

                  child: new Container(
                   // padding: EdgeInsets.all(8),
                      width: 50.0,
                      height: 50.0,
                      child: new Image.network(widget.user.image,
                          fit: BoxFit.cover))),
              new Container(width: 12.0),
              new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                 // crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[

                    new Container(
                        width: MediaQuery.of(context).size.width*0.7,

                        child: new Text(


                                   widget.user.firstname +
                                      "  " +
                                      widget.user.fullname,

                                  style: new TextStyle(

                                      fontWeight: FontWeight.bold,
                                      fontSize: 13.0

                        ))),
                    /*Container(
                        width: MediaQuery.of(context).size.width*0.7,
                        child: new Text(
                            widget.user.role.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: new TextStyle(color: Colors.grey[800])))*/
                  ]),
              new Expanded(child: new Container()),
            /*  IconButton(
                iconSize: 42,
                icon:  CircleAvatar(
                    radius: 28,
                   backgroundColor: Colors.white,
                    child:
                    Padding(
                        padding: EdgeInsets.all(8),
                        child:Image.asset("images/use.png",color: Colors.blue,width: 20,height: 20,))),
                onPressed: () async{
                  await getLOcation();
                  Navigator.push(context,
                      new MaterialPageRoute(builder: (BuildContext context) {
                        return new Details_user(
                            widget.user, widget.user_me, block_user(), true,widget.list, widget.analytics);
                      }));

                },)*/
            /*  new RaisedButton(
                  color: Colors.blue,
                  child: new Text(
                    "Voir profil",
                    style: new TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {

                    await getLOcation();
                    Navigator.push(context,
                        new MaterialPageRoute(builder: (BuildContext context) {
                      return new Details_user(
                          widget.user, widget.user_me, block_user(), true,widget.list, widget.analytics);
                    }));
                  })*/
            ],
          )),
        ),
       /* new Container(
          height: 1.0,
          width: 1000.0,
          color: Colors.grey[300],
        )*/
      ]),
      onTap: () async{
        await getLOcation();

        Navigator.push(context,
            new MaterialPageRoute(builder: (BuildContext context) {
              return new Details_user(
                  widget.user, widget.user_me, block_user(), true,widget.list, widget.analytics);
            }));
        /* Navigator.push(context,
            new MaterialPageRoute(builder: (BuildContext context) {
              return new Invite_view(posts[index].auth_id, posts[index].notif_id,id,widget.user_me,go,delete_not);
            }));*/
      },
    );
  }
}
