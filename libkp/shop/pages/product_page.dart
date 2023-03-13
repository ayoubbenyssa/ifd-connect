import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:ifdconnect/cards/commande_button.dart';
import 'package:ifdconnect/cards/details_partner.dart';
import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/models/offers.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/widgets/common.dart';

class ProductPage extends StatefulWidget {
  final Offers product;
  User user;

  ProductPage(this.product, this.user);

  @override
  ProductPageState createState() {
    return new ProductPageState();
  }
}

class ProductPageState extends State<ProductPage> {
  void toggle() {}
  ParseServer parseFunctions = new ParseServer();

  @override
  void initState() {
    super.initState();
    print(widget.product.count);

    parseFunctions.putparse("offers/" + widget.product.objectId,
        {"count": widget.product.count + 1});

    print("ji------------------");
    print(widget.user.phone);
  }

  @override
  Widget build(BuildContext context) {
    final key = new GlobalKey<ScaffoldState>();

    var style = new TextStyle(color: Colors.white, fontSize: 14.5);
    var style1 = new TextStyle(color: Colors.yellow[800], fontSize: 14.5);

    return Scaffold(
      key: key,
      bottomNavigationBar: CommandeButton(
          widget.product, widget.user, context,false),
      body: new Container(
        color: Colors.white,
        child: new ListView(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Hero(
                  tag: "product_${widget.product.objectId.toString()}",
                  child: FadingImage.network(
                    widget.product.pic[0],
                    height: 300.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 40.0),
                    child: IconButton(
                        icon: Icon(
                          Icons.keyboard_arrow_left,
                          color: Colors.blue,
                          size: 40.0,
                        ),
                        onPressed: () => Navigator.of(context).pop())),
                /* Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(right: 16.0, bottom: 50.0),
                        child: IconButton(
                          icon: Icon(
                            Icons.favorite,
                            size: 30.0,
                          ),
                          color: Colors.white,
                          onPressed: () => toggle(),
                        ),
                      )),*/
              ],
            ),
            new Container(
              height: 12.0,
            ),
            Container(
              //padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        widget.product.name,
                        style: TextStyle(fontSize: 16.0),
                      )),
                  new Container(
                    height: 6.0,
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          new Text(
                            " Prix:    ",
                            style: TextStyle(
                                fontSize: 14.0, fontWeight: FontWeight.w600),
                          ),
                          new Container(
                            width: 12.0,
                          ),
                          new Text(
                            widget.product.sellingPrice + " DHS",
                            style: TextStyle(
                                color: Colors.blue[300],
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600),
                          ),
                          new Container(
                            width: 12.0,
                          ),
                          new Text(
                            widget.product.initialPrice + " DHS",
                            style: new TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey[400],
                                fontSize: 14.0),
                          ),
                          new Expanded(
                              child: new Container(
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
                      )),
                  new Container(
                    height: 6.0,
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      height: 0.5,
                      width: 421.0,
                      color: Color(0xffDEDEDE),
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          new InkWell(
                              onTap: () {
                                Navigator.push(context, new MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return new PartnerCardDetails(
                                      widget.product.partner);
                                }));
                              },
                              child: new ClipOval(
                                  child: new Container(
                                      color: Fonts.col_app,
                                      width: 44.0,
                                      height: 44.0,
                                      child: new Center(
                                          child: FadingImage.network(
                                        widget.product.partner.logo,
                                        width: 46.0,
                                        height: 46.0,
                                        fit: BoxFit.cover,
                                      ))))),
                          new Container(
                            width: 8.0,
                          ),
                          new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text(widget.product.partner.name,
                                  style: new TextStyle(
                                      color: Fonts.col_app,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.5)),
                              new Text(
                                widget.product.startDate,
                                style: new TextStyle(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.6),
                              ),
                            ],
                          ),
                        ],
                      )),
                  Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      height: 0.5,
                      width: 421.0,
                      color: Color(0xffDEDEDE),
                    ),
                  ),
                  HtmlWidget(
                    widget.product.summary
                        .toString()
                        .replaceAll(RegExp(r'(\\n)+'), ''),

                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      height: 0.5,
                      width: 421.0,
                      color: Color(0xffDEDEDE),
                    ),
                  ),
                  HtmlWidget(
                    widget.product.description
                        .toString()
                        .replaceAll(RegExp(r'(\\n)+'), ''),

                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
