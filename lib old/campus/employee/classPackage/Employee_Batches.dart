class BatchSubject {
  final int subject_id;
  final String subject;
  final int batch_id;

  BatchSubject({this.subject_id, this.subject, this.batch_id});

  factory BatchSubject.fromJson(Map<String, dynamic> json) {
    return BatchSubject(
        subject_id: json["subject_id"],
        subject: json["subject"],
        batch_id: json["batch_id"]);
  }
}



class Batch {
  final List<BatchSubject> batchSubjects;

  Batch({
    this.batchSubjects,
  });

  factory Batch.fromJson(List<dynamic> parsedJson) {
    List<BatchSubject> batchSubjects = new List<BatchSubject>();
    batchSubjects = parsedJson.map((i) => BatchSubject.fromJson(i)).toList();

    return new Batch(
        batchSubjects:batchSubjects );
  }
}