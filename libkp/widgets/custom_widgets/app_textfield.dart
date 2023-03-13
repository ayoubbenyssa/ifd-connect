import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ifdconnect/services/Fonts.dart';

class TextFieldWidget extends StatelessWidget {
  TextFieldWidget(
    this.name,
    this.focus,
    this.myController,
    this.type,
    this.validator, {
    this.obscure = false,
    this.prefixWidget,
    this.submit,
    this.suffixIcon,
    this.maxLines = 1,
  });

  String name;
  FocusNode focus;
  final prefixWidget;
  TextEditingController myController = new TextEditingController();
  var validator;
  String suffixIcon;
  var type;
  bool obscure;
  int maxLines = 1;

  var submit;

  @override
  Widget build(BuildContext context) {
    Widget textfield = TextFormField(
      style: new TextStyle(fontSize: 13.5.sp, color: Colors.black),
      obscureText: obscure,
      controller: myController,
      focusNode: focus,
      maxLines: maxLines,
      decoration: InputDecoration(
          suffixIcon: prefixWidget == null
              ? SizedBox(width: 1, height: 1)
              : prefixWidget,
         /* prefixIcon: suffixIcon == ""
              ? null
              : Container(
                  padding: EdgeInsets.only(
                    top: 12.w,
                    bottom: 12.w,
                  ),
                  child: SvgPicture.asset(suffixIcon,
                      width: 12.w, height: 8.h, color: Fonts.col_text)),*/
          contentPadding: new EdgeInsets.symmetric(horizontal:20.0.w,vertical: 10.h),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 5.0),
          ),
          fillColor: Fonts.col_cl,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.r)),
            borderSide:
                BorderSide(width: 1, color: Fonts.border_col),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.r)),
            borderSide:
                BorderSide(width: 1, color: Fonts.border_col),
          ),
          hintText: name,
          hintStyle: Fonts.sub_title),
      keyboardType: type,
      validator: validator,
      onChanged: (val) {
        if (submit != null) {
          submit();
        }
      },
      /* onSaved: (val) {
        myController.text = val;
        submit();
      },
      onFieldSubmitted: (val) {
        myController.text = val;
        submit();
      },*/
    );

    return textfield;
  }
}

