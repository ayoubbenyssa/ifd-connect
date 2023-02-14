import 'Absence.dart';

class AbsencesList {
  final List<Absence> absences;

  AbsencesList({this.absences});

  factory AbsencesList.fromJson(List<dynamic> parsedJson) {
    List<Absence> absencesList = new List<Absence>();
    absencesList = parsedJson.map((i) => Absence.fromJson(i)).toList();

    return new AbsencesList(absences: absencesList);
  }
}
