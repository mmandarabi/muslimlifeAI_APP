import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:muslim_life_ai_demo/screens/hadith_screen.dart';
import 'package:muslim_life_ai_demo/screens/quran_read_mode.dart';
import 'package:muslim_life_ai_demo/screens/quran_screen.dart';
import 'package:muslim_life_ai_demo/theme/app_theme.dart';
import 'package:muslim_life_ai_demo/widgets/glass_card.dart';

class QuranHomeScreen extends StatefulWidget {
  const QuranHomeScreen({super.key});

  @override
  State<QuranHomeScreen> createState() => _QuranHomeScreenState();
}

class _QuranHomeScreenState extends State<QuranHomeScreen> {
  bool? _isReadModePreferred;
  int _selectedTabIndex = 0;

  void _handleSurahTap(BuildContext context) {
    if (_isReadModePreferred == null) {
      _showModeSelectionDialog(context);
    } else {
      _navigateToMode(context, _isReadModePreferred!);
    }
  }

  void _navigateToMode(BuildContext context, bool isReadMode) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            isReadMode ? const QuranReadMode() : const QuranScreen(),
      ),
    );
  }

  void _showModeSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF0B0C0E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Choose Mode",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _isReadModePreferred = true);
                        Navigator.pop(context);
                        _navigateToMode(context, true);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAF3E0),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            const Icon(LucideIcons.book_open,
                                color: Color(0xFF2C2C2C), size: 32),
                            const SizedBox(height: 12),
                            Text(
                              "READ",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: const Color(0xFF2C2C2C),
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Digital Mushaf",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: const Color(0xFF2C2C2C).withOpacity(0.7),
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _isReadModePreferred = false);
                        Navigator.pop(context);
                        _navigateToMode(context, false);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.primary),
                        ),
                        child: Column(
                          children: [
                            const Icon(LucideIcons.mic,
                                color: AppColors.primary, size: 32),
                            const SizedBox(height: 12),
                            Text(
                              "PRACTICE",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Smart Tutor",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.white70,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedTabIndex == 1 ? "Hadith" : "Quran",
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    if (_selectedTabIndex == 0)
                      IconButton(
                        onPressed: () => _showReciterSelector(context),
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(LucideIcons.mic, color: Colors.white),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                // Search Bar (Visual Only) - Only show for Quran tab as Hadith has its own
                if (_selectedTabIndex == 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Row(
                      children: [
                        const Icon(LucideIcons.search, color: Colors.white38, size: 20),
                        const SizedBox(width: 12),
                        Text(
                          "Search Surah, Juz, or Ayah...",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white38,
                              ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _buildTab(context, "Quran", 0),
                const SizedBox(width: 12),
                _buildTab(context, "Hadith", 1),
                const SizedBox(width: 12),
                _buildTab(context, "Favorites", 2),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Content
          Expanded(
            child: _selectedTabIndex == 1
                ? const HadithScreen()
                : ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      _buildSurahItem(
                        context,
                        number: 1,
                        englishName: "Al-Fātiḥah",
                        arabicName: "الفاتحة",
                        verses: 7,
                      ),
                      const SizedBox(height: 12),
                      _buildSurahItem(
                        context,
                        number: 2,
                        englishName: "Al-Baqarah",
                        arabicName: "البقرة",
                        verses: 286,
                      ),
                      const SizedBox(height: 12),
                      _buildSurahItem(
                        context,
                        number: 3,
                        englishName: "Āl ʿImrān",
                        arabicName: "آل عمران",
                        verses: 200,
                      ),
                      const SizedBox(height: 80), // Bottom padding for nav bar
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(BuildContext context, String text, int index) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.white10,
          ),
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isSelected ? Colors.black : Colors.white70,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }

  Widget _buildSurahItem(
    BuildContext context, {
    required int number,
    required String englishName,
    required String arabicName,
    required int verses,
  }) {
    return GestureDetector(
      onTap: () => _handleSurahTap(context),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white10),
              ),
              child: Text(
                number.toString(),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    englishName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    "$verses Verses",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white54,
                        ),
                  ),
                ],
              ),
            ),
            Text(
              arabicName,
              style: const TextStyle(
                fontFamily: 'Amiri', // Assuming font availability or fallback
                fontSize: 24,
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showReciterSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0B0C0E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select Reciter",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildReciterAvatar(context, "Saad al-Ghamdi", true),
                  const SizedBox(width: 20),
                  _buildReciterAvatar(context, "Al-Sudais", false),
                  const SizedBox(width: 20),
                  _buildReciterAvatar(context, "Mishary Alafasy", false),
                  const SizedBox(width: 20),
                  _buildReciterAvatar(context, "Minshawi", false),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildReciterAvatar(BuildContext context, String name, bool isSelected) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 2,
            ),
          ),
          child: Icon(
            LucideIcons.user,
            color: isSelected ? AppColors.primary : Colors.white54,
            size: 32,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isSelected ? AppColors.primary : Colors.white70,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
        ),
      ],
    );
  }
}
