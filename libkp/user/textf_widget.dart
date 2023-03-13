import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyTextFormField extends StatelessWidget {
  MyTextFormField(
      {this.name, this.ctrl, this.focus, this.type, this.validation});

  String name;
  TextEditingController ctrl;
  FocusNode focus;
  TextInputType type;
  Function validation;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
        padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
        // height: widget.height,
        child: new TextFormField(
          validator: (value) => validation(value),
          controller: ctrl,
          focusNode: focus,
          keyboardType: type,
          style: new TextStyle(
              color: Colors.grey[800], fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            hintStyle: new TextStyle(
                color: Colors.grey[800], fontWeight: FontWeight.w600),
            filled: true,
            enabledBorder: new OutlineInputBorder(
              // width: 0.0 produces a thin "hairline" border
              borderSide: new BorderSide(color: Colors.white, width: 0.0),
            ),
            hintText: name,
            contentPadding:
                EdgeInsets.all(ScreenUtil().setWidth(14)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                    ScreenUtil().setWidth(10))),
          ),
        ));
  }
}
