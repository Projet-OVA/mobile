
class QuizDetail {
  final String id;
  final String nom;
  final String description;
  final List<Question> questions;

  QuizDetail({
    required this.id,
    required this.nom,
    required this.description,
    required this.questions,
  });

  factory QuizDetail.fromJson(Map<String, dynamic> json) {
    return QuizDetail(
      id: json['id'] ?? '',
      nom: json['nom'] ?? '',
      description: json['description'] ?? '',
      questions: (json['questions'] as List? ?? [])
          .map((q) => Question.fromJson(q))
          .toList(),
    );
  }
}

class Question {
  final String id;
  final String content;
  final List<Option> options;

  Question({
    required this.id,
    required this.content,
    required this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] ?? '',
      content: json['content'] ?? '',
      options: (json['options'] as List? ?? [])
          .map((o) => Option.fromJson(o))
          .toList(),
    );
  }
}

class Option {
  final String id;
  final String content;

  Option({
    required this.id,
    required this.content,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      id: json['id'] ?? '',
      content: json['content'] ?? '',
    );
  }
}

class QuizSubmission {
  final String quizId;
  final List<QuizAnswer> answers;

  QuizSubmission({
    required this.quizId,
    required this.answers,
  });

  Map<String, dynamic> toJson() {
    return {
      'quizId': quizId,
      'answers': answers.map((a) => a.toJson()).toList(),
    };
  }
}

class QuizAnswer {
  final String questionId;
  final String responseId;

  QuizAnswer({
    required this.questionId,
    required this.responseId,
  });

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'responseId': responseId,
    };
  }
}

class QuizResult {
  final String quizId;
  final int scorePercentage;
  final int totalQuestions;
  final int correctAnswers;

  QuizResult({
    required this.quizId,
    required this.scorePercentage,
    required this.totalQuestions,
    required this.correctAnswers,
  });

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      quizId: json['quizId'] ?? '',
      scorePercentage: json['scorePercentage'] ?? 0,
      totalQuestions: json['totalQuestions'] ?? 0,
      correctAnswers: json['correctAnswers'] ?? 0,
    );
  }
}