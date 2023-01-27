import 'package:flutter/material.dart';
import 'package:ifdconnect/search/list_users_results.dart';
import 'package:ifdconnect/services/Fonts.dart';

class SearchWidget extends StatelessWidget {
  SearchWidget(this.user, this.list, this.lat, this.lng, this.analytics,
      {Key key})
      : super(key: key);
  var user;
  var list;
  var lat;
  var lng;
  var analytics;

  var text = new TextEditingController();
  FocusNode focus = new FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(

        //height: ,
        // margin: EdgeInsets.only(top: 8,bottom: 8),
        child: Card(
      color: Colors.grey[50],
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2.0)),
      ),
      child: Container(
          // padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                child: Icon(
                  Icons.search,
                  color: Fonts.col_app_fonn,
                ),
                onTap: () {},
              ),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: Container(
                    //   margin: EdgeInsets.only(bottom: 8),
                    child: TextFormField(
                      style: new TextStyle(color: Colors.black),

                      controller: text,
                  //focusNode: focus,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.white),

                    filled: true,
                    //  contentPadding: EdgeInsets.all(8),
                    //   border: InputBorder.none, hintText: "Chercher .."),
                    counterStyle: TextStyle(color: Fonts.col_app_fonn),
                    isDense: true,
                    fillColor: Colors.grey[50],
                    contentPadding: EdgeInsets.all(6.0),
                    hintText: '  Chercher ..',
                   /* enabledBorder: OutlineInputBorder(
                      // width: 0.0 produces a thin "hairline" border
                      borderSide:
                          BorderSide(color: Colors.grey[50], width: 0.0),
                      borderRadius: BorderRadius.circular(60.0),
                    ),*/
                    hintStyle: TextStyle(color: Fonts.col_app_fonn),
                  ),
                  onFieldSubmitted: (String text) {
                    if(text.length >0)
                      {
                        Navigator.push(context,
                            new MaterialPageRoute(builder: (BuildContext context) {
                              return new UserListsResults(
                                  text, user, list, analytics, lat, lng);
                            }));
                      }

                  },
                )),
              ),
              /*InkWell(
              onTap: () {
                //Navigator.of(context).push(
                  //  MaterialPageRoute(builder: (context) => SettingsScreen()));
              },
              child: Icon(
                Icons.search,
                color: Colors.black54,
              ),
            ),*/
            ],
          ),

          Container(
            width: 220,
            height: 0.8,
            color: Colors.white,
          )
          //  Container(height: 0.8,width: 50,color: Colors.white,)
        ],
      )),
    ));
  }
}
