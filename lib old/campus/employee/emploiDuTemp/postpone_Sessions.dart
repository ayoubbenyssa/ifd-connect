import 'package:ifdconnect/config/config.dart';
import 'package:ifdconnect/services/Fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';

import 'MyTextFormField.dart';



class PostponeSession extends StatefulWidget {
  final sessions;
  final params;

  PostponeSession(this.sessions,this.params);

  @override
  _PostponeSessionState createState() => _PostponeSessionState();
}

class _PostponeSessionState extends State<PostponeSession> {
  List<bool> _selectedSession;
  bool _alreadyPostponed;
  TextEditingController dateCtrl = TextEditingController();
  List timings;
  String timing = "";
  bool isLoading = true;
  var timingsMap;


  List formatTimeString(String string) {
    var st;
    st = string.split("-");
    return st;
  }

  Future getTimings() async {
    Map param = widget.params;

    var timingsList = await http.post(
        "${Config.url_api}/list_class_timings",
        body: json.encode(param),
        headers: {
          'Content-Type': 'application/json',
        }
    );
    var data = jsonDecode(timingsList.body);
    setState(() {
      timings = data['class_timings'].map((timing) {
        String chreno = timing['class_timing']['start_time'].substring(11,16);
        chreno += ' - ' + timing['class_timing']['end_time'].substring(11,16);
        return chreno;
      }).toList();
      timing = timings[0];
      isLoading = false;
    });
    timingsMap = data;
    print('data');
    print(data);
  }
  Future checkDisponibility() async {
    setState(() {
      isLoading = true;
    });
    Map param = widget.params;
    param['date'] = dateCtrl.text;
    param["class_timing"] = timingsMap['class_timings'][timings.indexOf(timing)]['class_timing']['id'].toString();


    var disponibility = await http.post(
        "${Config.url_api}/check_disponibility",
        body: json.encode(param),
        headers: {
          'Content-Type': 'application/json',
        }
    );
    var data = jsonDecode(disponibility.body);
    setState(() {
      isLoading = false;
    });
    print('disponibility');
    print(data);
    return data;
  }
  Future validatePostponement() async {

    Map param = widget.params;
    param['date'] = dateCtrl.text;
    param["class_timing"] = timingsMap['class_timings'][timings.indexOf(timing)]['class_timing']['id'].toString();
    var data = await http.post(
        "${Config.url_api}/valid_decision",
        body: json.encode(param),
        headers: {
          'Content-Type': 'application/json',
        }
    );
    // data = jsonDecode(data.body);
    print('after validation');
    print(jsonDecode(data.body));
  }
  AlertDialog boxDialog(bool disponible, String message) {
    return AlertDialog(
      title: const Text(''),
      content: Text(
          disponible ? 'Veuillez valider votre choix' : message),
      actions: <Widget>[
        if(disponible) FlatButton(
            child: Text('Valider'),
            onPressed: () async{
              await validatePostponement();
              Navigator.of(context,rootNavigator: true).pop('dialog');
              Navigator.pop(context);
            }),
        FlatButton(
          child: Text(disponible ? 'Annuler' : 'Ok'),
          onPressed: () {
            Navigator.of(context,rootNavigator: true).pop('dialog');
          },
        ),
      ],
    );
  }


  @override
  void initState() {
    // _selectedSession = List<bool>.generate(widget.sessions.length, (int index) {
    //   if(widget.sessions[index]['seance_reported']) {
    //     _alreadyPostponed = true;
    //     return true;
    //   }
    //   else return false;
    // });

    getTimings();

    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reporter une séance'),
      ),
      body: isLoading ?
      Center(
        child: CircularProgressIndicator(),
      )
          : Column(
        children: <Widget>[
          SizedBox(height: 100,),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text('Veuillez indiquer la date à laquelle vous vouler reporter la séance',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700
              ),),
          ),
          InkWell(
              onTap: () async {
                print("yessss");
                /* showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Container(
                                    width: double.maxFinite,
                                    child: SfDateRangePicker(
                                      onSelectionChanged:
                                          (DateRangePickerSelectionChangedArgs
                                              args) {
                                        print(args.value
                                            .toString()
                                            .substring(0, 10));
                                        birthDateCtrl.text = args.value
                                            .toString()
                                            .substring(0, 10);
                                        Navigator.pop(context);
                                      },
                                      selectionMode:
                                          DateRangePickerSelectionMode.single,
                                    ),
                                  ),
                                );
                              });*/

                DateTime datePicked = await DatePicker.showSimpleDatePicker(
                  context,
                  // initialDate: DateTime(1994),
                  firstDate: DateTime(1930),
                  reverse: false,
                  titleText: "Choisir une date",

                  // lastDate: DateTime(2012),
                  dateFormat: "dd-MMMM-yyyy",
                  locale: DateTimePickerLocale.fr,
                  looping: true,
                );
                if (!this.mounted) return;
                setState(() {
                  dateCtrl.text =
                      new DateFormat('dd-MM-yyyy').format(datePicked);
                });
              },
              child: Container(
                  width: double.maxFinite,
                  child: IgnorePointer(
                      child: MyTextFormField(
                          name: 'Date de la séance',
                          ctrl: dateCtrl,
                          focus: FocusNode(),
                          suffix: Container(),
                          validation: null,
                          type: TextInputType.text)))),
          SizedBox(height: 20,),
          DropdownButton(
            underline: SizedBox(),
            dropdownColor: Color(0xFFf8f9fa),
            value: timing,
            //elevation: 5,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
            iconEnabledColor: Colors.black,
            items: timings.cast<String>()
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
            hint: Text(
              'Chreno',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w800),
            ),
            onChanged: (String value) {
              setState(() {
                timing = value;
              });
            },
          ),
          SizedBox(height: 20,),
          Center(
            child: TextButton(
              child: Text("Confirmer"),
              style: TextButton.styleFrom(
                  elevation: 1,
                  primary: Colors.white,
                  backgroundColor: (dateCtrl.text=='') ? Colors.grey[300] : Fonts.col_app,
                  shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  textStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.white
                  )
              ),
              onPressed: (dateCtrl.text=='') ? null
                  : () async{
                Map dispo = await checkDisponibility();
                return showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => boxDialog(dispo['status'].toLowerCase()=='true',dispo['message']));
              },
            ),
          )
        ],
      ),
    );
  }
}