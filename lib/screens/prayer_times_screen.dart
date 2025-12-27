import 'dart:async';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart'; // For PlayerState
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:muslim_mind/models/prayer_times.dart';
import 'package:muslim_mind/services/prayer_service.dart';
import 'package:muslim_mind/services/unified_audio_service.dart';
import 'package:muslim_mind/services/prayer_log_service.dart';
import 'package:muslim_mind/theme/app_theme.dart';
import 'package:muslim_mind/widgets/glass_card.dart';
import 'package:muslim_mind/services/theme_service.dart';

class PrayerTimesScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const PrayerTimesScreen({super.key, this.onBack});

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
    // 1. Instant Cache Load
    final cached = await PrayerService().loadCachedData();
    if (cached != null && mounted) {
      setState(() {
         _prayerTimes = cached;
         _isLoading = false;
      });
      _scheduleFutureNotifications(cached);
      _startCountdown();
    }
    
    // 2. Network Refresh
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
      if (mounted && _prayerTimes == null) {
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

    return Stack(
      children: [
        // 0. LAYER: STRICK BACKROUND
        Positioned.fill(
          child: Container(
            color: AppColors.background, // Strictly #202124
          ),
        ),
        
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false, 
            leading: widget.onBack != null 
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      widget.onBack!();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                      ),
                      child: const Icon(LucideIcons.chevron_left, size: 20, color: Colors.white),
                    ),
                  ),
                )
              : null, 
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(LucideIcons.map_pin, size: 14, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(
                  _prayerTimes?.locationName ?? "Locating...",
                  style: GoogleFonts.outfit(
                    color: AppColors.textPrimaryDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(LucideIcons.bell, color: AppColors.textPrimaryDark, size: 20),
                onPressed: _checkPermissions,
              ),
               IconButton(
                icon: const Icon(LucideIcons.settings_2, color: AppColors.textPrimaryDark, size: 20),
                onPressed: _showVoiceSelector,
              ),
            ],
          ),
          
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // Minimal Hijri Date
                Text(
                  _prayerTimes?.dateHijri ?? "",
                  style: GoogleFonts.outfit(
                    color: AppColors.textSecondaryDark, 
                    fontSize: 11,
                    letterSpacing: 1,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Main Countdown Card (Strictly #35363A)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(
                    color: AppColors.cardDark, // Strictly #35363A
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                       Text(
                        _calculatedNextPrayerName?.toUpperCase() ?? pt.nextPrayerName.toUpperCase(),
                        style: GoogleFonts.outfit(
                          color: AppColors.accent, // Premium Gold #D4AF37
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                        ),
                      ),
                      const SizedBox(height: 8),
                       Text(
                        _formatDuration(_timeUntilNextPrayer),
                        style: GoogleFonts.outfit(
                          color: AppColors.textPrimaryDark,
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.primary.withValues(alpha: 0.1),
                        ),
                        child: Text(
                          "Next at ${_calculatedNextPrayerTime ?? pt.nextPrayerTime}",
                          style: GoogleFonts.outfit(
                            color: AppColors.primary, // Sanctuary Emerald #10B981
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Daily Schedule List - Expanded to fit without scroll
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildPrayerRow("Fajr", pt.fajr, "الفجر", 0, 6),
                      _buildPrayerRow("Sunrise", pt.sunrise, "الشروق", 1, 6),
                      _buildPrayerRow("Dhuhr", pt.dhuhr, "الظُّهر", 2, 6),
                      _buildPrayerRow("Asr", pt.asr, "العصر", 3, 6),
                      _buildPrayerRow("Maghrib", pt.maghrib, "المغرب", 4, 6),
                      _buildPrayerRow("Isha", pt.isha, "العشاء", 5, 6),
                    ],
                  ),
                ),
                
                const SizedBox(height: 10),
                
                // Footer info
                Padding(
                  padding: const EdgeInsets.only(bottom: 100), // Space for nav pill
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LucideIcons.info, size: 12, color: AppColors.textSecondaryDark.withValues(alpha: 0.5)),
                      const SizedBox(width: 6),
                      Text(
                        "Adhan playing in foreground enabled.",
                        style: GoogleFonts.inter(color: AppColors.textSecondaryDark.withValues(alpha: 0.5), fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrayerRow(String english, String time, String arabic, int index, int total) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = AppColors.getTextPrimary(context);
    final secondaryTextColor = AppColors.getTextSecondary(context);
    final logService = PrayerLogService();

    bool isNext = english == (_calculatedNextPrayerName ?? _prayerTimes?.nextPrayerName);
    bool isPlayingThis = _playingPrayer == english;
    bool isPrayed = logService.isPrayed(DateTime.now(), english);
    
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Time Column
          SizedBox(
            width: 60,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  time,
                  style: GoogleFonts.outfit(
                    color: isNext ? AppColors.primary : secondaryTextColor,
                    fontSize: 12,
                    fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          
          // Timeline Column
          Column(
            children: [
              // Top line
              Container(
                width: 1,
                height: 16,
                color: index == 0 ? Colors.transparent : Colors.white.withOpacity(0.1),
              ),
              // Dot
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isPrayed || isNext ? AppColors.primary : Colors.transparent,
                  border: Border.all(
                    color: isPrayed || isNext ? AppColors.primary : Colors.white.withOpacity(0.2),
                    width: 2,
                  ),
                  boxShadow: isNext ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 2,
                    )
                  ] : [],
                ),
              ),
              // Bottom line
              Expanded(
                child: Container(
                  width: 1,
                  color: index == total - 1 ? Colors.transparent : Colors.white.withOpacity(0.1),
                ),
              ),
            ],
          ),
          
          const SizedBox(width: 20),
          
          // Content Column
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 2),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isNext 
                    ? AppColors.primary.withValues(alpha: 0.1) 
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isNext ? AppColors.primary.withValues(alpha: 0.2) : Colors.transparent,
                ),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        english,
                        style: GoogleFonts.outfit(
                          color: isNext ? AppColors.primary : textColor,
                          fontWeight: isNext ? FontWeight.bold : FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        arabic,
                        style: GoogleFonts.amiri(
                          color: isNext ? AppColors.primary.withOpacity(0.7) : textColor.withOpacity(0.4),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  
                  // Play button (Adhan)
                  if (isPlayingThis || isNext) ...[
                    IconButton(
                      icon: Icon(
                        isPlayingThis ? LucideIcons.circle_stop : LucideIcons.volume_2,
                        size: 20,
                        color: isPlayingThis ? AppColors.primary : secondaryTextColor.withOpacity(0.3),
                      ),
                      onPressed: () async {
                        HapticFeedback.lightImpact();
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
                    ),
                  ],

                  // Checkbox (Mark as Prayed)
                  if (english != "Sunrise")
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      logService.togglePrayer(DateTime.now(), english);
                      setState(() {}); // Local refresh
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: isPrayed ? AppColors.primary : (isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05)),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isPrayed ? AppColors.primary : Colors.white.withOpacity(0.1),
                          width: 1.5,
                        ),
                      ),
                      child: isPrayed 
                          ? const Icon(LucideIcons.check, size: 16, color: Colors.white)
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _checkPermissions() async {
    bool localReminder = _audioService.reminderEnabled;
    bool localNotification = _audioService.notificationEnabled;
    bool localSound = _audioService.soundEnabled;
    bool localShortAdhan = _audioService.shortAdhanEnabled;

    // Mutual Exclusion Logic
    // Option 1: Notification Only (Silent) -> sound=false
    // Option 2: 10s Adhan -> sound=true, short=true
    // Option 3: Full Adhan -> sound=true, short=false
    
    // UI State Helpers
    bool isSilent = localNotification && !localSound;
    bool isShort = localSound && localShortAdhan;
    bool isFull = localSound && !localShortAdhan;
    
    // Default to Silent if nothing set? Or off?
    if (!localNotification && !localSound) {
       // Everything off
       isSilent = false; isShort = false; isFull = false;
    }

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
                isSilent, 
                (v) => setDialogState(() {
                   if (v!) {
                     isSilent = true; isShort = false; isFull = false;
                   } else {
                     isSilent = false;
                   }
                })
              ),
              
              // Option 2: 10s Adhan (Fade In)
              _buildDialogCheckbox(
                "10-Second Adhan", 
                "Plays 10s of Adhan with soft fade-in.", 
                isShort, 
                (v) => setDialogState(() {
                   if (v!) {
                     isShort = true; isSilent = false; isFull = false;
                   } else {
                     isShort = false;
                   }
                })
              ),

              // Option 3: Full Adhan Sound
              _buildDialogCheckbox(
                "Full Adhan Sound", 
                "Play the beautiful full recitation.", 
                isFull, 
                (v) => setDialogState(() {
                   if (v!) {
                     isFull = true; isSilent = false; isShort = false;
                   } else {
                     isFull = false;
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
        // Map UI state back to Service flags
        // isSilent -> notification=true, sound=false
        // isShort  -> notification=true (optional), sound=true, short=true
        // isFull   -> notification=true (optional), sound=true, short=false
        
        bool newNotification = false;
        bool newSound = false;
        bool newShort = false;

        if (isSilent) {
          newNotification = true;
          newSound = false;
          newShort = false;
        } else if (isShort) {
          newSound = true;
          newShort = true;
          newNotification = true; // Still show notification banner
        } else if (isFull) {
          newSound = true;
          newShort = false;
          newNotification = true; // Still show notification banner
        }

        await _audioService.updateAdhanSettings(
          reminder: false, 
          notification: newNotification,
          sound: newSound,
          shortAdhan: newShort,
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
            Text("Choose Adhan Style", style: TextStyle(color: AppColors.getTextPrimary(context), fontSize: 20, fontWeight: FontWeight.bold)),
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
