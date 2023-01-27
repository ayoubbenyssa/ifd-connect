import 'package:flutter/material.dart';
import 'package:ifdconnect/models/category_shop.dart';

class CategoryCard extends StatelessWidget {
  final CategoryShop category;
  final int index;
  final Color color = Color(0xff444444);
  var ontap;
  String category1;

  CategoryCard(this.category, this.index,this.ontap,this.category1);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {

        print(category.name);
        category1 =  category.name;
        ontap();
      }
          /*Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => null)*/,
      child: Container(
        margin: EdgeInsets.only(
            top: 16.0,
            bottom: 16.0,
            left: index == 0 ? 16.0 : 8.0,),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6.0),
            boxShadow: [
              BoxShadow(
                  color: Color(0x1a000000), spreadRadius: 2.0, blurRadius: 9.0)
            ]),
        width: 114.0,
        child: Column(
         // mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Image.network(
                category.picture,
                color: Colors.blue[900],
                width: 30.0,
                height: 30.0,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 12.0, bottom: 12.0, right: 12.0),
              child: Row(
                children: <Widget>[
                  new Container(
                      width: 80.0,
                      padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                      child: Text(
                        category.name,
                        style: TextStyle(color: color, fontSize: 11.0),
                      )),
                  Icon(
                    Icons.arrow_forward,
                    size: 8.0,
                    color: color,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
