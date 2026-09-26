import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/category_model.dart';
import '../models/question_model.dart';
import '../models/quiz_config.dart';
import '../models/quiz_result.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

enum QuizStatus {
  initial,
  loadingCategories,
  categoriesLoaded,
  loadingQuestions,
  inProgress,
  completed,
  error,
}

class QuizProvider extends ChangeNotifier {
  final ApiService _apiService;
  final StorageService _storageService;

  QuizProvider({
    ApiService? apiService,
    StorageService? storageService,
  })  : _apiService = apiService ?? ApiService(),
        _storageService = storageService ?? StorageService() {
    _init();
  }

  // --- State Variables ---
  QuizStatus _status = QuizStatus.initial;
  QuizStatus get status => _status;

  // Categories
  List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;
  String? _categoryError;
  String? get categoryError => _categoryError;

  // Configuration
  QuizConfig _config = QuizConfig();
  QuizConfig get config => _config;

  // Active Quiz
  List<QuestionModel> _questions = [];
  List<QuestionModel> get questions => _questions;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  QuestionModel? get currentQuestion =>
      _questions.isNotEmpty && _currentIndex < _questions.length
          ? _questions[_currentIndex]
          : null;

  String? _selectedAnswer;
  String? get selectedAnswer => _selectedAnswer;

  bool _isAnswerSubmitted = false;
  bool get isAnswerSubmitted => _isAnswerSubmitted;

  int _score = 0;
  int get score => _score;

  int _incorrectCount = 0;
  int get incorrectCount => _incorrectCount;

  int _unansweredCount = 0;
  int get unansweredCount => _unansweredCount;

  String? _questionError;
  String? get questionError => _questionError;

  // Timer
  static const int questionTimeLimit = 25; // 25 seconds per question
  int _remainingSeconds = questionTimeLimit;
  int get remainingSeconds => _remainingSeconds;

  int _totalTimeSpentSeconds = 0;
  int get totalTimeSpentSeconds => _totalTimeSpentSeconds;

  Timer? _questionTimer;
  Timer? _totalDurationTimer;

  QuizResult? _lastResult;
  QuizResult? get lastResult => _lastResult;

  String _userName = 'Mabin';
  String get userName => _userName;

  // --- Initializer ---
  Future<void> _init() async {
    _config = await _storageService.loadQuizConfig();
    _userName = await _storageService.loadUserName();
    notifyListeners();
  }

  // --- Category Logic ---
  Future<void> loadCategories({bool forceRefresh = false}) async {
    if (_categories.isNotEmpty && !forceRefresh) return;

    _status = QuizStatus.loadingCategories;
    _categoryError = null;
    notifyListeners();

    try {
      _categories = await _apiService.getCategories(forceRefresh: forceRefresh);
      _status = QuizStatus.categoriesLoaded;
    } catch (e) {
      _categoryError = e.toString();
      _status = QuizStatus.error;
    }
    notifyListeners();
  }

  void selectCategory(CategoryModel category) {
    _config.categoryId = category.id;
    _config.categoryName = category.displayName;
    _saveConfig();
    notifyListeners();
  }

  void updateAmount(int amount) {
    _config.amount = amount;
    _saveConfig();
    notifyListeners();
  }

  void updateDifficulty(String difficulty) {
    _config.difficulty = difficulty;
    _saveConfig();
    notifyListeners();
  }

  void updateType(String type) {
    _config.type = type;
    _saveConfig();
    notifyListeners();
  }

  void updateUserName(String name) {
    _userName = name;
    _storageService.saveUserName(name);
    notifyListeners();
  }

  Future<void> _saveConfig() async {
    await _storageService.saveQuizConfig(_config);
  }

  // --- Quiz Execution ---
  Future<bool> startQuiz() async {
    _status = QuizStatus.loadingQuestions;
    _questionError = null;
    _score = 0;
    _incorrectCount = 0;
    _unansweredCount = 0;
    _currentIndex = 0;
    _selectedAnswer = null;
    _isAnswerSubmitted = false;
    _totalTimeSpentSeconds = 0;
    notifyListeners();

    try {
      _questions = await _apiService.getQuestions(_config);
      if (_questions.isEmpty) {
        throw ApiException('No questions received. Please try again.');
      }
      _status = QuizStatus.inProgress;
      _startTotalDurationTimer();
      _startQuestionTimer();
      notifyListeners();
      return true;
    } catch (e) {
      _questionError = e.toString();
      _status = QuizStatus.error;
      notifyListeners();
      return false;
    }
  }

  void _startTotalDurationTimer() {
    _totalDurationTimer?.cancel();
    _totalDurationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _totalTimeSpentSeconds++;
    });
  }

  void _startQuestionTimer() {
    _questionTimer?.cancel();
    _remainingSeconds = questionTimeLimit;

    _questionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        _questionTimer?.cancel();
        _handleTimeout();
      }
    });
  }

  void _handleTimeout() {
    if (_isAnswerSubmitted) return;
    _isAnswerSubmitted = true;
    _unansweredCount++;
    _selectedAnswer = null; // No answer selected = timed out
    notifyListeners();

    // Auto-advance after showing correct answer for 1.5 seconds on timeout
    Timer(const Duration(milliseconds: 1500), () {
      if (_status == QuizStatus.inProgress) {
        nextQuestion();
      }
    });
  }

  void selectAnswer(String answer) {
    if (_isAnswerSubmitted) return;

    _questionTimer?.cancel();
    _selectedAnswer = answer;
    _isAnswerSubmitted = true;

    if (currentQuestion != null && answer == currentQuestion!.correctAnswer) {
      _score++;
    } else {
      _incorrectCount++;
    }

    notifyListeners();
  }

  bool nextQuestion() {
    _questionTimer?.cancel();

    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      _selectedAnswer = null;
      _isAnswerSubmitted = false;
      _startQuestionTimer();
      notifyListeners();
      return true;
    } else {
      _finishQuiz();
      return false;
    }
  }

  void _finishQuiz() {
    _questionTimer?.cancel();
    _totalDurationTimer?.cancel();

    _lastResult = QuizResult(
      totalQuestions: _questions.length,
      correctCount: _score,
      incorrectCount: _incorrectCount,
      unansweredCount: _unansweredCount,
      totalTimeSeconds: _totalTimeSpentSeconds,
      categoryName: _config.categoryName,
    );

    _status = QuizStatus.completed;
    notifyListeners();
  }

  void resetQuiz() {
    _questionTimer?.cancel();
    _totalDurationTimer?.cancel();
    _status = QuizStatus.initial;
    _questions = [];
    _currentIndex = 0;
    _selectedAnswer = null;
    _isAnswerSubmitted = false;
    _score = 0;
    _incorrectCount = 0;
    _unansweredCount = 0;
    _totalTimeSpentSeconds = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    _questionTimer?.cancel();
    _totalDurationTimer?.cancel();
    super.dispose();
  }
}
