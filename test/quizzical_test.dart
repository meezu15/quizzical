import 'package:flutter_test/flutter_test.dart';
import 'package:quizzical/models/category_model.dart';
import 'package:quizzical/models/question_model.dart';
import 'package:quizzical/models/quiz_config.dart';
import 'package:quizzical/models/quiz_result.dart';

void main() {
  group('CategoryModel Tests', () {
    test('Parses Category from JSON properly', () {
      final json = {'id': 9, 'name': 'General Knowledge'};
      final cat = CategoryModel.fromJson(json);

      expect(cat.id, 9);
      expect(cat.name, 'General Knowledge');
      expect(cat.displayName, 'General Knowledge');
    });

    test('displayName strips prefix correctly', () {
      final json = {'id': 10, 'name': 'Entertainment: Books'};
      final cat = CategoryModel.fromJson(json);

      expect(cat.displayName, 'Books');
    });
  });

  group('QuizConfig Tests', () {
    test('Default values are correct', () {
      final config = QuizConfig();
      expect(config.amount, 10);
      expect(config.difficulty, 'any');
      expect(config.type, 'multiple');
    });

    test('Serialization to JSON and from JSON roundtrips properly', () {
      final config = QuizConfig(
        categoryId: 18,
        categoryName: 'Computers',
        amount: 15,
        difficulty: 'hard',
        type: 'multiple',
      );

      final json = config.toJson();
      final revived = QuizConfig.fromJson(json);

      expect(revived.categoryId, 18);
      expect(revived.categoryName, 'Computers');
      expect(revived.amount, 15);
      expect(revived.difficulty, 'hard');
      expect(revived.type, 'multiple');
    });
  });

  group('QuestionModel Tests', () {
    test('Decodes HTML entities in questions and answers', () {
      final json = {
        'category': 'Entertainment: Film',
        'type': 'multiple',
        'difficulty': 'easy',
        'question': 'Which character says &quot;May the Force be with you&quot;?',
        'correct_answer': 'Han Solo&#039;s friend',
        'incorrect_answers': ['Darth Vader &amp; crew', 'Luke', 'Yoda']
      };

      final q = QuestionModel.fromJson(json);
      expect(q.question, 'Which character says "May the Force be with you"?');
      expect(q.correctAnswer, "Han Solo's friend");
      expect(q.shuffledAnswers.contains("Han Solo's friend"), isTrue);
      expect(q.shuffledAnswers.length, 4);
    });

    test('Boolean question generates exactly True and False answers', () {
      final json = {
        'category': 'General Knowledge',
        'type': 'boolean',
        'difficulty': 'easy',
        'question': 'The earth is round.',
        'correct_answer': 'True',
        'incorrect_answers': ['False']
      };

      final q = QuestionModel.fromJson(json);
      expect(q.shuffledAnswers, ['True', 'False']);
    });
  });

  group('QuizResult Tests', () {
    test('Calculates score percentage and pass status', () {
      const resultPass = QuizResult(
        totalQuestions: 10,
        correctCount: 8,
        incorrectCount: 2,
        unansweredCount: 0,
        totalTimeSeconds: 75,
        categoryName: 'General Knowledge',
      );

      expect(resultPass.scorePercentage, 80);
      expect(resultPass.isPassed, isTrue);
      expect(resultPass.title, 'Congratulation');
      expect(resultPass.formattedTime, '1m 15s');

      const resultFail = QuizResult(
        totalQuestions: 10,
        correctCount: 3,
        incorrectCount: 7,
        unansweredCount: 0,
        totalTimeSeconds: 45,
        categoryName: 'History',
      );

      expect(resultFail.scorePercentage, 30);
      expect(resultFail.isPassed, isFalse);
      expect(resultFail.title, 'Keep Trying!');
      expect(resultFail.formattedTime, '45s');
    });
  });
}
