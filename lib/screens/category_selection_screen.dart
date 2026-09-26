import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/quiz_provider.dart';
import '../widgets/category_card.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/retry_banner.dart';
import 'quiz_configuration_screen.dart';

class CategorySelectionScreen extends StatefulWidget {
  const CategorySelectionScreen({super.key});

  @override
  State<CategorySelectionScreen> createState() => _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  @override
  void initState() {
    super.initState();
    // Cache check & fetch in provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuizProvider>().loadCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = context.watch<QuizProvider>();
    final isLoading = quizProvider.status == QuizStatus.loadingCategories;
    final hasError = quizProvider.categoryError != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Quizzical'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh Categories',
            onPressed: () => quizProvider.loadCategories(forceRefresh: true),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header text matching Figma Screen 2
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                'choose a category to focus on:',
                style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: AppColors.textSecondary.withOpacity(0.85),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Retry banner on error
            if (hasError)
              RetryBanner(
                message: quizProvider.categoryError ?? 'Failed to load categories',
                onRetry: () => quizProvider.loadCategories(forceRefresh: true),
              ),

            // Content: Shimmer or Grid
            Expanded(
              child: isLoading
                  ? const CategorySkeletonGrid()
                  : quizProvider.categories.isEmpty && !hasError
                      ? const Center(
                          child: Text(
                            'No categories found.',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        )
                      : LayoutBuilder(
                          builder: (context, constraints) {
                            // Responsive grid columns
                            final crossAxisCount = constraints.maxWidth > 800
                                ? 4
                                : (constraints.maxWidth > 500 ? 3 : 2);

                            return GridView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.88,
                              ),
                              itemCount: quizProvider.categories.length,
                              itemBuilder: (context, index) {
                                final category = quizProvider.categories[index];
                                return CategoryCard(
                                  category: category,
                                  index: index,
                                  onTap: () {
                                    // Save category in provider
                                    quizProvider.selectCategory(category);
                                    // Navigate to Quiz Configuration Screen
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            QuizConfigurationScreen(
                                          categoryId: category.id,
                                          categoryName: category.displayName,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
