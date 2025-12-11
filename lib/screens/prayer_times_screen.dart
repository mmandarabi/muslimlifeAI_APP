import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:muslim_life_ai_demo/models/prayer_times.dart';
import 'package:muslim_life_ai_demo/services/prayer_service.dart';
import 'package:muslim_life_ai_demo/theme/app_theme.dart';
import 'package:muslim_life_ai_demo/widgets/glass_card.dart';

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  PrayerTimes? _prayerTimes;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPrayerTimes();
  }

  Future<void> _loadPrayerTimes() async {
    try {
      final data = await PrayerService().fetchPrayerTimes();
      if (mounted) {
        setState(() {
          _prayerTimes = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = "Unavailable";
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0B0C0E),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: const Color(0xFF0B0C0E),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const BackButton(color: Colors.white),
        ),
        body: Center(
            child: Text(_errorMessage!,
                style: const TextStyle(color: Colors.white54))),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0B0C0E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(LucideIcons.map_pin, size: 14, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(
                  "Belmont, VA", // Location is still placeholder per instructions
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              "27 Jumada al-Awwal 1447 AH", // Date placeholder for now
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white54,
                  ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.5,
                  colors: [
                    Color(0xFF064E3B), // Dark Emerald
                    Color(0xFF0B0C0E), // Deep Black
                  ],
                  stops: [0.0, 0.4],
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Hero Card (Next Prayer)
                  GlassCard(
                    padding: const EdgeInsets.all(24),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.5),
                      width: 1.5,
                    ),
                    child: Column(
                      children: [
                        Text(
                          _prayerTimes!.nextPrayer,
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _prayerTimes!.nextPrayerTime,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                              ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.primary),
                          ),
                          child: Text(
                            "Incoming Prayer",
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                         .scale(begin: const Offset(1, 1), end: const Offset(1.05, 1.05), duration: 1.5.seconds),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Daily Schedule List
                  _buildPrayerRow(context, "Fajr", "الفجر", _prayerTimes!.fajr, isNext: _prayerTimes!.nextPrayer == "Fajr"),
                  const SizedBox(height: 12),
                  _buildPrayerRow(context, "Dhuhr", "الظهر", _prayerTimes!.dhuhr, isNext: _prayerTimes!.nextPrayer == "Dhuhr"),
                  const SizedBox(height: 12),
                  _buildPrayerRow(context, "Asr", "العصر", _prayerTimes!.asr, isNext: _prayerTimes!.nextPrayer == "Asr"),
                  const SizedBox(height: 12),
                  _buildPrayerRow(context, "Maghrib", "المغرب", _prayerTimes!.maghrib, isNext: _prayerTimes!.nextPrayer == "Maghrib"),
                  const SizedBox(height: 12),
                  _buildPrayerRow(context, "Isha", "العشاء", _prayerTimes!.isha, isNext: _prayerTimes!.nextPrayer == "Isha"),

                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      "📢 Full Adhan will play automatically at each prayer time.",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Bottom Actions
                  Row(
                    children: [
                      Expanded(child: _buildActionButton(context, "Select Voice")),
                      const SizedBox(width: 12),
                      Expanded(child: _buildActionButton(context, "Prayer History", icon: LucideIcons.history)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildActionButton(context, "Monthly")),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // AI Insight Hook
                  GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(LucideIcons.sparkles,
                            color: AppColors.primary, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "AI INSIGHT",
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${_prayerTimes!.nextPrayer} is next. Remind me 5 mins before?",
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.white70,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text("Yes"),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 120), // Bottom nav padding
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerRow(BuildContext context, String name, String arabicName, String time,
      {bool isNext = false}) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Reduced vertical padding slightly to accommodate larger text
      border: isNext
          ? Border.all(color: AppColors.primary.withOpacity(0.5))
          : null,
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isNext ? AppColors.primary : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                Text(
                  arabicName,
                  style: const TextStyle(
                    fontFamily: 'Amiri', // Assuming Amiri is available or using default fallback
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  time,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isNext ? AppColors.primary : Colors.white70,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          const Icon(LucideIcons.volume_2, color: AppColors.primary, size: 20),
          const SizedBox(width: 16),
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24),
            ),
            child: const Icon(LucideIcons.check, size: 14, color: Colors.transparent),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, String label, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: Colors.white70),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
