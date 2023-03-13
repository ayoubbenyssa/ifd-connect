import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:ifdconnect/chat/list_images.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/widgets/common.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageWidget2 extends StatefulWidget {
  ImageWidget2(this.pic, this.tap);

  var pic;
  var tap;

  @override
  _ImageWidgetState createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget2> {
  int _swiperIndex = 0;

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    gotoImage(pics) {
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (BuildContext context) => new ImageList(pics)));
    }

    Widget pic_wid1(pic) => GestureDetector(
        child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0.r),
            child: Container(
              // height: 225.0.h,
              width: MediaQuery.of(context).size.width / 2 + 40.0,
              decoration: BoxDecoration(),
              child: FadeInImage.assetNetwork(
                placeholder: "images/pl.png",
                image: pic[0],
              ),
            )),
        onTap: () {
          widget.tap();
        });

    Widget build_images(pic) {
      return pic.length > 1
          ? GestureDetector(
          onTap: () {
            widget.tap();
          },
          child: Padding(
            padding: EdgeInsets.only(bottom: 4.h),
            child: Stack(
              children: [
                new Swiper(
                  index: _swiperIndex,
                  onIndexChanged: (indx) {
                    setState(() {
                      _swiperIndex = indx;
                    });
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return new Container(
                        child: new FadingImage.network(

                          pic[index].toString(),
                          fit: BoxFit.cover,
                        ));
                  },
                  itemCount: pic.length,
                  pagination: new SwiperPagination(),
                  control: new SwiperControl(),
                ),
                Positioned(
                  right: 0.w,
                  left: 0.w,
                  bottom: 4.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: map<Widget>(pic, (index, url) {
                      return Container(
                        width: 10.0,
                        height: 10.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _swiperIndex == index
                              ? Fonts.col_app
                              : Colors.grey,
                        ),
                      );
                    }),
                  ),
                )
              ],
            ),
          ))
          : Container() /*Container(
                  height: 225.0,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        pic_wid1(pic),
                        SizedBox(width: 2.0),
                        Container(
                          height: 225.5.h,
                          width: MediaQuery.of(context).size.width / 2 - 58.0,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(pic[1]),
                                  fit: BoxFit.cover)),
                        )
                      ])),
              onTap: () {
                gotoImage(pic);
              })
          : pic.length > 2
              ? GestureDetector(
                  child: Container(
                      // padding: EdgeInsets.only( right: 15.0),
                      child: Container(
                    height: 225.0,
                    child: Row(
                      children: <Widget>[
                        pic_wid1(pic),
                        SizedBox(width: 2.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 111.5,
                              width:
                                  MediaQuery.of(context).size.width / 2 - 58.0,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      colorFilter: new ColorFilter.mode(
                                          Colors.black.withOpacity(0.5),
                                          BlendMode.darken),
                                      image: NetworkImage(pic[1]),
                                      fit: BoxFit.cover)),
                            ),
                            SizedBox(height: 2.0),
                            Container(
                              height: 111.5,
                              width:
                                  MediaQuery.of(context).size.width / 2 - 58.0,
                              decoration: BoxDecoration(),
                              child: FadingImage.network(pic[2],
                                  fit: BoxFit.cover),
                            ),
                          ],
                        )
                      ],
                    ),
                  )),
                  onTap: () {
                    gotoImage(pic);
                  })
              : Container()*/
      ;
    }

    return widget.pic.length == 1
        ? /*Hero(
            tag: "im"+pic[0],*/

    /**
     *  FadeInImage.assetNetwork(
        placeholder: "images/play.png",
        image: pic[0],
        ),
     */
    GestureDetector(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal:8.w),
            child: Container(
                width: 332.w,
                height: 240.h,
                decoration: BoxDecoration(
                    borderRadius:
                    new BorderRadius.all(Radius.circular(18.0.r)),
                    color: Color(0xff03120b),
                    border:
                    new Border.all(width: 1.4, color: Fonts.col_grey)),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0.r),
                    child: new FadeInImage.assetNetwork(
                      placeholder: "images/pl.png",
                      image: widget.pic[0],

                      width: MediaQuery.of(context).size.width * 0.98,
                      fit: BoxFit.cover,
                      //fit: BoxFit.cover,
                    )))),
        onTap: () {
          widget.tap();

          /*Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullScreenWrapper(
                          imageProvider: NetworkImage(
                              pic[0]),
                        ),
                      ));  */
        })
        : build_images(widget.pic);
  }
}

/*





 */
