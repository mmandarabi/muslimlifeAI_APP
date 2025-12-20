import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:muslim_life_ai_demo/theme/app_theme.dart';
import 'package:muslim_life_ai_demo/widgets/glass_card.dart';

class HadithScreen extends StatelessWidget {
  const HadithScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Daily Hadith Card
          GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(LucideIcons.sparkles,
                            color: AppColors.primary, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          "Daily Hadith",
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(LucideIcons.bookmark,
                              color: AppColors.getTextSecondary(context), size: 20),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(LucideIcons.share_2,
                              color: AppColors.getTextSecondary(context), size: 20),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  "مَنْ صَلَّى الْبَرْدَيْنِ دَخَلَ الْجَنَّةَ",
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 24,
                    color: AppColors.getTextPrimary(context),
                    height: 1.8,
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 12),
                Text(
                  "\"Whoever prays Fajr and ʿIshā’ will enter Jannah.\"",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.getTextSecondary(context),
                        fontStyle: FontStyle.italic,
                        height: 1.5,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  "— Bukhari 574",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.getTextSecondary(context).withValues(alpha: 0.5),
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Search Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.getTextPrimary(context).withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.getTextPrimary(context).withOpacity(0.1)),
            ),
            child: Row(
              children: [
                Icon(LucideIcons.search, color: AppColors.getTextSecondary(context).withOpacity(0.5), size: 20),
                const SizedBox(width: 12),
                Text(
                  "Search by topic...",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.getTextSecondary(context).withOpacity(0.5),
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Collections Header
          Text(
            "Collections",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.getTextPrimary(context),
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),

          // Collections List
          _buildCollectionTile(
            context,
            title: "Sahih al-Bukhāri",
            count: "7,563 Hadiths",
            color: const Color(0xFF10B981), // Emerald
          ),
          const SizedBox(height: 12),
          _buildCollectionTile(
            context,
            title: "Sahih Muslim",
            count: "7,563 Hadiths",
            color: const Color(0xFF3B82F6), // Blue
          ),
          const SizedBox(height: 80), // Bottom padding
        ],
      ),
    );
  }

  Widget _buildCollectionTile(
    BuildContext context, {
    required String title,
    required String count,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        // Mock detail list navigation
      },
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Icon(LucideIcons.book, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.getTextPrimary(context),
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    count,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.getTextSecondary(context),
                        ),
                  ),
                ],
              ),
            ),
            Icon(LucideIcons.chevron_right, color: AppColors.getTextSecondary(context).withOpacity(0.3)),
          ],
        ),
      ),
    );
  }
}
