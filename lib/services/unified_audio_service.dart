import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class UnifiedAudioService with WidgetsBindingObserver {
  static final UnifiedAudioService _instance = UnifiedAudioService._internal();

  factory UnifiedAudioService() {
    return _instance;
  }

  UnifiedAudioService._internal() {
    WidgetsBinding.instance.addObserver(this);
  }

  final AudioPlayer _audioPlayer = AudioPlayer();
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  
  // Voice Preferences
  static const String _prefVoiceKey = 'selected_voice_key';
  static const String _prefVoiceSetKey = 'voice_explicitly_set';
  static const String _prefQuranReciterKey = 'selected_quran_reciter_key';
  
  String _currentVoice = 'makkah'; // For Adhan
  String _currentQuranReciter = 'sudais'; // For Quran
  bool _isVoiceExplicitlySet = false;

  // State
  bool _isPlaying = false;
  String? _currentAsset; 

  bool get isPlaying => _isPlaying;
  String? get currentAsset => _currentAsset;
  String get currentVoice => _currentVoice;
  String get currentQuranReciter => _currentQuranReciter;
  bool get isVoiceExplicitlySet => _isVoiceExplicitlySet;
  
  Stream<void> get onPlayerComplete => _audioPlayer.onPlayerComplete;
  Stream<PlayerState> get onPlayerStateChanged => _audioPlayer.onPlayerStateChanged;

  final ValueNotifier<bool> downloadingNotifier = ValueNotifier(false);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Audio continues in background as per user requirement.
    // Logic removed.
  }

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _currentVoice = prefs.getString(_prefVoiceKey) ?? 'makkah';
    _currentQuranReciter = prefs.getString(_prefQuranReciterKey) ?? 'sudais';
    _isVoiceExplicitlySet = prefs.getBool(_prefVoiceSetKey) ?? false;
    
    _audioPlayer.onPlayerStateChanged.listen((state) {
      _isPlaying = state == PlayerState.playing;
    });
    
    _audioPlayer.onPlayerComplete.listen((event) {
      _isPlaying = false;
      _currentAsset = null;
    });
    
    await _initNotificationChannel();
    tz.initializeTimeZones();
  }
  
  Future<void> _initNotificationChannel() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false, 
      requestSoundPermission: false,
      requestBadgePermission: false,
    );
    const settings = InitializationSettings(android: androidSettings, iOS: iosSettings);
    
    await _notificationsPlugin.initialize(settings);
  }
  
  Future<bool> requestNotificationPermissions() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final bool? result = await _notificationsPlugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      return result ?? false;
    } else if (defaultTargetPlatform == TargetPlatform.android) {
        final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
            _notificationsPlugin.resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();
        
        final bool? granted = await androidImplementation?.requestNotificationsPermission();
        return granted ?? false;
    }
    return false;
  }

  Future<void> playAdhan() async {
    await _stopInternal(); 
    await _playAdhanInternal(false);
  }
  
  Future<void> playAdhanWithFade() async {
    await _stopInternal();
    await _playAdhanInternal(true);
  }

  Future<void> _playAdhanInternal(bool fade) async {
    final methodStartTime = DateTime.now();

    // Guard: If Stop was pressed very recently (race condition from UI toggle), abort.
    if (_lastStopRequest.isAfter(methodStartTime)) return;

    String filename;
    switch (_currentVoice.toLowerCase()) {
      case 'madinah': filename = 'Madinah'; break;
      case 'quds': filename = 'Al-Quds'; break;
      case 'makkah': 
      default: filename = 'Makkah'; break;
    }
    
    final assetPath = 'audio/Adhan/$filename.mp3';
    debugPrint("UnifiedAudioService: Attempting to play $assetPath (Fade: $fade)");

    try {
      if (fade) {
        await _audioPlayer.setVolume(0.1); 
      } else {
        await _audioPlayer.setVolume(1.0);
      }
      
      // Re-check interruption before actual play
      if (_lastStopRequest.isAfter(methodStartTime)) {
         debugPrint("UnifiedAudioService: Adhan cancelled by stop request.");
         return;
      }
      
      await _audioPlayer.play(AssetSource(assetPath));
      _currentAsset = assetPath;
      
      if (fade) {
        // Ramp up volume over 2 seconds
        _volumeTimer?.cancel();
        double volume = 0.1;
        _volumeTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
          if (_lastStopRequest.isAfter(methodStartTime)) {
             timer.cancel();
             return;
          }
          volume += 0.1;
          if (volume >= 1.0) {
            volume = 1.0;
            _audioPlayer.setVolume(1.0);
            timer.cancel();
          } else {
            _audioPlayer.setVolume(volume);
          }
        });
      }
    } catch (e) {
      debugPrint("UnifiedAudioService: Error playing Adhan - $e");
    }
  }

  http.Client? _activeDownloadClient;
  Timer? _volumeTimer;
  DateTime _lastStopRequest = DateTime.fromMillisecondsSinceEpoch(0);

  Future<void> playSurah(int surahId, {int? ayahNumber}) async {
    // 1. Pre-emptive Switch: Stop anything currently playing or downloading
    await stop(); 
    
    // 2. Start a fresh lifecycle for this request
    _activeDownloadClient = http.Client();
    final methodStartTime = DateTime.now();

    try {
      downloadingNotifier.value = true; // Lock UI spinner
      
      // Gentle fade-in start volume
      await _audioPlayer.setVolume(0.1); 

      final formattedId = surahId.toString().padLeft(3, '0');
      final fileName = 'surah_${formattedId}_$_currentQuranReciter.mp3';

      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$fileName');
      final tempFile = File('${dir.path}/$fileName.temp');

      // Sync check: was stop requested while we were setting up?
      if (_lastStopRequest.isAfter(methodStartTime)) return;

      if (await file.exists()) {
        await _audioPlayer.play(DeviceFileSource(file.path));
        _currentAsset = file.path;
      } else {
        // Dynamic reciter path logic
        String baseUrl = 'https://download.quranicaudio.com/quran/abdurrahmaan_as-sudays/';
        switch (_currentQuranReciter) {
          case 'saad':
            baseUrl = 'https://download.quranicaudio.com/quran/sa3d_al-ghaamidi/complete/';
            break;
          case 'mishary':
            baseUrl = 'https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/';
            break;
          default:
            baseUrl = 'https://download.quranicaudio.com/quran/abdurrahmaan_as-sudays/';
            break;
        }

        final url = '$baseUrl$formattedId.mp3';
        debugPrint("UnifiedAudioService: Downloading from $url");
        
        // Resumable Download Logic
        int startByte = 0;
        if (await tempFile.exists()) {
          startByte = await tempFile.length();
        }

        final headers = startByte > 0 ? {'Range': 'bytes=$startByte-'} : <String, String>{};
        
        // Use the managed client for pre-emptive cancellation
        final response = await _activeDownloadClient!.get(Uri.parse(url), headers: headers);
        
        if (_lastStopRequest.isAfter(methodStartTime)) return;

        if (response.statusCode == 200 || response.statusCode == 206) {
          final mode = (response.statusCode == 206) ? FileMode.append : FileMode.write;
          final raf = await tempFile.open(mode: mode);
          await raf.writeFrom(response.bodyBytes);
          await raf.close();
          
          await tempFile.rename(file.path);

          // Verify again before playing
          if (_lastStopRequest.isAfter(methodStartTime)) return;

          await _audioPlayer.play(DeviceFileSource(file.path));
          _currentAsset = file.path;
        } else if (response.statusCode == 416) {
           debugPrint("UnifiedAudioService: Range error 416. Resetting.");
           await tempFile.delete(); 
           return;
        } else {
          debugPrint("UnifiedAudioService: Failed to download - ${response.statusCode}");
          return;
        }
      }

      // Gentle Fade-In Effect
      _volumeTimer?.cancel();
      double volume = 0.1;
      _volumeTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        if (_lastStopRequest.isAfter(methodStartTime)) {
           timer.cancel();
           return;
        }
        volume += 0.1;
        if (volume >= 1.0) {
          volume = 1.0;
          _audioPlayer.setVolume(1.0);
          timer.cancel();
        } else {
          _audioPlayer.setVolume(volume);
        }
      });
      
    } catch (e) {
      if (e is http.ClientException || e.toString().contains('closed')) {
        debugPrint("UnifiedAudioService: Request cancelled by user action.");
      } else {
        debugPrint("UnifiedAudioService: Error in playSurah - $e");
      }
    } finally {
      downloadingNotifier.value = false;
    }
  }
  


  Future<void> stop() async {
    debugPrint("UnifiedAudioService: STOP requested");
    _lastStopRequest = DateTime.now();
    await _stopInternal();
  }

  Future<void> _stopInternal() async {
    _volumeTimer?.cancel();
    _activeDownloadClient?.close();
    _activeDownloadClient = null;
    await _audioPlayer.stop();
    _isPlaying = false;
    _currentAsset = null;
    downloadingNotifier.value = false;
  }

  Future<void> setVoice(String voice) async {
    // This now strictly controls ADHAN voice
    _currentVoice = voice;
    _isVoiceExplicitlySet = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefVoiceKey, voice);
    await prefs.setBool(_prefVoiceSetKey, true);
  }

  Future<void> setQuranReciter(String reciterId) async {
    // This controls QURAN reciter
    _currentQuranReciter = reciterId;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefQuranReciterKey, reciterId);
  }
  
  /// Schedules notifications for all provided prayer times
  Future<void> scheduleAdhanNotifications(Map<String, DateTime> prayerTimes) async {
    await _notificationsPlugin.cancelAll(); // Clear old logic
    
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
    
    int id = 1;
    for (var entry in prayerTimes.entries) {
      final prayerName = entry.key;
      final scheduledTime = entry.value;
      
      if (scheduledTime.isBefore(DateTime.now())) continue; // Skip past times
      
      final tzTime = tz.TZDateTime.from(scheduledTime, tz.local);
      
      await _notificationsPlugin.zonedSchedule(
        id++,
        '$prayerName Prayer',
        'It is time for $prayerName.',
        tzTime,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'adhan_channel',
            'Adhan Notifications',
             channelDescription: 'Gentle reminders for prayer times',
             importance: Importance.high, 
             priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(presentSound: true),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
      debugPrint("Scheduled Adhan for $prayerName at $tzTime");
    }
  }

  List<String> getAvailableVoices() {
    return ['makkah', 'madinah', 'quds'];
  }
}
