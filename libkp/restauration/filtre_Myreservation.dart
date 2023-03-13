// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:ifdconnect/models/meal.dart';
// import 'package:intl/intl.dart';
//
//
//
// import 'my_reservations.dart';
// class Filtre_reservation extends StatefulWidget {
//   final int _userId;
//   final int _studentId;
//   final int _token;
//   Filtre_reservation(this._userId, this._studentId, this._token);
//   @override
//   _Filtre_reservationState createState() => _Filtre_reservationState();
// }
//
// class _Filtre_reservationState extends State<Filtre_reservation> {
//
//   var List_repa ;
//   var name_repa ;
//   DateTime star_date = DateTime.now();
//   DateTime end_date = DateTime.now();
//   _datePicker_start(){
//     showDatePicker(
//         context: context,
//         initialDate: DateTime.now(),
//         firstDate: DateTime(DateTime.now().year   ,DateTime.now().month ,DateTime.now().day,DateTime.now().hour ,DateTime.now().minute ),
//         lastDate: DateTime(DateTime.now().year + 2  ,DateTime.now().month ,DateTime.now().day,DateTime.now().hour ,DateTime.now().minute )
//     ).then((value){
//       if(value == null ){return ;}
//       setState(() {
//         star_date = value ;
//       });
//     }
//     );
//   }
//
//
//   _datePicker_end(){
//     showDatePicker(
//         context: context,
//         initialDate: DateTime.now(),
//         firstDate: DateTime(DateTime.now().year   ,DateTime.now().month ,DateTime.now().day,DateTime.now().hour ,DateTime.now().minute ),
//         lastDate: DateTime(DateTime.now().year + 2  ,DateTime.now().month ,DateTime.now().day,DateTime.now().hour ,DateTime.now().minute )
//     ).then((value){
//       if(value == null ){return ;}
//       setState(() {
// end_date = value ;
//       });
//     }
//     );
//   }
//   Future GetListRepas(int user_id, int student_id, int token,) async{
//     // var url = Uri.parse('${Config.url_api}/meals');
//     final param = {
//       "user_id": "$user_id",
//       "student_id": "$student_id",
//       "auth_token": "$token",
//     };
//
//     final listRepa = await http.post(
//       "${Config.url_api}/meals",
//       body: param,
//     );
//     var responsebody = jsonDecode(listRepa.body);
//     print(responsebody["meals"]);
//     for(int k = 0 ; k < responsebody["meals"].length ; k++){
//       print("***********");
//       List_repa[k] = ("${responsebody["meals"][k]["meal"]["name"]}");
//     }
//     // if (this.mounted) {
//     //   setState(() {
//     //     List_repa = json.decode(listRepa.body)["meals"];
//     //   });
//     // }
//     print("****************");
//     print(List_repa);
//     print("****************");
//
//
//     return List_repa;
//
//   }
//
//
//
//   Widget Dropdown(hint,selected ,listItem , ){
//     return
//       DropdownButton<String>(
//         focusColor:Colors.white,
//         value: select_repa,
//         //elevation: 5,
//         style: TextStyle(color: Colors.white),
//         iconEnabledColor:Colors.black,
//         items: listItem.map<DropdownMenuItem<String>>((value) {
//           return DropdownMenuItem<String>(
//             value: value.toString(),
//             child: Text(value.toString(),style:TextStyle(color:Colors.black),),
//           );
//         }).toList(),
//         hint:Text(
//           hint,
//           style: TextStyle(
//               color: Colors.black,
//               fontSize: 20,
//               fontWeight: FontWeight.w500),
//         ),
//         onChanged: (String value) {
//           setState(() {
//             select_repa = value;
//           });
//         },
//       );
//   }
//
//   List list_repas = ["Déjeuner" ,  "Petit-déjeuner" , "Dinner" ,"FTOUR", "SHOR" , "TOUT"];
//   String select_repa ;
//   @override
//   void initState() {
//     // TODO: implement initState
//     GetListRepas(widget._userId,widget._studentId, widget._token,);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         // mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             margin: EdgeInsets.only(left: 30,top: 30),
//             child: Row(
//               children: [
//                 Container(child: Text("Repas            :",style: TextStyle(fontSize: 20),),),
//                 SizedBox(width: 25,),
//                 Container(padding: EdgeInsets.only(left: 10, right: 10 ,bottom: 1,top: 1),
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.all(Radius.circular(15)),
//                       color: Colors.black38
//
//                   ),child: Dropdown("choiser un repa" , select_repa , list_repas),)
//               ],
//             ),
//           ),
//           Container(
//             margin: EdgeInsets.only(left: 30,top: 30),
//             child: Row(
//               children: [
//                 Container(child: Text("Star date          :",style: TextStyle(fontSize: 20),),),
//                 SizedBox(width: 25,),
//                 Container(padding: EdgeInsets.only(left: 10, right: 10 ,bottom: 1,top: 1),
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.all(Radius.circular(15)),
//                         color: Colors.black38
//
//                     ),child: Text(DateFormat.yMd().format(star_date,),style: TextStyle(fontSize: 20),)),
//                 SizedBox(width: 25,),
//
//                 Container(child:
//                 IconButton(
//                   icon: new Icon(Icons.calendar_today_outlined,size: 30,),
//                   tooltip: 'Navigation menu',
//                   onPressed: _datePicker_start, // null disables the button
//                 ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             margin: EdgeInsets.only(left: 30,top: 30),
//             child: Row(
//               children: [
//                 Container(child: Text("End date          :",style: TextStyle(fontSize: 20),),),
//                 SizedBox(width: 25,),
//
//                 Container(padding: EdgeInsets.only(left: 10, right: 10 ,bottom: 1,top: 1),
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.all(Radius.circular(15)),
//                       color: Colors.black38
//
//                   ),child: Text(DateFormat.yMd().format(end_date),style: TextStyle(fontSize: 20)),
//                 ),
//                 SizedBox(width: 25,),
//
//                 Container(child:
//                 IconButton(
//                   icon: new Icon(Icons.calendar_today_outlined,size: 30),
//                   tooltip: 'Navigation menu',
//                   onPressed: _datePicker_end, // null disables the button
//                 ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 30,),
//           InkWell(child: Container(padding: EdgeInsets.only(top: 5,bottom: 5,left: 15,right: 15),decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.all(Radius.circular(15))), child: Text("Filtre ",style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),),),onTap: (){
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => Myreservations(widget._userId, widget._studentId, widget._token),
//
//                 ));
//
//           },),
//
//         ],
//       ),
//     );
//   }
// }
