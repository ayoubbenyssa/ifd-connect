import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ifdconnect/accueil/repositories/home_response.dart';
import 'package:ifdconnect/accueil/widgets/ytbe_video.dart';
import 'package:ifdconnect/models/offers.dart';
import 'package:ifdconnect/widgets/widgets.dart';

class VideosList extends StatefulWidget {
  const VideosList({Key key}) : super(key: key);

  @override
  _VideosListState createState() => _VideosListState();
}

class _VideosListState extends State<VideosList> {
  List<Offers> videos = [];

  getVideos() async {
    HomeRepository.get_allVideos("all").then((value) {
      if (!this.mounted) return;
      setState(() {
        videos = value.publications;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 4.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        height: 120.h,
        child: videos.isEmpty
            ? Center(
                child: Widgets.load(),
              )
            : ListView(
                // padding: EdgeInsets.all(12.w),
                // scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: videos
                    .map((e) => Container(
                        margin: EdgeInsets.all(8.w),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0.r),
                            child: YtbeVideo(e.link_id,
                                MediaQuery.of(context).size.width, 220.h))))
                    .toList()));
  }
}
