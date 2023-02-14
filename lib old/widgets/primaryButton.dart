import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PrimaryButton extends StatefulWidget {
  final bool inverted;
  final Color iconColor;
  String text;
  final Widget prefix;
  final Color color;
  final Color disabledColor;
  final TextStyle textStyle;
  final bool enabled;
  final bool isLoading;
  final void Function() onTap;
  double fonsize;
  final String icon;
  final Color colorText;

  PrimaryButton(
      {this.inverted = false,
      this.iconColor = Colors.white,
      this.colorText = Colors.white,
      @required this.text,
      @required this.fonsize,
      @required this.prefix,
      @required this.icon,
      @required this.color,
      @required this.disabledColor,
      @required this.textStyle,
      this.enabled = true,
      this.isLoading = false,
      @required this.onTap})
      : super();

  @override
  _SecPrimaryButtonState createState() => _SecPrimaryButtonState();
}

class _SecPrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.enabled ? widget.onTap : null,
      child: Container(
        height: 52,
        constraints: BoxConstraints(
          minWidth: double.infinity,
        ),
        padding: EdgeInsets.symmetric(
          vertical: 0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: widget
              .color /*widget.enabled == true
             /* ? (widget.color ??
              (widget.inverted == true ? Colors.transparent : COLOR_CONST.col_app))
              : */(widget.disabledColor ?? COLOR_CONST.col_grey)*/
          ,
          border: !widget.inverted || !widget.enabled
              ? null
              : Border.all(color: Colors.white, width: 1),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            if (widget.prefix != null)
              Positioned.directional(
                textDirection: Directionality.of(context),
                start: 37,
                child: widget.prefix,
              ),
            if (widget.isLoading)
              CupertinoTheme(
                data: CupertinoTheme.of(context)
                    .copyWith(brightness: Brightness.dark),
                child: CupertinoActivityIndicator(),
              ),
            Visibility(
              visible: !widget.isLoading,
              maintainAnimation: true,
              maintainSize: true,
              maintainState: true,
              child: Container(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.icon == ""
                      ? Container()
                      : SvgPicture.asset(
                          widget.icon,
                          color: widget.iconColor,
                          width: 16,
                        ),
                  Container(width: widget.icon == "" ? 0 : 4),
                  Text(
                    widget.text,
                    style: TextStyle(
                      fontSize: widget.fonsize,
                      fontWeight: FontWeight.w600,
                      color: widget.colorText,
                    ),
                  ),
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }
}
