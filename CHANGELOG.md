## 3.0.0

* **Public release** ready for pub.dev.
* Bootstrap framework for Flutter apps featuring:
  * Lightweight custom Provider system (`IProvider`, `Provider`, `ManagerProvider`).
  * Reactive widgets: `Consumer`, `PropConsumer`, base listeners.
  * `AwesomeApp` entry point with zone error handling, lifecycle hooks, restart support.
  * Modules: DeviceInfo, InternetConnection, Permissions, HTTP (Dio), AsyncStorage, Clipboard, Debug logging, In-App Review, In-App Update.
  * Theme system (`ThemeProvider`) with light/dark mode + locale persistence.
  * App state helpers (`AwesomeAppState`, splash, animations).
* Added comprehensive dartdoc on public APIs.
* Added unit tests (`test/`).
* Added working `example/` application.
* Fixed circular import in platform module.
* Fixed deprecated `WidgetsBinding.window` usage.
* Cleaned leftover plugin platform-interface boilerplate.
* MIT License, proper README, CHANGELOG, topics in pubspec.

## 0.0.1

* Internal pre-release.
