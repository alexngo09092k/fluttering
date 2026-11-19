/// A complete bootstrap toolkit for Flutter applications.
///
/// Provides a lightweight custom Provider system, app lifecycle management
/// via [AwesomeApp], theming, networking, storage, device utilities,
/// permissions, connectivity, in-app review, and more.
///
/// ## Quick start
///
/// ```dart
/// import 'package:fluttering/fluttering.dart';
///
/// void main() {
///   AwesomeApp(
///     app: const MyApp(),
///     providers: [ThemeProvider()],
///   ).run();
/// }
/// ```
///
/// See the package README for full documentation and examples.
library fluttering;

/// Main exports
export 'provider/index.dart';
export 'modules/index.dart';
export 'widgets/index.dart';
export 'repositories/index.dart';
export 'theme/index.dart';

/// Re-exported popular dependencies for convenience
export 'package:device_info_plus/device_info_plus.dart';
export 'package:dio/dio.dart';
export 'package:native_flutter_proxy/native_flutter_proxy.dart';
export 'package:permission_handler/permission_handler.dart';
export 'package:connectivity_plus/connectivity_plus.dart';
export 'package:mime_type/mime_type.dart';

/// Awesome App bootstrap
export 'app.dart';
