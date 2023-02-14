import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ifdconnect/app/filters_users_bloc/filter_bloc.dart';
import 'package:ifdconnect/app/users_filter_repository.dart';
import 'package:ifdconnect/commeents/comment_bloc/comments_bloc.dart';
import 'package:ifdconnect/commeents/comment_repository.dart';
import 'package:ifdconnect/login/rout_page.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _StateApp createState() => _StateApp();
}

class _StateApp extends State<MyApp> {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
  FirebaseAnalyticsObserver(analytics: analytics);
  final CommentsRepository commentsRepos = CommentsRepository();

  FilterUsersRepository flt = FilterUsersRepository();

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<FilterUsersRepository>(create: (context) => flt),
        ],
        child: MultiBlocProvider(
            providers: [
              BlocProvider<CommentsBloc>(
                create: (_) => CommentsBloc(commentsRepository: commentsRepos),
              ),
              BlocProvider<FilterUsersBloc>(
                create: (_) => FilterUsersBloc(filterRepository: flt),
              ),
            ],
            child: ScreenUtilInit(
                designSize: Size(375, 812),
                builder: () => new MaterialApp(
                  title: 'IFD CONNECT',
                  localizationsDelegates: [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: [
                    const Locale('fr'),
                  ],
                  debugShowCheckedModeBanner: false,
                  navigatorObservers: <NavigatorObserver>[observer],
                  theme: new ThemeData(
                      fontFamily: "Helvetica", primaryColor: Fonts.col_app),
                  home: new RootPage(
                      analytics: analytics, observer: observer),
                ))));
  }
}
