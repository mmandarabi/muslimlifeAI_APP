class PrayerTimes {
  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;
  final String nextPrayer;
  final String nextPrayerTime;

  PrayerTimes({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.nextPrayer,
    required this.nextPrayerTime,
  });

  factory PrayerTimes.fromJson(Map<String, dynamic> json) {
    return PrayerTimes(
      fajr: json['fajr'] ?? '--:--',
      sunrise: json['sunrise'] ?? '--:--',
      dhuhr: json['dhuhr'] ?? '--:--',
      asr: json['asr'] ?? '--:--',
      maghrib: json['maghrib'] ?? '--:--',
      isha: json['isha'] ?? '--:--',
      nextPrayer: json['nextPrayer'] ?? '--',
      nextPrayerTime: json['nextPrayerTime'] ?? '--:--',
    );
  }
}
