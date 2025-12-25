import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:muslim_mind/theme/app_theme.dart';
import 'package:muslim_mind/widgets/glass_card.dart';
import 'package:url_launcher/url_launcher.dart';

class MissionScreen extends StatelessWidget {
  const MissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrow_left, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topRight,
                  radius: 1.3,
                  colors: [
                    Color(0xFF064E3B), // Dark Emerald
                    AppColors.background,
                  ],
                  stops: [0.0, 0.5],
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Why We Built MuslimLife",
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 24),

                  // Card 1: The Context
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(LucideIcons.target,
                                  color: AppColors.primary, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "The Context",
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Muslims today face a fragmented digital landscape. Finding authentic, personalized guidance requires navigating through noise and unverified sources.",
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                height: 1.5,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Card 2: Core Capabilities
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(LucideIcons.shield,
                                  color: AppColors.primary, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "Core Capabilities",
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildCapabilityItem(context, "Context-Aware Rulings"),
                        _buildCapabilityItem(context, "Privacy-First Architecture"),
                        _buildCapabilityItem(context, "Scholar-Verified Knowledge Graph"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Section 3: Investor Data Room
                  Text(
                    "Investor Data Room",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white70,
                          letterSpacing: 1,
                        ),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildDataRoomItem(context, "VC Teaser Deck", "PDF • 2.4 MB", "docs/MuslimLife_AI_Investment_Overview.docx"),
                  const SizedBox(height: 8),
                  _buildDataRoomItem(context, "Product Overview", "PDF • 1.8 MB", "docs/MuslimLife_AI_product_overview.docx"),
                  const SizedBox(height: 8),
                  _buildDataRoomItem(context, "Full Business Case", "PDF • 3.1 MB", "docs/MuslimLife_AI_BusinessCase.docx"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCapabilityItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataRoomItem(BuildContext context, String title, String subtitle, String url) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse(url)),
        child: GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          borderRadius: 12,
          child: Row(
            children: [
              const Icon(LucideIcons.file_text, color: Colors.white54, size: 20),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.white38,
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(LucideIcons.download, color: AppColors.primary, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
