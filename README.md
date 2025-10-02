# Multi-QR Attendance (Flutter)

Minimal Flutter app for **offline-first attendance**. Shows a **pending sync counter**, basic navigation, and a simple status banner. **Camera/QR scanning is intentionally disabled** in this version so you can plug in your preferred scanner later.

---

## Features

- Status banner with online/offline color  
- Pending count via `DatabaseHelper.getPendingCount()`  
- History page (stub)  
- Refresh button to reload status

---

## Structure

```
lib/
├─ main.dart
├─ database_helper.dart
├─ history_page.dart
└─ config.dart
```

---

## Quick Start

```bash
flutter pub get
flutter run
```

Create `lib/config.dart`:

```dart
class AppConfig {
  static const bool startOnline = false;
}
```

Stub `lib/database_helper.dart`:

```dart
class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();
  Future<int> getPendingCount() async => 0; // TODO: implement with sqflite
}
```

Recommended packages (in `pubspec.yaml`):

```yaml
dependencies:
  sqflite: ^2.3.0
  path_provider: ^2.1.0
  # Add later for scanning:
  # mobile_scanner: ^5.0.0
```

---

## Add Scanning (Later)

Integrate `mobile_scanner` or `qr_code_scanner`, then on detect:

1. Save record locally (`synced = 0`)  
2. Update pending count  
3. Sync in background, mark `synced = 1`
