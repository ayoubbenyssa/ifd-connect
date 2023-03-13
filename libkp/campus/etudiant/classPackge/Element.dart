class Smodules {
  final String markAr;
  final String subjectWeighting;
  final String average;
  final String subject;
  final String mark;

  Smodules(
      {this.markAr,
        this.subjectWeighting,
        this.average,
        this.subject,
        this.mark});

  factory Smodules.fromJson(Map<String, dynamic> parsedJson) {


    return Smodules(
        markAr: parsedJson["mark_ar"].toString(),
        subjectWeighting: parsedJson["subject_weighting"].toString(),
        average: parsedJson["average"].toString(),
        subject: parsedJson["subject"],
        mark: parsedJson["mark"].toString());
  }
}
