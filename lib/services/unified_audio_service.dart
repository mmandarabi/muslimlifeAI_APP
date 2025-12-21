import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as fln;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:quran/quran.dart' as quran;

class SurahContext {
  final int surahId;
  final String surahName;
  final String? arabicName;

  SurahContext({
    required this.surahId,
    required this.surahName,
    this.arabicName,
  });
}

class UnifiedAudioService with WidgetsBindingObserver {
  static final UnifiedAudioService _instance = UnifiedAudioService._internal();

  factory UnifiedAudioService() {
    return _instance;
  }

  UnifiedAudioService._internal() {
    WidgetsBinding.instance.addObserver(this);
  }

  AudioPlayer? _audioPlayer;
  final fln.FlutterLocalNotificationsPlugin _notificationsPlugin = fln.FlutterLocalNotificationsPlugin();
  
  // Proxy Stream Controllers to persist across player instance changes
  final StreamController<PlayerState> _playerStateController = StreamController<PlayerState>.broadcast();
  final StreamController<Duration> _positionController = StreamController<Duration>.broadcast();
  final StreamController<Duration?> _durationController = StreamController<Duration?>.broadcast();
  
  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _durationSubscription;

  // Lifecycle Guards
  int _playbackSessionId = 0; // The surgical fix for race conditions
  int _lastCompletionEventTime = 0;
  bool _isTransitioning = false;
  bool _completionHandled = false;

  // Voice Preferences
  static const String _prefVoiceKey = 'selected_voice_key';
  static const String _prefVoiceSetKey = 'voice_explicitly_set';
  static const String _prefQuranReciterKey = 'selected_quran_reciter_key';
  static const String _prefReminderEnabled = 'adhan_reminder_enabled';
  static const String _prefNotificationEnabled = 'adhan_notification_enabled';
  static const String _prefSoundEnabled = 'adhan_sound_enabled';
  
  String _currentVoice = 'makkah'; // For Adhan
  String _currentQuranReciter = 'sudais'; // For Quran
  bool _isVoiceExplicitlySet = false;
  
  bool _reminderEnabled = true;
  bool _notificationEnabled = false;
  bool _soundEnabled = false;

  // Persistent Playback State
  double _playbackSpeed = 1.0;
  LoopMode _loopMode = LoopMode.off;

  // Timestamp Data Cache
  final Map<int, List<AyahSegment>> _ayahTimestampCache = {};

  // State
  String? _currentAsset; 
  int? _currentSurahId;

  bool get isPlaying => _audioPlayer?.playing ?? false;
  bool get isTransitioning => _isTransitioning;
  String? get currentAsset => _currentAsset;
  String get currentVoice => _currentVoice;
  String get currentQuranReciter => _currentQuranReciter;
  bool get isVoiceExplicitlySet => _isVoiceExplicitlySet;
  int? get currentSurahId => _currentSurahId;
  bool get reminderEnabled => _reminderEnabled;
  bool get notificationEnabled => _notificationEnabled;
  bool get soundEnabled => _soundEnabled;
  double get playbackSpeed => _playbackSpeed;
  LoopMode get loopMode => _loopMode;
  
  Duration get position => _audioPlayer?.position ?? Duration.zero;
  Duration? get duration => _audioPlayer?.duration;
  
  // Stream Getters (Proxied via Controllers)
  Stream<void> get onPlayerComplete => _playerStateController.stream
      .where((state) => state.processingState == ProcessingState.completed)
      .map((_) => null);

  Stream<PlayerState> get onPlayerStateChanged => _playerStateController.stream;
  Stream<Duration> get onPositionChanged => _positionController.stream;
  Stream<Duration?> get onDurationChanged => _durationController.stream;

  final ValueNotifier<bool> downloadingNotifier = ValueNotifier(false);
  final ValueNotifier<bool> transitioningNotifier = ValueNotifier(false);
  final ValueNotifier<int?> surahChangedNotifier = ValueNotifier(null);
  final ValueNotifier<SurahContext?> currentSurahContext = ValueNotifier(null);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}

  Future<void> init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    
    final prefs = await SharedPreferences.getInstance();
    _currentVoice = prefs.getString(_prefVoiceKey) ?? 'makkah';
    _currentQuranReciter = prefs.getString(_prefQuranReciterKey) ?? 'sudais';
    _isVoiceExplicitlySet = prefs.getBool(_prefVoiceSetKey) ?? false;
    _reminderEnabled = prefs.getBool(_prefReminderEnabled) ?? true;
    _notificationEnabled = prefs.getBool(_prefNotificationEnabled) ?? false;
    _soundEnabled = prefs.getBool(_prefSoundEnabled) ?? false;
    
    await _initNotificationChannel();
    tz_data.initializeTimeZones();
  }

  Future<void> _ensurePlayerInitialized() async {
    if (_audioPlayer != null) return;
    
    debugPrint("UnifiedAudioService: Initializing Persistent AudioPlayer instance.");
    final player = AudioPlayer();
    _audioPlayer = player;
    
    // Wire up proxy streams with persistent subscription
    // We use the stream controllers to broadcast values regardless of internal state
    _playerStateSubscription = player.playerStateStream.listen((state) {
        _playerStateController.add(state);
        
        // Sync downloading state with player loading/buffering
        final isBuffering = state.processingState == ProcessingState.buffering || 
                           state.processingState == ProcessingState.loading;
        if (downloadingNotifier.value != isBuffering) {
          downloadingNotifier.value = isBuffering;
        }

        // Handle completion logic internally using the LATEST session ID
        if (state.processingState == ProcessingState.completed && !_completionHandled) {
           final now = DateTime.now().millisecondsSinceEpoch;
           if (now - _lastCompletionEventTime > 2000) {
              _lastCompletionEventTime = now;
              _onPlaybackComplete(_playbackSessionId); 
           }
        }
    });

    _positionSubscription = player.positionStream.listen((pos) {
        _positionController.add(pos);
    });

    _durationSubscription = player.durationStream.listen((dur) {
        _durationController.add(dur);
    });
  }
  
  Future<void> _onPlaybackComplete(int completedSessionId) async {
      // 1. ATOMIC GUARD: Fire once and only once
      if (_completionHandled) return;
      
      // 2. SESSION GUARD: Is this still the active session?
      if (_playbackSessionId != completedSessionId) {
        debugPrint("UnifiedAudioService: Completion ignored - session ID mismatch ($completedSessionId vs $_playbackSessionId)");
        return;
      }
      
      _completionHandled = true;
      
      // 3. Capture LOCALLY to survive the await stop() which clears global state
      final currentId = _currentSurahId;

      if (currentId != null && currentId < 114) {
        debugPrint("UnifiedAudioService: Surah $currentId complete. Advancing to ${currentId + 1}");
        
        _isTransitioning = true;
        transitioningNotifier.value = true;
        
        // 4. AWAIT FULL STOP (Fresh Player Pattern)
        await stop();
        
        // 5. Small delay for OS audio settlement
        await Future.delayed(const Duration(milliseconds: 400));
        
        // 6. Begin new surah using CAPTURED ID (which will increment session ID again)
        await playSurah(currentId + 1);
        
      } else {
        debugPrint("UnifiedAudioService: Playback finished (End of Quran or manual stop)");
        await stop();
        _currentAsset = null;
        _currentSurahId = null;
        _isTransitioning = false;
        transitioningNotifier.value = false;
        _completionHandled = false; 
      }
  }

  Future<void> _initNotificationChannel() async {
    const androidSettings = fln.AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = fln.DarwinInitializationSettings(
      requestAlertPermission: true, 
      requestSoundPermission: true,
      requestBadgePermission: true,
    );
    const settings = fln.InitializationSettings(android: androidSettings, iOS: iosSettings);
    
    await _notificationsPlugin.initialize(settings);

    const androidAdhanChannel = fln.AndroidNotificationChannel(
        'adhan_channel_v1',
        'Adhan Notifications',
        description: 'Critical notifications for prayer times',
        importance: fln.Importance.max,
        playSound: true,
        sound: fln.RawResourceAndroidNotificationSound('adhan_makkah'),
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<fln.AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidAdhanChannel);
  }

  Future<void> updateAdhanSettings({bool? reminder, bool? notification, bool? sound}) async {
    final prefs = await SharedPreferences.getInstance();
    if (reminder != null) {
      _reminderEnabled = reminder;
      await prefs.setBool(_prefReminderEnabled, reminder);
    }
    if (notification != null) {
      _notificationEnabled = notification;
      await prefs.setBool(_prefNotificationEnabled, notification);
    }
    if (sound != null) {
      _soundEnabled = sound;
      await prefs.setBool(_prefSoundEnabled, sound);
    }
  }
  
  Future<bool> requestNotificationPermissions() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final bool? result = await _notificationsPlugin
          .resolvePlatformSpecificImplementation<fln.IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      return result ?? false;
    } else if (defaultTargetPlatform == TargetPlatform.android) {
       final fln.AndroidFlutterLocalNotificationsPlugin? androidImplementation =
            _notificationsPlugin.resolvePlatformSpecificImplementation<
                fln.AndroidFlutterLocalNotificationsPlugin>();
        return await androidImplementation?.requestNotificationsPermission() ?? false;
    }
    return false;
  }

  Future<void> playAdhan() async {
    await stop(); 
    await _playAdhanInternal(false);
  }
  
  Future<void> playAdhanWithFade() async {
    await stop();
    await _playAdhanInternal(true);
  }

  Future<void> playAdhanCue() async {
    // 1. INVALIDATE IMMEDIATELY
    _playbackSessionId++;
    final int currentSession = _playbackSessionId; 
    
    // 2. STOP GENTLY
    if (_audioPlayer != null) {
      try {
        await _audioPlayer!.stop();
      } catch (e) {
        debugPrint("UnifiedAudioService: Adhan stop error - $e");
      }
    }

    // 4. GUARD
    if (_playbackSessionId != currentSession) return;

    await _playAdhanInternal(true);
    
    Future.delayed(const Duration(seconds: 10), () async {
       if (_playbackSessionId == currentSession && _audioPlayer != null && _audioPlayer!.playing && _currentAsset != null && _currentAsset!.contains('audio/Adhan')) {
          debugPrint("UnifiedAudioService: Auto-stopping Adhan cue.");
          await stop();
       }
    });
  }

  Future<void> _playAdhanInternal(bool fade) async {
    final int currentSession = _playbackSessionId;
    String filename;
    switch (_currentVoice.toLowerCase()) {
      case 'madinah': filename = 'Madinah'; break;
      case 'quds': filename = 'Al-Quds'; break;
      case 'makkah': 
      default: filename = 'Makkah'; break;
    }
    
    final assetPath = 'assets/audio/Adhan/$filename.mp3'; 
    debugPrint("UnifiedAudioService: Attempting to play $assetPath (Fade: $fade, Session: $currentSession)");

    // Clear Surah context when playing Adhan
    currentSurahContext.value = null;

    try {
      await _ensurePlayerInitialized();
      if (_playbackSessionId != currentSession) return;

      if (fade) {
        await _audioPlayer?.setVolume(0.1); 
      } else {
        await _audioPlayer?.setVolume(1.0);
      }
      
      await _audioPlayer?.setAudioSource(AudioSource.asset(assetPath));
      if (_playbackSessionId != currentSession) return;

      _currentAsset = assetPath;
      await _audioPlayer?.play();
      
      if (fade) {
        _startVolumeRamp(currentSession);
      }
    } catch (e) {
      debugPrint("UnifiedAudioService: Error playing Adhan - $e");
    }
  }

  /// Updates the internal context without starting playback.
  /// Used for preserving state during browsing while paused.
  void setContext(int surahId) {
    if (_currentSurahId == surahId) return;
    _currentSurahId = surahId;
    currentSurahContext.value = SurahContext(
      surahId: surahId,
      surahName: quran.getSurahName(surahId),
      arabicName: quran.getSurahNameArabic(surahId),
    );
  }

  Timer? _volumeTimer;

  void _startVolumeRamp(int sessionId) {
    _volumeTimer?.cancel();
    double volume = 0.1;
    _volumeTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (_playbackSessionId != sessionId || _audioPlayer == null || !_audioPlayer!.playing) {
         timer.cancel();
         return;
      }
      volume += 0.1;
      if (volume >= 1.0) {
        volume = 1.0;
        _audioPlayer?.setVolume(1.0);
        timer.cancel();
      } else {
        _audioPlayer?.setVolume(volume);
      }
    });
  }

  Future<void> playSurah(int surahId, {int? ayahNumber, Duration? fromPosition}) async {
    // 1. INVALIDATE IMMEDIATELY & NOTIFY UI EARLY
    _playbackSessionId++; 
    final int currentSession = _playbackSessionId;
    _currentSurahId = surahId;

    // 🛑 SEEK FIX: If ayahNumber is provided but fromPosition is null, lookup the timestamp.
    if (ayahNumber != null && fromPosition == null) {
      final segments = await getAyahTimestamps(surahId);
      final segment = segments.firstWhere(
        (s) => s.ayahNumber == ayahNumber, 
        orElse: () => AyahSegment(ayahNumber: 0, timestampFrom: 0, timestampTo: 0)
      );
      fromPosition = Duration(milliseconds: segment.timestampFrom);
      debugPrint("UnifiedAudioService: Seeking to Ayah $ayahNumber at ${fromPosition.inMilliseconds}ms");
    }

    // Update Global Context
    currentSurahContext.value = SurahContext(
      surahId: surahId,
      surahName: quran.getSurahName(surahId),
      arabicName: quran.getSurahNameArabic(surahId),
    );
    
    debugPrint("TRACE: UnifiedAudioService.playSurah($surahId, ayah: $ayahNumber) - SETTING NOTIFIER EARLY");
    surahChangedNotifier.value = surahId; 
    
    debugPrint("TRACE: UnifiedAudioService.playSurah($surahId) - SESSION $currentSession START");

    // 🛑 FIX: Reuse Player instance 🛑
    // instead of disposing and recreating, we just stop and set a new source.
    if (_audioPlayer != null) {
      try {
        await _audioPlayer!.stop();
      } catch (e) {
        debugPrint("UnifiedAudioService: Warning - Old player stop failed (Ignored): $e");
      }
    }

    _completionHandled = false; 

    // 3. GUARD: Did we get superseded during the stop?
    if (_playbackSessionId != currentSession) {
       debugPrint("UnifiedAudioService: Session $currentSession aborted before allocation.");
       return;
    }
    
    try {
      // 4. ENSURE INITIALIZED
      await _ensurePlayerInitialized();
      
      if (_playbackSessionId != currentSession) return;

      // Reset loading states - UI will now follow processingState via notifier
      _isTransitioning = false; 
      transitioningNotifier.value = false;

      await _audioPlayer?.setVolume(0.1); 
      await _audioPlayer?.setSpeed(_playbackSpeed);
      await _audioPlayer?.setLoopMode(_loopMode);

      // Reciter Logic
      String baseUrl = 'https://download.quranicaudio.com/qdc/abdurrahmaan_as_sudais/murattal/';
      String fileNameForUrl = surahId.toString(); 

      switch (_currentQuranReciter) {
        case 'saad':
          baseUrl = 'https://download.quranicaudio.com/qdc/saad_al_ghamidi/murattal/';
          break;
        case 'mishary':
          baseUrl = 'https://download.quranicaudio.com/qdc/mishari_alafasy/murattal/';
          break;
        default:
          baseUrl = 'https://download.quranicaudio.com/qdc/abdurrahmaan_as_sudais/murattal/';
          break;
      }

      final url = '$baseUrl$fileNameForUrl.mp3';
      debugPrint("UnifiedAudioService: Session $currentSession loading from $url");
      
      // 4. Load source (Async)
      await _audioPlayer?.setAudioSource(
          AudioSource.uri(Uri.parse(url)),
          initialPosition: fromPosition ?? Duration.zero,
      );
      
      // 5. GUARD: Did another request come in during long load?
      if (_playbackSessionId != currentSession) {
         debugPrint("UnifiedAudioService: Session $currentSession superseded after load.");
         return;
      }

      _currentAsset = url;
      _isTransitioning = false; 
      
      await _audioPlayer?.play();
      _startVolumeRamp(currentSession);
      
    } catch (e) {
      debugPrint("UnifiedAudioService: Error in Session $currentSession - $e");
    } finally {
      if (_playbackSessionId == currentSession) {
        _isTransitioning = false;
        transitioningNotifier.value = false;
        downloadingNotifier.value = false;
      }
    }
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer?.seek(position);
  }

  Future<void> pause() async {
    await _audioPlayer?.pause();
  }

  Future<void> resume() async {
    debugPrint("UnifiedAudioService: resume() called. CurrentSurahId: $_currentSurahId, PlayerState: ${_audioPlayer?.processingState}");
    
    await _ensurePlayerInitialized();
    if (_audioPlayer != null && _audioPlayer!.processingState != ProcessingState.idle) {
      await _audioPlayer!.play();
    } else if (_currentSurahId != null) {
      debugPrint("UnifiedAudioService: Player is idle/null but currentSurahId is set. Starting playback for $_currentSurahId");
      await playSurah(_currentSurahId!);
    } else {
      debugPrint("UnifiedAudioService: resume() failed - no active surah to play.");
    }
  }

  Future<void> setSpeed(double speed) async {
    _playbackSpeed = speed;
    await _audioPlayer?.setSpeed(speed);
  }

  Future<void> setLoopMode(LoopMode mode) async {
    _loopMode = mode;
    await _audioPlayer?.setLoopMode(mode);
  }

  /// Stops current playback and sets the context for a new Surah without playing.
  /// Used for library navigation where we want to "prime" the player for Sura B.
  Future<void> prepareSurah(int surahId, String surahName, {String? arabicName}) async {
    await stop(); 
    
    _currentSurahId = surahId;
    currentSurahContext.value = SurahContext(
      surahId: surahId,
      surahName: surahName,
      arabicName: arabicName ?? quran.getSurahNameArabic(surahId),
    );
    surahChangedNotifier.value = surahId;
  }

  Future<void> stop() async {
    // 1. INVALIDATE IMMEDIATELY
    final int currentSession = ++_playbackSessionId; 
    _volumeTimer?.cancel();
    _isTransitioning = false;
    transitioningNotifier.value = false;
    downloadingNotifier.value = false;

    if (_audioPlayer != null) {
      try {
        await _audioPlayer!.stop();
      } catch (e) {
        debugPrint("UnifiedAudioService: stop error - $e");
      }
    }

    // 2. SESSION GUARD: Only clear global state if we haven't been superseded
    if (_playbackSessionId == currentSession) {
      _currentAsset = null;
      _currentSurahId = null;
      currentSurahContext.value = null;
      _completionHandled = false;
    }
  }

  Future<void> setVoice(String voice) async {
    _currentVoice = voice;
    _isVoiceExplicitlySet = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefVoiceKey, voice);
    await prefs.setBool(_prefVoiceSetKey, true);
  }

  Future<void> setQuranReciter(String reciterId) async {
    _currentQuranReciter = reciterId;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefQuranReciterKey, reciterId);
  }
  
  Future<void> scheduleAdhanNotifications(Map<String, DateTime> prayerTimes) async {
    await _notificationsPlugin.cancelAll(); 
    
    try {
      final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(currentTimeZone));
    } catch (e) {
      debugPrint("UnifiedAudioService: Timezone setup error - $e");
    }
    
    int id = 100;
    for (var entry in prayerTimes.entries) {
      final prayerName = entry.key;
      final scheduledTime = entry.value;
      if (scheduledTime.isBefore(DateTime.now())) continue; 

      final reminderTime = scheduledTime.subtract(const Duration(minutes: 5));
      if (_reminderEnabled && reminderTime.isAfter(DateTime.now())) {
          await _notificationsPlugin.zonedSchedule(
            id++,
            'Upcoming: $prayerName',
            'Prayer starts in 5 minutes.',
            tz.TZDateTime.from(reminderTime, tz.local),
            const fln.NotificationDetails(
              android: fln.AndroidNotificationDetails(
                'reminder_channel_v1',
                'Prayer Reminders',
                 channelDescription: '5-minute warnings before prayer',
                 importance: fln.Importance.high, 
                 priority: fln.Priority.high,
              ),
              iOS: fln.DarwinNotificationDetails(presentAlert: true, presentSound: true),
            ),
            androidScheduleMode: fln.AndroidScheduleMode.exactAllowWhileIdle,
            // uiLocalNotificationDateInterpretation: fln.UILocalNotificationDateInterpretation.absoluteTime,
          );
      }

      if (_notificationEnabled || _soundEnabled) {
        // 🛑 iOS FIX: Ensure we use common extensions or match the filename exactly.
        // Android handles 'adhan_makkah' without extension from res/raw.
        // iOS requires the file with extension in the app bundle.
        final String soundFile = 'adhan_makkah.mp3'; 

        await _notificationsPlugin.zonedSchedule(
          id++,
          '$prayerName Prayer Time',
          _soundEnabled ? 'Al-Adhan: High quality recitation' : 'Time for $prayerName prayer.',
          tz.TZDateTime.from(scheduledTime, tz.local),
          fln.NotificationDetails(
            android: fln.AndroidNotificationDetails(
              'adhan_channel_v1',
              'Adhan Notifications',
               channelDescription: 'Plays Adhan sound or notification at prayer time',
               importance: _soundEnabled ? fln.Importance.max : fln.Importance.high, 
               priority: _soundEnabled ? fln.Priority.max : fln.Priority.high,
               sound: _soundEnabled ? fln.RawResourceAndroidNotificationSound('adhan_makkah') : null,
               playSound: _soundEnabled,
               fullScreenIntent: _soundEnabled,
            ),
            iOS: fln.DarwinNotificationDetails(
              presentAlert: true,
              presentSound: _soundEnabled,
              sound: _soundEnabled ? soundFile : null,
            ),
          ),
          androidScheduleMode: fln.AndroidScheduleMode.exactAllowWhileIdle,
          // uiLocalNotificationDateInterpretation: fln.UILocalNotificationDateInterpretation.absoluteTime,
        );
      }
    }
  }

  List<String> getAvailableVoices() {
    return ['makkah', 'madinah', 'quds'];
  }

  Future<List<AyahSegment>> getAyahTimestamps(int surahId) async {
    if (_ayahTimestampCache.containsKey(surahId)) {
      return _ayahTimestampCache[surahId]!;
    }

    try {
      debugPrint("UnifiedAudioService: Fetching precision timestamps for Surah $surahId...");
      final url = 'https://api.quran.com/api/v4/chapter_recitations/3/$surahId?segments=true';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> timestampData = data['audio_file']['timestamps'];
        
        final List<AyahSegment> segments = timestampData.map((t) {
          final parts = t['verse_key'].toString().split(':');
          final ayahNum = int.parse(parts[1]);
          
          return AyahSegment(
            ayahNumber: ayahNum,
            timestampFrom: t['timestamp_from'],
            timestampTo: t['timestamp_to'],
          );
        }).toList();

        _ayahTimestampCache[surahId] = segments;
        return segments;
      }
    } catch (e) {
      debugPrint("UnifiedAudioService: Error fetching timestamps: $e");
    }

    return [];
  }
}

class AyahSegment {
  final int ayahNumber;
  final int timestampFrom; // in milliseconds
  final int timestampTo; // in milliseconds

  AyahSegment({
    required this.ayahNumber,
    required this.timestampFrom,
    required this.timestampTo,
  });
}