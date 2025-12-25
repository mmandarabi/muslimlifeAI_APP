import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_mind/theme/app_theme.dart';
import 'package:muslim_mind/widgets/glass_card.dart';

class SettingsBottomSheet extends StatefulWidget {
  const SettingsBottomSheet({super.key});

  @override
  State<SettingsBottomSheet> createState() => _SettingsBottomSheetState();
}

class _SettingsBottomSheetState extends State<SettingsBottomSheet> {
  // Placeholder state - normally connected to a Service
  bool _notificationsEnabled = true;
  String _language = 'English';
  String _themeMode = 'Dark'; // System, Light, Dark

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final secondaryColor = isDark ? Colors.white70 : Colors.black87;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: secondaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Settings",
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(LucideIcons.x, color: secondaryColor),
              ),
            ],
          ),
          
          const SizedBox(height: 32),

          // 1. Appearance Section
          _sectionTitle("APPEARANCE", secondaryColor),
          const SizedBox(height: 16),
          _buildThemeSelector(isDark),

          const SizedBox(height: 32),

          // 2. Preferences
          _sectionTitle("PREFERENCES", secondaryColor),
          const SizedBox(height: 16),
          _buildSwitchTile(
            "Notifications", 
            "Prayer times and updates", 
            LucideIcons.bell, 
            _notificationsEnabled, 
            (v) => setState(() => _notificationsEnabled = v),
            textColor,
            secondaryColor,
          ),
          const SizedBox(height: 16),
           _buildLanguageTile(textColor, secondaryColor),

          const SizedBox(height: 32),
          
          // 3. About
          Center(
             child: Text(
               "Muslim Life AI v1.0.0",
               style: GoogleFonts.inter(
                 fontSize: 12,
                 color: secondaryColor.withOpacity(0.5),
               ),
             ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, Color color) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w900,
        letterSpacing: 2,
        color: color.withOpacity(0.5),
      ),
    );
  }

  Widget _buildThemeSelector(bool isDark) {
    return Row(
      children: [
        Expanded(child: _themeOption("System", LucideIcons.smartphone, _themeMode == 'System')),
        const SizedBox(width: 12),
        Expanded(child: _themeOption("Light", LucideIcons.sun, _themeMode == 'Light')),
        const SizedBox(width: 12),
        Expanded(child: _themeOption("Dark", LucideIcons.moon, _themeMode == 'Dark')),
      ],
    );
  }

  Widget _themeOption(String label, IconData icon, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => _themeMode = label),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.withOpacity(0.2),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon, 
              size: 20, 
              color: isSelected ? Colors.white : Colors.grey,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? Colors.white : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, IconData icon, bool value, Function(bool) onChanged, Color textColor, Color subColor) {
    return Row(
      children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
             color: subColor.withOpacity(0.05),
             borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: textColor),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(title, style: GoogleFonts.outfit(fontSize: 16, color: textColor)),
               Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: subColor)),
            ],
          ),
        ),
        Switch(
          value: value, 
          onChanged: onChanged,
          activeColor: AppColors.primary,
        ),
      ],
    );
  }
  
  Widget _buildLanguageTile(Color textColor, Color subColor) {
    return GestureDetector(
      onTap: () => setState(() => _language = _language == 'English' ? 'Arabic' : 'English'),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
               color: subColor.withOpacity(0.05),
               borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(LucideIcons.languages, size: 20, color: textColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text("Language", style: GoogleFonts.outfit(fontSize: 16, color: textColor)),
                 Text(_language, style: GoogleFonts.inter(fontSize: 12, color: subColor)),
              ],
            ),
          ),
          Icon(LucideIcons.chevron_right, color: subColor, size: 20),
        ],
      ),
    );
  }
}
