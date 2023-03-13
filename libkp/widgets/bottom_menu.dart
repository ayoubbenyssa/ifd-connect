import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ifdconnect/reclamation/form_reclamation.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/fils_actualit/add_vote.dart';
import 'package:ifdconnect/widgets/custom_widgets/bottombar.dart';
import 'package:location/location.dart';
import 'package:ifdconnect/annonces/add_annonces.dart';
import 'package:ifdconnect/chat/messages_list.dart';
import 'package:ifdconnect/fils_actualit/stream_posts.dart';
import 'package:ifdconnect/func/parsefunc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ifdconnect/home/request_users.dart';
import 'package:ifdconnect/models/connect.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/networking/filter_page.dart';
import 'package:ifdconnect/search/list_users_results.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/services/connect.dart';
import 'package:ifdconnect/services/location_services.dart';
import 'package:ifdconnect/user/myprofile.dart';
import 'package:ifdconnect/notifications/userslist.dart';
import 'package:ifdconnect/widgets/common.dart';
import 'package:ifdconnect/widgets/menu.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:ifdconnect/widgets/search_widget.dart';
import 'package:ifdconnect/widgets/widgets.dart';
import 'package:flutter/services.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';

var indx = 0;

class BottomNavigation extends StatefulWidget {
  BottomNavigation(this.auth, this.sign, this.user, this.list_partners,
      this.show_menu, this.analytics,
      {animate});

  var auth;
  var sign;
  User user;
  bool show_menu = false;
  List list_partners;
  var animate;
  var analytics;

  @override
  _BottomNavigationState createState() => new _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  PageController _pageController = new PageController();
  int _page = 0;
  bool load_location = false;

  ParseServer parse_s = new ParseServer();

  var lat, lng;
  List items = [
    {"icon": "assets/icons/home.svg", "name": "Accueil"},
    {"icon": "assets/icons/Share.svg", "name": "Networking"},
    {"icon": "add", "name": "add"},
    {"icon": "assets/icons/chat.svg", "name": "Messages"},
    {"icon": "assets/icons/account.svg", "name": "Profil"}
  ];

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool gps_none = true;

  User user_me;

//search
  final key = new GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = new TextEditingController();
  List<String> _list;
  bool _IsSearching;
  String _searchText = "";

  bool lo = false;

  gotosond() {
    Navigator.pop(context);
    Navigator.push(
      context,
      new PageRouteBuilder(
        pageBuilder:
            (BuildContext context, Animation<double> _, Animation<double> __) {
          return new AddVote(widget.user);
        },
      ),
    );
  }

  rel() {
    setState(() {
      lo = true;
    });
    // getRequestLIst();
    new Timer(const Duration(seconds: 1), () {
      try {
        setState(() => lo = false);
      } catch (e) {
        e.toString();
      }
    });
  }

  bool add;

  List<ConnectModel> conn = new List<ConnectModel>();
  bool load_conn = false;

  var count;
  var select = "";

  ScrollController _hideButtonController;
  SearchBar searchBar;


  reclamationgo() {

    Navigator.pop(context);
    Navigator.push(
      context,
      new PageRouteBuilder(
        pageBuilder:
            (BuildContext context, Animation<double> _, Animation<double> __) {
          return new FormReclamation(widget.user);
        },
      ),
    );
  }

  tap() {

    Navigator.pop(context);
    Navigator.push(
      context,
      new PageRouteBuilder(
        pageBuilder:
            (BuildContext context, Animation<double> _, Animation<double> __) {
          return new AddAnnonce(widget.user, widget.auth, widget.sign,
              widget.list_partners, select);
        },
      ),
    );
  }

  row(name, icon, tap, wid, he, selec) => new ListTile(
      onTap: () {
        if (name != "Covoiturage") {
          select = selec;
        }

        if (name == "A partir de votre école") {
          add = true;
        } else if (name == "Vers votre école") {
          add = false;
        }
        tap();
      },
      title: Row(children: [
        Image.asset(
          icon,
          width: wid,
          height: he,
          color: Fonts.col_app,
        ),
        Container(
          width: 16.0,
        ),
        new Text(
          name,
          style: TextStyle(fontSize: 14.5, color: Colors.white),
        )
      ]));

  show() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => new Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Container(
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20.r)),
                    child: BackdropFilter(
                        filter: ImageFilter.blur(
                            sigmaX: 20.0,
                            sigmaY: 20.0,
                            tileMode: TileMode.mirror),
                        child: Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22.r),
                                border: Border.all(
                                    color: Fonts.col_app.withOpacity(0.5),
                                    width: 1)),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    height: 16,
                                  ),
                                  Center(
                                      child: Text("Publier:",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700))),
                                  Container(
                                    height: 16,
                                  ),

                                  row("Reclamation", "assets/icons/customer.png", reclamationgo, 40.0,
                                      40.0, "Reclamation"),

                                  row("Annonce", "images/ot.png", tap, 40.0,
                                      40.0, "Général"),
                                  row(
                                      "Offres Stages/Emplois",
                                      "images/mission.png",
                                      tap,
                                      35.0,
                                      35.0,
                                      "Offres Stages/Emplois"),
                                  row("  Objets perdus", "images/lost.png", tap,
                                      30.0, 30.0, "Objets perdus"),
                                  row("Sondage", "images/vote.png", gotosond,
                                      35.0, 35.0, "Vote"),
                                ])))))));
  }

  getRequestLIst() async {
    setState(() {
      conn = [];
      load_conn = true;
      loading = true;
    });
    var a = await Connect.get_list_connect(widget.user.id);
    // if (this.mounted) return;

    setState(() {
      conn = a["res"];
      count = a["count"] - 3;
      load_conn = false;
      loading = false;
    });
  }

  void onSubmitted(String value) {
    //here
    Navigator.push(context,
        new MaterialPageRoute(builder: (BuildContext context) {
          return new UserListsResults(
              value,
              widget.user,
              widget.list_partners,
              widget.analytics,
              _currentLocation == null ? 0.0 : _currentLocation["latitude"],
              _currentLocation == null ? 0.0 : _currentLocation["longitude"]);
        }));
  }

  _BottomNavigationState() {
    searchBar = new SearchBar(
        inBar: false,
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        onSubmitted: onSubmitted);

    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _IsSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _IsSearching = true;
          _searchText = _searchQuery.text;
        });
      }
    });
  }

  bool loading = false;

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        backgroundColor: Fonts.col_app,
        centerTitle: true,
        title: _page != 1
            ? Padding(
            padding: EdgeInsets.all(8.w),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10.r)),
                child: Container(
                    height: 44.w,
                    width: 44.w,
                    color: Colors.white.withOpacity(0.9),
                    padding: EdgeInsets.all(0.w),
                    child: Image.asset(
                      "images/launcher_icon_ifd.png",
                    ))))
            : SearchWidget(
          widget.user,
          widget.list_partners,
          _currentLocation == null ? 0.0 : _currentLocation["latitude"],
          _currentLocation == null ? 0.0 : _currentLocation["longitude"],
          widget.analytics,
        ),
        elevation: 0.0,
        leading: Container(
          // padding: EdgeInsets.all(4),
            child: IconButton(
              onPressed: () {
                _scaffoldKey.currentState.openDrawer(); // CHANGE THIS LINE
              },
              icon: SvgPicture.asset(
                "images/mn.svg",
                color: Colors.white,
                width: 24.w,
                fit: BoxFit.cover,
              ),
            )),
        actions: [
          /*searchBar.getSearchAction(context)*/

          Padding(
              padding: EdgeInsets.all(4),
              child: IconButton(
                color: Fonts.col_app_fon,
                icon: new Stack(children: <Widget>[
                  new SvgPicture.asset("images/Notification.svg",
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width * 0.07,
                      height: 36),
                  new Positioned(
                    // draw a red marble
                    top: -2.0,
                    right: 0.0,
                    child: not.toString() != "null" && not.toString() != "false"
                        ? new Icon(Icons.brightness_1,
                        size: 12.0, color: Colors.redAccent)
                        : new Container(),
                  )
                ]),
                onPressed: () {
                  var gMessagesDbRef3 =
                  FirebaseDatabase.instance.reference().child("notif_new");
                  gMessagesDbRef3.update({widget.user.auth_id: false});

                  Navigator.push(context,
                      new MaterialPageRoute(builder: (BuildContext context) {
                        return new Listusers(widget.user, widget.auth, widget.sign,
                            widget.list_partners, Reload, widget.analytics);
                      }));
                },
              ))
        ]);
  }

  Reload() {
    new Timer(const Duration(seconds: 1), () {
      try {
        setState(() => loading = false);
      } catch (e) {
        e.toString();
      }
    });
  }

  connect_widgets() {
    List<Widget> list = [];

    list = loading
        ? [new Container()]
        : conn
        .map((ConnectModel con) => con.author.toString() == "null"
        ? new Container()
        : new Container(
        padding: new EdgeInsets.only(right: 2.0, left: 8.0),
        child: new ClipOval(
            child: new Container(
                color: Fonts.col_app,
                width: 30.0,
                height: 30.0,
                child: new Center(
                    child: FadingImage.network(
                      con.author["photoUrl"].toString(),
                      width: 36.0,
                      height: 36.0,
                      fit: BoxFit.cover,
                    ))))))
        .toList();

    list.add(count <= 0
        ? new Container()
        : new Container(
        padding: new EdgeInsets.only(right: 2.0, left: 8.0),
        child: new CircleAvatar(
          radius: 16.0,
          backgroundColor: Colors.orange[900],
          child: new Text(
            "+" + count.toString(),
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        )));

    list.add(loading
        ? new Container()
        : Container(
      width: 60.0,
      height: 30.0,
      padding: new EdgeInsets.only(right: 2.0, left: 8.0),
      child: RaisedButton(
        color: Colors.grey[50],
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0)),
        padding: new EdgeInsets.all(0.0),
        onPressed: () {
          Navigator.push(context,
              new MaterialPageRoute(builder: (BuildContext context) {
                return new UserListsRequests(
                    widget.user.id,
                    widget.user,
                    widget.auth,
                    widget.sign,
                    widget.list_partners,
                    Reload,
                    widget.analytics);
              }));
        },
        child: Text(
          "Details",
          style: TextStyle(
              color: Fonts.col_app_fon, fontWeight: FontWeight.w900),
        ),
      ),
    ));

    return list;
  }

  Widget buildBar(BuildContext context) {
    return _page == 0
        ? searchBar.build(context)
        : new AppBar(
        backgroundColor: Colors.grey[50],
        centerTitle: true,
        elevation: 1.0,
        bottom: _page == 2
            ? PreferredSize(
            preferredSize: Size.fromHeight(!_isVisible ? 60.0 : 110.0),
            child: Column(
              children: <Widget>[
                !_isVisible
                    ? new Container()
                    : Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 8.0),
                  child: TextField(
                    controller: _searchQuery,
                    decoration: InputDecoration(
                        counterStyle:
                        TextStyle(color: Colors.white),
                        isDense: true,
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 6.0),
                        hintText:
                        '  Chercher une conversation...',
                        enabledBorder: OutlineInputBorder(
                          // width: 0.0 produces a thin "hairline" border
                          borderSide: BorderSide(
                              color: Colors.grey[600],
                              width: 0.0),
                          borderRadius:
                          BorderRadius.circular(60.0),
                        ),
                        hintStyle:
                        TextStyle(color: Colors.grey[600]),
                        suffixIcon: Padding(
                          padding:
                          const EdgeInsetsDirectional.only(
                              end: 12.0),
                          child: Icon(
                            Icons.search,
                            color: Colors.grey[600],
                            size: 30.0,
                          ), // icon is 48px widget.
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey[50], width: 0.0),
                          borderRadius:
                          BorderRadius.circular(60.0),
                        ),
                        filled: true),
                  ),
                ),
                conn.isEmpty
                    ? new Container()
                    : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        width: 8.0,
                      ),
                      new Text(
                        "Demandes en attente: ",
                        style: new TextStyle(
                            color: Colors.grey[50],
                            fontWeight: FontWeight.w500),
                      )
                    ]),
                Container(
                    height: 50.0,
                    child: conn.isEmpty
                        ? new Container()
                        : Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: connect_widgets()))
              ],
            ))
            : PreferredSize(
            preferredSize: Size.fromHeight(0.0), child: Container()),
        actions: <Widget>[
          !_isVisible
              ? new IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                setState(() {
                  _isVisible = true;
                });
              })
              : new Container()
        ]);
  }

  Map<String, double> _currentLocation;

  StreamSubscription<Map<String, double>> _locationSubscription;

  Location _location = new Location();

  initPlatformState() async {
    Map<String, double> location;
    // Platform messages may fail, so we use a try/catch PlatformException.

    try {
      // _permission = await _location.hasPermission();

      print("jojoojoj");
      location = await Location_service.getLocation();

      lat = location["latitude"];
      lng = location["longitude"];

      print(lat);
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print(e.code);
        setState(() {
          gps_none = false;
        });
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        print(e.code);
        setState(() {
          gps_none = false;
        });
      }

      location = null;
    }
  }

  getLocation() async {
    await initPlatformState();

    var js = {
      "location": {"__type": "GeoPoint", "latitude": lat, "longitude": lng},
      "lat": lat,
      "lng": lng,
    };

    await parse_s.putparse("users/" + widget.user.id, js);

    setState(() {
      load_location = true;
    });
  }

  make_user_online() async {
    Map<String, dynamic> map = new Map<String, dynamic>();
    map["online"] = true;
    map["last_active"] = 0;
    print(
        "------------------------------------------------update data--------------------------------------------------------");
    await Firestore.instance
        .collection('users')
        .document(widget.user.auth_id)
        .updateData(map);

    FirebaseDatabase.instance
        .reference()
        .child("status")
        .update({widget.user.auth_id: true});
    FirebaseDatabase.instance
        .reference()
        .child("status")
        .onDisconnect()
        .update({widget.user.auth_id: false});
  }

  bool not = false;

  bool not_msg = false;

  notif_msg() async {
    FirebaseUser my_id = await FirebaseAuth.instance.currentUser();

    FirebaseDatabase.instance
        .reference()
        .child("notif_new_msg/" + my_id.uid)
        .onValue
        .listen((val) {
      var d = val.snapshot.value;
      setState(() {
        not_msg = d;
      });
    });
  }

  setNotifi() async {
    FirebaseUser my_id = await FirebaseAuth.instance.currentUser();

    FirebaseDatabase.instance
        .reference()
        .child("notif_new/" + my_id.uid)
        .onValue
        .listen((val) {
      var d = val.snapshot.value;
      setState(() {
        not = d;
      });
    });
  }

  bool _isVisible = true;

  func_change_index(indx) {
    print("--------------------------------------------------------");
    print(indx);
    setState(() {
      _page = indx;
    });
  }

  @override
  void initState() {
    super.initState();
    print("%%%%%%%  ${widget.user.token} %%%%");
    _isVisible = true;
    _hideButtonController = new ScrollController();
    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        setState(() {
          _isVisible = false;
        });
      }
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.forward) {
        setState(() {
          _isVisible = true;
        });
      }
    });

    getLocation().then((_) {
      setNotifi();
      notif_msg();
      make_user_online();
      getRequestLIst();

      print(gps_none);
      /* if (widget.show_menu) {
        if (gps_none == true) {
          new Future.delayed(Duration.zero, () {
            showDialog(
                context: context,
                builder: (context) => new AlertDialog(
                    titlePadding: EdgeInsets.all(0.0),
                    contentPadding: EdgeInsets.only(top: 8.0),
                    content: new Container(
                        height: 420.0,
                        width: 800.0,
                        child: Center(
                            child: Grid_view(
                                _pageController,
                                lat,
                                lng,
                                widget.user,
                                widget.auth,
                                widget.list_partners,
                                widget.analytics,
                                func_change_index,
                                _page)))));
          });
        }
      }*/
    });

    _IsSearching = false;

    if (widget.animate != null) {
      new Timer(const Duration(seconds: 2), () {
        _pageController.animateToPage(1,
            duration: const Duration(milliseconds: 300), curve: Curves.ease);
      });
    }
  }

  navigationTapped(int page) async {
    getLocation();
    try {
      setState(() {
        this._page = page;
      });

      print(this._page);

      if (this._page == 4) {
        _pageController.animateToPage(3,
            duration: const Duration(milliseconds: 100), curve: Curves.ease);
        /* var gMessagesDbRef3 =
            FirebaseDatabase.instance.reference().child("notif_new");
        gMessagesDbRef3.update({widget.user.auth_id: false});*/
      } else if (this._page == 3) {
        _pageController.animateToPage(2,
            duration: const Duration(milliseconds: 100), curve: Curves.ease);

        var gMessagesDbRef3 =
        FirebaseDatabase.instance.reference().child("notif_new_msg");
        gMessagesDbRef3.update({widget.user.auth_id: false});
      } else {
        _pageController.animateToPage(this._page,
            duration: const Duration(milliseconds: 100), curve: Curves.ease);
      }
    } catch (e) {}
  }

  out() {
    if (_page != 0) {
      setState(() {
        _page = 0;
        _isVisible = true;
      });
      _pageController.animateToPage(0,
          duration: const Duration(milliseconds: 100), curve: Curves.ease);
    } else {
      Widgets.exitapp(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () {
          out();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          drawer: new Drawer(
              child: new Menu(
                  widget.user,
                  widget.user.id,
                  widget.auth,
                  widget.sign,
                  lat,
                  lng,
                  widget.list_partners,
                  widget.analytics)),
          appBar: _page == 2 ? buildBar(context) : searchBar.build(context),
          key: _scaffoldKey,
          body: new PageView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                StreamPots(
                    widget.user,
                    _currentLocation == null
                        ? 0.0
                        : _currentLocation["latitude"],
                    _currentLocation == null
                        ? 0.0
                        : _currentLocation["longitude"],
                    widget.list_partners,
                    widget.analytics),
                FilterPage(widget.user),

                /* HomePage(
                            widget.auth,
                            widget.sign,
                        _currentLocation == null?0.0:   _currentLocation["latitude"],
                        _currentLocation == null?0.0:  _currentLocation["longitude"],
                            widget.user,
                            widget.list_partners,
                            Reload,
                            widget.analytics),*/
                new MessagesList(
                    widget.user,
                    widget.user.auth_id,
                    _searchText,
                    _hideButtonController,
                    widget.list_partners,
                    Reload,
                    widget.auth,
                    widget.analytics),
                new MyProfile(widget.user, false, true, lat, lng,
                    widget.list_partners, widget.analytics),
              ],
              controller: _pageController),
          //extendBodyBehindAppBar: true,
          extendBody: true,
          bottomNavigationBar: Container(
              height: Platform.isIOS?124.h:100.h,
              child: BottomAppBar(
                  color: Colors.transparent,
                  elevation: 0.0,
                  child: BottomNavigationDotBar(
                      activeColor: Fonts.col_app,
                      color: Fonts.col_app_grey,
                      indexPageSelected: _page,
                      func: show,
                      items: items
                          .map((icon) => BottomNavigationDotBarItem(
                          icon: icon["icon"],
                          name: icon["name"],
                          onTap: () {
                            int p = items.indexWhere((element) =>
                            element["icon"] == icon["icon"]);

                            if (p == 3) {
                              _pageController.animateToPage(2,
                                  duration:
                                  const Duration(milliseconds: 300),
                                  curve: Curves.ease);
                            } else if (p == 4) {
                              _pageController.animateToPage(3,
                                  duration:
                                  const Duration(milliseconds: 300),
                                  curve: Curves.ease);
                            } else
                              _pageController.animateToPage(
                                  items.indexWhere((element) =>
                                  element["icon"] == icon["icon"]),
                                  duration:
                                  const Duration(milliseconds: 300),
                                  curve: Curves.ease);

                            /* setState(() {
                          load = true;
                          _page =  icons.indexWhere((element) =>
                          element["icon"] ==
                              icon["icon"]);
                        });

                       new Timer(new Duration(milliseconds: 100), () {
                          setState(() {
                            load = false;
                          });
                        });
                        _pageController.animateToPage(
                            icons.indexWhere((element) =>
                            element["icon"] ==
                                icon["icon"]),
                            duration: const Duration(
                                milliseconds: 300),
                            curve: Curves.ease);*/

                            /* Cualquier funcion - [abrir nueva venta] */
                          }))
                          .toList())) /*BubbleBottomBar(
            backgroundColor: Colors.black,
            opacity: .3,
            currentIndex: _page,
            onTap: navigationTapped,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            elevation: 8,
            fabLocation: BubbleBottomBarFabLocation.end,
            //new
            hasNotch: true,
            //new
            hasInk: true,
            //new, gives a cute ink effect
            items: <BubbleBottomBarItem>[
              BubbleBottomBarItem(
                  backgroundColor: Colors.white,
                  title: Text(
                    "Accueil",
                    style: TextStyle(fontSize: 15.5),
                  ),
                  icon: new Container(
                      padding: EdgeInsets.only(bottom: 4),
                      width: 24.0,
                      height: 24.0,
                      child: new Image.asset(
                        _page != 0 ? "images/home.png" : "images/home.png",
                        color: Colors.grey[200],
                      )),
                  activeIcon: new Container(
                      padding: EdgeInsets.only(bottom: 4),
                      width: 24.0,
                      height: 24.0,
                      child: new Image.asset(
                        _page != 0 ? "images/hom.png" : "images/hom.png",
                        color: Colors.white,
                      ))),
              BubbleBottomBarItem(
                backgroundColor: Colors.white,
                title: Text(
                  "Networking",
                  style: TextStyle(fontSize: 14.5),
                ),
                icon: new Container(
                    padding: EdgeInsets.only(bottom: 4),
                    width: 24.0,
                    height: 24.0,
                    child: new Image.asset("images/res.png",
                        color: Colors.grey[200])),
                activeIcon: new Container(
                    padding: EdgeInsets.only(bottom: 4),
                    width: 24.0,
                    height: 24.0,
                    child: new Image.asset("images/resw.png",
                        color: Colors.white)),
              ),
              BubbleBottomBarItem(
                  backgroundColor: Colors.white,
                  title: Text(
                    "Messages",
                    style: TextStyle(fontSize: 14.5),
                  ),
                  icon: new Container(
                      padding: EdgeInsets.only(bottom: 4),
                      width: 24.0,
                      height: 24.0,
                      child: new Stack(children: <Widget>[
                        new Image.asset(
                          "images/chat.png",
                          color: _page != 2
                              ? Colors.grey[200]
                              : Fonts.col_app_green,
                        ),
                        new Positioned(
                          // draw a red marble
                          top: -2.0,
                          right: 0.0,
                          child: not_msg.toString() != "null" &&
                                  not_msg.toString() != "false"
                              ? new Icon(Icons.brightness_1,
                                  size: 12.0, color: Colors.redAccent)
                              : new Container(),
                        )
                      ])),
                  activeIcon: new Stack(children: <Widget>[
                    new Container(
                        padding: EdgeInsets.only(bottom: 4),
                        width: 24.0,
                        height: 24.0,
                        child: new Image.asset(
                          "images/chatw.png",
                          color: Colors.white,
                        )),
                    new Positioned(
                      // draw a red marble
                      top: -2.0,
                      right: 0.0,
                      child: not_msg.toString() != "null" &&
                              not_msg.toString() != "false"
                          ? new Icon(Icons.brightness_1,
                              size: 12.0, color: Colors.redAccent)
                          : new Container(),
                    )
                  ])),
              BubbleBottomBarItem(
                  backgroundColor: Colors.white,
                  title: Text(
                    "Profil",
                    style: TextStyle(fontSize: 15.5),
                  ),
                  icon: new Container(
                      padding: EdgeInsets.only(bottom: 4),
                      width: 24.0,
                      height: 24.0,
                      child: new Image.asset(
                          _page != 3 ? "images/user.png" : "images/usern.png",
                          color: Colors.grey[200])),
                  activeIcon: new Container(
                      padding: EdgeInsets.only(bottom: 4),
                      width: 24.0,
                      height: 24.0,
                      child: new Image.asset("images/usern.png",
                          color: Colors.white))),
            ],
          )*/
          ),
          /*floatingActionButton: FloatingActionButton(
            onPressed: () {
              show();
            },
            child: Icon(
              Icons.add,
              size: 32,
            ),
            backgroundColor: Fonts.col_app_green,
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,*/
        ));
  }
}
