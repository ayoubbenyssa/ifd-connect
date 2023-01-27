import 'package:flutter/material.dart';
import 'package:ifdconnect/cards/details_partner.dart';
import 'package:ifdconnect/cards/shop_card.dart';
import 'package:ifdconnect/home/list_boutiques.dart';
import 'package:ifdconnect/models/partner.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';



class PartnerCard extends StatefulWidget {
  PartnerCard(this.partner,this.lat,this.lng);
  Partner partner;
  var lat;
  var lng;



  @override
  _PartnerCardState createState() => _PartnerCardState();
}

class _PartnerCardState extends State<PartnerCard> {
  @override
  Widget build(BuildContext context) {


    return GestureDetector(child:Card(

     // color: Colors.white,

      child:   new ListView(

          children: <Widget>[ new Container(height: 400.0,child: new Stack(
      alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[

            new Positioned.fill(child:  new Container(
        height: 400.0,
          decoration: new BoxDecoration(
            color: Fonts.col_app_fon,
            image: new DecorationImage(
              fit: BoxFit.cover,
              colorFilter: new ColorFilter.mode(
                  Colors.blueGrey[100].withOpacity(0.9),
                  BlendMode.dstATop),
              image: new NetworkImage(
                widget.partner.logo,

              ),

            ),
          ),
          child: new Column(children: <Widget>[
            new Row(
              children: <Widget>[
                new Expanded(child: new Container()),
                Container()
              ],
            ),

            /* new Hero(
                        tag: widget.user.id,
                        child:*/

           /* new ClipOval(
                child: new Container(
                  width: 120.0,
                  height: 120.0,
                  child: new Image.network(
                    widget.partner.logo,
                    fit: BoxFit.cover,
                  ),
                )),*/
            new Container(
              height: 4.0,
            ),

            new Container(
              height: 4.0,
            ),

            new Container(
              height: 4.0,
            ),
          ]))),
            new Positioned(
              top: 8.0,
              left: 0.0,
              child: new Container(

                padding: new EdgeInsets.only(left: 8.0,top: 8.0,bottom: 8.0,right: 16.0),
                decoration: new BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15.0),
                      topLeft: Radius.circular(0.0),
                      bottomRight: Radius.circular(15.0),
                      bottomLeft: Radius.circular(0.0),
                    ),
                    gradient: new LinearGradient(

                        colors: [
                          const Color(0xFF3366FF),
                          const Color(0xFF00CCFF),
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp
                )),
                  child:new Text("Sponsorisé",style: new TextStyle(color: Colors.white,fontSize: 17.0,fontWeight: FontWeight.bold)))),


            new Positioned(
                bottom: 12,
                right: 12,
                child: Row(children: <Widget>[

                  FloatingActionButton(
                    heroTag: 22,
                    highlightElevation: 7.0,

                    elevation:15.0,
                    //iconSize: 62,

                    child:  CircleAvatar(
                        radius: 44,
                        backgroundColor: Colors.deepOrange[900],
                        child:
                        Padding(
                            padding: EdgeInsets.all(8),
                            child:Image.asset("images/locc.png",color: Colors.white,width: 34,height: 34,))),
                    onPressed: (){

                      Navigator.push(context,   new MaterialPageRoute(
                          builder: (BuildContext context) {
                            return new ShopLIst(widget.partner.partnerKey.toString(),widget.partner.objectId,widget.lat,widget.lng
                            );
                          }));

                    },),

                  Container(width: 12,),

                 FloatingActionButton(
                   heroTag: 11,
                   highlightElevation: 7.0,

                   elevation:15.0,
                    //iconSize: 62,

                    child:  CircleAvatar(
                        radius: 44,
                        backgroundColor: Colors.green[800],
                        child:
                        Padding(
                            padding: EdgeInsets.all(8),
                            child:Image.asset("images/info.png",color: Colors.white,width: 24,height: 24,))),
                    onPressed: (){

                      Navigator.push(context, new MaterialPageRoute(
                          builder: (BuildContext context) {
                            return new PartnerCardDetails(
                                widget.partner);
                          }));

                    },)


                ],))


          ])),
          new Container(
            height: 4.0,
          ),

          new Center(child:  SizedBox(
            // width: 150.0,

            height: 20.0,
            child: ColorizeAnimatedTextKit(
              text: [
                widget.partner.name,
              ],
              textStyle: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold
              ),
              colors: [
                Fonts.col_app_fon,
                Colors.pink[200],
                Fonts.col_app,
                Colors.black,
              ],
            ),
          )),

      new Padding(
        padding: EdgeInsets.all(16.0),
          child: new Text(
              widget.partner.address
              ,
              style: new TextStyle(
                  color: Colors
                  .blueGrey[800],
                  fontSize: 15.0,
                  fontWeight:
                  FontWeight
                      .w500),
              textAlign:
              TextAlign.justify)),


      new Container(
        height: 8.0,
      ),

         /* new Padding(
              padding: EdgeInsets.all(16.0),
              child: new Text(
              widget.partner.description
              ,
              style: new TextStyle(
                  color:Colors
                      .grey[500],
                  fontSize: 15.0,
                  fontWeight:
                  FontWeight
                      .w500),
              textAlign:
              TextAlign.justify)),*/


    ])
    ),
    onTap: (){

      Navigator.push(context, new MaterialPageRoute(
          builder: (BuildContext context) {
            return new PartnerCardDetails(
                widget.partner);
          }));

      /*Navigator.push(context,   new MaterialPageRoute(
          builder: (BuildContext context) {
            return new ShopCardDetails(widget.partner.partnerKey.toString(),widget.partner.objectId
              );
          }));*/



    },);
  }
}
