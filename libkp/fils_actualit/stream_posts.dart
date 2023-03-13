import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ifdconnect/accueil/gallery_widget.dart';
import 'package:ifdconnect/accueil/videos_list.dart';
import 'package:ifdconnect/accueil/widgets/ytbe_video.dart';
import 'package:ifdconnect/services/remote_config_service.dart';
import 'package:ifdconnect/widgets/all_home.dart';
import 'package:ifdconnect/widgets/custom_widgets/buttons_appbar.dart';
import 'package:ifdconnect/cards/pub_parc_card.dart';
import 'package:ifdconnect/cards/sonagecard.dart';
import 'package:latlong/latlong.dart';
import 'package:ifdconnect/fils_actualit/wall_card.dart';
import 'package:ifdconnect/models/offers.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/services/posts_services.dart';
import 'package:ifdconnect/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:latlong/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:video_player/video_player.dart';

class StreamPots extends StatefulWidget {
  StreamPots(this.user, this.lat, this.lng, this.list_partners, this.analytics);

  User user;
  var lat;
  var lng;
  var list_partners;
  var analytics;

  @override
  _StreamPotsState createState() => _StreamPotsState();
}

class _StreamPotsState extends State<StreamPots> with TickerProviderStateMixin {
  List<Offers> list = new List<Offers>();
  ScrollController _hideButtonController1 = new ScrollController();
  TabController _controller;

  TabController _tabController;
  bool isPlaying = false;

  var noPost = "";
  bool story = false;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  SliverPersistentHeaderDelegate delegate;
  List listWidget = new List();
  bool isLoading = true;
  int skip = 0;

  //var count = 0;
  var count2 = 0;
  int indx = 0;

  List _list = [];

  String selectedValue = "news";
  String selected_type = "news";

  strt() {
    setState(() {
      story = true;
    });
    new Timer(const Duration(seconds: 1), () {
      try {
        setState(() => story = false);
      } catch (e) {
        e.toString();
      }
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    //  if (_controllerv != null) _controllerv.pause();
  }

  Reload() {
    setState(() => isLoading = true);
    skip = 0;
    if (selected_type == "center") {
      setState(() {
        isLoading = false;
      });
    }
    streampost(0);
  }

  Future<List<Offers>> getLIst() async {
    list = [];

    if (selected_type == "center")
      setState(() {
        list = [];
      });
    else {
      var a =
          await PostsServices.get_pub_type(skip, selected_type, widget.user);
      list = a["results"];
    }

    ///count = list.length;

    if (this.mounted)
      setState(() {
        isLoading = false;
      });

    return list;
  }

  errorrequest(text) {
    var errorWithYourRequest = "Error";
    if (text == "nointernet")
      errorWithYourRequest =
          "S'il vous plait vérifier votre connexion internet!";
    Scaffold.of(context).showSnackBar(new SnackBar(
      duration: new Duration(seconds: 5),
      content: new Text(errorWithYourRequest,
          style: new TextStyle(color: Colors.red[900])),
      action: new SnackBarAction(
          label: "try again",
          onPressed: () {
            streampost(skip);
          }),
    ));
  }

  Distance distance = new Distance();

  eventcard(Offers postdata) {
    if (postdata.latLng.isNotEmpty && postdata.latLng.toString() != "null") {
      print(4444);
      print(postdata.latLng);

      if (postdata.latLng.split(";")[0] != null &&
          postdata.latLng.split(";")[1] != null) {
        postdata.dis = "-.- " + "Kms";
      } else
        postdata.dis = distance
                .as(
                    LengthUnit.Kilometer,
                    new LatLng(double.parse(postdata.latLng.split(";")[0]),
                        double.parse(postdata.latLng.split(";")[1])),
                    new LatLng(widget.lat, widget.lng))
                .toString() +
            " " +
            "Kms";
    } else {
      postdata.dis = "-.- " + "Kms";
    }
    return Container(
        child: new ParcPubCard(postdata, widget.user, true, [], null,
            widget.analytics, context, widget.lat, widget.lng));
  }

  streampost(skipp) async {
    if (skipp == 0) listWidget = new List();
    List<Offers> result = await getLIst();

    if (!this.mounted) return;

    setState(() => isLoading = false);

    if (result == "nointernet" || result == "error")
      errorrequest(result);
    else if (result == "empty" || result == "nomoreresults")
      noPosts(result);
    else
      showwidgets(result);
  }

  getdata() async {
    _hideButtonController1.addListener(() {
      if (_hideButtonController1.position.atEdge) {
//  if (count2 < count)
        streampost(count2);
      }
    });
    streampost(skip);
  }

  initializeRemoteConfig() async {
    RemoteConfigService _remoteConfigService;
    _remoteConfigService = await RemoteConfigService.getInstance();
    await _remoteConfigService.initialize();
    print(_remoteConfigService.getUrl.toString());

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('api_url', _remoteConfigService.getUrl);
    prefs.setString('url_parce', _remoteConfigService.geturl_parce);
    prefs.setString('urlclasse', _remoteConfigService.geturlclasse);
    prefs.setString('"appId_parce"', _remoteConfigService.getappId_parce);
    prefs.setString('Parse_Id', _remoteConfigService.getParse_Id);
    prefs.setString('Parse_Key', _remoteConfigService.getParse_Key);
    prefs.setString('Content_type', _remoteConfigService.getContent_type);
  }
  @override
  void initState() {
    super.initState();

    print("%%%%%%%%%%%%%%%%%%");
    initializeRemoteConfig();
    print("%%%%%%%%%%%%%%%%%%");


// Optional: enter your test device ids here
    /*  _controller.setTestDeviceIds([
      "ca-app-pub-3542535357117024/6214301788",
      ""
    ]);*/

    _list = [
      {"name": "Accueil", "type": "all"},
      {"name": "Actualités", "type": "news"},
      {"name": "Agenda / Événement", "type": "event"},
      {"name": "Actualité de l’institut", "type": "Général_emi"},
      {"name": "Offres Stage / Emploi", "type": "Offres Stages/Emplois_emi"},
      {"name": "Photothèque", "type": "gellery"},
      {"name": "Vidéothèque", "type": "videotheque"},
      {"name": "Objets perdus", "type": "Objets perdus_emi"},
      {"name": "Sondages", "type": "sondage"}
    ];
    _controller = TabController(length: _list.length, vsync: this);

//VideoRca
    getdata();
  }

  @override
  void dispose() {
    super.dispose();
  }

  noPosts(type) {
    try {
      if (type == "nomoreresults")
        setState(() => noPost = "Il n y a aucun autre résultat");
      else
        setState(() => noPost = "Aucun post trouvé");
    } catch (e) {
      e.toString();
    }
  }

  getrefresh() {
    skip = 0;

    streampost(0);
    Completer<Null> completer = new Completer<Null>();
    new Timer(new Duration(seconds: 1), () {
      completer.complete();
    });
    return completer.future;
  }

  ld(i) {
    /* if (_list[i]["type"] == "tous") {
      setState(() {
        selectedValue = "Type de publication";
        selected_type = "";
      });
      //com = value;
      Reload();
    } */
    setState(() {
      selectedValue = _list[i]["name"];
      selected_type = _list[i]["type"];
    });
    //com = value;
    Reload();
  }

  st(i) {
    setState(() {
      indx = i;
    });
    ld(i);
  }

  st3(i) {
    st(i);
    _controller.animateTo(i);
  }

  showwidgets(List<Offers> result) {
    for (Offers item in result) {
      count2++;

      print('--------------------------------------');
      print(item.type);

      listWidget.add(Column(children: [
        /* item.type == "videotheque"
            ? YtbeVideo(item.link_id, 190.w, 120.h))
            : */
        item.type == "sondage"
            ? SondageCard(widget.user, item, list)
            : item.type == "event"
                ? /**/
                eventcard(item)
                : Wall_card(item, widget.user, widget.list_partners, widget.lat,
                    widget.lng, widget.analytics),
        /*  (result.indexOf(item) % 10 == 0 /*&& result.indexOf(item) != 0*/)
            ? Container(
                height: 170,
                child: Card(
                    elevation: 1,
                    child: NativeAdmob(
                      adUnitID: AppServices.admobNativeAdIdAndroid,
                      loading: Center(child: CircularProgressIndicator()),
                      error: Text(""),
                      controller: _controller,
                      type: NativeAdmobType.full,
                      options: NativeAdmobOptions(
                        ratingColor: Colors.green,
                        // Others ...
                      ),
                    )))
            : Container(),*/
      ]));
    }

    setState(() => skip += 30);
  }

  @override
  Widget build(BuildContext context) {
    Widget buildBody(BuildContext context) {
      Widget loading = new SliverToBoxAdapter(
          child: new Center(
              child: Padding(
                  padding: EdgeInsets.only(top: 24), child: Widgets.load())));

      Widget header_widget = SliverToBoxAdapter();

      Widget bottom = new SliverToBoxAdapter(
          child: new Center(
              child: new Container(
                  padding: const EdgeInsets.only(
                      top: 85.0, left: 16.0, right: 16.0, bottom: 16.0),
                  child: new Text(noPost))));
      Widget silverheader = new SliverToBoxAdapter(child: Container());

      Widget listposts = new SliverList(
          delegate:
              new SliverChildListDelegate(new List<Widget>.from(listWidget)));

      Widget scrollview =
          new CustomScrollView(controller: _hideButtonController1, slivers: [
        silverheader,
        header_widget,

        // widget.silver == null ? new SliverToBoxAdapter() : widget.silver,
        isLoading ? loading : listposts,
        bottom,
      ]);
      return new RefreshIndicator(
          onRefresh: () => getrefresh(),
          child: scrollview,
          key: _refreshIndicatorKey);
    }

    Widget tbs = Container(
            height: 40.0.h,
            child: ButtonsTabBar(
              backgroundColor: Fonts.col_app,
              radius: 42.r,
              contentPadding: EdgeInsets.all(6.w),
              borderWidth: 1.0,
              controller: _controller,
              borderColor: Fonts.col_app,
              unselectedBorderColor: Fonts.col_app_fon,
              unselectedBackgroundColor: Colors.white,
              unselectedLabelStyle:
                  TextStyle(color: Fonts.col_app_fon, fontSize: 12.sp),
              labelStyle: TextStyle(
                  fontSize: 12.0.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              onPressed: st,
              tabs: _list.map((a) => new Tab(text: a["name"])).toList(),
            )) /*TabBar(
      onTap: (i) {
        st(i);

        ld(i);
      },
      isScrollable: true,
      indicatorColor: Fonts.col_gr,
      indicatorWeight: 4,
      unselectedLabelColor: Fonts.col_grey,
      labelColor: Colors.black,
      labelStyle: new TextStyle(
          color: Colors.black,
          fontFamily: "Helvetica",
          fontWeight: FontWeight.w600,
          fontSize: 16),
      indicatorPadding: new EdgeInsets.all(0.0),
      tabs: _list
          .map((dynamic a) => isLoading && _list.indexOf(a) != indx
              ? Container(
                  child: new Card(
                      child: Container(
                    padding: EdgeInsets.all(4),
                    margin: new EdgeInsets.only(bottom: 7.0, top: 8.0),
                    color: Colors.grey[100],
                    height: 10.0,
                    width: 70.0,
                  )),
                )
              : new Tab(text: a["name"]))
          .toList(),
    )*/
        ;

    return DefaultTabController(
            initialIndex: 0,
            length: _list.length,
            child: Column(children: <Widget>[
              /* Container(
                  decoration: new BoxDecoration(
                      color: Fonts.col_app_green,
                      image: new DecorationImage(
                          fit: BoxFit.cover,
                          colorFilter: new ColorFilter.mode(
                              Fonts.col_app_green.withOpacity(0.25), BlendMode.dstATop),
                          image: new AssetImage("images/bck1.png"))),
                  child: StoriesWidget(
                widget.user,
                rounded: true,
              )),*/
              // drop_down(),

              Container(height: 12.h),
              Container(
                  //  height: MediaQuery.of(context).size.height * 0.08,
                  child: isLoading
                      ? IgnorePointer(
                          child: tbs,
                        )
                      : tbs),

              Expanded(
                  child: indx == 6
                      ? VideosList()
                      : indx == 5
                          ? GalleryWidget()
                          : indx == 0
                              ? AllHome(
                                  widget.user, widget.lat, widget.lng, st3)
                              : Container(
                                  color: Fonts.col_cl,
                                  child: new Builder(builder: buildBody)))
            ])) /*Scaffold(
        //backgroundColor: Colors.blue[100],
        appBar: AppBar(),
        body: list.isEmpty
            ? Center(child: RefreshProgressIndicator())
            : Container(
               // color: Colors.blue[50],
                child: ListView(
                    padding: EdgeInsets.all(0),
                    children: list.map((Offers item) {
                      return item.type == "cov"
                          ? Cov_Card(
                              item,
                              widget.user,
                              null,
                              null,
                              widget.list_partners,
                              lat: widget.lat,
                              lng: widget.lng,
                            )
                          : Wall_card(item, widget.user, widget.list_partners);
                    }).toList())))*/
        ;
  }
}
