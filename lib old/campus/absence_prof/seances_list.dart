import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ifdconnect/campus/absence_prof/absence_repository.dart';
import 'package:ifdconnect/models/detail.dart';
import 'package:ifdconnect/models/matiers.dart';
import 'package:ifdconnect/models/student.dart';
import 'package:ifdconnect/models/user.dart';
import 'package:ifdconnect/services/Fonts.dart';


class ChoiceSeances extends StatefulWidget {
  ChoiceSeances(this.prof, this.student, this.date, this.batch_id, {Key key})
      : super(key: key);
  User prof;
  Student student;
  DateTime date;
  var batch_id;

  @override
  _ChoiceSeancesState createState() => _ChoiceSeancesState();
}

class _ChoiceSeancesState extends State<ChoiceSeances> {
  List<Detail> cats = new List<Detail>();
  List matieres = List() ;
  List attendance = List() ;


  bool load = true;
  var json = {};
  final TextEditingController _RaisonQuery = new TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Absence_repository home_repos = Absence_repository();
   getList() async {
    var a = await home_repos.get_details_seances(
        widget.prof, widget.student, widget.date, widget.batch_id);

    if (!this.mounted) return;
    print("------------333333------------");

    print(a);
    print("----------33333--------------");

    setState(() {
     matieres = a["result"].toList();
     attendance = a["attendance"].toList();
      // cats = a;
      print("**********************12******");
      print(matieres.length);
      print("***** attendance");
      print(attendance.length);
     print(attendance);

     print("**********************13******");



      load = false;
    });

    for(Detail d in cats){
      if(d.check == true){
        setState(() {
          choice_category.add(d);
        });
      }
    }
  }

  List<Detail> choice_category = [];

  click_cat(Detail category) {
    if (!choice_category.contains(category)) {
      setState(() {
        /* for (Service ct in cats) {
          setState(() {
            ct.check = false;
          });
        }*/
        category.check = true;
        choice_category.add(category);
      });
    } else {
      setState(() {
        category.check = false;
        choice_category.remove(category);
      });
    }
  }

  attandence_table(matiere , date ,Type_Seance , Raison , Periode,id,user_id,employee_id,auth_token,student_id,batch_id,index){
    return
      InkWell(
        child: Container(
          margin: EdgeInsets.only(left: 12.w,right: 12.w, bottom: 5.h,top: 15.h),
          height: 140.h,width: 354.w,
          decoration: BoxDecoration(
            border: Border.all(color: Fonts.col_app_fonn,width: 0.5.w),
            borderRadius: BorderRadius.all(Radius.circular(22.r)),
          ),
          child:  Column(
            children: [
              Container(
                // color: Colors.red,
                margin: EdgeInsets.only(
                    top: 12.h ,
                    left: 15.w ,
                    right: 15.w
                ),
                width: 325.w,
                height: 55.h,
                child: Row(
                  children: [
                    //doctor
                    Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(width: 1.5.w,   color: Fonts.border_col),
                              bottom: BorderSide(width: 1.5.w,   color: Fonts.border_col),

                              // bottom: BorderSide(width: 16.0, color: Colors.lightBlue.shade900),
                            ),
                            // color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                child:
                                Text("Période", maxLines: 1,
                                  style: TextStyle(color: Fonts.col_app_grey,fontSize: 12.sp,fontWeight: FontWeight.bold),
                                ),),
                              SizedBox(height: 5.h,),

                              Container(  child: Text(Periode,
                                style:
                                TextStyle(fontSize: 12.sp, color: Fonts.col_app_fonn,fontWeight: FontWeight.w500),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,

                              ),),
                              SizedBox(height: 5.h,),


                            ],
                          ),
                        )
                    ),
                    //date
                    Expanded(

                        child: Container(
                          // padding: EdgeInsets.only(bottom: 10.h),
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(width: 1.5.w,   color: Fonts.border_col),
                              bottom: BorderSide(width: 1.5.w,   color: Fonts.border_col),

                              // bottom: BorderSide(width: 16.0, color: Colors.lightBlue.shade900),
                            ),
                            // color: Colors.white,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container( child: Text("date", maxLines: 1 ,
                                style: TextStyle(color: Fonts.col_app_grey,fontSize: 12.sp,fontWeight: FontWeight.bold),
                              ),),
                              SizedBox(height: 5.h,),

                              Container( child: Text(date,  maxLines: 1,
                                style:
                                TextStyle(fontSize: 12.sp, color: Fonts.col_app_fonn,fontWeight: FontWeight.w500),
                              ),),
                              SizedBox(height: 5.h,),


                            ],
                          ),
                        )
                    ),
                    //temps
                    Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(width: 1.5.w,   color: Fonts.border_col),
                              bottom: BorderSide(width: 1.5.w,   color: Fonts.border_col),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,

                            children: [
                              Container(  child: Text("Type d'absonce",  maxLines: 1,
                                style: TextStyle(color: Fonts.col_app_grey,fontSize: 12.sp,fontWeight: FontWeight.bold),
                              ),),
                              SizedBox(height: 5.h,),

                              Container(  child: Text(Type_Seance,  maxLines: 1,
                                style:
                                TextStyle(fontSize: 12.sp, color: Fonts.col_app_fonn,fontWeight: FontWeight.w500),
                              ),),
                              SizedBox(height: 5.h,),


                            ],
                          ),
                        )),

                  ],
                ),

              ),
              Container(
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container( margin: EdgeInsets.only(
                        left: 20.w ,right: 5.w,top: 15.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(child: Text("Matiére",textAlign: TextAlign.center,
                                style: TextStyle(color: Fonts.col_app_grey,fontSize: 12.sp,fontWeight: FontWeight.bold),
                          ),),
                          SizedBox(height: 5.h,),
                          Container(width: 250.w,child: Text(
                            matiere,maxLines: 1,
                            style:
                            TextStyle(fontSize: 12.sp, color: Fonts.col_app_fonn,fontWeight: FontWeight.w500),
                          ),),

                        ],),
                    ),
                    InkWell(
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                            bottom:12.h,
                            left: 5.w,
                            right: 5.w
                            ,top: 15.h
                        ),
                        height: 30.h,
                        width: 64.w,
                        decoration: BoxDecoration(
                            border: Border.all( color: Fonts.col_app_red,width: 1.w),
                            color: Color.fromRGBO(206, 206, 206, 100),
                            borderRadius: BorderRadius.all(Radius.circular(15.r))
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("Supprimer",style: TextStyle(color: Fonts.col_app_red,fontSize: 12.sp,fontWeight: FontWeight.bold),),

                          ],
                        ),),
                      onTap: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          // title: const Text('AlertDialog Title'),
                          elevation: 0.0,
                          content: const Text('Voulez-vous vraiment supprimer cette entrée ?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async{
                                print("delette_attendence");
                                await home_repos.delete_attendence(id,user_id,employee_id,auth_token,date,student_id,batch_id);

                                setState(() {
                                  print("-----------------------");
                                  print(index);
                                  print(attendance);
                                  print("attendance.lenght 1 == ${attendance.length}");

                                  attendance.removeAt(index);
                                  print("attendance.lenght 2 == ${attendance.length}");
                                  attendance ;
                                  // Supprition_abs(attendance);
                                  // getList();
                                });
                                print("delette_attendence2");
                                Navigator.pop(context, 'ok');

                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ) ,)
            ],) ,
        ) ,onTap:
          ()   {
        showDialog(context: context, builder: (context)
        {

        });
      },
      );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getList();
    attendance ;
  }

  String dropdownSeance = "1"  ;
  String dropdownMatiers ;
  String matiere_selected ;


  bool Matinee = false  ;
  bool apre_midi = false ;
  bool abs = true  ;
  bool retard = false ;
  String selected = "1";

//   List checkListItems = [
//   {
//   "id": 1,
//   "value": false,
//   "title": "Absonce",
// },
// {
// "id": 2,
// "value": false,
// "title": "Retard",
// },
//   ] ;

  @override
  Widget build(BuildContext context) {
    TextStyle text4(e) => TextStyle(
        color: Colors.black,
        fontSize: ScreenUtil().setSp(e.check == true ? 18 : 18),
        fontWeight: e.check == true ? FontWeight.w800 : FontWeight.w500);

    Widget divid = Container(
      margin: EdgeInsets.only(
        left: 12,
        right: 12,
      ),
      width: MediaQuery.of(context).size.width,
      height: 1,
      color: Fonts.col_grey.withOpacity(0.06),
    );
    confirmation_abd () async{
      if (choice_category != []) {
        /* json["category"]=choice_category;*/

        List<String> ids= [];
        for(Detail d in choice_category){
          ids.add(d.id);
        }
        var params = {
          'params':  {
            "user_id": "${widget.prof.user_id}",
            "employee_id": "${widget.prof.employee_id}",
            "auth_token": "${widget.prof.token_user}",
            "date": "${widget.date.year.toString()}-${widget.date.month.toString()}-${widget.date.day.toString()}",
            "student_id": "${widget.student.student_id}",
            "batch_id": "${widget.batch_id}",
            "tte_ids": ids,
            "raison" :"${_RaisonQuery.text}",
            "seance" :"$dropdownSeance",
            "matieres" :"${dropdownMatiers}",
            "type_abs" : "${selected}",
            'periode':{
              "forenoon": Matinee ,
              "afternoon" : apre_midi,
            }
          },
          "nom_matieres":matiere_selected,

          "student":widget.student,
          "details": choice_category,

        };
        if(dropdownSeance == null) {
          _scaffoldKey.currentState.showSnackBar(new SnackBar(
              content: new Text("Veuillez choisir une séance !")));
        } else if(Matinee == false && apre_midi == false) {
          _scaffoldKey.currentState.showSnackBar(new SnackBar(
              content: new Text("Veuillez choisir une Période !")));
        } else if(dropdownMatiers == null ) {
          _scaffoldKey.currentState.showSnackBar(new SnackBar(
              content: new Text("Veuillez choisir une matiéres !")));
        } else {
          Navigator.pop(context, params);
          Navigator.pop(context, params);
        }
      }
    }

    Widget row_widget(Detail e, onPressed) => Container(
        color: e.check == true ? Fonts.col_app.withOpacity(0.06) : Colors.white,
        child: InkWell(
          child: Column(children: [
            Padding(
                padding: EdgeInsets.only(
                  top: 16,
                  bottom: 16,
                  left: 23,
                  right: 23,
                ),
                child: Row(children: [
                  Container(
                    width: ScreenUtil().setWidth(12),
                  ),
                  Container(
                      color: e.check != true ? Colors.grey[400] : Fonts.col_app,
                      width: 22,
                      height: 22,
                      child: Icon(
                        Icons.check,
                        color:
                            e.check != true ? Colors.white : Colors.grey[300],
                        size: 18,
                      )),
                  Container(
                    width: 10,
                  ),
                  Expanded(
                      child: Text(
                    e.name,
                    style: text4(e),
                  )),
                  Text(e.time.toString()),
                  Container(
                    width: 10,
                  ),
                  SvgPicture.asset("images/next.svg")
                ])),
            divid
          ]),
          onTap: () {
            onPressed(e);
          },
        ));

    Widget text(String text) => Container(
        padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(28),
          top: ScreenUtil().setHeight(16),
        ),
        child: Text(
          text,
          style: TextStyle(
              color: Fonts.col_grey,
              fontSize: ScreenUtil().setSp(16),
              fontWeight: FontWeight.w900),
        ));

    Widget text2(String text) => Container(
        padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(28),
            bottom: ScreenUtil().setHeight(21)),
        child: Text(
          text,
          style: TextStyle(
              color: Fonts.col_grey,
              fontSize: ScreenUtil().setSp(12.5),
              fontWeight: FontWeight.w400),
        ));





    return Scaffold(
       key : _scaffoldKey ,
        bottomNavigationBar: Container(
            padding: EdgeInsets.only(left: 35.w, right: 35.w, bottom: 7.h, top: 7.h),
            //width: ScreenUtil().setWidth(135),
            margin: EdgeInsets.symmetric(horizontal: 85.w ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(22.r))
            ),
            
            child: RaisedButton(
              color:
                  choice_category == null ? Color(0xffF1F0F5) : Fonts.col_app,
              elevation: 0,
              shape: new RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(22.r),
                ),
              ),
              onPressed: () {
                print("_--------------------------------____ 1") ;
               confirmation_abd();
                print("_--------------------------------____ 2") ;

              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Confirmer ",
                    style: TextStyle(
                      fontSize: 16.sp,
                        fontWeight: FontWeight.w100,
                        color: choice_category == null
                            ? Color(0xffcccccc)
                            : Colors.white),
                  ),
                ],
              ),
            )
        ),


        appBar: AppBar(
          elevation: 0.0,
          titleSpacing: 0.0,
          toolbarHeight: 60.h ,
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
    padding: const EdgeInsets.only(top: 10,bottom:10),
    color: Fonts.col_app,
    child: Row(
    children: [
    Image.asset(
    "images/appointment.png",
    color: Colors.white,
    width: 23.5.w,
    height: 25.5.h,
    ),              Container(width: 7.w,),
    Padding(
    padding: const EdgeInsets.only(top: 10,bottom:10),
    child: Container(
      width: MediaQuery.of(context).size.width * 0.54.w,
      child: Text(
        widget.student.first_name + " " + widget.student.last_name,
      style: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w500,
      fontSize: 18.0.sp),
      ),
    ),
    ),

    Expanded(child: Container()),
    Padding(
    padding: EdgeInsets.all(8.w),
    child: ClipRRect(
    borderRadius: BorderRadius.all(Radius.circular(10.r)),
    child: Container(
    height: 44.w,
    width: 44.w,
    color: Colors.white.withOpacity(0.9),
    padding: EdgeInsets.all(0.w),
    child: Image.asset(
    "images/launcher_icon_ifd.png",
    )))),
    SizedBox(width: 22.w,),
    ],

    ),
    ),
        ),
        body:
        // load == true
        //     ? Center(
        //         child: CupertinoActivityIndicator(),
        //       )
        //     :
        Container(
          color: Fonts.col_app,
          child: ClipRRect(
            borderRadius: BorderRadius.only(topRight : Radius.circular(39.r)),

            child: Container(
              color: Colors.white,
              child: ListView(children: [

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // children: cats.map((e) => row_widget(e, click_cat)).toList(),
                        children: [
                          // Container(height: 10.h,),
                          Container(
                            margin:  EdgeInsets.only(
                              top: 20.h, left: 30.w,bottom: 10.h),
                            child: Text("Raison :",
                              style: TextStyle(fontSize: 18.sp ,color: Fonts.col_app,fontWeight: FontWeight.w100),
                       ),
                          ),
                          Container(
                            margin:  EdgeInsets.symmetric(
                                // vertical: 8.0,
                                horizontal: 15.0.w),

                            decoration: BoxDecoration(
                              // color: Fonts.col_cl,
                              borderRadius: BorderRadius.all(Radius.circular(25.r))
                            ),
                            child: TextField(
                              scrollPadding:  EdgeInsets.symmetric(
                                    vertical: 8.0.h, horizontal: 8.0.w),
                              controller: _RaisonQuery,
                              decoration: InputDecoration(
                                  counterStyle: TextStyle(color: Colors.white),
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 8.0.w,
                                  ),
                                  hintText: 'Raison ...',
                                  enabledBorder: OutlineInputBorder(
                                    // width: 0.0 produces a thin "hairline" border
                                    borderSide:
                                    BorderSide(color: Fonts.border_col, width: 0.0),
                                    borderRadius: BorderRadius.circular(25.0.r),
                                  ),
                                  hintStyle: TextStyle(fontSize: 13.sp,color: Fonts.col_text),
                                  suffixIcon: Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                        end: 1.0, start: 1.0),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Fonts.border_col, width: 0.0),
                                    borderRadius: BorderRadius.circular(12.0.r),
                                  ),
                                  filled: true),
                            ),
                          ),


                          Container(
    margin:  EdgeInsets.only(
    top: 20.h, left: 30.w,bottom: 10.h),
    child: Text("Séance :",
      style: TextStyle(fontSize: 18.sp ,color: Fonts.col_app,fontWeight: FontWeight.w100),
    ),
    ),
                          Container(
                            margin:  EdgeInsets.symmetric(
                              // vertical: 8.0,
                              horizontal: 15.0.w),
                            padding:  EdgeInsets.symmetric(
                                vertical: 1.0.h, horizontal: 8.0.w),
                            decoration: BoxDecoration(
                              color: Fonts.col_cl,
                              border: Border.all(
                                style: BorderStyle.solid,
                                  color: Fonts.border_col, width: 0.5.w

                              ),
                              borderRadius: BorderRadius.circular(25.0.r),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: dropdownSeance,
                                isExpanded: true,
                                icon:  Icon(Icons.arrow_drop_down, size: 30.r, color: Fonts.col_text,),
                                elevation: 2,

                                style: const TextStyle(color: Colors.black),
                                onChanged: (String newValue) {
                                  setState(() {
                                    print("dropdownValue $dropdownSeance");

                                    dropdownSeance = newValue;
                                    print("dropdownValue $dropdownSeance");
                                  });
                                },
                                items: <String>['1', '2', '3','4']
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value,style: TextStyle(color: Fonts.col_text , fontSize: 15.sp , ),),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                            //Période
                          Container(
                            child:
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.4.w,
                                  // color: Colors.green,
                                  child:
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,                                    children: [
                                      Container(
                                        margin:  EdgeInsets.only(
                                            top: 20.h, left: 30.w,bottom: 10.h),
                                        child: Text("Période :",
                                          style: TextStyle(fontSize: 18.sp ,color: Fonts.col_app,fontWeight: FontWeight.w100),
                                        ),
                                      ),
                                    Container(
                                      // padding: EdgeInsets.only(right: 10,left: 40),
                                      child: Column(
                                        children: [
                                          Container(child: Row(
                                            children: [
                                              InkWell(
                                                child: Container(
                                                  margin: EdgeInsets.only(top: 12.h,left: 30.w,right: 12.w ),
                                                  height: 18.h,
                                                    width: 18.w,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(4.5),),
                                                    border: Border.all(color: Fonts.border_col,style: BorderStyle.solid),
                                                    // color: Fonts.col_app_grey
                                                  ),
                                                  child: Matinee ? Center(child: Icon(Icons.check ,color: Fonts.col_app_grey,size: 15.r,)) : Container() ,
                                                ),
                                                onTap: (){
                                                  setState(() {
                                                    Matinee ? Matinee = false : Matinee = true ;
                                                  });
                                                },
                                              ),
                                              Container(child : Text("Matinée",
                                                style: TextStyle(fontSize: 14.sp,color: Fonts.col_app_grey),
                                              )
                                              )
                                            ],
                                          ),
                                          ),

                                          Container(child: Row(
                                            children: [
                                              InkWell(
                                                child: Container(
                                                  margin: EdgeInsets.only(top: 12.h,left: 30.w,right: 12.w ),
                                                  height: 18.h,
                                                  width: 18.w,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.all(Radius.circular(4.5),),
                                                      border: Border.all(color: Fonts.border_col,style: BorderStyle.solid),
                                                      // color: Fonts.col_app_grey
                                                  ),
                                                  child: apre_midi ? Center(child: Icon(Icons.check ,color: Fonts.col_app_grey,size: 15.r,)) : Container() ,
                                                ),
                                                onTap: (){
                                                  setState(() {
                                                    apre_midi ? apre_midi = false : apre_midi = true ;

                                                  });
                                                },
                                              ),
                                              Container(child : Text("Aprés-midi",
                                                style: TextStyle(fontSize: 14.sp,color: Fonts.col_app_grey),
                                              )
                                              )
                                            ],
                                          ),
                                          ),

                                        ],
                                      ),
                                    ),


                                  ],),),
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.55.w,
                                  // color : Colors.red ,

                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,                                    children: [
                                      Container(
                                        margin:  EdgeInsets.only(
                                            top: 20.h, left: 20.w,bottom: 10.h),
                                        child: Text("Type d'absonce :",
                                          style: TextStyle(fontSize: 18.sp ,color:  Fonts.col_app,fontWeight: FontWeight.w100),
                                        ),
                                      ),
                                    Container(
                                      padding: EdgeInsets.only(left: 20.w),
                                      child: Center(
                                        child: Column(
                                          children: [

                                            Container(child: Row(
                                              children: [
                                                InkWell(
                                                  child: Container(
                                                    margin: EdgeInsets.only(top: 12.h,left: 0.w,right: 12.w ),
                                                    height: 18.h,
                                                    width: 18.w,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.all(Radius.circular(4.5),),
                                                      border: Border.all(color: Fonts.border_col,style: BorderStyle.solid),
                                                      // color: Fonts.col_app_grey
                                                    ),
                                                    child: abs ? Center(child: Icon(Icons.check ,color: Fonts.col_app_grey,size: 15.r,)) : Container() ,
                                                  ),
                                                  onTap: (){
                                                    setState(() {
                                                      // apre_midi ? apre_midi = false : apre_midi = true ;
                                                      if(abs){
                                                        abs = false ;
                                                        retard = true ;
                                                        selected = "2" ;
                                                      } else {
                                                        abs = true ;
                                                        retard = false ;
                                                        selected = "1" ;
                                                      }

                                                    });
                                                  },
                                                ),
                                                Container(child : Text("Absence",
                                                  style: TextStyle(fontSize: 14.sp,color: Fonts.col_app_grey),
                                                )
                                                )
                                              ],
                                            ),
                                            ),



                                            Container(child: Row(
                                              children: [
                                                InkWell(
                                                  child: Container(
                                                    margin: EdgeInsets.only(top: 12.h,left: 0.w,right: 12.w ),
                                                    height: 18.h,
                                                    width: 18.w,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.all(Radius.circular(4.5),),
                                                      border: Border.all(color: Fonts.border_col,style: BorderStyle.solid),
                                                      // color: Fonts.col_app_grey
                                                    ),
                                                    child: retard ? Center(child: Icon(Icons.check ,color: Fonts.col_app_grey,size: 15.r,)) : Container() ,
                                                  ),
                                                  onTap: (){
                                                    setState(() {
                                                      if(retard){
                                                        retard = false ;
                                                        abs =  true ;
                                                        selected = "1" ;

                                                      } else {
                                                        retard = true ;
                                                        abs =  false ;
                                                        selected = "2" ;
                                                      }

                                                    });
                                                  },
                                                ),
                                                Container(child : Text("Retarde ",
                                                  style: TextStyle(fontSize: 14.sp,color: Fonts.col_app_grey),
                                                )
                                                )
                                              ],
                                            ),
                                            ),


                                            // Column(
                                            //   children: List.generate(
                                            //     checkListItems.length,
                                            //         (index) => CheckboxListTile(
                                            //       controlAffinity: ListTileControlAffinity.leading,
                                            //       contentPadding: EdgeInsets.zero,
                                            //       dense: true,
                                            //       title: Text(
                                            //         checkListItems[index]["title"],
                                            //         style: const TextStyle(
                                            //           fontSize: 16.0,
                                            //           color: Colors.black,
                                            //         ),
                                            //       ),
                                            //       value: checkListItems[index]["value"],
                                            //       onChanged: (value) {
                                            //         print("selected == $selected");
                                            //         setState(() {
                                            //           for (var element in checkListItems) {
                                            //             element["value"] = false;
                                            //           }
                                            //           checkListItems[index]["value"] = value;
                                            //           selected ="${checkListItems[index]["id"]}";
                                            //
                                            //           // "${checkListItems[index]["id"]}, ${checkListItems[index]["title"]}, ${checkListItems[index]["value"]}";
                                            //           print("selected == $selected");
                                            //         }
                                            //         );
                                            //       },
                                            //     ),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],),),
                              ],
                            ),
                          ),

                          // Matiéres
                          Container(
    margin:  EdgeInsets.only(
    top: 20.h, left: 30.w,bottom: 10.h),
    child: Text("Matiéres :",
      style: TextStyle(fontSize: 18.sp ,color: Fonts.col_app,fontWeight: FontWeight.w100),
    ),
    ),
                          Container(
                            margin:  EdgeInsets.symmetric(
                              // vertical: 8.0,
                                horizontal: 14.0.w),
                            padding:  EdgeInsets.symmetric(
                                vertical: 1.0.h, horizontal: 8.0.w),
                            decoration: BoxDecoration(
                              color: Fonts.col_cl,
                              border: Border.all(
                                  style: BorderStyle.solid,
                                  color: Fonts.border_col, width: 1.0

                              ),
                              borderRadius: BorderRadius.circular(25.0.r),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: dropdownMatiers,
                                hint: Text("choisir un matieres", style: TextStyle(color: Fonts.col_text,fontSize: 15.sp),),
                                isExpanded: true,
                                icon:  Icon(Icons.arrow_drop_down,color: Fonts.col_text,size: 30.r,),
                                elevation: 2,
                                style: const TextStyle(color: Colors.black),
                                onChanged: (String newValue) {
                                  setState(() {
                                    print("dropdownMatiers $dropdownMatiers");
                                    dropdownMatiers = newValue;
                                    print("dropdownValue $dropdownMatiers");
                                  });
                                },
                                items: matieres
                                    .map<DropdownMenuItem<String>>((value) {
                                  return DropdownMenuItem<String>(
onTap: (){
  setState(() {
    print("matiere_selected $matiere_selected");
    matiere_selected = value['name'] ;
    print("matiere_selected $matiere_selected");

  });
},
                                    value: value['id'].toString(),
                                    child: Text(value['name'].toString(),style: TextStyle(color: Fonts.col_text,fontSize: 15.sp),),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          // Container(height: 12.h),
                          Container(
                           margin:  EdgeInsets.only(
                           top: 20.h, left: 30.w,bottom: 10.h),
                            child: Text("Les matiéres de l'absence : ",
                              style: TextStyle(fontSize: 18.sp ,color: Fonts.col_app,fontWeight: FontWeight.w100),
                            ),
                              ),
                          Container(
                            // height: attendance.length == 0 ? 5.h :(double.parse("${attendance.length}") * 200).h ,
                            height: attendance.length == 0 ? 55.h : 200.h ,
                            child:
                            attendance.length == 0 ?
                            Center(child: Center(child: Container(child: Text("",style: TextStyle(fontSize: 12.sp , fontWeight: FontWeight.bold),),)))
                                :
                            ListView.builder(
                                itemCount: attendance.length,
                                itemBuilder: (BuildContext context, int index) {
                                  print("@@@@@@@@@##");
                                  print("${attendance[index]["objectId"]}");
                                  print("${attendance[index]["objectId"]}");
                                  print("${attendance.length}");

                                  print("@@@@@@@@@##");
                                  return attandence_table(attendance[index]["matiere"] ,attendance[index]["date"],attendance[index]["type_abs"] == null ? "" :attendance[index]["type_abs"] ,attendance[index]["raison"],attendance[index]["periode"],attendance[index]["id"],attendance[index]["user_id"],attendance[index]["employee_id"],attendance[index]["auth_token"],attendance[index]["student_id"],attendance[index]["batch_id"],index);
                                }
                            ),
                          )


                        ],
                      ),
                      // Container(
                      //   height: 52,
                      // ),
                    ]),
            ),
          ),
        ));
  }
}
