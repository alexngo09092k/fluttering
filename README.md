# fluttering

**A complete bootstrap toolkit for Flutter apps.**

`fluttering` helps you start production-ready Flutter applications faster with a lightweight custom Provider system, app lifecycle management, networking, storage, device utilities, theming, and more — all in one cohesive package.

---

## Features

- **AwesomeApp** – Central entry point with initialization hooks, error handling (`runZonedGuarded`), and restart support.
- **Custom Provider system** – Lightweight `IProvider` / `Provider` (inspired by `ChangeNotifier`) + `ManagerProvider` for global registration, lazy providers, and app lifecycle.
- **Reactive widgets** – `PState`, `Consumer`, `PConsumer`, `AutoConsumer`, `AutoPConsumer` for easy rebuilding.
- **Theme & Locale** – `ThemeProvider` with light/dark mode, locale switching, status bar styling, and persistent storage.
- **Modules**:
  - **DeviceInfo** – Cached platform device information (iOS / Android / Web).
  - **Internet** – Connectivity status via `connectivity_plus`.
  - **Permission** – Convenient permission request helpers.
  - **HTTP** – Powerful Dio-based client with proxy support, mime detection, and convenience methods.
  - **AsyncStorage** – Simple wrapper around `shared_preferences`.
  - **Clipboard** – Easy clipboard read/write.
  - **Logs / Debug** – Pretty debug logging with timing.
  - **In-App Review** – Configurable rate-dialog manager (launch count + days since install).
  - **In-App Update** – Version comparison (Play Store / App Store / Huawei AppGallery support).
- **App state helpers** – `AwesomeAppState` base class, splash support, simple animations.
- **Repositories** – Basic `BaseRepository` / `BaseResponse` pattern for data layers.

---

## Getting started

### 1. Add dependency

```yaml
dependencies:
  fluttering: ^3.0.0
```

Then run:

```bash
flutter pub get
```

### 2. Platform setup

Some features require additional configuration:

| Feature              | Android | iOS | Notes |
|----------------------|---------|-----|-------|
| Permissions          | ✅      | ✅  | Follow `permission_handler` docs |
| Connectivity         | ✅      | ✅  | — |
| In-App Review        | ✅      | ✅  | — |
| In-App Update        | ✅      | ✅  | Huawei optional |
| HTTP Proxy           | ✅      | ✅  | Uses `native_flutter_proxy` |

For Huawei AppGallery version checking you need the `huawei_hmsavailability` dependency (already included).

---

## Usage

### Minimal bootstrap

```dart
import 'package:flutter/material.dart';
import 'package:fluttering/fluttering.dart';

void main() {
  AwesomeApp(
    app: const MyApp(),
    providers: [
      // Your global providers
      ThemeProvider(themeMode: ThemeMode.system),
    ],
    onWillInitialize: () async {
      // e.g. load remote config, check force-update...
      return true;
    },
    onDidInitialize: () async {
      return true;
    },
    onError: (error) {
      // Report to Crashlytics / Sentry
      Debug.log(error);
    },
    debugMode: kDebugMode,
    inAppReview: const InAppReviewConfig(
      enable: true,
      minLaunchTimes: 5,
      minDaysAfterInstall: 3,
    ),
  ).run();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: AwesomeAppState.navigatorKey,
      title: 'Fluttering Demo',
      home: const HomePage(),
    );
  }
}
```

### Using providers & listeners

```dart
// Register a provider
class CounterProvider extends Provider {
  @override
  String get version => '1.0.0';

  int _count = 0;
  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }
}

// In UI – rebuilds whenever the provider notifies
Consumer<CounterProvider>(
  builder: (context, child, provider) {
    return Text('Count: ${provider.count}');
  },
)
```

### Theme

```dart
final theme = ManagerProvider.of<ThemeProvider>();

theme.changeThemeMode(ThemeMode.dark);
theme.changeLocale(const Locale('vi'));
```

### HTTP

```dart
final http = Http(); // or your configured instance

final response = await http.get('/users');
if (response.error == null) {
  final data = response.data;
}
```

### Async storage

```dart
await AsyncStorage.instance.setString('token', 'abc');
final token = AsyncStorage.instance.getString('token');
```

### Device & connectivity

```dart
await DeviceInfo.instance.initial();
print(DeviceInfo.instance.android?.model);

final hasNet = await InternetConnection.instance.checkConnection();
```

### In-App Review

```dart
// Already wired in AwesomeAppState if you enable InAppReviewConfig.
// Manual trigger:
await InAppReviewManager().showRateDialogIfMeetsConditions();
```

---

## Architecture overview

```
lib/
├── app.dart                 # AwesomeApp bootstrap
├── fluttering.dart          # Public API exports
├── provider/                # Custom state management
│   ├── provider.dart
│   ├── manager_provider.dart
│   └── widgets/             # PState, listeners...
├── modules/                 # Device, network, storage, etc.
├── theme/                   # ThemeProvider + colors
├── widgets/                 # AwesomeAppState, splash, animation
└── repositories/            # BaseRepository pattern
```

---

## Additional information

- **Author**: Brennan Ngo / ThemePlace (Anh Ngo)
- **License**: MIT
- **Issues / Contributions**: Feel free to open issues or PRs on the repository (add your GitHub link in `pubspec.yaml` → `repository`).

This package is designed as a **practical starter kit** rather than a heavyweight framework. You can use only the modules you need.

Happy coding! 🚀
