import 'package:html_unescape/html_unescape.dart';

final HtmlUnescape _unescape = HtmlUnescape();

class QuestionModel {
  final String category;
  final String type; // 'multiple' or 'boolean'
  final String difficulty;
  final String question;
  final String correctAnswer;
  final List<String> incorrectAnswers;
  final List<String> shuffledAnswers;

  QuestionModel({
    required this.category,
    required this.type,
    required this.difficulty,
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
    required this.shuffledAnswers,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    final rawQuestion = json['question'] as String? ?? '';
    final rawCorrect = json['correct_answer'] as String? ?? '';
    final rawIncorrect = (json['incorrect_answers'] as List<dynamic>? ?? [])
        .map((e) => _unescape.convert(e.toString()))
        .toList();

    final decodedQuestion = _unescape.convert(rawQuestion);
    final decodedCorrect = _unescape.convert(rawCorrect);

    List<String> answers;
    final type = json['type'] as String? ?? 'multiple';
    if (type == 'boolean') {
      // For boolean, standardize as ['True', 'False']
      answers = ['True', 'False'];
    } else {
      answers = [decodedCorrect, ...rawIncorrect];
      answers.shuffle(); // Shuffle answers once on creation
    }

    return QuestionModel(
      category: _unescape.convert(json['category'] as String? ?? ''),
      type: type,
      difficulty: json['difficulty'] as String? ?? 'easy',
      question: decodedQuestion,
      correctAnswer: decodedCorrect,
      incorrectAnswers: rawIncorrect,
      shuffledAnswers: answers,
    );
  }
}
