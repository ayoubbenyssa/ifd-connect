class EvaluationQuestionDetail{
  String key;
  String val;
  String value;
  String type;
  String answer;

  EvaluationQuestionDetail({
    this.key,
    this.val,
    this.type,
    this.answer,
    this.value
  });
  factory EvaluationQuestionDetail.fromDoc(Map<String, dynamic> document) {
    return EvaluationQuestionDetail(
        key: document["key"],
        val: document["val"],
        type: document["eval_qst_type"],
        answer: document["eval_qst_type"]=="text_field" ? '' : document["value_to_display"],
        value: document["eval_qst_type"]=="text_field" ? '' : document["value"]
    );
  }
}