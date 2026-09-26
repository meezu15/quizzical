class QuizConfig {
  int? categoryId;
  String categoryName;
  int amount;
  String difficulty; // 'any', 'easy', 'medium', 'hard'
  String type; // 'any', 'multiple', 'boolean'

  QuizConfig({
    this.categoryId,
    this.categoryName = 'General Knowledge',
    this.amount = 10,
    this.difficulty = 'any',
    this.type = 'multiple',
  });

  Map<String, dynamic> toJson() => {
        'categoryId': categoryId,
        'categoryName': categoryName,
        'amount': amount,
        'difficulty': difficulty,
        'type': type,
      };

  factory QuizConfig.fromJson(Map<String, dynamic> json) {
    return QuizConfig(
      categoryId: json['categoryId'] as int?,
      categoryName: json['categoryName'] as String? ?? 'General Knowledge',
      amount: json['amount'] as int? ?? 10,
      difficulty: json['difficulty'] as String? ?? 'any',
      type: json['type'] as String? ?? 'multiple',
    );
  }

  QuizConfig copyWith({
    int? categoryId,
    String? categoryName,
    int? amount,
    String? difficulty,
    String? type,
  }) {
    return QuizConfig(
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      amount: amount ?? this.amount,
      difficulty: difficulty ?? this.difficulty,
      type: type ?? this.type,
    );
  }

  String get difficultyLabel {
    switch (difficulty) {
      case 'easy':
        return 'Easy';
      case 'medium':
        return 'Medium';
      case 'hard':
        return 'Hard';
      default:
        return 'Any Difficulty';
    }
  }

  String get typeLabel {
    switch (type) {
      case 'multiple':
        return 'Multiple Choice';
      case 'boolean':
        return 'True / False';
      default:
        return 'Any Type';
    }
  }
}
