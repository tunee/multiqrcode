class AppConfig {
  // API Configuration
  static const String baseUrl = 'https://api.example.com';
  static const String endpoint = '/attendance';
  static String get fullApiUrl => '$baseUrl$endpoint';
  static const Duration apiTimeout = Duration(seconds: 30);
  
  // QR Scanning Configuration
  static const Duration deduplicationWindow = Duration(seconds: 5);
  static const Duration garbageCollectionInterval = Duration(minutes: 1);
  static const Duration syncInterval = Duration(minutes: 2);
  static const Duration snackBarDuration = Duration(seconds: 3);
  
  // UI Configuration
  static const double scanOverlaySize = 200.0;
}