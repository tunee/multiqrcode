# Multi-QR Attendance (Flutter)

A minimal Flutter app scaffold for **multi-QR attendance** with placeholders for **offline storage**, **history**, and **configurable sync**.  
The current build intentionally **disables camera and database features** so the UI can run without native dependencies.

---

## ✨ Features

- **Status bar:** Shows basic app status and pending sync count.  
- **History screen:** Placeholder UI for past scans.  
- **Configurable:** Centralized settings in `lib/config.dart`.  
- **Ready to extend:** Stubs for database and syncing in `lib/database_helper.dart`.

---

## 🧱 Project Structure

```
lib/
├─ main.dart            # App entry, basic UI scaffolding and navigation
├─ history_page.dart    # Placeholder history screen
├─ database_helper.dart # Stubbed database interface
└─ config.dart          # Centralized configuration (API, timing, UI)

pubspec.yaml            # Dependencies (camera/DB commented out for a lean demo build)
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK **3.0.0 or newer**
- Android Studio / Xcode toolchains as needed

**Verify setup:**

```bash
flutter --version
flutter doctor
```

### Run (UI-only demo)

```bash
flutter pub get
flutter run -d <device_id>
```

### Build APK

```bash
flutter build apk --release
# Output (typical):
# build/app/outputs/flutter-apk/app-release.apk
```

You may also find sample builds in the repo root (if provided):  
`Multi-QR-Attendance-v1.0.1.apk`, `Multi-QR-Attendance-Fixed-v1.0.2.apk`.

---

## 🧩 Configuration

Edit `lib/config.dart` (example):

```dart
class AppConfig {
  // API
  static const String baseUrl = "https://api.example.com";
  static const String endpoint = "/attendance/sync";
  static const Duration apiTimeout = Duration(seconds: 15);

  // Scanning
  static const Duration deduplicationWindow = Duration(seconds: 4);

  // Sync
  static const Duration syncInterval = Duration(minutes: 5);

  // UI
  static const double scanOverlaySize = 260.0;
  static const Duration snackBarDuration = Duration(seconds: 2);

  // Demo toggle
  static const bool startOnline = false; // used by the UI banner in demo
}
```

---

## 🛠️ Enable Full Functionality (Optional)

The demo runs without camera/DB/network. To enable **real scanning**, **storage**, and **syncing**:

### 1) Dependencies (`pubspec.yaml`)

Add or uncomment the following under `dependencies:`:

```yaml
dependencies:
  # Core
  http: ^1.2.2
  collection: ^1.18.0

  # Camera + barcode (choose one barcode solution)
  camera: ^0.11.0+2
  google_mlkit_barcode_scanning: ^0.13.0

  # Offline storage
  sqflite: ^2.3.0
  path: ^1.9.0
  path_provider: ^2.1.0

  # Connectivity
  connectivity_plus: ^6.0.5

  # Android lifecycle (required by some camera flows)
  flutter_plugin_android_lifecycle: ^2.0.21
```

> For a simpler scanner integration, you can alternatively use:
>
> ```yaml
> dependencies:
>   mobile_scanner: ^5.0.0
> ```

Run:

```bash
flutter pub get
```

### 2) Android permissions (`android/app/src/main/AndroidManifest.xml`)

Add inside the `<manifest>` element:

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

Inside `<application ...>` consider setting camera orientation/queries as needed for your device set.

### 3) Implement database/storage (`lib/database_helper.dart`)

Replace the stubs with working `sqflite` logic, e.g.:

```dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static const _dbName = "attendance.db";
  static const _dbVersion = 1;
  static const _table = "scans";

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, _dbName);
    _db = await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
    return _db!;
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_table (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        code TEXT NOT NULL,
        scannedAt INTEGER NOT NULL,   -- epoch millis
        synced INTEGER NOT NULL       -- 0=pending, 1=synced
      )
    ''');
  }

  Future<int> getPendingCount() async {
    final db = await database;
    final res = await db.rawQuery('SELECT COUNT(*) as c FROM $_table WHERE synced = 0');
    final c = Sqflite.firstIntValue(res) ?? 0;
    return c;
    }
}
```

### 4) Implement scanner & handlers (`lib/main.dart`)

- Initialize camera or integrate `mobile_scanner`.
- On barcode detect:
  1. **Deduplicate** within `AppConfig.deduplicationWindow`.
  2. **Persist** to local DB as `synced = 0`.
  3. **Update** the pending counter in the UI.
  4. **Schedule** periodic sync (`Timer.periodic`) that POSTs to your API; upon success, mark `synced = 1`.

### 5) Configure API (`lib/config.dart`)

- Set `baseUrl`, `endpoint`, and `apiTimeout` according to your backend.
- Consider auth headers/tokens and error handling policy (retry/backoff).

### 6) iOS setup (if targeting iOS)

Add camera usage descriptions to `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>This app requires camera access to scan QR codes.</string>
<key>NSMicrophoneUsageDescription</key>
<string>Optional: required only if you capture video with audio.</string>
```

Then run:

```bash
cd ios
pod install
cd ..
flutter run
```

---

## 📝 Notes

- The demo UI displays **“Camera functionality disabled”** and **“History functionality disabled”** until you implement the pieces above.
- If `dependency_overrides` are used for `flutter_plugin_android_lifecycle`, remove them once your stack stabilizes.
- Always test on both **physical devices** and **emulators/simulators** for camera and file I/O parity.

---

## 📄 License

MIT

