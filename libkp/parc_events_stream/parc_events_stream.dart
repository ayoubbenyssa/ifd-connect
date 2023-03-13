import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ifdconnect/widgets/widgets.dart';

//import 'package:flutter_nativeads/flutter_nativeads.dart';
import 'package:latlong/latlong.dart';
import 'package:ifdconnect/cards/ads_card.dart';
import 'package:ifdconnect/cards/annonce_card.dart';
import 'package:ifdconnect/cards/promotion_card.dart';
import 'package:ifdconnect/cards/pub_parc_card.dart';
import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/models/annonces.dart';
import 'package:ifdconnect/models/favorite.dart';
import 'package:ifdconnect/models/offers.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/parc_events_stream/stream_parc_events_func.dart';
import 'package:ifdconnect/search/search_user_widget.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/shop/data.dart';
import 'package:ifdconnect/shop/widgets/hot_product_card.dart';
import 'package:ifdconnect/shop/widgets/product_list_item.dart';
import 'package:ifdconnect/shop/widgets/shimmer_widgets.dart';

class StreamParcPub extends StatefulWidget {
  StreamParcPub(this.widgetheader, this.lat, this.lng, this.user, this.tpe,
      this.list_partner, this.analytics,
      {this.widgetfooter,
      this.auth,
      this.category,
      this.sector,
      this.boutique,
      this.type,
      this.likepost,
      this.dep,
      this.dest,
      this.da,
      this.user_id_cov,
      this.search,
      this.cat,
      this.favorite,
      this.context,
      Key key})
      : super(key: key);
  final Widget widgetheader;
  final Widget widgetfooter;
  var lat;
  var lng;
  var auth;
  String tpe;
  List list_partner;
  var likepost;
  User user;
  var sector;
  final String type;
  var dep;
  var dest;
  var da;
  var cat;
  String user_id_cov;
  bool boutique = false;
  bool favorite = false;
  var context;
  final String category;
  var analytics;
  var search = "";

//  final User current;

  @override
  _StreamPostsState createState() => new _StreamPostsState();
}

class _StreamPostsState extends State<StreamParcPub> {
  ScrollController scrollController = new ScrollController();

  StreamPostsFunctions streamPosts = new StreamPostsFunctions();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  SliverPersistentHeaderDelegate delegate;
  List listWidget = new List();
  bool isLoading = true;
  var skip = 0;
  var count = 0;
  var count2 = 0;
  var noPost = "";
  ParseServer parseFunctions = new ParseServer();

  //calculate distance
  Distance distance = new Distance();

  getdata() async {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (count2 < count) streampost(count2);
      }
    });
    streampost(skip);
  }

  getrefresh() {
    streampost(0);
    Completer<Null> completer = new Completer<Null>();
    new Timer(new Duration(seconds: 3), () {
      completer.complete();
    });
    return completer.future;
  }

  streampost(skipp) async {
    if (skipp == 0) listWidget = new List();

    var result = await streamPosts.fetchposts(widget.user,
        category: widget.category,
        cat: widget.cat,
        type: widget.type,
        likepost: widget.likepost,
        skip: skipp,
        search: widget.search,
        sector: widget.sector,
        dep: widget.dep,
        dest: widget.dest,
        da: widget.da,
        boutique: widget.boutique,
        favorite: widget.favorite,
        user_cov_id: widget.user_id_cov);

    if (!this.mounted) return;

    try {
      setState(() => isLoading = false);
    } catch (e) {
      e.toString();
    }
    if (result == "nointernet" || result == "error")
      errorrequest(result);
    else if (result == "empty" || result == "nomoreresults")
      noPosts(result);
    else
      showwidgets(result);
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

  noPosts(type) {
    try {
      if (type == "nomoreresults")
        setState(() => noPost = "Il n y'a aucun autre résultat");
      else
        setState(() => noPost = "Aucun résultat trouvé");
    } catch (e) {
      e.toString();
    }
  }

  showwidgets(result) {
    if (skip == 0) count = result["count"];

    if (result["results"].length != 0) {
      for (var post in result["results"]) {
        count2++;

        //UserSearchWidget(widget.user_me,user,widget.list, widget.analytics)

        if (widget.search != "" && widget.search != null) {
          User postdata;
          postdata = post;

          listWidget.add(UserSearchWidget(
              widget.user, postdata, widget.list_partner, widget.analytics));

          setState(() => skip += 20);
        } else if (widget.favorite == true) {
          Favorite postdata;
          postdata = post;
          if (postdata.offer.latLng.isEmpty) {
            postdata.offer.dis = "-.- Km";
          } else {
            postdata.offer.dis = distance
                    .as(
                        LengthUnit.Kilometer,
                        new LatLng(
                            double.parse(postdata.offer.latLng.split(";")[0]),
                            double.parse(postdata.offer.latLng.split(";")[1])),
                        new LatLng(widget.lat, widget.lng))
                    .toString() +
                " Km(s)";
          }
          listWidget.add(ProductCard(postdata.offer, widget.user));
          setState(() => skip += 20);
        } else if (widget.boutique == true) {
          Offers postdata;
          postdata = post;
          parseFunctions.putparse(
              "offers/" + postdata.objectId, {"views": postdata.views + 1});

          if (postdata.latLng.isEmpty) {
            postdata.dis = "-.- Km";
          } else {
            postdata.dis = distance
                    .as(
                        LengthUnit.Kilometer,
                        new LatLng(double.parse(postdata.latLng.split(";")[0]),
                            double.parse(postdata.latLng.split(";")[1])),
                        new LatLng(widget.lat, widget.lng))
                    .toString() +
                " Km(s)";
          }
          listWidget.add(ProductCard(postdata, widget.user));
          setState(() => skip += 20);
        } else if (widget.category != "" &&
                widget.category != null &&
                widget.category == "promotion" ||
            widget.sector != "" && widget.sector != null) {
          Offers postdata;
          postdata = post;
          parseFunctions.putparse(
              "offers/" + postdata.objectId, {"views": postdata.views + 1});

          if (postdata.latLng.isEmpty) {
            postdata.dis = "-.- Km";
          } else {
            postdata.dis = distance
                    .as(
                        LengthUnit.Kilometer,
                        new LatLng(double.parse(postdata.latLng.split(";")[0]),
                            double.parse(postdata.latLng.split(";")[1])),
                        new LatLng(widget.lat, widget.lng))
                    .toString() +
                " Km(s)";
          }

          /*  if (result["results"].indexOf(post) % 2 == 0) {
            listWidget.add(AppInstalledAd());
          }*/

          listWidget
              .add(new PromotionsCard(postdata, widget.user, false, true));
          setState(() => skip += 20);
        } else if (widget.category != "" && widget.category != null) {
          Offers postdata;
          postdata = post;
          parseFunctions.putparse(
              "offers/" + postdata.objectId, {"views": postdata.views + 1});

          /*if (postdata.latLng.isEmpty) {
            postdata.dis = "-.- Km";
          } else {
            postdata.dis = distance
                    .as(
                        LengthUnit.Kilometer,
                        new LatLng(double.parse(postdata.latLng.split(";")[0]),
                            double.parse(postdata.latLng.split(";")[1])),
                        new LatLng(widget.lat, widget.lng))
                    .toString() +
                " Km(s)";
          }*/

          /* if (result["results"].indexOf(post) % 1 == 0) {
            listWidget.add(AppInstalledAd());
          }*/

          listWidget.add(new ParcPubCard(
              postdata,
              widget.user,
              widget.tpe,
              widget.list_partner,
              widget.auth,
              widget.analytics,
              widget.context,
              widget.lat,
              widget.lng));
          setState(() => skip += 20);
        } else if (widget.likepost != null && widget.likepost != "") {
          User postdata;
          postdata = post;

          listWidget.add(UserSearchWidget(
              widget.user, postdata, widget.list_partner, widget.analytics));

          setState(() => skip += 20);
        } else if (widget.type != "" && widget.type != null) {
          Offers postdata;
          postdata = post;

          parseFunctions.putparse(
              "offers/" + postdata.objectId, {"views": postdata.views + 1});

          listWidget.add(new AnnonceCard(
            postdata,
            widget.user,
            null,
            null,
            widget.analytics,
            null,
            widget.list_partner,
          ));
          setState(() => skip += 20);
        }
      }

      if (count2 >= count) {
        noPosts("nomoreresults");
      } else {}
    }
  }

  @override
  initState() {
    super.initState();
    getdata();
    // setupNativeAd();
  }

  @override
  Widget build(BuildContext context) {
    Widget buildBody(BuildContext context) {
      Widget loading = new SliverToBoxAdapter(
          child: Padding(
              padding: EdgeInsets.all(32),
              child: Widgets.load()));
      Widget bottom = new SliverToBoxAdapter(
          child: new Center(
              child: new Container(
                  padding: const EdgeInsets.only(
                      top: 85.0, left: 16.0, right: 16.0, bottom: 16.0),
                  child: new Text(noPost))));
      Widget silverheader = new SliverToBoxAdapter(child: widget.widgetheader);

      Widget listposts = widget.boutique || widget.favorite
          ? new SliverGrid.count(
              crossAxisCount: 2,
              childAspectRatio: 0.90,
              //mainAxisSpacing: 4.0,
              //crossAxisSpacing: 4.0,
              children: new List<Widget>.from(listWidget))
          : new SliverList(
              delegate: new SliverChildListDelegate(
                  new List<Widget>.from(listWidget)));

      Widget scrollview =
          new CustomScrollView(controller: scrollController, slivers: [
        silverheader,
        // widget.silver == null ? new SliverToBoxAdapter() : widget.silver,
        isLoading
            ? widget.boutique || widget.favorite
                ? ShimmerWidgets.shimmerlist()
                : loading
            : listposts,
        bottom
      ]);
      return new RefreshIndicator(
          onRefresh: () => getrefresh(),
          child: scrollview,
          key: _refreshIndicatorKey);
    }

    return widget.user_id_cov.toString() != "null" && widget.user_id_cov != ""
        ? new SliverList(
            delegate:
                new SliverChildListDelegate(new List<Widget>.from(listWidget)))
        : new Builder(builder: buildBody);
  }
}
