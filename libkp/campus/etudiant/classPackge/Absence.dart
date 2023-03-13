class Absence {
   var nbh;
   var date;
   var justif;
  final String name;
  bool more_ditail ;
  bool afternoon;
  bool forenoon;
   String schoolYear;

  Absence({this.more_ditail,this.nbh, this.date, this.justif, this.name, this.schoolYear,this.forenoon,this.afternoon});

  factory Absence.fromJson(Map<String, dynamic> json) {
    return new Absence(
      nbh: json['nbh'].toString(),
      date: json['date'].toString(),
      justif: json['justif'].toString(),
      forenoon: json["forenoon"],
      afternoon : json["afternoon"],
      name: json['name'],
      schoolYear: json['school_year'].toString(),
        more_ditail : true ,
    );
  }
}
