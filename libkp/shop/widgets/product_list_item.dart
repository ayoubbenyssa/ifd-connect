import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ifdconnect/models/offers.dart';
import 'package:ifdconnect/shop/models/Product.dart';
import 'package:ifdconnect/shop/pages/product_page.dart';


class ProductListItem extends StatelessWidget {
  final Offers product;

  ProductListItem(this.product);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => null/*Navigator
          .of(context)
          .push(MaterialPageRoute(builder: (ctx) => ProductPage(product))*/,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: product.pic[0],
                width: 100.0,
                height: 100.0,
                fit: BoxFit.cover,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(product.name,style: new TextStyle(fontSize: 9.0),),
                      Text(
                        "\$" + product.initialPrice,
                        style: TextStyle(fontSize: 10.0),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Divider(
            height: 0.0,
          )
        ],
      ),
    );
  }
}
