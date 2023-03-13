import 'package:flutter/material.dart';
import 'package:ifdconnect/models/category_shop.dart';
import 'package:ifdconnect/shop/widgets/category_card.dart';


class CategoryCardScroller extends StatelessWidget {
  CategoryCardScroller(this.cat_list,this.ontap,this.category);
  List<CategoryShop> cat_list = new List<CategoryShop>();
  var ontap;
  String category;




  @override
  Widget build(BuildContext context) {


    return Container(
        height: 120.0,
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowGlow();
          },
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: cat_list.length,
            itemBuilder: (context, index) =>
                CategoryCard(cat_list[index], index,ontap,category),
          ),
        ));
  }
}
