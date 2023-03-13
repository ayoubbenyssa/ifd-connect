import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextFieldWidgetMulti extends StatelessWidget {
  TextFieldWidgetMulti(this.name, this.focus, this.myController,
      this.type, this.validator,
      {this.obscure = false, this.submit});

  String name;
  FocusNode focus;
  TextEditingController myController = new TextEditingController();
  var validator;
  var type;
  bool obscure;
  var submit;

  @override
  Widget build(BuildContext context) {



    Widget textfield = TextFormField(
      style: new TextStyle(fontSize: 16.0.sp, color: Colors.black),
      obscureText: obscure,
      controller: myController,
      focusNode: focus,
      maxLines: 5,
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: new EdgeInsets.all(8.0),
        hintText: name,
        hintStyle: new TextStyle(fontSize: 16.0.sp, color: Colors.grey),
      ),
      keyboardType: type,
      validator: validator,
      onChanged: (val){
        // myController.text = val;
        submit();
      },

    );

    return textfield;
  }
}
