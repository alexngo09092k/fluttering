/// Central registry and lifecycle manager for all [IProvider] instances.
///
/// Created Date: Sunday, Jan 9th 2022
/// Author: Brennan Ngo
///
/// Copyright (c) 2022 ThemePlace
library fluttering;

import 'package:flutter/material.dart';

import 'provider.dart';
import 'provider_delegate.dart';
import 'provider_observer.dart';

/// Factory function that creates a provider on demand.
typedef LazyProviderCallback<T extends IProvider> = T Function();

/// Abstract interface for the provider manager (also acts as a [RouteObserver]).
abstract class IManagerProvider extends RouteObserver<PageRoute<dynamic>> {
  /// Retrieves a registered provider of type [T].
  static T of<T extends IProvider>([String? version]) {
    throw ErrorDescription("Not found provider");
  }

  static Future<bool> willSplash() async => true;
  static Future<bool> willCloseApp() async => true;
  static Future<bool> didSplash() async => true;

  void dispose();
}

/// Singleton manager that holds and provides access to all [IProvider]s.
///
/// Use [ManagerProvider.of] to retrieve a provider anywhere in the app.
class ManagerProvider extends IManagerProvider {
  static final ManagerProvider _instance = ManagerProvider._internal();
  static ManagerProvider get instance => _instance;
  static RouteObserver get observer => _instance;

  factory ManagerProvider() => _instance;
  ManagerProvider._internal();

  final List<IProvider> _providers = [];
  final List<IProvider> _activeProviders = [];
  final List<LazyProviderCallback> _registeredLazyProviders = [];
  final List<LazyProviderCallback> _lazyProviders = [];

  /// Returns the provider of type [T].
  static T of<T extends IProvider>([String? version]) =>
      _instance._of<T>(version);

  T _of<T extends IProvider>([String? version]) {
    for (final item in _activeProviders) {
      if (item is T) {
        if (version != null && item.version == version) return item;
        return item;
      }
    }
    for (final item in _lazyProviders) {
      if (item is LazyProviderCallback<T> &&
          !_registeredLazyProviders.contains(item)) {
        final p = item();
        _registeredLazyProviders.add(item);
        _activeProviders.add(p);
        if (version != null && p.version == version) return p;
        return p;
      }
    }
    throw ErrorDescription("Not found provider of type $T");
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    for (final item in _activeProviders) {
      if (item is ProviderObserver) {
        (item as ProviderObserver).didPop(route, previousRoute);
      }
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    for (final item in _activeProviders) {
      if (item is ProviderObserver) {
        (item as ProviderObserver).didPush(route, previousRoute);
      }
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    for (final item in _activeProviders) {
      if (item is ProviderObserver) {
        (item as ProviderObserver).didRemove(route, previousRoute);
      }
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    for (final item in _activeProviders) {
      if (item is ProviderObserver) {
        (item as ProviderObserver)
            .didReplace(newRoute: newRoute, oldRoute: oldRoute);
      }
    }
  }

  /// Registers both eager and lazy providers. Called by [AwesomeApp].
  static Future<bool> registerProviders({
    List<IProvider> providers = const [],
    List<LazyProviderCallback> lazyProviders = const [],
  }) async {
    return _instance._registerProviders(
      providers: providers,
      lazyProviders: lazyProviders,
    );
  }

  Future<bool> _registerProviders({
    List<IProvider> providers = const [],
    List<LazyProviderCallback> lazyProviders = const [],
  }) async {
    _providers
      ..clear()
      ..addAll(providers);
    _lazyProviders
      ..clear()
      ..addAll(lazyProviders);
    _activeProviders
      ..clear()
      ..addAll(providers);
    _registeredLazyProviders.clear();

    final results = <bool>[];
    await _delegateInLazyProviders();

    for (final item in _activeProviders) {
      if (item is ProviderDelegate) {
        results.add(await (item as ProviderDelegate).registered());
      }
    }
    return !results.contains(false);
  }

  Future<void> _delegateInLazyProviders() async {
    for (final item in _lazyProviders) {
      if (item is LazyProviderCallback &&
          !_registeredLazyProviders.contains(item)) {
        final p = item();
        _registeredLazyProviders.add(item);
        _activeProviders.add(p);
      }
    }
  }

  static Future<bool> willOpenApp() => _instance._willOpenApp();

  Future<bool> _willOpenApp() async {
    final results = <bool>[];
    for (final item in _activeProviders) {
      if (item is ProviderDelegate) {
        results.add(await (item as ProviderDelegate).willOpenApp());
      }
    }
    return !results.contains(false);
  }

  static Future<bool> willSplash() => _instance._willSplash();

  Future<bool> _willSplash() async {
    final results = <bool>[];
    for (final item in _activeProviders) {
      if (item is ProviderDelegate) {
        results.add(await (item as ProviderDelegate).willSplash());
      }
    }
    return !results.contains(false);
  }

  static Future<bool> willCloseApp() => _instance._willCloseApp();

  Future<bool> _willCloseApp() async {
    final results = <bool>[];
    for (final item in _activeProviders) {
      if (item is ProviderDelegate) {
        results.add(await (item as ProviderDelegate).willCloseApp());
      }
    }
    return !results.contains(false);
  }

  static Future<bool> changedAppLifecycleState(AppLifecycleState state) =>
      _instance._changedAppLifecycleState(state);

  Future<bool> _changedAppLifecycleState(AppLifecycleState state) async {
    final results = <bool>[];
    for (final item in _activeProviders) {
      if (item is ProviderDelegate) {
        results.add(
            await (item as ProviderDelegate).changedAppLifecycleState(state));
      }
    }
    return !results.contains(false);
  }

  /// Removes a previously registered provider.
  static void cancelRegistration<T extends IProvider>(T provider,
      [String? version]) {
    _instance._cancelRegistration<T>(provider, version);
  }

  void _cancelRegistration<T extends IProvider>(T provider, [String? version]) {
    _registeredLazyProviders.removeWhere(
        (item) => item is LazyProviderCallback<T>);
    _activeProviders.removeWhere(
        (item) => item is T && (version == null || item.version == version));
  }

  @override
  void dispose() {
    for (final item in _activeProviders) {
      item.dispose();
    }
    _activeProviders.clear();
    _providers.clear();
    _lazyProviders.clear();
    _registeredLazyProviders.clear();
  }
}
