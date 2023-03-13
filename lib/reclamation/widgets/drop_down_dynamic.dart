import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ifdconnect/services/Fonts.dart';

class DropDownBtnWidgetDynamicList extends StatelessWidget {
  const DropDownBtnWidgetDynamicList(
      {this.hint,
      this.selectedValue,
      this.listItem,
      this.leftIcon,
      this.onChanged,
      this.width,
      this.color,
      this.border,
      this.color_text,
      this.open_func,
      Key key})
      : super(key: key);
  final String hint;
  final dynamic selectedValue;
  final List<DropdownMenuItem<dynamic>> listItem;
  final String leftIcon;
  final dynamic onChanged;
  final Color color;
  final double width;
  final Color color_text;
  final Border border;
  final Function open_func;

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: Container(
                  height: 42,
                  padding: EdgeInsets.symmetric(vertical: 6.h),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: border,
                    borderRadius: BorderRadius.circular(30),
                    color: color ?? Fonts.col_app_shadow,
                  ),
                  child: Row(children: [
                    SizedBox(
                      width: 8.w,
                    ),
                    leftIcon == ""
                        ? Container()
                        : SvgPicture.asset("assets/icons/$leftIcon.svg"),
                    SizedBox(
                      width: leftIcon == "" ? 0 : 16.w,
                    ),
                    Expanded(
                        child: DropdownButtonHideUnderline(

                      child: DropdownButton(

                        value: selectedValue,
                        //  buttonHeight: 42.h,
                        itemHeight: 100,
                        style: const TextStyle(fontSize: 11.0),
                        iconEnabledColor: Fonts.col_app,
                        underline: const SizedBox(),
                        icon: Padding(
                          padding: EdgeInsets.only(right: 8.0.w),
                          child: Icon(Icons
                              .arrow_forward_ios) /*SvgPicture.asset("assets/icons/arrow.svg")*/,
                        ),
                        iconSize: 24,
                        isExpanded: true,
                        /**
                             *     SvgPicture.asset("assets/icons/$leftIcon.svg"),
                                SizedBox(
                                width: 16.w,
                                ),
                             */
                        hint: Text(hint,
                            style: TextStyle(
                                fontSize: 14,
                                color: color_text ?? Colors.grey[800])),
                        items: listItem,
                        onChanged: onChanged,

                        /*
         Row(children: [
          SvgPicture.asset("assets/icons/$leftIcon.svg"),
          SizedBox(
            width: 16.w,
          ),
         */
                        // iconDisabledColor: Colors.grey,
                        // buttonWidth: 160,
                        //buttonPadding: EdgeInsets.only(left: 8.w, right: 8.w),
                        /*buttonDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: color ?? Fonts.col_app.withOpacity(0.1),
                            ),
                            //  buttonElevation: 2,

                            itemPadding: EdgeInsets.only(left: 14.w, right: 14.w),
                            dropdownMaxHeight: 480.h,*/
                        //dropdownWidth: width ?? 280.w,
                        // dropdownWidth: 280.w,
                        // dropdownPadding: const EdgeInsets.only(left: 14, right: 14),

                        //dropdownElevation: 8,
                      ),
                    ))
                  ])))
        ]);
  }
}
