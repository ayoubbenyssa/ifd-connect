class Student {
  var student_id;
  var last_name;
  var batch_id;
  var first_name;
  bool check;

  Student(
      {this.batch_id,
      this.check,
      this.first_name,
      this.last_name,
      this.student_id});

  Student.fromMap(map)
      : last_name = map['last_name'].toString(),
        first_name = map['first_name'].toString(),
        student_id = map['id'].toString(),
        batch_id = map['batch_id'].toString(),
        check = false;
}
