import 'package:flutter/material.dart';
import 'package:ifdconnect/chat/list_images.dart';
import 'package:ifdconnect/widgets/common.dart';

class ImageWidget extends StatelessWidget {
  ImageWidget(this.pic,this.tap);

  var pic;
  var tap;

  @override
  Widget build(BuildContext context) {




    gotoImage(pics){

      print(pics);
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (BuildContext
              context) =>
              new ImageList(pics)));
    }


    Widget pic_wid1(pic) => GestureDetector(child:Container(
      height: 225.0,
      width: MediaQuery.of(context).size.width / 2 + 40.0,
      decoration: BoxDecoration(),
      child: FadingImage.network(pic[0], fit: BoxFit.cover),
    ),

        onTap: (){
          tap();
        }


    );

    Widget build_images(pic) {
      return pic.length == 2
          ?   GestureDetector(child:Container(
          height: 225.0,
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                pic_wid1(pic),
                SizedBox(width: 2.0),
                Container(
                  height: 225.5,
                  width: MediaQuery.of(context).size.width / 2 - 58.0,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(pic[1]), fit: BoxFit.cover)),
                )
              ])),

          onTap: (){
            gotoImage(pic);
          }


      )
          : pic.length > 2
          ?GestureDetector(child: Container(
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
                      width: MediaQuery.of(context).size.width / 2 - 58.0,
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
                      width: MediaQuery.of(context).size.width / 2 - 58.0,
                      decoration: BoxDecoration(),
                      child:
                      FadingImage.network(pic[2], fit: BoxFit.cover),
                    ),
                  ],
                )
              ],
            ),
          )),

          onTap: (){
            gotoImage(pic);
          }


      )
          : Container();
    }

    return pic.length == 1
        ? /*Hero(
            tag: "im"+pic[0],*/


    GestureDetector(child:new FadingImage.network(
      pic[0],

      width: MediaQuery.of(context).size.width * 0.98,
      fit: BoxFit.fitWidth,
      //fit: BoxFit.cover,
    ),

        onTap: (){

          tap();

          /*Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullScreenWrapper(
                          imageProvider: NetworkImage(
                              pic[0]),
                        ),
                      ));  */              }


    )
        : build_images(pic);
  }
}

/*




   
 */
