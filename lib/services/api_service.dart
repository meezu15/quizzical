import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';
import '../models/question_model.dart';
import '../models/quiz_config.dart';

class ApiException implements Exception {
  final String message;
  final int? responseCode;

  ApiException(this.message, [this.responseCode]);

  @override
  String toString() => message;
}

class ApiService {
  static const String _baseUrl = 'https://opentdb.com';
  final http.Client _client;

  // Session-level memory cache for categories
  List<CategoryModel>? _cachedCategories;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Fetches categories. Caches the result in memory for the session.
  Future<List<CategoryModel>> getCategories({bool forceRefresh = false}) async {
    if (_cachedCategories != null && !forceRefresh) {
      return _cachedCategories!;
    }

    try {
      final uri = Uri.parse('$_baseUrl/api_category.php');
      final response = await _client.get(uri).timeout(
        const Duration(seconds: 12),
        onTimeout: () {
          throw ApiException('Connection timed out. Please check your internet connection.');
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> list = data['trivia_categories'] as List<dynamic>? ?? [];
        final categories = list.map((json) => CategoryModel.fromJson(json)).toList();
        _cachedCategories = categories;
        return categories;
      } else {
        throw ApiException('Failed to load categories (Status: ${response.statusCode})');
      }
    } on SocketException {
      throw ApiException('Network error: Unable to reach OpenTDB. Please check your internet connection.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Unexpected error while fetching categories: $e');
    }
  }

  /// Fetches questions according to configuration parameters.
  Future<List<QuestionModel>> getQuestions(QuizConfig config) async {
    final queryParams = <String, String>{
      'amount': config.amount.toString(),
    };

    if (config.categoryId != null) {
      queryParams['category'] = config.categoryId.toString();
    }
    if (config.difficulty != 'any') {
      queryParams['difficulty'] = config.difficulty;
    }
    if (config.type != 'any') {
      queryParams['type'] = config.type;
    }

    final uri = Uri.parse('$_baseUrl/api.php').replace(queryParameters: queryParams);

    try {
      final response = await _client.get(uri).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw ApiException('Question fetch timed out. OpenTDB might be slow, please try again.');
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final int responseCode = data['response_code'] as int? ?? -1;

        switch (responseCode) {
          case 0:
            final List<dynamic> results = data['results'] as List<dynamic>? ?? [];
            if (results.isEmpty) {
              throw ApiException('No questions returned by the server.', 1);
            }
            return results.map((json) => QuestionModel.fromJson(json)).toList();

          case 1:
            throw ApiException(
              'Not enough questions available with these filters. Try reducing the number of questions or choosing "Any Difficulty".',
              1,
            );

          case 2:
            throw ApiException('Invalid parameters provided to OpenTDB.', 2);

          case 5:
            throw ApiException(
              'OpenTDB rate limit reached. Please wait 5 seconds before trying again.',
              5,
            );

          default:
            throw ApiException('OpenTDB error (code: $responseCode). Please try again.', responseCode);
        }
      } else {
        throw ApiException('Server error (Status: ${response.statusCode}). Please try again.');
      }
    } on SocketException {
      throw ApiException('Network error: Unable to reach OpenTDB. Please check your connection.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error fetching questions: $e');
    }
  }
}
