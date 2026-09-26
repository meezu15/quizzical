import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class OptionCard extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool isCorrect;
  final bool isAnswerSubmitted;
  final VoidCallback onTap;

  const OptionCard({
    super.key,
    required this.text,
    required this.isSelected,
    required this.isCorrect,
    required this.isAnswerSubmitted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = const Color(0xFFF1F4F4);
    Color borderColor = Colors.transparent;
    Widget? trailingIcon;

    if (isAnswerSubmitted) {
      if (isCorrect) {
        // Highlight correct answer in green
        backgroundColor = AppColors.correctGreen;
        borderColor = AppColors.correctDark.withOpacity(0.5);
        trailingIcon = Container(
          width: 26,
          height: 26,
          decoration: const BoxDecoration(
            color: AppColors.primaryDark,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check,
            size: 16,
            color: Colors.white,
          ),
        );
      } else if (isSelected && !isCorrect) {
        // Highlight incorrect choice in red
        backgroundColor = AppColors.incorrectRed;
        borderColor = AppColors.incorrectDark.withOpacity(0.5);
        trailingIcon = Container(
          width: 26,
          height: 26,
          decoration: const BoxDecoration(
            color: AppColors.incorrectDark,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.close,
            size: 16,
            color: Colors.white,
          ),
        );
      } else {
        // Other non-selected wrong choices
        backgroundColor = const Color(0xFFF5F6F8).withOpacity(0.6);
        trailingIcon = Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black26, width: 1.5),
          ),
        );
      }
    } else {
      // Not yet answered
      if (isSelected) {
        backgroundColor = AppColors.primaryLight;
        borderColor = AppColors.primary;
        trailingIcon = Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: CircleAvatar(
              radius: 4,
              backgroundColor: Colors.white,
            ),
          ),
        );
      } else {
        backgroundColor = const Color(0xFFF3F4F6);
        trailingIcon = Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black26, width: 1.5),
          ),
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: isAnswerSubmitted ? null : onTap,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor, width: 1.5),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                trailingIcon ?? const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
