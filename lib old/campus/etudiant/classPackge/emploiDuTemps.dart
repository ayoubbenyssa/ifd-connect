class TimeTablee {
  final int id;
  final String end_date;
  final String start_date;

  TimeTablee({this.id, this.end_date, this.start_date});

  factory TimeTablee.fromJson(Map<String, dynamic> json) {
    return TimeTablee(
        id: json['id'],
        end_date: json['end_date'],
        start_date: json['start_date']);
  }
}

class TimeTableList {
  final List<TimeTablee> timeTables;

  TimeTableList({
    this.timeTables,
  });

  factory TimeTableList.fromJson(List<dynamic> parsedJson) {
    List<TimeTablee> timeTables = new List<TimeTablee>();
    timeTables = parsedJson.map((i) => TimeTablee.fromJson(i)).toList();

    return new TimeTableList(timeTables: timeTables);
  }
}
