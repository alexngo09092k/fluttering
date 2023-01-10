// ignore_for_file: public_member_api_docs, sort_constructors_first
/// Created Date: Sunday, Jan 9th 2022
/// Author: Brennan Ngo
///
/// Copyright (c) 2022 ThemePlace
library fluttering;

import 'package:flutter/material.dart';

import 'provider.dart';
import 'provider_delegate.dart';
import 'provider_observer.dart';

typedef LazyProviderCallback<T extends IProvider> = T Function();

abstract class IManagerProvider extends RouteObserver<PageRoute<dynamic>> {
  static T of<T extends IProvider>([String? version]) {
    throw ErrorDescription("Not found provider");
  }

  static Future<bool> willSplash() async {
    return Future.value(true);
  }

  static Future<bool> willCloseApp() async {
    return Future.value(true);
  }

  static Future<bool> didSplash() async {
    return Future.value(true);
  }

  /// is called when closed app
  void dispose();
}

class ManagerProvider extends IManagerProvider {
  static final ManagerProvider _instance = ManagerProvider._internal();
  static ManagerProvider get instance => _instance;

  factory ManagerProvider() => _instance;

  ManagerProvider._internal();

  /// Defined your providers are used in app
  final List<IProvider> _providers = [];

  /// create instance for provider;
  final List<IProvider> _activeProviders = [];

  final List<LazyProviderCallback> _registeredLazyProviders = [];

  /// Defined your lazy providers are used in app
  final List<LazyProviderCallback> _lazyProviders = [];

  static T of<T extends IProvider>([String? version]) => _instance._of<T>(version);

  T _of<T extends IProvider>([String? version]) {
    for (var item in _activeProviders) {
      if (item is T) {
        if (version != null && (item.version == version)) {
          return item;
        }
        return item;
      }
    }
    for (var item in _lazyProviders) {
      if (item is LazyProviderCallback<T> && !_registeredLazyProviders.contains(item)) {
        final p = item();
        if (version != null && p.version == version) {
          _registeredLazyProviders.add(item);
          _activeProviders.add(p);
          return p;
        }
        _registeredLazyProviders.add(item);
        _activeProviders.add(p);
        return p;
      }
    }
    throw ErrorDescription("Not found provider");
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) async {
    super.didPop(route, previousRoute);
    for (var item in _activeProviders) {
      if (item is ProviderObserver) {
        (item as ProviderObserver).didPop(route, previousRoute);
      }
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    for (var item in _activeProviders) {
      if (item is ProviderObserver) {
        (item as ProviderObserver).didPush(route, previousRoute);
      }
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    for (var item in _activeProviders) {
      if (item is ProviderObserver) {
        (item as ProviderObserver).didReplace(newRoute: newRoute, oldRoute: oldRoute);
      }
    }
  }

  static Future<bool> willOpenApp() => _instance._willOpenApp();

  Future<bool> _willOpenApp() async {
    List<bool> _ = [];

    for (var item in _activeProviders) {
      if (item is ProviderDelegate) {
        _.add(await (item as ProviderDelegate).willOpenApp());
      }
    }

    return !_.contains(false);
  }

  static Future<bool> willSplash() => _instance._willSplash();

  Future<bool> _willSplash() async {
    List<bool> _ = [];

    for (var item in _activeProviders) {
      if (item is ProviderDelegate) {
        _.add(await (item as ProviderDelegate).willSplash());
      }
    }

    return !_.contains(false);
  }

  static Future<bool> willCloseApp() => _instance._willCloseApp();

  Future<bool> _willCloseApp() async {
    List<bool> _ = [];

    for (var item in _activeProviders) {
      if (item is ProviderDelegate) {
        _.add(await (item as ProviderDelegate).willCloseApp());
      }
    }

    return !_.contains(false);
  }

  static Future<bool> registerProviders({
    List<IProvider> providers = const [],
    List<LazyProviderCallback> lazyProviders = const [],
  }) async =>
      _instance._registerProviders(
        providers: providers,
        lazyProviders: lazyProviders,
      );

  Future<bool> _registerProviders({
    List<IProvider> providers = const [],
    List<LazyProviderCallback> lazyProviders = const [],
  }) async {
    _providers.clear();
    _providers.addAll(providers);

    _lazyProviders.clear();
    _lazyProviders.addAll(lazyProviders);

    _activeProviders.clear();
    _activeProviders.addAll(providers);

    _registeredLazyProviders.clear();

    List<bool> _ = [];

    await _delegateInLazyProviders();

    for (var item in _activeProviders) {
      if (item is ProviderDelegate) {
        _.add(await (item as ProviderDelegate).registered());
      }
    }

    return !_.contains(false);
  }

  Future<void> _delegateInLazyProviders() async {
    for (var item in _lazyProviders) {
      if (item is LazyProviderCallback<Provider> && !_registeredLazyProviders.contains(item)) {
        Provider p = item();
        _registeredLazyProviders.add(item);
        _activeProviders.add(p);
      }
    }
  }

  static Future<bool> changedAppLifecycleState(AppLifecycleState state) => _instance._changedAppLifecycleState(state);

  Future<bool> _changedAppLifecycleState(AppLifecycleState state) async {
    List<bool> _ = [];

    for (var item in _activeProviders) {
      if (item is ProviderDelegate) {
        _.add(await (item as ProviderDelegate).changedAppLifecycleState(state));
      }
    }

    return !_.contains(false);
  }

  static void cancelRegistration<T extends IProvider>(T provider, [String? version]) => _instance._cancelRegistration<T>(provider, version);

  void _cancelRegistration<T extends IProvider>(T provider, [String? version]) {
    /// REMOVE IN RESGISTERED LAZY PROVIDERS
    _registeredLazyProviders.removeWhere((item) => item is LazyProviderCallback<T> && _registeredLazyProviders.contains(item));

    /// REMOVE IN ACTIVE
    _activeProviders.removeWhere((item) => item is T && (version == null || item.version == version));
  }

  @override
  void dispose() {
    for (var item in _activeProviders) {
      item.dispose();
    }
  }
}
