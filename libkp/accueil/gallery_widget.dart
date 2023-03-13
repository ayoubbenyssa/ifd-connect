
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:ifdconnect/accueil/models/gallery.dart';
import 'package:ifdconnect/accueil/widgets/gallery_im.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/services/partners_list.dart';
import 'package:ifdconnect/widgets/custom_widgets/app_appbar.dart';
import 'package:ifdconnect/widgets/custom_widgets/buttons_appbar.dart';
import 'package:ifdconnect/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GalleryWidget extends StatefulWidget {
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<GalleryWidget> {
  List<Gallery> gal = [];
  bool load = true;
  List<Album> comps = new List<Album>();
  String type = "";

  getGalleries(type) async {
    var a = await PartnersList.get_list_gallery(type);
    if (!this.mounted) return;
    setState(() {
      gal = a;
      print(gal);
      load = false;
    });
  }

  inits() async {
    var a = await PartnersList.get_list_album();
    if (!this.mounted) return;
    setState(() {
      comps = a;
    });
    getGalleries(a[0].objectId);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    inits();

    //getGalleries("");
  }

  changer(a) {
    setState(() {
      load = true;
      new Timer(new Duration(milliseconds: 200), () {
        setState(() {
          load = false;
        });
      });
      type = comps[a].objectId;
      getGalleries(comps[a].objectId);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget tbs = comps.isEmpty
        ? PreferredSize(
      preferredSize: Size.fromHeight(40.0),
      child: Container(),
    )
        : Container(
        padding: EdgeInsets.only(left: 20.w),
        height: 46.h,
        child: ButtonsTabBar(
          backgroundColor: Fonts.col_app,
          radius: 24.r,
          borderWidth: 1.2,
          // borderColor: Fonts.col_gold,
          unselectedBorderColor: Fonts.border_col,
          unselectedBackgroundColor: Colors.white,
          unselectedLabelStyle:
          TextStyle(color: Fonts.col_text, fontSize: 16.sp),
          labelStyle: TextStyle(
              fontSize: 16.0.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold),
          onPressed: (a) {
            changer(a);
          },
          tabs: comps
              .map((Album c) => new Tab(
            text: c.name,
          ))
              .toList(),
          //controller: _tabContro
          //controller: _tabController,
        ));

    Widget pge =  Container(
            //decoration: Widgets.boxdecoration_container3(),
            //padding: EdgeInsets.only(top: 12.h),
            child: Container(

              //  decoration: Widgets.boxdecoration_container3(),
                child: load
                    ? Center(
                  child: Widgets.load(),
                )
                    : Column(children: [
                  Container(height: 16.h),
                  comps.isEmpty
                      ? PreferredSize(
                    preferredSize: Size.fromHeight(40.0),
                    child: Container(),
                  )
                      : Padding(
                    padding:
                    EdgeInsets.only(left: 20.w, right: 20.w),
                    child: tbs,
                  ),
                  Expanded(
                    // height: MediaQuery.of(context).size.height-140.h,
                    child: load
                        ? Center(child: Widgets.load())
                        : gal.isEmpty
                        ? Center(
                        child: Text("Aucune galerie trouvée"))
                        : ListView(
                      padding: EdgeInsets.all(12.w),
                      children: gal
                          .map((gl) => GalleryCard(gl))
                          .toList(),
                    ),
                  )
                ])));

    return comps.isEmpty
        ? Scaffold(
        body: Center(
          child: Widgets.load(),
        ))
        : DefaultTabController(
        initialIndex: 0, length: comps.length, child: pge);
  }
}

class GalleryCard extends StatefulWidget {
  GalleryCard(this.gal);

  Gallery gal;

  @override
  _GalleryCardState createState() => _GalleryCardState();
}

class _GalleryCardState extends State<GalleryCard> {
  int _actualIndex = 0;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    Widget carousel = new Carousel(
      onImageChange: (i,j){
        setState(() {
          _actualIndex = j;
        });
      },
      boxFit: BoxFit.cover,
      autoplay: true,
      autoplayDuration: Duration(seconds: 5),
      onImageTap: (i) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GalleryPhotoViewWrapper(
                galleryItems: widget.gal.pic,
                backgroundDecoration: const BoxDecoration(
                  color: Colors.black,
                ),
                initialIndex: i,
              ),
            ));
        /* Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FullScreenWrapper(
                    imageProvider: NetworkImage(gal.pic[i].toString()),
                  ),
            ));*/
      },
      images: widget.gal.pic
          .map((val) => new NetworkImage(val))
          .toList() /*[
      new AssetImage('assets/images/im1.png'),
      new AssetImage('assets/images/im1.png'),
      new AssetImage('assets/images/im1.png'),
      new AssetImage('assets/images/im1.png'),
    ]*/
      ,
      animationCurve: Curves.fastOutSlowIn,
      dotSpacing: 12.2,
    );

    Widget banner = new Padding(
      padding: const EdgeInsets.only(top: 12.0, left: 12.0),
      child: new Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              bottomRight: Radius.circular(15.0)),
          color: Fonts.col_app_green.withOpacity(0.8),
        ),
        padding: const EdgeInsets.all(10.0),
        child: new Text(
          widget.gal.date,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 16, //18.0,
            //color: Colors.white,
          ),
        ),
      ),
      // ),
      //  ),
    );

    Widget banner1 = widget.gal.title == ""
        ? Container()
        : Center(
      child: new Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15.0),
              bottomRight: Radius.circular(15.0)),
          color: Colors.black26.withOpacity(0.9),
        ),
        padding: const EdgeInsets.all(10.0),
        child: new Text(
          widget.gal.title,
          maxLines: 3,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 16, //18.0,
            //color: Colors.white,
          ),
        ),
      ),
      // ),
      //  ),
    );
    return Center(
      child: new Container(
        padding: const EdgeInsets.all(8.0),
        height: screenHeight / 2,
        child: new ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Column(children: [
              Expanded(
                  child: new Stack(
                    children: [
                      carousel,
                      Positioned(right: 12, child: banner),

                    ],
                  )),
              banner1,
            ])),
      ),
    );
  }
}
