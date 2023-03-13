import 'package:flutter/material.dart';
import 'package:ifdconnect/services/Fonts.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  AppAppBar({@required this.title_widget, Key key}) : super(key: key);

  Widget title_widget;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Fonts.col_app,
      centerTitle: true,
      title: title_widget,
      iconTheme: IconThemeData(color: Colors.white),
      shadowColor: Colors.transparent,
      elevation: 0,
      actions: [

      ],
    );
  }

  static final _appBar = AppBar();

  @override
  Size get preferredSize => _appBar.preferredSize;
}
