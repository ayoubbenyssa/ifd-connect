import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/login/login_laureat.dart';
import 'package:ifdconnect/login/login_tabs.dart';
import 'package:ifdconnect/models/role.dart';
import 'package:ifdconnect/widgets/custom_widgets/primary_button.dart';
import 'package:ifdconnect/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CChooseRole extends StatefulWidget {
  CChooseRole();

  @override
  _CChooseRoleState createState() => _CChooseRoleState();
}

class _CChooseRoleState extends State<CChooseRole> {
  List<Role> roles = List<Role>();
  Role role1;

  ParseServer parse_s = new ParseServer();
  int index = 0;

  change(Role role) {
    setState(() {
      role1 = role;
    });
    print(role1);
  }

  get_roles() async {
    var res = await parse_s.getparse("role");
    if (!this.mounted) return;

    List sp = res["results"];
    setState(() {
      roles = sp.map((var contactRaw) => new Role.fromMap(contactRaw)).toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    get_roles();
  }

  func() {
    setState(() {
      roles.forEach((element) => element.check = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    var style = new TextStyle(
        color: const Color(0xffeff2f7),
        fontSize: ScreenUtil().setSp(20.0),
        fontWeight: FontWeight.w500);

    Widget page;

    //page = new ListView(children: loadPosts());
    page = roles.isEmpty
        ? Widgets.load()
        : Expanded(
            child: new ListView(
                padding: const EdgeInsets.all(1.5),
                children: roles.map((var item) {
                  return new RoleWidget(
                      item, func, roles.indexOf(item), change);
                }).toList()));

    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 70,
            ),
            /* ClipRRect(
                borderRadius: BorderRadius.circular(24.0),
                child: Center(
                    child: Image.asset(
                  "images/logo_last.png",
                  height: MediaQuery.of(context).size.height * 0.15,
                  fit: BoxFit.cover,
                ))),*/
            new Container(height: 24.0),
            Padding(
                padding: EdgeInsets.only(left: 64.w, bottom: 24.h),
                child: Text(
                  "Choisir votre rôle ",
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(24.5),
                      color: Fonts.col_app,
                      fontFamily: "Helvetica_neu",
                      fontWeight: FontWeight.w900),
                )),
            page,
            Container(
              height: 16,
            ),
            Center(
                child: new Container(
                    width: MediaQuery.of(context).size.width * 0.76,
                    // height: ScreenUtil().setHeight(50),
                    padding: new EdgeInsets.only(left: 12.0, right: 12.0),
                    child: PrimaryButton(
                      disabledColor: Fonts.col_grey,
                      fonsize: 14.5.sp,
                      icon: "",
                      prefix: Container(),
                      color: Fonts.col_app,
                      text: "SUIVANT",
                      isLoading: false,
                      onTap: () async {
                        if (role1 == null) {
                        } else {
                          if (role1.id == "9UHbnUrotk") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginLaureat(role1)));
                          } else {
                            var a = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen(role1)));
                            if (a != null) null;
                          }
                        }
                      },
                    ) /*new Material(
                    elevation: 12.0,
                    shadowColor: Fonts.col_app,
                    borderRadius: new BorderRadius.circular(12.0),
                    color: Fonts.col_app,
                    child: new MaterialButton(
                      // color:  const Color(0xffa3bbf1),
                      onPressed: () async {
                        print("role1");
                        print(role1);
                        print("role1");


                      },
                      child: new Text(
                        "Suivant",
                        style: style,
                      ),
                    ))*/
                    )),
            new Container(height: MediaQuery.of(context).size.height * 0.12),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
              width: MediaQuery.of(context).size.width,
              height: 116.h,
              decoration: BoxDecoration(
                color: Fonts.col_app,
                borderRadius: new BorderRadius.only(
                  topRight: Radius.circular(32.0.r),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/images/lgo.png",
                    width: 80.w,
                  ),
                  Container(
                    width: 16.w,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/images/ifd.png",
                        width: 150.w,
                        color: Colors.white,
                      ),
                      Container(height: 6.h),
                      Text(
                        "L'application officielle de l'IFD",
                        style: TextStyle(color: Colors.white, fontSize: 12.sp),
                      ),
                      Container(height: 8.h),
                    ],
                  )
                ],
              ),
            )
          ],
        ));
  }
}

class RoleWidget extends StatefulWidget {
  RoleWidget(this.com, this.func, this.index, this.change);

  Role com;

  var func;
  int index;
  var change;

  @override
  _RolewidgetState createState() => _RolewidgetState();
}

class _RolewidgetState extends State<RoleWidget> {
  ParseServer parse_s = new ParseServer();

  @override
  Widget build(BuildContext context) {
    _buildTextContainer(BuildContext context, color) {
      final TextTheme textTheme = Theme.of(context).textTheme;
      final categoryText = new Text(
        widget.com.name,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w500,
          fontSize: ScreenUtil().setSp(20.0),
        ),
        textAlign: TextAlign.center,
      );

      return new Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          categoryText,
          // desc,
        ],
      );
    }

    return new GestureDetector(
        onTap: () {
          widget.func();

          if (widget.com.check == false)
            setState(() {
              widget.com.check = true;
              widget.change(widget.com);
            });
          else
            setState(() {
              widget.com.check = false;
              widget.change(null);
            });
          // nearDistance();
        },
        child: new Padding(
            padding: EdgeInsets.symmetric(
              vertical: 4.0,
              horizontal: 64.0.w,
            ),
            child: new Container(
              height: 64.h,
              // padding: EdgeInsets.symmetric(horizontal: 64.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32.r),
                border: new Border.all(color: Fonts.border_col, width: 1.0),
                color: widget.com.check ? Fonts.col_app : Colors.white,
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [
                      0.3,
                      1
                    ],
                    colors: [
                      widget.com.check ? Color(0xff2990E9) : Colors.white,
                      widget.com.check
                          ? Color(0xff95DCFF)
                          : Colors.white,
                    ]),
              ),
              // elevation: 1.0,
              ///borderRadius: new BorderRadius.circular(8.0),
              child: Padding(
                  padding: EdgeInsets.only(
                      top: ScreenUtil().setHeight(12),
                      bottom: ScreenUtil().setHeight(12)),
                  //   size: new Size.fromHeight(90.0),
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /**
                          new InkWell(
                          //highlightColor: Colors.red,
                          splashColor: Fonts.col_app,
                          onTap: () {
                          widget.func();

                          if (widget.com.check == false)
                          setState(() {
                          widget.com.check = true;
                          widget.change(widget.com);
                          });
                          else
                          setState(() {
                          widget.com.check = false;
                          widget.change(null);
                          });
                          },
                          child: new Container(
                          width: 30,
                          height: 30,
                          margin: new EdgeInsets.only(left: 8.0, right: 0.0),
                          child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                          new Container(
                          // height: 70.0,
                          //width: 70.0,
                          child: widget.com.check
                          ? new Icon(
                          Icons.check,
                          size: 20.0,
                          color: Colors.white,
                          )
                          : new Container(
                          width: 20.0,
                          height: 20.0,
                          ),
                          decoration: new BoxDecoration(
                          color: widget.com.check
                          ? Fonts.col_app
                          : Colors.white,
                          border: new Border.all(
                          width: 2.0,
                          color: widget.com.check
                          ? Fonts.col_app
                          : Colors.grey),
                          borderRadius: const BorderRadius.all(
                          const Radius.circular(2.0)),
                          ),
                          )
                          ],
                          ),
                          ),
                          ),
                       */
                      Container(
                        width: 12,
                      ),

                      // image,

                      Container(
                        width: 12,
                      ),
                      // wid,
                      _buildTextContainer(context,
                          widget.com.check ? Colors.white : Fonts.col_text),
                    ],
                  )),
            )));
  }
}
