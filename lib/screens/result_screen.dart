import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/quiz_provider.dart';
import '../widgets/app_illustrations.dart';
import '../widgets/custom_button.dart';
import 'category_selection_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quizProvider = context.watch<QuizProvider>();
    final result = quizProvider.lastResult;

    if (result == null) {
      return Scaffold(
        body: Center(
          child: CustomButton(
            text: 'Back to Home',
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
        ),
      );
    }

    final isPassed = result.isPassed;

    return WillPopScope(
      onWillPop: () async {
        quizProvider.resetQuiz();
        Navigator.popUntil(context, (route) => route.isFirst);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        // Celebration party horn or Keep Trying graphic
                        ResultIllustration(isPassed: isPassed),
                        const SizedBox(height: 24),

                        // Title
                        Text(
                          result.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Figma Score Badge (e.g. 80% or 33%)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(
                            color: isPassed
                                ? const Color(0xFFC8E6C9)
                                : const Color(0xFFFFCCBC),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isPassed
                                  ? const Color(0xFF81C784)
                                  : const Color(0xFFFF8A65),
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '${result.scorePercentage}%',
                                style: TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.w900,
                                  color: isPassed
                                      ? const Color(0xFF1B5E20)
                                      : const Color(0xFFBF360C),
                                ),
                              ),
                              Text(
                                'You scored ${result.correctCount}/${result.totalQuestions}!',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: isPassed
                                      ? const Color(0xFF2E7D32)
                                      : const Color(0xFFD84315),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Feedback message
                        Text(
                          result.feedbackMessage,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Stats Summary Card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.cardBg,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatItem(
                                label: 'Category',
                                value: result.categoryName,
                                icon: Icons.category_rounded,
                              ),
                              _buildStatItem(
                                label: 'Time',
                                value: result.formattedTime,
                                icon: Icons.timer_outlined,
                              ),
                              _buildStatItem(
                                label: 'Accuracy',
                                value: '${result.scorePercentage}%',
                                icon: Icons.trending_up_rounded,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 36),

                        // PLAY AGAIN CTA
                        CustomButton(
                          text: 'PLAY AGAIN',
                          onPressed: () {
                            quizProvider.resetQuiz();
                            // Navigate back to Category Selection
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const CategorySelectionScreen(),
                              ),
                              (route) => route.isFirst,
                            );
                          },
                        ),
                        const SizedBox(height: 12),

                        // Secondary Option: Return to Welcome Screen
                        TextButton(
                          onPressed: () {
                            quizProvider.resetQuiz();
                            Navigator.popUntil(
                              context,
                              (route) => route.isFirst,
                            );
                          },
                          child: const Text(
                            'Back to Welcome',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textSecondary,
                            ),
                          ),
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
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textMuted,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
