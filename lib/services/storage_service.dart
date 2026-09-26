import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quiz_config.dart';

class StorageService {
  static const String _keyLastConfig = 'quizzical_last_quiz_config';
  static const String _keyUserName = 'quizzical_user_name';

  Future<void> saveQuizConfig(QuizConfig config) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(config.toJson());
    await prefs.setString(_keyLastConfig, jsonString);
  }

  Future<QuizConfig> loadQuizConfig() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyLastConfig);
    if (jsonString != null && jsonString.isNotEmpty) {
      try {
        final Map<String, dynamic> map = jsonDecode(jsonString);
        return QuizConfig.fromJson(map);
      } catch (e) {
        // Fallback to default
      }
    }
    return QuizConfig();
  }

  Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserName, name);
  }

  Future<String> loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserName) ?? 'Mabin';
  }
}
