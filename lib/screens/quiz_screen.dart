import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/quiz_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/option_card.dart';
import 'result_screen.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quizProvider = context.watch<QuizProvider>();
    final currentQ = quizProvider.currentQuestion;
    final totalQ = quizProvider.questions.length;
    final currentIndex = quizProvider.currentIndex;
    final progress = totalQ > 0 ? (currentIndex + 1) / totalQ : 0.0;

    // Check if quiz finished
    if (quizProvider.status == QuizStatus.completed && context.mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ResultScreen()),
        );
      });
    }

    if (currentQ == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz')),
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async => await _showExitConfirmDialog(context, quizProvider),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            '${currentIndex + 1}/$totalQ',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          centerTitle: true,
          actions: [
            TextButton.icon(
              onPressed: () => _showExitConfirmDialog(context, quizProvider),
              icon: const Text(
                'EXIT',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              label: const Icon(
                Icons.exit_to_app_rounded,
                color: AppColors.textPrimary,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(6),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 5,
            ),
          ),
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Column(
                    children: [
                      // Question and Timer area
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Timer badge & Category pill
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Category Pill
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryLight,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      currentQ.category,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryDark,
                                      ),
                                    ),
                                  ),
                                  // Countdown Timer indicator
                                  _buildTimerIndicator(quizProvider.remainingSeconds),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Question Card matching Figma Screen 4/5
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 16,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  currentQ.question,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Answer Options
                              ...currentQ.shuffledAnswers.map((answer) {
                                final isSelected =
                                    quizProvider.selectedAnswer == answer;
                                final isCorrect =
                                    answer == currentQ.correctAnswer;

                                return OptionCard(
                                  text: answer,
                                  isSelected: isSelected,
                                  isCorrect: isCorrect,
                                  isAnswerSubmitted:
                                      quizProvider.isAnswerSubmitted,
                                  onTap: () {
                                    quizProvider.selectAnswer(answer);
                                  },
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ),

                      // Next button footer
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        child: CustomButton(
                          text: currentIndex == totalQ - 1 ? 'Finish' : 'Next',
                          onPressed: quizProvider.isAnswerSubmitted
                              ? () {
                                  final hasNext = quizProvider.nextQuestion();
                                  if (!hasNext && context.mounted) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const ResultScreen(),
                                      ),
                                    );
                                  }
                                }
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTimerIndicator(int seconds) {
    Color timerColor = AppColors.primary;
    if (seconds <= 5) {
      timerColor = AppColors.timerRed;
    } else if (seconds <= 10) {
      timerColor = AppColors.timerOrange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: timerColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: timerColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_outlined, size: 16, color: timerColor),
          const SizedBox(width: 4),
          Text(
            '${seconds}s',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: timerColor,
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _showExitConfirmDialog(
      BuildContext context, QuizProvider provider) async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Exit Quiz?'),
        content: const Text(
          'Are you sure you want to exit? Your progress for this quiz will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Resume'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.incorrectDark,
              foregroundColor: Colors.white,
            ),
            child: const Text('Exit'),
          ),
        ],
      ),
    );

    if (shouldExit == true) {
      provider.resetQuiz();
      if (context.mounted) {
        Navigator.popUntil(context, (route) => route.isFirst);
      }
      return true;
    }
    return false;
  }
}
