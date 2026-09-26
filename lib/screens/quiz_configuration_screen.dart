import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/quiz_provider.dart';
import '../widgets/app_illustrations.dart';
import '../widgets/custom_button.dart';
import '../widgets/retry_banner.dart';
import 'quiz_screen.dart';

class QuizConfigurationScreen extends StatelessWidget {
  final int? categoryId;
  final String categoryName;

  const QuizConfigurationScreen({
    super.key,
    this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    final quizProvider = context.watch<QuizProvider>();
    final config = quizProvider.config;
    final isLoading = quizProvider.status == QuizStatus.loadingQuestions;
    final hasError = quizProvider.questionError != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Settings switches illustration from Figma Screen 3
                      const ConfigIllustration(),
                      const SizedBox(height: 16),

                      // Headers
                      const Text(
                        'Quizzical',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Configuration',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        categoryName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Retry banner if error occurs while preserving config
                      if (hasError) ...[
                        RetryBanner(
                          message: quizProvider.questionError!,
                          onRetry: () => _handleStart(context, quizProvider),
                        ),
                        const SizedBox(height: 12),
                      ],

                      // Number of Questions Slider
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Number of Questions',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  '${config.amount}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                            const Text(
                              'Select 1–50',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textMuted,
                              ),
                            ),
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: AppColors.primary,
                                inactiveTrackColor: Colors.grey.shade200,
                                thumbColor: AppColors.primary,
                                overlayColor: AppColors.primary.withOpacity(0.12),
                                trackHeight: 4,
                              ),
                              child: Slider(
                                value: config.amount.toDouble(),
                                min: 1,
                                max: 50,
                                divisions: 49,
                                onChanged: (val) {
                                  quizProvider.updateAmount(val.round());
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Difficulty Dropdown
                      _buildDropdownSection(
                        title: 'Difficulty Level',
                        value: config.difficulty,
                        items: const [
                          DropdownMenuItem(value: 'any', child: Text('Any Difficulty')),
                          DropdownMenuItem(value: 'easy', child: Text('Easy')),
                          DropdownMenuItem(value: 'medium', child: Text('Medium')),
                          DropdownMenuItem(value: 'hard', child: Text('Hard')),
                        ],
                        onChanged: (val) {
                          if (val != null) quizProvider.updateDifficulty(val);
                        },
                      ),
                      const SizedBox(height: 20),

                      // Question Type Dropdown
                      _buildDropdownSection(
                        title: 'Question Type',
                        value: config.type,
                        items: const [
                          DropdownMenuItem(
                              value: 'multiple', child: Text('Multiple Choice')),
                          DropdownMenuItem(
                              value: 'boolean', child: Text('True / False')),
                          DropdownMenuItem(value: 'any', child: Text('Any Type')),
                        ],
                        onChanged: (val) {
                          if (val != null) quizProvider.updateType(val);
                        },
                      ),
                      const SizedBox(height: 36),

                      // START CTA
                      CustomButton(
                        text: 'START',
                        isLoading: isLoading,
                        onPressed: () => _handleStart(context, quizProvider),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDropdownSection({
    required String title,
    required String value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300, width: 1.2),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textSecondary),
              items: items,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleStart(BuildContext context, QuizProvider provider) async {
    final success = await provider.startQuiz();
    if (success && context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const QuizScreen(),
        ),
      );
    }
  }
}
