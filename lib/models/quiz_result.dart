class QuizResult {
  final int totalQuestions;
  final int correctCount;
  final int incorrectCount;
  final int unansweredCount;
  final int totalTimeSeconds;
  final String categoryName;

  const QuizResult({
    required this.totalQuestions,
    required this.correctCount,
    required this.incorrectCount,
    required this.unansweredCount,
    required this.totalTimeSeconds,
    required this.categoryName,
  });

  double get accuracy =>
      totalQuestions > 0 ? (correctCount / totalQuestions) * 100 : 0.0;

  int get scorePercentage => accuracy.round();

  bool get isPassed => scorePercentage >= 60;

  String get title => isPassed ? 'Congratulation' : 'Keep Trying!';

  String get feedbackMessage => isPassed
      ? "You've got a great foundation. Ready to try a different category?"
      : "Don't give up! Practice makes perfect. Try again to improve your score";

  String get formattedTime {
    final minutes = totalTimeSeconds ~/ 60;
    final seconds = totalTimeSeconds % 60;
    if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    }
    return '${seconds}s';
  }
}
