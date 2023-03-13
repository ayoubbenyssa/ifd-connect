import 'package:flutter/cupertino.dart';

import 'evaluation_question_detail.dart';

class EvaluationQuestion{
  int id;
  String name;
  List<EvaluationQuestionDetail> details;

  int index ;
  // TextEditingController controller = TextEditingController();
  TextEditingController controller = TextEditingController();
  String answer;
  String key;

  EvaluationQuestion({
    this.id,
    this.name,
    this.details,
    this.key='',
    this.controller,
    this.answer,
    this.index
  });
  factory EvaluationQuestion.fromDoc(Map<String, dynamic> document) {
    String ans;
    String ansR;
    int i;
    if(document["eval_qst_details"].length==1){
      ans = document["eval_qst_details"][0]['chosen_answer'];
    }
    else if(document["eval_qst_details"].length>1){
      i = document["eval_qst_details"].indexWhere((resp) => resp['chosen_answer']==true);
      if(i!=-1) ansR = document["eval_qst_details"][i]["value"];
    }

    return EvaluationQuestion(
        id: document["eval_qst_id"],
        name: document["eval_qst_name"],
        details: document["eval_qst_details"] == null
            ? []
            : (document["eval_qst_details"] as List)
            .map((var element) => EvaluationQuestionDetail.fromDoc(element))
            .toList(),
        key: document["eval_qst_details"] != null ? document["eval_qst_details"][0]['val'] : '',
        index: i!=-1 ? i : null,
        answer: ansR,
        controller: ans!=null ? TextEditingController(text: ans) : TextEditingController()
    );
  }
}