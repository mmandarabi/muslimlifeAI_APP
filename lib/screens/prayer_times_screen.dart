import 'dart:async';
import 'package:audioplayers/audioplayers.dart'; // For PlayerState
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
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
  
  // Audio Service
  final UnifiedAudioService _audioService = UnifiedAudioService();
  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _playerCompleteSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadPrayerTimes();
    _audioService.init();
    
    // Listen for external stop or completion
    _playerStateSubscription = _audioService.onPlayerStateChanged.listen((state) {
        if (state != PlayerState.playing && mounted) {
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
    _audioService.stop(); 
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
      
      await _audioService.scheduleAdhanNotifications(times);
  }

  void _startCountdown() {
    if (_prayerTimes == null) return;
    
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      DateTime? nextTime = _parseTime(_prayerTimes!.nextPrayerTime);
      
      if (nextTime != null) {
        // Auto-Play Logic: Check tight window (e.g. 0-1 second match)
        // Only if app is foreground (which is true if this timer is running usually, but check lifecycle state ideally).
        // Since we are in Widget, we assume standard behavior.
        
        if (nextTime.hour == now.hour && nextTime.minute == now.minute && now.second == 0) {
            // Guard: Only fire if we haven't already for this time slot
            if (_lastAutoAdhanTime == null || now.difference(_lastAutoAdhanTime!).inMinutes >= 1) {
                _handleAutoAdhan();
                _lastAutoAdhanTime = now;
            }
        }
        
        if (nextTime.isBefore(now)) {
             nextTime = nextTime.add(const Duration(days: 1));
        }
        
        final diff = nextTime.difference(now);
        if (mounted) {
          setState(() {
            _timeUntilNextPrayer = diff;
          });
        }
      }
    });
  }
  
  void _handleAutoAdhan() async {
      // 1. User Intent Guard: If user stopped it, don't restart it.
      if (_userStoppedAdhan) {
         debugPrint("UI: Auto-Adhan BLOCKED by user intent lock.");
         return;
      }
      
      // 2. Permission Guard: Check silently (don't request if not already granted/determined)
      // Actually, for foreground auto-play, we assume if they are on this screen, they might want it.
      // But per request: "Adhan plays at prayer time when notifications are enabled."
      // We will check permission status without prompting if possible, or just assume enabled for now based on user flow.
      // Reverting to simple specific requirement: "if app is open... and notifications enabled"
      
      bool enabled = await _audioService.requestNotificationPermissions(); 
      if (enabled) {
          debugPrint("Auto-Adhan Triggered (Foreground)");
          if (mounted && _prayerTimes != null) {
             setState(() {
                _playingPrayer = _prayerTimes!.nextPrayer;
             });
          }
          _audioService.playAdhanWithFade();
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
        // Background Gradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0B1410), // Deep Green/Black
                Color(0xFF0B0C0E), // Black
              ],
            ),
          ),
        ),
        
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(LucideIcons.menu, color: Colors.white),
              onPressed: () {},
            ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(LucideIcons.map_pin, size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  "Belmont, VA", // Dynamic?
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            centerTitle: true,
            actions: [
              IconButton( // Notification Toggle Button
                icon: const Icon(LucideIcons.bell, color: Colors.white),
                onPressed: _checkPermissions, // Request/Show Rationale
              ),
               IconButton(
                icon: const Icon(LucideIcons.settings_2, color: Colors.white),
                onPressed: _showVoiceSelector,
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(20),
              child: Text(
                _prayerTimes?.dateHijri ?? "27 Jumada al-Awwal 1447 AH",
                style: const TextStyle(color: Colors.white54, fontSize: 12),
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
                    padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                    child: Column(
                      children: [
                         Text(
                          pt.nextPrayerName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(height: 10),
                         Text(
                          _formatDuration(_timeUntilNextPrayer),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            fontFeatures: [FontFeature.tabularFigures()],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.primary.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(20),
                            color: AppColors.primary.withOpacity(0.1),
                          ),
                          child: Text(
                            "Next Prayer at ${pt.nextPrayerTime}",
                            style: const TextStyle(color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // Daily Schedule List
                _buildPrayerRow("Fajr", pt.fajr, "الفجر"),
                const SizedBox(height: 12),
                _buildPrayerRow("Dhuhr", pt.dhuhr, "الظهر"),
                const SizedBox(height: 12),
                _buildPrayerRow("Asr", pt.asr, "العصر"),
                const SizedBox(height: 12),
                _buildPrayerRow("Maghrib", pt.maghrib, "المغرب"), // Highlight if current?
                const SizedBox(height: 12),
                _buildPrayerRow("Isha", pt.isha, "العشاء"),
                
                const SizedBox(height: 30),
                
                 Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.volume_2, size: 16, color: Colors.white54),
                    SizedBox(width: 8),
                    Text(
                      "Adhan plays at prayer time when notifications are enabled.",
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ),
                 const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrayerRow(String english, String time, String arabic) {
    bool isNext = english == _prayerTimes?.nextPrayerName;
    bool isPlayingThis = _playingPrayer == english;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: isNext ? const Color(0xFF0B1410).withOpacity(0.8) : const Color(0xFF1E1E1E),
        border: isNext ? Border.all(color: AppColors.primary.withOpacity(0.5)) : Border.all(color: Colors.white10),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              english,
              style: TextStyle(
                color: isNext ? AppColors.primary : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const Spacer(),
          Text(
            arabic,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'KFGQPCUthmanic', // Assuming font is available
            ),
          ),
          const Spacer(),
          Text(
            time,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 16),
          
          // Speaker Icon Toggle
          GestureDetector(
            onTap: () {
              final now = DateTime.now();
              if (_lastTapTime != null && now.difference(_lastTapTime!).inMilliseconds < 1000) {
                debugPrint("UI: Tap debounced.");
                return; // Debounce
              }
              _lastTapTime = now;

              if (isPlayingThis) {
                debugPrint("UI: User manually TAP STOP");
                _userStoppedAdhan = true; // User explicitly stopped it
                _audioService.stop();
                setState(() => _playingPrayer = null);
              } else {
                debugPrint("UI: User manually TAP PLAY");
                _userStoppedAdhan = false; // User explicitly played it, reset lock
                _audioService.playAdhan(); // Full Adhan explicit play
                setState(() => _playingPrayer = english);
              }
            },
            child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: isPlayingThis ? AppColors.primary.withOpacity(0.2) : Colors.transparent,
                    shape: BoxShape.circle,
                ),
                child: Icon(
                  isPlayingThis ? Icons.stop_circle_outlined : LucideIcons.volume_2, // Play/Stop Toggle
                  color: isPlayingThis ? AppColors.primary : Colors.grey, // Active Green, Inactive Gray
                  size: 20,
                ),
            ).animate(target: isPlayingThis ? 1 : 0).scale(begin: const Offset(1,1), end: const Offset(1.1, 1.1)),
          ),
          
          const SizedBox(width: 8),
          
          // Radio Button (just visual or logic?) existing UI had it.
          // Keeping it as visual check for "Next" or just empty circle
           Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _checkPermissions() async {
    final bool? shouldRequest = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text("Enable Adhan Notifications?", style: TextStyle(color: Colors.white)),
        content: const Text(
          "To hear the Adhan at prayer times, please allow notifications. We verify this respects your device's \"Do Not Disturb\" settings.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Later", style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Enable"),
          ),
        ],
      ),
    );

    if (shouldRequest == true) {
      final granted = await _audioService.requestNotificationPermissions();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(granted ? "Notifications Enabled" : "Permission Denied"),
            backgroundColor: granted ? Colors.green : Colors.red,
          ),
        );
      }
    }
  }

  void _showVoiceSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0B0C0E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Select Adhan Voice", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
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
    return ListTile(
      title: Text(label, style: const TextStyle(color: Colors.white)),
      leading: const Icon(LucideIcons.mic, color: Colors.white70),
      onTap: () async {
        await _audioService.setVoice(id);
        if (mounted) Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Voice set to $label")));
      },
      trailing: const Icon(LucideIcons.chevron_right, color: Colors.white38, size: 16),
    );
  }
}
