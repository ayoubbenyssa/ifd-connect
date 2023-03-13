import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/reclamation/drop_down_thematique.dart';
import 'package:ifdconnect/reclamation/dropdown_type_reclamation.dart';
import 'package:ifdconnect/reclamation/provider/reclamation_provider.dart';
import 'package:ifdconnect/reclamation/widgets/drop_down_priority.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/widgets/custom_widgets/app_textfield.dart';
import 'package:ifdconnect/widgets/custom_widgets/primary_button.dart';
import 'package:ifdconnect/widgets/widgets.dart';
import 'package:provider/provider.dart';

class FormReclamation extends StatefulWidget {
  FormReclamation(this.user, {Key key}) : super(key: key);
  User user;

  @override
  _FormReclamationState createState() => _FormReclamationState();
}

class _FormReclamationState extends State<FormReclamation> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _autovalidate = false;
  final _descctrl = new TextEditingController();
  FocusNode _descfocus = new FocusNode();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  ParseServer parse_s = new ParseServer();

  bool load = false;



  go(provider) async {

    setState(() {
      load = true;
    });
   // final provider = context.read<ReclamationProvider>();

    await parse_s.postparse('Reclamation', {
      "user": {
        "__type": "Pointer",
        "className": "users",
        "objectId": widget.user.id
      },
      "thematique": {
        "__type": "Pointer",
        "className": "Thematique",
        "objectId": provider.selectedThematque.objectId
      },
      "type": {
        "__type": "Pointer",
        "className": "TypeReclamation",
        "objectId": provider.selectedReclamation.objectId
      },
      "priority": provider.selectedPriority,
      "description": _descctrl.text


    });

    setState(() {
      load = false;
    });

    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text("Votre reclamation a bien été envoyé !"),
      backgroundColor: Colors.green,
    ));

    new Timer(new Duration(seconds: 3), () {
     Navigator.pop(context);
    });

  }
  @override
  Widget build(BuildContext context) {


    void showInSnackBar(String value) {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text(value),
        backgroundColor: Colors.red[900],
      ));
    }


    return ChangeNotifierProvider(
        create: (context) => ReclamationProvider(context,widget.user),
        builder: (context, __) {
          final provider = context.read<ReclamationProvider>();

          return Scaffold(
              key: _scaffoldKey,
              backgroundColor: Colors.white,
              appBar: AppBar(
                centerTitle: true,
                iconTheme: IconThemeData(color: Colors.white),
                toolbarHeight: 60.h,
                elevation: 0.0,

                // iconTheme: IconThemeData(color: Fonts.col_app),
                // titleSpacing: double.infinity,
                titleSpacing: 0,
                leading: Container(
                  color: Fonts.col_app,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                title: Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  color: Fonts.col_app,
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/icons/customer.png",
                        color: Colors.white,
                        width: 23.5.w,
                        height: 25.5.h,
                      ),
                      Container(
                        width: 7.w,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          "Ajouter une reclamation",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 18.0.sp),
                        ),
                      ),
                      Expanded(child: Container()),
                      Padding(
                          padding: EdgeInsets.all(8.w),
                          child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.r)),
                              child: Container(
                                  height: 44.w,
                                  width: 44.w,
                                  color: Colors.white.withOpacity(0.9),
                                  padding: EdgeInsets.all(0.w),
                                  child: Image.asset(
                                    "images/launcher_icon_ifd.png",
                                  )))),
                      SizedBox(
                        width: 22.w,
                      ),
                    ],
                  ),
                ),
              ),
              body: Form(
                key: _formKey,
                child: Container(
                    color: Fonts.col_app,
                    child: ClipRRect(
                        borderRadius:
                            BorderRadius.only(topRight: Radius.circular(39.r)),
                        child: Container(
                            color: Colors.white,
                            child:
                                ListView(padding: EdgeInsets.all(8), children: [
                              new Container(
                                  padding: new EdgeInsets.all(8.0),
                                  child: new Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          height: 40.h,
                                        ),
                                        ThematiqueDropDownMenu(),
                                        Container(
                                          height: 12.h,
                                        ),
                                        TypeReclamationDropDownMenu(
                                          hint: "Type reclamation",
                                        ),
                                        Container(
                                          height: 12.h,
                                        ),
                                        PriorityDropDownMenu(),
                                        Container(
                                          height: 12.h,
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12.w),
                                          child: TextFieldWidget(
                                            "Description",
                                            _descfocus,
                                            _descctrl,
                                            TextInputType.text,
                                            null,
                                            suffixIcon: "",
                                            maxLines: 8,
                                          ),
                                        ),
                                        Container(
                                          height: 36.h,
                                        ),
                                        Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12.w),
                                            child: PrimaryButton(
                                              disabledColor: Fonts.col_grey,
                                              fonsize: 14.5.sp,
                                              icon: "",
                                              prefix: Container(),
                                              color: Color(0xff085E89),
                                              text: "Envoyer",
                                              isLoading: load,
                                              onTap: () async {
                                                final FormState form =
                                                    _formKey.currentState;



                                                if (provider
                                                        .selectedThematque ==
                                                    null) {
                                                  showInSnackBar("Veuillez choisir la thématique !");
                                                } else if (provider
                                                        .selectedReclamation ==
                                                    null) {
                                                  showInSnackBar("Veuillez choisir le type de reclamation !");

                                                } else if (provider
                                                        .selectedPriority ==
                                                    null) {
                                                  showInSnackBar("Veuillez choisir la priorité !");

                                                } else if (_descctrl.text ==
                                                    "") {
                                                  showInSnackBar("Veuillez écrire une description !");

                                                } else {


                                                  go(provider);
                                                }
                                              },
                                            ))
                                      ]))
                            ])))),
              ));
        });
  }
}
