class EvaluationDisponible{
  int id;
  String title;
  bool dejaRempli;

  EvaluationDisponible({
    this.id,
    this.title,
    this.dejaRempli,
});
  factory EvaluationDisponible.fromDoc(Map<String, dynamic> document) {
    print('hala');
    print(document);
    return EvaluationDisponible(
      id: document["evaluation_sample_id"],
      title: document["evaluation_sample_title"],
      dejaRempli: document["deja_rempli"]
    );
  }
}