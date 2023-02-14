import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:ifdconnect/cards/shop_card.dart';
import 'package:ifdconnect/models/shop.dart';
import 'package:ifdconnect/widgets/common.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopItem extends StatefulWidget {
  ShopItem(this.shop,this.lat,this.lng);

  Shop shop;
  var lat,lng;

  @override
  _ShopItemState createState() => _ShopItemState();
}

class _ShopItemState extends State<ShopItem> {

  Distance distance = new Distance();


  //For ùaking a call
  Future _launched;

  Future _launch(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }



  final imageOverlayGradient = new DecoratedBox(
    decoration: new BoxDecoration(
      gradient: new LinearGradient(
        begin: FractionalOffset.bottomCenter,
        end: FractionalOffset.topCenter,
        colors: [
          const Color(0xFF000000),
          // Colors.black87,
          const Color(0x00000000),
          const Color(0x00000000),
        ],
      ),
    ),
  );

  image() => InkWell(
      onTap: (){
        var lat = widget.shop.latLng.toString().split(";")[0];
        var lng = widget.shop.latLng.toString().split(";")[1];
        _launched = _launch(
            'https://www.google.com/maps/@$lat,$lng,16z');
      },
      child: new FadingImage.asset(
             "images/route.png",
    width: 40,height: 40,
            ));

  var style = new TextStyle(
      fontWeight: FontWeight.w900, color: Colors.black, fontSize: 18.0);

  _buildTextContainer(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final categoryText =
    Container(
      width: MediaQuery.of(context).size.width*0.5,
        child:  new Text(
      widget.shop.name+" ("+(distance(
          new LatLng(double.parse(widget.shop.latLng.toString().split(";")[0]), double.parse(widget.shop.latLng.toString().split(";")[1])),
          new LatLng(widget.lat, widget.lng))
          .toDouble() /
          1000).toString()+" Km)",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,

      style: textTheme.caption.copyWith(
        color: Colors.black,
        fontWeight: FontWeight.w700,
        fontSize: 11.0,

      ),
      textAlign: TextAlign.start,
    ));

    final desc = new Text(
      widget.shop.description.toString(),
      style: textTheme.caption.copyWith(
        color: Colors.grey,
        fontWeight: FontWeight.w700,
        fontSize: 13.0,
        letterSpacing: 2.0,
      ),
      textAlign: TextAlign.center,
    );

    return  new Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          categoryText,
          // desc,
        ]

    );
  }

  @override
  Widget build(BuildContext context) {


    return new GestureDetector(
        onTap: () {
          Navigator.push(context,
              new MaterialPageRoute(builder: (BuildContext context) {
            return new ShopCardDetails(widget.shop);
          }));
        },
        child: new Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 4.0,
              horizontal: 4.0,
            ),
            child: new Material(
              elevation: 4.0,
              borderRadius: new BorderRadius.circular(8.0),
              child:  Row(
                  
                  children:[
                    Container(
                      width:100,
                      height: 100,
                      padding: EdgeInsets.all(8.0),
                      child:   image(),
                    ),
                    
                    /*new Size.fromHeight(140.0),
                child: new Stack(
                  fit: StackFit.expand,
                  children: [*/

                    Container(width: 4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                      _buildTextContainer(context),
                      Container(height: 4,),

                     Container(
                         width: MediaQuery.of(context).size.width*0.42,
                         child: new Text(
                        widget.shop.address,
                           maxLines: 2,
                           overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w400,
                          fontSize: 13.0,

                        ),
                        textAlign: TextAlign.start,
                      )),



                    ],),


                 Expanded(child: Container()),


                    IconButton(
                           iconSize: 42,
                     icon:  CircleAvatar(
                       radius: 28,
                         backgroundColor: Colors.green[500],
                       child: 
                       Padding(
                           padding: EdgeInsets.all(8),
                           child:Image.asset("images/info.png",color: Colors.white,width: 20,height: 20,))),
                   onPressed: (){
                     Navigator.push(context, new MaterialPageRoute(
                         builder: (BuildContext context) {
                           return new ShopCardDetails(widget.shop);
                         }));
                   },)


                    ,Container(width: 8)

                  ],
                ),
              ),
            ));
    ;
  }
}
