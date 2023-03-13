import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ifdconnect/shop/data.dart';

class ShimmerWidgets {


/*
 new Card(
                      child: Container(
                    margin: new EdgeInsets.only(bottom: 7.0, top: 8.0),
                    color: Colors.grey[100],
                    height: 130.0,
                    width: 120.0,
                  ))
 */

  static shimmerlist() => new SliverGrid.count(
  crossAxisCount: 2,
  childAspectRatio: 0.90,
  mainAxisSpacing: 1.0,
  crossAxisSpacing: 1.0,

  children:Data.products.map((p)=> new Card(
      child: Container(
        color: Colors.grey[200],
        height: 130.0,
        width: 120.0,
      ))).toList())
    ;



  static shimmercategorycard() => Container(
    padding: new EdgeInsets.all(16.0),
      height: 130.0,
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
        },
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 6,
            itemBuilder: (context, index) => Shimmer.fromColors(
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[100],
                  child: new Card(
                      child: Container(
                    margin: new EdgeInsets.only(bottom: 7.0, top: 8.0),
                    color: Colors.grey[100],
                    height: 130.0,
                    width: 120.0,
                  )),
                )
            // CategoryCard(Data.categories[index], index),
            ),
      ));



  static shimmercategoryText() => Container(
      padding: new EdgeInsets.all(16.0),
      height: 10.0,
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
        },
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) => Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              child: new Card(
                  child: Container(
                    margin: new EdgeInsets.only(bottom: 7.0, top: 8.0),
                    color: Colors.grey[100],
                    height: 130.0,
                    width: 120.0,
                  )),
            )
          // CategoryCard(Data.categories[index], index),
        ),
      ));

}
