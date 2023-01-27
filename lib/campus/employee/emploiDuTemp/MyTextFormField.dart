import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class MyTextFormField extends StatelessWidget {
  MyTextFormField(
      {this.name,
        this.ctrl,
        this.focus,
        this.type,
        this.validation,
        this.suffix});

  String name;
  TextEditingController ctrl;
  FocusNode focus;
  TextInputType type;
  Function validation;
  Widget suffix;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
        // height: widget.height,
        child: new TextFormField(
          validator: (value) => validation(value),
          controller: ctrl,
          // focusNode: focus,
          keyboardType: type,
          decoration: InputDecoration(
            suffixIcon:
            suffix == null ? SizedBox(width: 0.2,height: 0.2,) : Icon(Icons.date_range_rounded),
            fillColor: Colors.grey[100],
            filled: true,
            enabledBorder: new OutlineInputBorder(
              // width: 0.0 produces a thin "hairline" border
              borderSide: new BorderSide(color: Colors.grey[300], width: 0.0),
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
