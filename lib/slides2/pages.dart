import 'package:flutter/material.dart';
import 'package:ifdconnect/services/Fonts.dart';

final pages = [
  new PageViewModel(
    Colors.blue[800],
    'assets/images/im1.png',
    'Bienvenue ',
    'Bienvenu(e) sur le 1er réseau social vertical pour la communauté de l’IFD : rassemblant le corps professoral et administratif, les étudiants et les lauréats de l’institut au sein d’une communauté d’échange et de services.',
    'images/opportunity.png',
    'assets/images/im1.png',  ),
  new PageViewModel(
    Colors.blueGrey[900],
    'assets/images/im2.png',
    'Réseautage & Entraide',
    'Nous facilitons  le networking et l’interaction entre les membres de l’institut ',
    'assets/images/im2.png',
    'assets/images/im2.png',
  ),
  new PageViewModel(
    // const Color(0xffd6a943),//0xFFd89d9d),
    Colors.teal[900],
    'assets/images/im3.png',

    'Actualités & Événements',
    'Restez informés des dernières actualités de votre institut',
    'images/cale.png',
    'assets/images/im3.png',
  ),
  new PageViewModel(
    // const Color(0xffd6a943),//0xFFd89d9d),
    Colors.indigo[800],
    'assets/images/im4.png',
    'Bons Plans',
    ' Nous négocions pour vous les meilleurs prix auprès des commerces de tout type',
    'images/cost.png',
    'assets/images/im4.png',
  ),
];

class Page extends StatelessWidget {
  final PageViewModel viewModel;
  final double percentVisible;

  Page({
    this.viewModel,
    this.percentVisible = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return new Container(
        width: double.infinity,
        //color: viewModel.color,
        child: new Container(
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // logo,

                /*   new Center(
                    child:   new Text("....................................",
                            style: new  TextStyle(
                              color: Colors.blue[50],
                              fontSize: 22.0,
                              fontWeight: FontWeight.w800,
                              fontFamily: "RapidinhoFontFamily",
                            ))),*/
                //new Container(height: 8.0,),
                new Transform(
                    transform: new Matrix4.translationValues(
                        0.0, 50.0 * (1.0 - percentVisible), 0.0),
                    child: new Container(
                        width: 120.0,
                        height: 120.0,
                        padding: new EdgeInsets.all(4.0),
                        child: new Material(
                          color: const Color(0xfff4f5f6),
                          type: MaterialType.circle,
                          shadowColor: Colors.black,
                          elevation: 8.0,
                          child: new Padding(
                            padding: new EdgeInsets.all(32.0),
                            child: new Image.asset(viewModel.heroAssetPath,
                                width: 90.0, height: 90.0),
                          ),
                        ))),
                new Container(height: 12.0),

                new Padding(
                  padding: new EdgeInsets.only(
                      top: 12.0, bottom: 4.0, left: 8.0, right: 8.0),
                  child: new Text(
                    viewModel.title,
                    style: new TextStyle(
                      //color: Colors.white,
                      color: Fonts.col_app,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ),

                Container(
                  height: 12.0,
                ),

                new Padding(
                  padding:
                      new EdgeInsets.only(bottom: 4.0, left: 24.0, right: 24.0),
                  child: new Text(
                    viewModel.body,
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                        //  color: Colors.white,
                        fontSize: 16.0),
                  ),
                ),

                new Container(height: 120.0),
              ]),
        ));
  }
}

class PageViewModel {
  final Color color;
  final String heroAssetPath;
  final String title;
  final String body;
  final String iconAssetPath;
  final String background;

  PageViewModel(this.color, this.heroAssetPath, this.title, this.body,
      this.iconAssetPath, this.background);
}
