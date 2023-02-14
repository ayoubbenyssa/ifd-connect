

import 'package:flutter/material.dart';
import 'package:ifdconnect/cards/favorite_widget.dart';
import 'package:ifdconnect/models/offers.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/shop/models/Product.dart';
import 'package:ifdconnect/shop/pages/product_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ifdconnect/widgets/common.dart';



class ProductCard extends StatefulWidget {
  final Offers product;
  User user;
  ProductCard(this.product,this.user);

  @override
  ProductCardState createState() {
    return new ProductCardState();
  }
}

class ProductCardState extends State<ProductCard> {

  var style = new TextStyle(color: Colors.white, fontSize: 10.5);
  var style1 = new TextStyle(color: Colors.yellow[800], fontSize: 10.5);


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, new MaterialPageRoute(
          builder: (BuildContext context) => ProductPage(widget.product,widget.user))),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child:Container(
            padding: new EdgeInsets.only(left: 4.0,right: 4.0,bottom: 4.0),
            child: Stack(
          alignment: Alignment.bottomCenter,
          overflow: Overflow.clip,
          children: <Widget>[

            Hero(
              tag: "product_${widget.product.objectId.toString()}",
              child: FadingImage.network(
               widget.product.pic[0],
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
            ),
            /*new Positioned(
                right: 8.0,
                top: 4.0,
                child: SavefavButton(widget.product,widget.user)),*/
            Container(
              height: 54.0,
              color: Colors.black87,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                   new Row(children: <Widget>[
                     Container(
                       width: 100.0,
                       child:
                       Text(
                         widget.product.name,
                         maxLines: 2,

                         style: TextStyle(color: Colors.white, fontSize: 11.0),
                       )
                     ),
                     new Expanded(child: new Container()),
                     SavefavButton(widget.product,widget.user)

                   ],) ,
                    new Expanded(child: new Container()),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[

                        new Text(
                          widget.product.sellingPrice + " DHS",
                          style: TextStyle(color: Colors.blue[300],fontSize: 10.0,fontWeight: FontWeight.w600),
                        ),
                        new Container(
                          width: 4.0,
                        ),
                        new Text(
                          widget.product.initialPrice + " DHS",
                          style: new TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey[400],
                              fontSize: 10.0),
                        ),
                       new Expanded(child: new Container(
                          width: 2.0,
                        )),
                        new Text(
                          widget.product.rate,
                          style: style1,
                        ),
                        new Container(
                          width: 2.0,
                        ),

                      ],
                    )
                    /*Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                            widget.product.initialPrice + "Dhs",
                          style: TextStyle(color: Colors.white, fontSize: 10.0),
                        ),
                       /* Icon(
                          Icons.favorite,
                          color:
                              MyShopApp.wishList.products.contains(widget.product)
                                  ? Colors.redAccent
                                  : Colors.white,
                          size: 16.0,
                        )*/
                      ],
                    )*/
                  ],
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}
