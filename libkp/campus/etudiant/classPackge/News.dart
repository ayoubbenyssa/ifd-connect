class New {
  final int author_id;
  final String content;
  final int id;
  final String title;
  final String created_at;
  final String updated_at;

  New(
      {this.author_id,
      this.content,
      this.id,
      this.title,
      this.created_at,
      this.updated_at});

  factory New.fromJson(Map<String, dynamic> json) {
    return New(
      author_id: json['author_id'],
      content: json['content'],
      id: json['id'],
      title: json['title'],
      created_at: json['created_at'],
      updated_at: json['updated_at'],
    );
  }
}

class NewToo {
  final New newToo;

  NewToo({this.newToo});

  factory NewToo.fromJson(Map<String, dynamic> parsedJson) {
    return NewToo(newToo: New.fromJson(parsedJson['news']));
  }
}

class ListNews {
  final List<NewToo> newToos;

  ListNews({this.newToos});
  factory ListNews.fromJson(List<dynamic> parsedJson) {
    List<NewToo> newToos = new List<NewToo>();
    newToos = parsedJson.map((i) => NewToo.fromJson(i)).toList();

    return new ListNews(newToos: newToos);
  }
}
