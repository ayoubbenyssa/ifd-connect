import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ifdconnect/accueil/gallery_widget.dart';
import 'package:ifdconnect/accueil/models/categoy_preview.dart';
import 'package:ifdconnect/accueil/models/gallery.dart';
import 'package:ifdconnect/accueil/news_slides.dart';
import 'package:ifdconnect/accueil/repositories/home_response.dart';
import 'package:ifdconnect/accueil/slider.dart';
import 'package:ifdconnect/accueil/slider_photos.dart';
import 'package:ifdconnect/accueil/slider_prof.dart';
import 'package:ifdconnect/accueil/videos_slide.dart';
import 'package:ifdconnect/models/offers.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ifdconnect/services/campus_services.dart';
import 'package:ifdconnect/services/partners_list.dart';
import 'package:ifdconnect/widgets/bottom_menu.dart';
import 'package:ifdconnect/widgets/widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AllHome extends StatefulWidget {
  AllHome(this.user, this.lat, this.lng, this.function_go, {Key key})
      : super(key: key);
  User user;
  double lat, lng;

  Function function_go;

  @override
  _AllHomeState createState() => _AllHomeState();
}

//Photo go to phottheque
//

class _AllHomeState extends State<AllHome> {
  List<CategoryPreview> categories = [];
  List<Offers> videos = [];
  List conventionsProximite = [];
  List conventions = [];
  List<Gallery> gal = new List<Gallery>();

  bool load = true;
  bool load_next = true;
  List all_cat = [];
  bool load_videos = true;
  bool load_photo = true;

  bool load_news = true;
  List<Offers> news = [];
  List<Offers> events = [];

  getnews() async {
    HomeResponse res = await HomeRepository.get_posts();
    if (!this.mounted) return;
    setState(() {
      news = res.publications;
      load_news = false;
    });
  }

  getGalleries() async {
    var a = await PartnersList.get_6list_gallery();
    if (!this.mounted) return;
    setState(() {
      gal = a;
      load_photo = false;
    });
  }

  getevents() async {
    HomeResponse res = await HomeRepository.get_events();
    if (!this.mounted) return;
    setState(() {
      events = res.publications;
      load_videos = false;
    });
  }

  int token_user = 0;
  CampusServices cmp = new CampusServices();
  SharedPreferences prefs;
  String etud_prof = "";
  bool loadin = true;
  bool chef_dept = false;

  auth_api_school() async {
    final param = {
      "username": widget.user.identifiant,
      "password": widget.user.password.toString()
    };
    prefs = await SharedPreferences.getInstance();

    final loginData = await http.post(
      "${prefs.getString('api_url')}/login",
      body: param,
    );

    var resBody = json.decode(loginData.body);
    prefs.setInt("token_user", resBody["auth_token"]);
    token_user = prefs.getInt("token_user");

    verify_login_campus();
  }

  verify_login_campus() async {
    prefs = await SharedPreferences.getInstance();
    token_user = prefs.getInt("token_user");

    setState(() {
      loadin = true;
    });

    widget.user.token_user = prefs.getInt("token_user");

    if (token_user.toString() != "null" && token_user != 0) {
      if (widget.user.employee_id.toString() != "null" &&
          widget.user.employee_id.toString() != "") {
        var prfile = await cmp.profile_emp(widget.user.user_id,
            widget.user.employee_id, prefs.getInt("token_user"));

        setState(() {
          loadin = false;
        });
        if (prfile == false) {
          auth_api_school();
        } else {
          setState(() {
            etud_prof = "Professeur";
            chef_dept = prfile["employee"]["employee"]["chef_dept"];
          });
        }
      } else {
        var prfile = await cmp.profile_etud(widget.user.user_id,
            widget.user.student_id, prefs.getInt("token_user"));

        setState(() {
          loadin = false;
        });

        if (prfile == false) {
          auth_api_school();
        } else {
          setState(() {
            etud_prof = "Étudiant";
          });
        }
      }
    } else {
      auth_api_school();
      setState(() {
        etud_prof = "";
      });
    }
  }

  getVideos() async {
    HomeRepository.get_3Videos("all").then((value) {
      if (!this.mounted) return;
      setState(() {
        videos = value.publications;

        print("gdggdgdgdggdgdgdgdgdgd");
        print(videos);
        print(videos);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    new Future.delayed(Duration.zero, () {
      setState(() {
        all_cat = [
          {
            "name": "" /*LinkomTexts.of(context).live()*/,
            "load": false,
            "list": [],
            "type": "banner1"
          },
          //  {"name": "", "load": false, "list": [], "type": "banner3"},
          {"name": "Actualités", "load": false, "list": [], "type": "news"},
          {"name": "Évènements", "load": false, "list": [], "type": "event"},
          {"name": "Vidéothèque", "load": false, "list": [], "type": "video"},
          {"name": "Photothèque", "load": false, "list": [], "type": "photo"}
        ];
        categories = all_cat.map((e) => CategoryPreview.fromMap(e)).toList();
      });
      if (widget.user.role.id != "9UHbnUrotk") verify_login_campus();
      getVideos();
      getGalleries();
      getnews();
      getevents();
    });
  }

  @override
  Widget build(BuildContext context) {
    double cardHeight = ScreenUtil().setHeight(167);
    double cardWidth = ScreenUtil().setWidth(163);

    cases_tap(String type) {
      switch (type) {
        case "photo":
          widget.function_go(5);

          /* Navigator.push(context,
              new MaterialPageRoute(builder: (BuildContext context) {
            return new GalleryWidget();
          }));*/
          break;
        case "banner":
          widget.function_go(3);
          break;
        case "banner":
          widget.function_go(3);
          break;
        case 'event':
          widget.function_go(2);

          /**
              Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
              builder: (context) => BottomNavigation(
              null,
              null,
              widget.user,
              [],
              true,
              null,
              widget.onLocaleChange,
              animate: true,
              )),
              (Route<dynamic> route) => false);
           */
          break;
        case 'news':
          widget.function_go(1);
          break;
        case 'acheter':
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => BottomNavigation(
                        null,
                        null,
                        widget.user,
                        [],
                        true,
                        null,
                        animate: 2,
                      )),
              (Route<dynamic> route) => false);
          break;
        case 'video':
          widget.function_go(6);
          break;
        // case 'acheter':
        //   widget.function_go(1);
        //   break;
        /* case "photo":
          Navigator.push(context,
              new MaterialPageRoute(builder: (BuildContext context) {
                return new GalleryWidget();
              }));
          break;*/
        default:
          null;
      }
    }

    widgets_all(CategoryPreview cat) {
      switch (cat.type) {
        case 'event':
          return load_videos
              ? Center(child: Widgets.load())
              : NewsSlides(widget.user, widget.lat, widget.lng, events);

        case "news":
          return load_news
              ? Center(child: Widgets.load())
              : NewsSlides(widget.user, widget.lat, widget.lng, news);
        case 'banner1':
          return Column(children: [
            (loadin &&
                    widget.user.role.id != "9UHbnUrotk" &&
                    widget.user.role.id != "rZWnnQTWIr")
                ? Center(child: Widgets.load())
                : Container(),
            etud_prof == "Étudiant" ? SliderBanner2(widget.user) : Container(),
            (widget.user.role.id == "NXiGscrffB" && etud_prof == "Professeur")
                ? SliderBanner2Prof(widget.user, chef_dept)
                : Container()
          ]);
        case 'video':
          return videos.isEmpty
              ? Center(child: Widgets.load())
              : VideosSlide(videos);
        case "photo":
          return load_photo == true
              ? Center(child: Widgets.load())
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: SliderBannerPhoto(gal));
          break;
        default:
          return Container();
      }
    }

    row_categoryItem(CategoryPreview cat) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        (cat.type == "banner1" || cat.type == "banner3")
            ? Container()
            : Container(
                color: Colors.white,
                padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Text(cat.name,
                            style: TextStyle(
                                color: Color(0xff606563),
                                fontSize: 15.5.sp,
                                fontFamily: "Hbold",
                                /* fontFamily: model.locale == "ar"
                                        ? "open"
                                        : 'tr_ligh',*/
                                fontWeight: FontWeight.w500))),
                    InkWell(
                        onTap: () {
                          cases_tap(cat.type);
                        },
                        child: Container(
                            padding: EdgeInsets.all(2.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Voir tout",
                                  style: TextStyle(
                                    color: Fonts.col_app,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11.0.sp,
                                  ),
                                ),
                                Container(width: 4.w),
                                Icon(Icons.arrow_forward_ios,
                                    color: Fonts.col_app, size: 12.w)
                              ],
                            ))),
                  ],
                )),
        widgets_all(cat)
        /* load == true
            ? CupertinoActivityIndicator()
            : Container(
            margin: EdgeInsets.only(top: 4.h),
            height: 120.h,
            child: ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: [] /*cat.map((e) => Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: Container()YtbeVideo(e.link_id, 165.w, 86.h)*/)),*/

        /*Divider(
          color: Fonts.col_grey,
          height: 2,
        ),*/
      ]);
    }

    return ListView(
        padding: EdgeInsets.only(bottom: 100.h),
        children: categories.map((e) => row_categoryItem(e)).toList());
  }
}
