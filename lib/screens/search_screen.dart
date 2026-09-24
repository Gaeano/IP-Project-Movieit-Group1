import 'package:flutter/material.dart';
import 'package:movieit/theme/app_colors.dart';
import 'package:movieit/theme/app_styles.dart';
import 'package:movieit/theme/movieit_theme.dart';
import 'package:movieit/widgets/layout/custom_footer.dart';
import 'package:movieit/widgets/movieit_search_bar.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.movieItTheme;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: theme.heroGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      MovieItSearchBar(onChanged: (_) {}),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(14),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                decoration: BoxDecoration(
                                  color: theme.glassSurface,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: theme.glassBorder,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.tune_rounded,
                                      color: theme.textPrimary,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Filters',
                                      style: AppStyles.body(
                                        size: 14,
                                        color: theme.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 80),
                      Center(
                        child: Column(
                          children: const [
                            Icon(Icons.movie_creation_outlined, size: 80, color: Colors.white24),
                            SizedBox(height: 16),
                            Text(
                              'Results',
                              style: TextStyle(fontSize: 18, color: Colors.white54),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: const CustomFooter(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}