import 'package:flutter/material.dart';
import 'package:ifdconnect/user/details_user.dart';
import 'package:ifdconnect/widgets/common.dart';


class ImageList extends StatelessWidget {
  ImageList(this.list);
  List list;


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,),
      body: ListView(
        children: list.map<Widget>((img)=>InkWell(
            onTap:(){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FullScreenWrapper(
                      imageProvider: NetworkImage(
                          img.toString()),
                    ),
                  ));
            },
            child:  Column(
              children: <Widget>[

                FadingImage.network(img,
                  height: 400,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,),
                Container(height: 6,)
              ],
            )
    )).toList()

      ),

    );
  }
}
