abstract class Model {
  int? id;

  static fromMap() {}
  toMap() {}
}

class QuizModel extends Model {
  static String table = "quiz";

  int? id;
  final String categoryName;
  int questionNo;

  QuizModel({
    this.id,
    required this.categoryName,
    required this.questionNo,
  });

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': id,
      'categoryName': categoryName,
      'questionNo': questionNo,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  static QuizModel fromMap(Map<String, dynamic> map) {
    return QuizModel(
        id: map['id'],
        categoryName: map['categoryName'],
        questionNo: map['questionNo']);
  }
}

class QuestionModel extends Model {
  static String table = "questions";

  int? id;
  int? questionId;
  String question;
  String correctAns;
  String wrongAns1;
  String wrongAns2;
  String wrongAns3;

  QuestionModel(
      {this.id,
      this.questionId,
      required this.question,
      required this.correctAns,
      required this.wrongAns1,
      required this.wrongAns2,
      required this.wrongAns3});

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'questionId': questionId,
      'question': question,
      'correctAns': correctAns,
      'wrongAns1': wrongAns1,
      'wrongAns2': wrongAns2,
      'wrongAns3': wrongAns3,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  static QuestionModel fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      id: map['id'],
      questionId: map['questionId'],
      question: map['question'],
      correctAns: map['correctAns'],
      wrongAns1: map['wrongAns1'],
      wrongAns2: map['wrongAns2'],
      wrongAns3: map['wrongAns3'],
    );
  }
}
