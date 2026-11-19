/// Bootstrap entry point for Flutter applications.
///
/// Created Date: Sunday, Jan 9th 2022
/// Author: Brennan Ngo
///
/// Copyright (c) 2022 ThemePlace
library fluttering;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'modules/index.dart';
import 'provider/index.dart';

/// The main entry point and configuration for a Fluttering-powered app.
///
/// Use [AwesomeApp] instead of calling [runApp] directly. It handles:
/// - Zone error guarding
/// - Core module initialization (DeviceInfo, AsyncStorage, Internet)
/// - Provider registration
/// - Optional in-app review configuration
/// - Restart support
///
/// ### Example
/// ```dart
/// void main() {
///   AwesomeApp(
///     app: const MyApp(),
///     providers: [ThemeProvider()],
///     onError: (e) => print(e),
///   ).run();
/// }
/// ```
class AwesomeApp {
  static AwesomeApp? _instance;

  /// The currently running [AwesomeApp] instance (set when constructed).
  static AwesomeApp? get instance => _instance;

  /// Shortcut to the global [RouteObserver] managed by [ManagerProvider].
  static RouteObserver get observer => ManagerProvider.observer;

  /// The root widget of the application (usually a [MaterialApp] or [CupertinoApp]).
  final Widget app;

  /// List of providers that will be registered immediately on startup.
  final List<IProvider> providers;

  /// Lazy provider factories. They are instantiated only when first requested
  /// via [ManagerProvider.of].
  final List<LazyProviderCallback> lazyProviders;

  /// Called before core modules are initialized.
  /// Return `false` to abort startup (rare).
  final Future<bool> Function()? onWillInitialize;

  /// Called after core modules are initialized but before [runApp].
  final Future<bool> Function()? onDidInitialize;

  /// Global error handler for uncaught errors inside the zone.
  final Function(Object?)? onError;

  /// Controls whether [Debug.log] prints messages.
  final bool debugMode;

  /// Configuration for the advanced in-app review feature.
  final InAppReviewConfig inAppReview;

  /// Creates an [AwesomeApp] configuration.
  ///
  /// The [app] parameter is required. All other parameters are optional.
  AwesomeApp({
    required this.app,
    this.providers = const [],
    this.lazyProviders = const [],
    this.onWillInitialize,
    this.onDidInitialize,
    this.onError,
    this.debugMode = kDebugMode,
    this.inAppReview = const InAppReviewConfig(),
  }) {
    _instance = this;
  }

  /// Starts the application.
  ///
  /// This method:
  /// 1. Ensures Flutter bindings are initialized
  /// 2. Sets debug mode
  /// 3. Runs [onWillInitialize]
  /// 4. Initializes core modules
  /// 5. Runs [onDidInitialize]
  /// 6. Registers providers
  /// 7. Calls [runApp]
  ///
  /// All of the above is wrapped in [runZonedGuarded] for error safety.
  void run() async {
    runZonedGuarded(() async {
      WidgetsFlutterBinding.ensureInitialized();

      Debug.debugMode = debugMode;

      try {
        if (onWillInitialize != null) await onWillInitialize!();

        await _initialize();

        if (onDidInitialize != null) await onDidInitialize!();

        await ManagerProvider.registerProviders(
          providers: providers,
          lazyProviders: lazyProviders,
        );

        runApp(app);
      } catch (error) {
        Debug.log(error);
        if (onError != null) onError!(error);
      }
    }, (e, stack) {
      Debug.log(e);
      Debug.log(stack);
      if (onError != null) onError!(e);
    });
  }

  /// Restarts the application lifecycle without killing the process.
  ///
  /// Useful after logout, language change, or force-update scenarios.
  /// Returns `true` if every step succeeded.
  Future<bool> restart() async {
    final List<bool> result = [];

    if (onWillInitialize != null) result.add(await onWillInitialize!());

    await _initialize();

    if (onDidInitialize != null) result.add(await onDidInitialize!());

    await ManagerProvider.registerProviders(
      providers: providers,
      lazyProviders: lazyProviders,
    );

    result.add(await ManagerProvider.willOpenApp());
    result.add(await ManagerProvider.willSplash());

    return !result.contains(false);
  }

  Future<bool> _initialize() async {
    final List<bool> result = [];

    result.add(await DeviceInfo.instance.initial());
    result.add(await AsyncStorage.instance.initial());
    result.add(await InternetConnection.instance.initial('google.com'));

    return !result.contains(false);
  }

  /// Disposes global resources (storage + providers).
  Future<bool> dispose() async {
    AsyncStorage.instance.dispose();
    ManagerProvider.instance.dispose();
    return true;
  }
}
