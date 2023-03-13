import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:ifdconnect/accueil/models/gallery.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ifdconnect/services/partners_list.dart';
import 'package:ifdconnect/widgets/widgets.dart';

class SliderBannerPhoto extends StatefulWidget {
  SliderBannerPhoto(this.gal,{Key key}) : super(key: key);
  List<Gallery> gal = new List<Gallery>();

  @override
  _SliderBannerState createState() => _SliderBannerState();
}

class _SliderBannerState extends State<SliderBannerPhoto> {
  int _currentIndex = 0;

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }




  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CarouselSlider(
          options: CarouselOptions(
            height: 200.0.h,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 10),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            pauseAutoPlayOnTouch: true,
            aspectRatio: 2.0,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: widget.gal.map((galitem) {
            return Builder(builder: (BuildContext context) {
              return Container(
                // height: MediaQuery.of(context).size.height * 0.30,
                width: MediaQuery.of(context).size.width,
                child: Card(
                  color: Colors.white,
                  child: Item1(galitem.pic[0], () {}),
                ),
              );
            });
          }).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: map<Widget>(widget.gal, (index, url) {
            return Container(
              width: 10.0,
              height: 10.0,
              margin:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                _currentIndex == index ? Fonts.col_app : Colors.grey,
              ),
            );
          }),
        ),
      ],
    );
  }
}

class Item1 extends StatelessWidget {
  Item1(this.image, this.click, {Key key}) : super(key: key);
  String image;
  Function click;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(12.0.r),
        child: Container(
          decoration: Widgets
              .boxdecoration_background() /*BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [
              0.3,
              1
            ],
            colors: [
              Color(0xffff4000),
              Color(0xffffcc66),
            ]),
      )*/
          ,
          child:
          Image.network(
            image,
            height: 190.0.h,

            fit: BoxFit
                .fitHeight, /*,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold)*/
          ),
          /*Text("Data",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0.sp,
                  fontWeight: FontWeight.w600)),*/

        ));
  }
}
