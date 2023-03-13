import 'evaluation_question.dart';

class EvaluationParagraph{
  String name;
  List<EvaluationQuestion> questions;

  EvaluationParagraph({
    this.name,
    this.questions,
  });
  factory EvaluationParagraph.fromDoc(Map<String, dynamic> document) {
    return EvaluationParagraph(
        name: document["paragraph_name"],
        questions: document["paragraph_qst"] == null
            ? []
            : (document["paragraph_qst"] as List)
            .map((var element) => EvaluationQuestion.fromDoc(element))
            .toList()
    );
  }
}