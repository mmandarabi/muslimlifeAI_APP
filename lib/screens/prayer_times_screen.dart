import 'dart:async';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart'; // For PlayerState
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:muslim_life_ai_demo/models/prayer_times.dart';
import 'package:muslim_life_ai_demo/services/prayer_service.dart';
import 'package:muslim_life_ai_demo/services/unified_audio_service.dart';
import 'package:muslim_life_ai_demo/theme/app_theme.dart';
import 'package:muslim_life_ai_demo/widgets/glass_card.dart';

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> with WidgetsBindingObserver {
  PrayerTimes? _prayerTimes;
  bool _isLoading = true;
  String? _errorMessage;
  
  // Countdown State
  Timer? _timer;
  Duration _timeUntilNextPrayer = Duration.zero;
  String? _playingPrayer; // Tracks which prayer icon is currently playing
  DateTime? _lastAutoAdhanTime; // Guards against re-triggering auto-play
  DateTime? _lastTapTime; // Debounce for manual taps
  bool _userStoppedAdhan = false; // User intent lock: if true, auto-adhan is blocked
  bool _isSwitchingAudio = false; // Guards against transient stop events during play switch
  
  // Calculated Countdown State
  String? _calculatedNextPrayerName;
  String? _calculatedNextPrayerTime;
  
  // Audio Service
  final UnifiedAudioService _audioService = UnifiedAudioService();
  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _playerCompleteSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadPrayerTimes();
    
    // Listen for external stop or completion
    _playerStateSubscription = _audioService.onPlayerStateChanged.listen((state) {
        // Ignore "stopped" events if we are in the middle of switching/starting audio
        if (_isSwitchingAudio) return;

        if (!state.playing && mounted) {
            setState(() {
                _playingPrayer = null;
            });
        }
    });

    _playerCompleteSubscription = _audioService.onPlayerComplete.listen((_) {
        if (mounted) {
            setState(() {
                _playingPrayer = null;
            });
        }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
      // If user backgrounds, UnifiedAudioService handles stopping audio. 
      // We just ensure UI state resets eventually.
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _playerStateSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    // UnifiedAudioService handles session; we don't stop on local disposal
    super.dispose();
  }

  Future<void> _loadPrayerTimes() async {
    try {
      final data = await PrayerService().fetchPrayerTimes();
      if (mounted) {
        setState(() {
          _prayerTimes = data;
          _isLoading = false;
        });
        _scheduleFutureNotifications(data);
        _startCountdown();
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
  
  Future<void> _scheduleFutureNotifications(PrayerTimes data) async {
      // Convert current string times to DateTime for today
      // This logic must parse times correctly.
      if (!await _audioService.requestNotificationPermissions()) return;

      Map<String, DateTime> times = {};
      final now = DateTime.now();
      
      void addTime(String name, String timeStr) {
          final dt = _parseTime(timeStr);
          if (dt != null) {
              // Ensure we schedule for today or tomorrow if passed?
              // Standard logic: schedule for Today. If passed, ignored by service.
              times[name] = dt;
          }
      }
      
      addTime("Fajr", data.fajr);
      addTime("Dhuhr", data.dhuhr);
      addTime("Asr", data.asr);
      addTime("Maghrib", data.maghrib);
      addTime("Isha", data.isha);

      // 🛑 SCHEDULING FIX: Also add tomorrow's times to ensure coverage if opened late at night.
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      void addTomorrowTime(String name, String timeStr) {
        final dt = _parseTime(timeStr);
        if (dt != null) {
          final tomorrowDt = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, dt.hour, dt.minute);
          times["$name (Tomorrow)"] = tomorrowDt;
        }
      }

      addTomorrowTime("Fajr", data.fajr);
      addTomorrowTime("Dhuhr", data.dhuhr);
      addTomorrowTime("Asr", data.asr);
      addTomorrowTime("Maghrib", data.maghrib);
      addTomorrowTime("Isha", data.isha);
      
      await _audioService.scheduleAdhanNotifications(times);
  }

  void _startCountdown() {
    if (_prayerTimes == null) return;
    
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final pt = _prayerTimes!;

      // 1. Identify the true "Next Prayer" by checking all 5 slots
      final List<MapEntry<String, String>> prayerSlots = [
        MapEntry("Fajr", pt.fajr),
        MapEntry("Dhuhr", pt.dhuhr),
        MapEntry("Asr", pt.asr),
        MapEntry("Maghrib", pt.maghrib),
        MapEntry("Isha", pt.isha),
      ];

      String? foundName;
      DateTime? foundTime;

      for (var slot in prayerSlots) {
        final time = _parseTime(slot.value);
        if (time != null && time.isAfter(now)) {
          foundName = slot.key;
          foundTime = time;
          break;
        }
      }

      // 2. If all passed today, next is tomorrow's Fajr
      if (foundName == null) {
        foundName = "Fajr";
        foundTime = _parseTime(pt.fajr)?.add(const Duration(days: 1));
      }

      if (foundTime != null) {
        // 3. Detect Transition (Current prayer passed)
        if (_calculatedNextPrayerName != null && _calculatedNextPrayerName != foundName) {
           final arrivingPrayer = _calculatedNextPrayerName;
           debugPrint("UI: Prayer transition detected: $arrivingPrayer passed. Next is $foundName");
           _handleAutoAdhan(arrivingPrayer); 
        }

        // 4. Special Case: EXACT Match for Auto-Play 
        // If we choose to trigger on the transition, the 'just passed' prayer is the one to play.
        if (foundTime.hour == now.hour && foundTime.minute == now.minute && now.second == 0) {
             // This hits exactly at the start of the next minute
             // But transitions are usually better triggers.
        }

        if (mounted) {
          setState(() {
            _calculatedNextPrayerName = foundName;
            _calculatedNextPrayerTime = DateFormat("h:mm a").format(foundTime!);
            _timeUntilNextPrayer = foundTime.difference(now);
          });
        }
      }
    });
  }

  // Overloading handle to accept the prayer name that just started? 
  // No, let's make it simpler: trigger when a prayer time is hit.
  
  void _handleAutoAdhan([String? prayerName]) async {
      if (_userStoppedAdhan) return;
      
      bool enabled = await _audioService.requestNotificationPermissions(); 
      if (enabled) {
          debugPrint("Auto-Adhan Triggered (Foreground)");
          if (mounted) {
             _isSwitchingAudio = true;
             setState(() {
                _playingPrayer = prayerName; 
             });
          }
          await _audioService.playAdhanCue();
          if (mounted) _isSwitchingAudio = false;
      }
  }

  DateTime? _parseTime(String timeStr) {
    if (timeStr == '--:--' || timeStr == '--') return null;
    try {
      final now = DateTime.now();
      final format24 = DateFormat("HH:mm");
      final dt = format24.parse(timeStr); 
      return DateTime(now.year, now.month, now.day, dt.hour, dt.minute);
    } catch (_) {
      try {
         final now = DateTime.now();
        final format12 = DateFormat("h:mm a");
        final dt = format12.parse(timeStr);
        return DateTime(now.year, now.month, now.day, dt.hour, dt.minute);
      } catch (e) {
        debugPrint("Error parsing time $timeStr: $e");
        return null;
      }
    }
  }
  
  String _formatDuration(Duration d) {
    if (d.isNegative) return "00:00:00";
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
    return "${twoDigits(d.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }
    
    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)));
    }

    final pt = _prayerTimes!;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = AppColors.getBackgroundColor(context);
    final textColor = AppColors.getTextPrimary(context);
    final secondaryTextColor = AppColors.getTextSecondary(context);
    final accentColor = isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF1F3F4);

    return Stack(
      children: [
        // 0. LAYER: SANCTUARY BACKGROUND
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(-0.2, -0.6),
                radius: 1.5,
                colors: [
                  isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF1F3F4), // Sanctuary Pulse
                  backgroundColor,
                ],
                stops: const [0.0, 0.7],
              ),
            ),
          ),
        ),
        
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            // leading: Removed as per user request (was menu icon)
            automaticallyImplyLeading: false, // Ensure no default back button if pushed (though it's a tab)
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(LucideIcons.map_pin, size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  "Belmont, VA",
                  style: GoogleFonts.outfit(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(LucideIcons.bell, color: textColor),
                onPressed: _checkPermissions,
              ),
               IconButton(
                icon: Icon(LucideIcons.settings_2, color: textColor),
                onPressed: _showVoiceSelector,
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(20),
              child: Text(
                _prayerTimes?.dateHijri ?? "27 Jumada al-Awwal 1447 AH",
                style: GoogleFonts.outfit(color: secondaryTextColor, fontSize: 12),
              ),
            ),
          ),
          
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                const SizedBox(height: 20),
                
                // Main Countdown Card
                GlassCard(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                    child: Column(
                      children: [
                         Text(
                          _calculatedNextPrayerName?.toUpperCase() ?? pt.nextPrayerName.toUpperCase(),
                          style: GoogleFonts.outfit(
                            color: textColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 12),
                         Text(
                          _formatDuration(_timeUntilNextPrayer),
                          style: GoogleFonts.outfit(
                            color: textColor,
                            fontSize: 48,
                            fontWeight: FontWeight.w900,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                            borderRadius: BorderRadius.circular(20),
                            color: AppColors.primary.withValues(alpha: 0.05),
                          ),
                          child: Text(
                            "Next at ${_calculatedNextPrayerTime ?? pt.nextPrayerTime}",
                            style: GoogleFonts.outfit(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 28),
                
                // Daily Schedule List
                _buildPrayerRow("Fajr", pt.fajr, "الفجر"),
                const SizedBox(height: 12),
                _buildPrayerRow("Dhuhr", pt.dhuhr, "الظُّهر"),
                const SizedBox(height: 12),
                _buildPrayerRow("Asr", pt.asr, "العصر"),
                const SizedBox(height: 12),
                _buildPrayerRow("Maghrib", pt.maghrib, "المغرب"),
                const SizedBox(height: 12),
                _buildPrayerRow("Isha", pt.isha, "العشاء"),
                
                const SizedBox(height: 32),
                
                 Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.info, size: 14, color: secondaryTextColor.withValues(alpha: 0.5)),
                    const SizedBox(width: 8),
                    Text(
                      "Adhan playing in foreground enabled.",
                      style: GoogleFonts.inter(color: secondaryTextColor.withValues(alpha: 0.5), fontSize: 11),
                    ),
                  ],
                ),
                 const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrayerRow(String english, String time, String arabic) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = AppColors.getTextPrimary(context);
    final secondaryTextColor = AppColors.getTextSecondary(context);

    bool isNext = english == (_calculatedNextPrayerName ?? _prayerTimes?.nextPrayerName);
    bool isPlayingThis = _playingPrayer == english;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: isNext 
            ? AppColors.primary.withValues(alpha: 0.1) 
            : (isDark ? Colors.white : Colors.black).withValues(alpha: 0.03),
        border: Border.all(
          color: isNext ? AppColors.primary.withValues(alpha: 0.3) : (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              english,
              style: GoogleFonts.outfit(
                color: isNext ? AppColors.primary : textColor,
                fontWeight: isNext ? FontWeight.bold : FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
          const Spacer(),
          Text(
            arabic,
            style: GoogleFonts.amiri( // Sanctuary standard for Arabic
              color: isNext ? AppColors.primary : textColor.withValues(alpha: 0.8),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Text(
            time,
            style: GoogleFonts.outfit(
              color: isNext ? textColor : secondaryTextColor,
              fontSize: 14,
              fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(width: 16),
          
          // Speaker Icon Toggle
          GestureDetector(
            onTap: () async {
              HapticFeedback.lightImpact();
              final now = DateTime.now();
              if (_lastTapTime != null && now.difference(_lastTapTime!).inMilliseconds < 1000) {
                return;
              }
              _lastTapTime = now;

              if (isPlayingThis) {
                _userStoppedAdhan = true;
                _audioService.stop();
                setState(() => _playingPrayer = null);
              } else {
                _userStoppedAdhan = false;
                _isSwitchingAudio = true;
                setState(() => _playingPrayer = english);
                await _audioService.playAdhan(); 
                if(mounted) _isSwitchingAudio = false;
              }
            },
            child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: isPlayingThis ? AppColors.primary.withValues(alpha: 0.2) : Colors.transparent,
                    shape: BoxShape.circle,
                ),
                child: Icon(
                  isPlayingThis ? LucideIcons.circle_stop : LucideIcons.volume_2,
                  color: isPlayingThis ? AppColors.primary : secondaryTextColor.withValues(alpha: 0.5),
                  size: 20,
                ),
            ).animate(target: isPlayingThis ? 1 : 0).scale(begin: const Offset(1,1), end: const Offset(1.1, 1.1)),
          ),
        ],
      ),
    );
  }

  Future<void> _checkPermissions() async {
    bool localReminder = _audioService.reminderEnabled;
    bool localNotification = _audioService.notificationEnabled;
    bool localSound = _audioService.soundEnabled;

    // Mutual Exclusion Logic
    // If Sound is ON, Notification Only is OFF (and vice versa)
    // Both can be OFF.
    
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColors.getBackgroundColor(context),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text("Adhan Settings", style: GoogleFonts.outfit(color: AppColors.getTextPrimary(context), fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Choose your notification preference. Options are mutually exclusive.",
                style: GoogleFonts.inter(color: AppColors.getTextSecondary(context), fontSize: 13),
              ),
              const SizedBox(height: 20),
              // Option 1: Notification Only
              _buildDialogCheckbox(
                "Notification Only", 
                "Show a silent text alert at prayer time.", 
                localNotification, 
                (v) => setDialogState(() {
                   localNotification = v!;
                   if (localNotification) {
                     localSound = false; // Disable sound if notification only
                   }
                })
              ),
              // Option 2: Full Adhan Sound
              _buildDialogCheckbox(
                "Full Adhan Sound", 
                "Play the beautiful Adhan recitation.", 
                localSound, 
                (v) => setDialogState(() {
                   localSound = v!;
                   if (localSound) {
                     localNotification = false; // Disable notification-only mode if sound is on
                   }
                })
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text("Cancel", style: TextStyle(color: AppColors.getTextSecondary(context).withValues(alpha: 0.5))),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Save & Enable", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );

    if (confirmed == true) {
      final granted = await _audioService.requestNotificationPermissions();
      if (granted) {
        await _audioService.updateAdhanSettings(
          reminder: false, // Always OFF as per user request
          notification: localNotification,
          sound: localSound,
        );
        // Re-schedule with new settings
        if (_prayerTimes != null) {
          await _scheduleFutureNotifications(_prayerTimes!);
        }
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(granted ? "Settings Saved" : "Permission Denied"),
            backgroundColor: granted ? Colors.green : Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildDialogCheckbox(String title, String subtitle, bool value, Function(bool?) onChanged) {
    return CheckboxListTile(
      title: Text(title, style: GoogleFonts.outfit(color: AppColors.getTextPrimary(context), fontSize: 15, fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: GoogleFonts.inter(color: AppColors.getTextSecondary(context), fontSize: 11)),
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.primary,
      checkColor: Colors.black,
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.trailing,
    );
  }

  void _showVoiceSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppColors.getBackgroundColor(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select Adhan Voice", style: TextStyle(color: AppColors.getTextPrimary(context), fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _buildVoiceOption("Makkah", "makkah"),
            _buildVoiceOption("Madinah", "madinah"),
            _buildVoiceOption("Al-Quds", "quds"),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceOption(String label, String id) {
    final textColor = AppColors.getTextPrimary(context);
    final secondaryTextColor = AppColors.getTextSecondary(context);
    return ListTile(
      title: Text(label, style: TextStyle(color: textColor)),
      leading: Icon(LucideIcons.mic, color: secondaryTextColor),
      onTap: () async {
        await _audioService.setVoice(id);
        if (mounted) Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Voice set to $label")));
      },
      trailing: Icon(LucideIcons.chevron_right, color: secondaryTextColor.withValues(alpha: 0.5), size: 16),
    );
  }
}
