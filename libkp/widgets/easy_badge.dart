import 'package:flutter/material.dart';

class EasyBadgeCard extends StatelessWidget {
  final Function onTap;
  final Color leftBadge;
  final Color prefixIconColor;
  final Color suffixIconColor;
  final String title;
  final String description;
  final String prefixIcon;
  final String suffixIcon;
  final Color backgroundColor;
  final Color titleColor;
  final Color descriptionColor;
  final Color rightBadge;

  const EasyBadgeCard(
      {Key key,
        this.onTap,
        this.title,
        this.description,
        this.leftBadge,
        this.prefixIcon,
        this.suffixIcon,
        this.suffixIconColor,
        this.prefixIconColor,
        this.backgroundColor,
        this.descriptionColor,
        this.titleColor,
        this.rightBadge})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: this.onTap,
        child: Card(
          color:this.backgroundColor
             ,
          margin: const EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              (this.leftBadge != null)
                  ? Container(
                width: (this.backgroundColor != null) ? 80.0 : 100.0,
                height: 60.0,
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[

                    Expanded(child: Container(),),
                    (this.prefixIcon != null)
                          ?  Image.asset(
                        this.prefixIcon,
                        height: 40.0,
                        color: this.prefixIconColor,
                      )
                          : Container(),
                    Expanded(child: Container(),),



                  ],
                ),
              )
                  : Container(),
              (this.backgroundColor != null && leftBadge != null)
                  ? Container(

              )
                  : Container(),
             Container(
                  margin: const EdgeInsets.only(left: 8.0,top: 12,bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      (this.title != null)
                          ? Container(
                        width: MediaQuery.of(context).size.width*0.65,

                        child: Text(
                          this.title,
                          style: TextStyle(
                              color: (this.titleColor != null)
                                  ? this.titleColor
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0),
                        ),
                      )
                          : Container(),
                      (this.description != null)
                          ? Container(
                        child: Text(
                          this.description,
                          style: TextStyle(
                              fontWeight: FontWeight.w100,
                              fontSize: 10.0,
                              color: (this.descriptionColor != null)
                                  ? this.descriptionColor
                                  : Colors.grey),
                        ),
                      )
                          : Container(),
                    ],
                  ),
                ),




            ],
          ),
        ),
      ),
    );
  }
}