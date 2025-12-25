import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:muslim_mind/theme/app_theme.dart';
import 'package:muslim_mind/widgets/glass_card.dart';

class CommunityScreen extends StatelessWidget {
  final VoidCallback? onBack;
  const CommunityScreen({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Standard Back Button Header
            if (onBack != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onBack!();
                  },
                  child: Align(
                     alignment: Alignment.centerLeft,
                     child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                      ),
                      child: const Icon(LucideIcons.chevron_left, color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Community",
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.map_pin,
                          size: 14, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Text(
                        "Belmont, VA",
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            _buildSectionTitle(context, "Nearby Masjids"),
            const SizedBox(height: 12),
            _buildCommunityItem(
              context,
              title: "Masjid Eesa Ibn Maryam",
              subtitle: "Isha Prayer at 8:15 PM",
              icon: LucideIcons.moon,
              tag: "1.2 mi",
            ),

            const SizedBox(height: 24),
            _buildSectionTitle(context, "Halal Dining"),
            const SizedBox(height: 12),
            _buildCommunityItem(
              context,
              title: "Kabul Kabob House",
              subtitle: "Halal Verified • Afghan Cuisine",
              icon: LucideIcons.utensils,
              tag: "4.8 ⭐",
              isHighlight: true,
            ),

            const SizedBox(height: 24),
            _buildSectionTitle(context, "Events & Charity"),
            const SizedBox(height: 12),
            _buildCommunityItem(
              context,
              title: "Ramadan Charity Drive",
              subtitle: "Donate to Local Food Bank",
              icon: LucideIcons.heart,
              tag: "Sat, 2 PM",
            ),
            
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white70,
            fontWeight: FontWeight.w600,
          ),
    );
  }

  Widget _buildCommunityItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required String tag,
    bool isHighlight = false,
  }) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isHighlight
                  ? AppColors.primary.withValues(alpha: 0.2)
                  : Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isHighlight ? AppColors.primary : Colors.white70,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white54,
                      ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              tag,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
