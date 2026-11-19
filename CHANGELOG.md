## 4.0.0

* Public release on pub.dev.
* Added explicit dependencies: `path`, `http_parser` (used by HTTP module).
* Fixed analysis warning in `ManagerProvider` (unnecessary type check).
* Fixed wildcard variable use in `AwesomeSplashState`.
* Bootstrap framework for Flutter apps featuring:
  * Lightweight custom Provider system (`IProvider`, `Provider`, `ManagerProvider`).
  * Reactive widgets: `Consumer`, `PropConsumer`, base listeners.
  * `AwesomeApp` entry point with zone error handling, lifecycle hooks, restart support.
  * Modules: DeviceInfo, InternetConnection, Permissions, HTTP (Dio), AsyncStorage, Clipboard, Debug logging, In-App Review, In-App Update.
  * Theme system (`ThemeProvider`) with light/dark mode + locale persistence.
  * App state helpers (`AwesomeAppState`, splash, animations).
* MIT License, README, topics in pubspec.

## 3.0.0

* Internal pre-release packaging.

## 0.0.1

* Internal pre-release.
