import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ifdconnect/accueil/widgets/ytbe_video.dart';
import 'package:ifdconnect/models/offers.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/widgets/widgets.dart';

class VideosSlide extends StatelessWidget {
  VideosSlide(this.videos, {Key key}) : super(key: key);
  List<Offers> videos = [];

  @override
  Widget build(BuildContext context) {

    return Container(
        margin: EdgeInsets.only(top: 4.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        height: 120.h,
        child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: videos
                .map((e) => Container(
                margin: EdgeInsets.only(right: 8.w),
                child: YtbeVideo(e.link_id, 190.w, 120.h)))
                .toList()));
  }
}
