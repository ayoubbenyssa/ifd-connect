import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/models/category_shop.dart';
import 'package:ifdconnect/parc_events_stream/parc_events_stream.dart';
import 'package:ifdconnect/services/sector_services.dart';
import 'package:ifdconnect/shop/models/Product.dart';
import 'package:ifdconnect/shop/models/shopping_basket.dart';
import 'package:ifdconnect/shop/models/wishlist.dart';
import 'package:ifdconnect/shop/widgets/favorite.dart';
import 'package:ifdconnect/shop/widgets/shimmer_widgets.dart';
import 'package:ifdconnect/teeeeest.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAppShop extends StatefulWidget {
  MyAppShop(this.user, this.lat, this.lng, this.list_partner, this.analytics);

  var user;
  var lat;
  var lng;
  List list_partner;
  var analytics;

  static ShoppingBasket shoppingBasket = ShoppingBasket();
  static WishList wishList = WishList();

  @override
  MyAppState createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyAppShop> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  bool _menuShown = false;

  display_slides() async {
    //Restez informés sur  tout ce qui se passe au sein de votre communauté à travers l’actualité et les événements.
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString("shop") != "shop") {
      new Timer(new Duration(seconds: 1), () {
        setState(() {
          _menuShown = true;
        });

        prefs.setString("shop", "shop");
      });
    }
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String searchTerm = "";

  List<Product> shuffleAndReturn(List<Product> products) {
    List<Product> r = products;
    r.shuffle();
    return r;
  }

  List<CategoryShop> cat_list = new List<CategoryShop>();
  bool show = false;

  getCategorieslist() async {
    var list = await SectorsServices.get_list_category();
    if (!this.mounted) return;
    setState(() {
      cat_list = list;
    });
  }

  ParseServer parse_s = new ParseServer();

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    display_slides();
    getCategorieslist();
  }

  String category = "Tous les produits";

  ontap() {
    //category);

    setState(() {
      show = true;
    });
    new Timer(const Duration(seconds: 1), () {
      try {
        setState(() => show = false);
      } catch (e) {
        e.toString();
      }
    });
  }
  onp() {
    setState(() {
      _menuShown = false;
    });
  }


  @override
  Widget build(BuildContext context) {



    Animation opacityAnimation =
    Tween(begin: 0.0, end: 1.0).animate(animationController);
    if (_menuShown)
      animationController.forward();
    else
      animationController.reverse();




    var cat = new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 12.0),
          child: Text(
            "Catégories",
            style: TextStyle(
                fontWeight: FontWeight.w100, color: Color(0xff444444)),
          ),
        ),
        cat_list.isEmpty
            ? ShimmerWidgets.shimmercategorycard()
            : Container(
                height: 120.0,
                child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (overscroll) {
                    overscroll.disallowGlow();
                  },
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: cat_list.length,
                      itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              //print(category.name);
                              //category1 =  category.name;
                              category = cat_list[index].name;
                              ontap();
                            }
                                /*Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => null)*/,
                            child: Container(
                              margin: EdgeInsets.only(
                                top: 16.0,
                                bottom: 16.0,
                                left: index == 0 ? 16.0 : 8.0,
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6.0),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color(0x1a000000),
                                        spreadRadius: 2.0,
                                        blurRadius: 9.0)
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
                                      cat_list[index].picture,
                                      color: Colors.blue[900],
                                      width: 30.0,
                                      height: 30.0,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12.0, bottom: 12.0, right: 12.0),
                                    child: Row(
                                      children: <Widget>[
                                        new Container(
                                            width: 80.0,
                                            padding: const EdgeInsets.only(
                                                left: 2.0, right: 2.0),
                                            child: Text(
                                              cat_list[index].name,
                                              style: TextStyle(
                                                  color: Colors.grey[800],
                                                  fontSize: 11.0),
                                            )),
                                        Icon(
                                          Icons.arrow_forward,
                                          size: 8.0,
                                          color: Colors.grey[900],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )),
                )),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
          child: Text(
            category,
            style: TextStyle(
                fontWeight: FontWeight.w100, color: Color(0xff444444)),
          ),
        ),
      ],
    );

    Widget aa = new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[cat, ShimmerWidgets.shimmerlist()],
    );

    return Scaffold(
        key: scaffoldKey,
        appBar: new AppBar(
          title: new Text("Boutiques"),
          actions: <Widget>[
            new IconButton(
                icon: Icon(Icons.favorite),
                onPressed: () {
                  Navigator.push(context,
                      new MaterialPageRoute(builder: (BuildContext context) {
                    return new FavoriteShps(widget.user, widget.lat, widget.lng,
                        widget.list_partner, widget.analytics);
                  }));
                })
          ],
        ),
        /* appBar: CustomAppBar((s) {
          setState(() {
            searchTerm = s;
          });
        }, scaffoldKey),*/
        body: Stack(
            children: <Widget>[  show
            ? cat
            : new StreamParcPub(cat, widget.lat, widget.lng, widget.user, "0",
                widget.list_partner,widget.analytics,
                category: category, favorite: false, boutique: true),

            _menuShown== false?Container(): Positioned(
              child: FadeTransition(
                opacity: opacityAnimation,
                child: ShapedWidget(
                    " De la conciergerie à la livraison de panier de fruits et légumes,  "
                        "cette rubrique vous propose des services sur mesure selon vos besoins.",
                    onp,180.0),
              ),
              right: 12.0,
              top: 86.0,
            ),
      ])

    )

    ;
  }
}
