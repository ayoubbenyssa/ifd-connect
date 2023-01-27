



import 'package:flutter/material.dart';
import 'package:ifdconnect/communities/communities.dart';
import 'package:ifdconnect/home/home.dart';
import 'package:ifdconnect/inactive/inactive_widget.dart';
import 'package:ifdconnect/login/choose_role.dart';
import 'package:ifdconnect/login/inactive.dart';
import 'package:ifdconnect/login/login.dart';
import 'package:ifdconnect/login/login_tabs.dart';
import 'package:ifdconnect/login/register.dart';
import 'package:ifdconnect/login/reset_password.dart';
import 'package:ifdconnect/widgets/bottom_menu.dart';

class Routes {

  static goto(context, go,auth,onSignedIn,list_partner,analytics) {
    var res;
    if (go == "register")
      res = new Register(list_partner );
    else if (go == "login") {
     // res = new Login1();
    }
    else if(go == "reset")
      {
        res = new Reset_Password(auth,onSignedIn);
      }
    Navigator.push(context,
        new MaterialPageRoute(builder: (BuildContext context) {
          return res;
        }));

  }

    static goto_home(context,auth,sign,user,list_partner,show,analytics){
      Navigator.pushReplacement(context,
          new MaterialPageRoute(builder: (BuildContext context) {
            return new BottomNavigation(auth,sign,user,list_partner,show,analytics );
          }));
    }



    static go_inactive(context,id, analytics){
      Navigator.pushReplacement(context,
          new MaterialPageRoute(builder: (BuildContext context) {
            return new InactiveWidget([],id,);
          }));
    }


  static go_login(context){
    Navigator.pushReplacement(context,
        new MaterialPageRoute(builder: (BuildContext context) {
          return new CChooseRole( );
        }));
  }

}