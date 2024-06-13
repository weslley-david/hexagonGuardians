class Question {
  int id;
  String content;
  int number;
  int test;
  String area;
  List<Answer> answers;

  Question(
      {required this.id,
      required this.content,
      required this.number,
      required this.test,
      required this.area,
      required this.answers});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      content: json['content'],
      number: json['number'],
      test: json['test'],
      area: json['area'],
      answers: (json['item_item_questionToquestion'] as List)
          .map((answerJson) => Answer.fromJson(answerJson))
          .toList(),
    );
  }

  set selectedAnswerId(int? selectedAnswerId) {}
}

class Answer {
  int id;
  String content;
  int number;
  String score;
  int question;

  Answer(
      {required this.id,
      required this.content,
      required this.number,
      required this.score,
      required this.question});

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'],
      content: json['content'],
      number: json['number'],
      score: json['score'],
      question: json['question'],
    );
  }
}
