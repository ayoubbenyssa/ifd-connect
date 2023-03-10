import 'package:flutter/material.dart';
import 'package:ifdconnect/shop/data.dart';
import 'package:ifdconnect/shop/principal.dart';
import 'package:ifdconnect/shop/pages/wishlist_page.dart';
import 'package:ifdconnect/shop/widgets/shopping_basket_list_item.dart';

class ShoppingBasketPage extends StatefulWidget {
  @override
  ShoppingBasketPageState createState() {
    return new ShoppingBasketPageState();
  }
}

class ShoppingBasketPageState extends State<ShoppingBasketPage> {
  void clearShoppingBasket() {
    setState(() {
     // MyApp.shoppingBasket.itemsAndQuantities.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Shopping Basket",
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () => Navigator
                  .of(context)
                  .push(MaterialPageRoute(builder: (ctx) => WishListPage())),
            ),
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () => clearShoppingBasket(),
            )
          ],
        ),
        body: MyAppShop.shoppingBasket.itemsAndQuantities.isNotEmpty
            ? new Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount:
                      MyAppShop.shoppingBasket.itemsAndQuantities.keys.length,
                      itemBuilder: (ctx, index) => ShoppingBasketListItem(
                          Data.products[MyAppShop
                              .shoppingBasket.itemsAndQuantities.keys
                              .elementAt(index)],
                          () => setState(() {})),
                    ),
                  ),
                  FlatButton(
                    onPressed: () =>
                        print("Pressed: " + "ShoppingBasketPageState"),
                    child: Center(
                      child: Text(
                        "Pay Now",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 32.0),
                    color: Theme.of(context).primaryColor,
                  )
                ],
              )
            : Container(
                padding: EdgeInsets.all(64.0),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.shopping_basket,
                          color: Colors.black26,
                          size: 32.0,
                        ),
                      ),
                      Text(
                        "You haven't added anything to your basket yet!",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black26),
                      ),
                    ],
                  ),
                ),
              ));
  }
}
