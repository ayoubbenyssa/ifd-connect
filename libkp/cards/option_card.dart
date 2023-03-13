import 'package:flutter/material.dart';
import 'package:ifdconnect/func/parsefunc.dart';
import 'package:ifdconnect/models/offers.dart';
import 'package:ifdconnect/models/option.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:ifdconnect/widgets/easy_card.dart';

class OptionCard extends StatefulWidget {

  OptionCard(this.offers, this.option, this.user, this.func, this.loadi);

  Option option;
  Offers offers;
  User user;
  var func;
  var loadi;

  @override
  _OptionCardState createState() => _OptionCardState();
}

class _OptionCardState extends State<OptionCard> {
  ParseServer parse_s = new ParseServer();


  delete_o(i) async {
    var js = {
      "users": {
        "__op": "Remove",
        "objects": [
          {
            "__type": "Pointer",
            "className": "users",
            "objectId": widget.user.id
          }
        ]
      }
    };

    return parse_s.putparse('options/' + i.id, js);
  }

  delete_option() async {
    var js = {
      "users": {
        "__op": "Remove",
        "objects": [
          {
            "__type": "Pointer",
            "className": "users",
            "objectId": widget.user.id
          }
        ]
      }
    };

    return parse_s.putparse('options/' + widget.option.id, js);
  }

  add_option() async {

    var js = {
      "users": {
        "__op": "AddUnique",
        "objects": [
          {
            "__type": "Pointer",
            "className": "users",
            "objectId": widget.user.id
          }
        ]
      }
    };

    return parse_s.putparse('options/' + widget.option.id, js);
  }


  @override
  void initState() {
    print("initState");
    // TODO: implement initState
    super.initState();

    widget.offers.length_option=0;


    for (var i in widget.offers.options) {
      widget.offers.length_option = widget.offers.length_option + i.users.length;


      if (i.id == widget.user.id) {
        setState(() {
          widget.option.check = true;
        });
      }
    }

    for (var i in widget.option.users) {
      if (i.id == widget.user.id) {
        setState(() {
          widget.option.check = true;
        });
      }
    }

    widget.option.txt = (100 * widget.option.users.length / widget.offers.length_option).toString();

    /*
    {
                    "__type": "Pointer",
                    "className": "options",
                    "objectId": i
                  }
     */
  }
  void sauver() {


    widget.offers.length_option=0;

    for (var i in widget.offers.options) {
      widget.offers.length_option = widget.offers.length_option + i.users.length;



      if (i.id == widget.user.id) {
        setState(() {
          widget.option.check = true;
        });
      }
    }

    for (var i in widget.option.users) {
      if (i.id == widget.user.id) {
        setState(() {
          widget.option.check = true;
        });
      }
    }

    widget.option.txt = (100 * widget.option.users.length / widget.offers.length_option).toString();

    /*
    {
                    "__type": "Pointer",
                    "className": "options",
                    "objectId": i
                  }
     */
  }
  @override
  Widget build(BuildContext context) {

    sauver();

    return new EasyCard(

      txt: widget.option.txt,
      prefixBadge:
      widget.option.check == true ? Fonts.col_app_green : Colors.grey[400],
      title: widget.option.title,

      description: widget.option.users.length.toString(),
      suffixIcon: Icons.check,
      onTap: () async {
        if (widget.option.check == false) {
          for (Option i in widget.offers.options) {
            if(i.check == true){
              await delete_o(i)  ;
            }
          }
          await add_option();
          widget.func(widget.offers);
        }
        else{
          await delete_option();
          widget.func(widget.offers);
        }


      },
      suffixIconColor:
      widget.option.check == true ? Fonts.col_app_green : Colors.grey[400],
    );
  }
}
