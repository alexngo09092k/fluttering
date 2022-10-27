// ignore_for_file: public_member_api_docs, sort_constructors_first
/// Created Date: Sunday, Jan 9th 2022
/// Author: Brennan Ngo
///
/// Copyright (c) 2022 ThemePlace
library fluttering;

import 'package:flutter/material.dart';

import 'package:fluttering/provider/provider.dart';
import 'package:fluttering/provider/provider_delegate.dart';
import 'package:fluttering/provider/provider_observer.dart';

typedef LazyFlutteringCallback<T extends IFlutteringProvider> = T Function();

abstract class IFlutteringManagerProvider {
  static T of<T extends IFlutteringProvider>([String? version]) {
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

class FlutteringManagerProvider extends IFlutteringManagerProvider {
  static final FlutteringManagerProvider _instance = FlutteringManagerProvider._internal();
  static FlutteringManagerProvider get instance => _instance;

  factory FlutteringManagerProvider() => _instance;

  FlutteringManagerProvider._internal();

  /// Defined your providers are used in app
  final List<IFlutteringProvider> _providers = [];

  /// create instance for provider;
  final List<IFlutteringProvider> _activeProviders = [];

  final List<LazyFlutteringCallback> _registeredLazyProviders = [];

  /// Defined your lazy providers are used in app
  final List<LazyFlutteringCallback> _lazyProviders = [];

  static T of<T extends IFlutteringProvider>([String? version]) => _instance._of<T>(version);

  T _of<T extends IFlutteringProvider>([String? version]) {
    for (var item in _activeProviders) {
      if (item is T) {
        if (version != null && (item.version == version)) {
          return item;
        }
        return item;
      }
    }
    for (var item in _lazyProviders) {
      if (item is LazyFlutteringCallback<T> && !_registeredLazyProviders.contains(item)) {
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

  static Future<bool> willOpenApp() => _instance._willOpenApp();

  Future<bool> _willOpenApp() async {
    List<bool> _ = [];

    for (var item in _activeProviders) {
      if (item is FlutteringProviderDelegate) {
        _.add(await (item as FlutteringProviderDelegate).willOpenApp());
      }
    }

    return !_.contains(false);
  }

  static Future<bool> willSplash() => _instance._willSplash();

  Future<bool> _willSplash() async {
    List<bool> _ = [];

    for (var item in _activeProviders) {
      if (item is FlutteringProviderDelegate) {
        _.add(await (item as FlutteringProviderDelegate).willSplash());
      }
    }

    return !_.contains(false);
  }

  static Future<bool> willCloseApp() => _instance._willCloseApp();

  Future<bool> _willCloseApp() async {
    List<bool> _ = [];

    for (var item in _activeProviders) {
      if (item is FlutteringProviderDelegate) {
        _.add(await (item as FlutteringProviderDelegate).willCloseApp());
      }
    }

    return !_.contains(false);
  }

  static Future<bool> registerProviders({
    List<IFlutteringProvider> providers = const [],
    List<LazyFlutteringCallback> lazyProviders = const [],
  }) async =>
      _instance._registerProviders(
        providers: providers,
        lazyProviders: lazyProviders,
      );

  Future<bool> _registerProviders({
    List<IFlutteringProvider> providers = const [],
    List<LazyFlutteringCallback> lazyProviders = const [],
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
      if (item is FlutteringProviderDelegate) {
        _.add(await (item as FlutteringProviderDelegate).registered());
      }
    }

    return !_.contains(false);
  }

  Future<void> _delegateInLazyProviders() async {
    for (var item in _lazyProviders) {
      if (item is LazyFlutteringCallback<FlutteringProvider> && !_registeredLazyProviders.contains(item)) {
        FlutteringProvider p = item();
        _registeredLazyProviders.add(item);
        _activeProviders.add(p);
      }
    }
  }

  static Future<bool> changedAppLifecycleState(AppLifecycleState state) => _instance._changedAppLifecycleState(state);

  Future<bool> _changedAppLifecycleState(AppLifecycleState state) async {
    List<bool> _ = [];

    for (var item in _activeProviders) {
      if (item is FlutteringProviderDelegate) {
        _.add(await (item as FlutteringProviderDelegate).changedAppLifecycleState(state));
      }
    }

    return !_.contains(false);
  }

  static Future<bool> willPopRoute() => _instance._willPopRoute();

  Future<bool> _willPopRoute() async {
    List<bool> _ = [];

    for (var item in _activeProviders) {
      if (item is FlutteringProviderObserver) {
        _.add(await (item as FlutteringProviderObserver).willPopRoute());
      }
    }

    return !_.contains(false);
  }

  static Future<bool> didPopRoute() => _instance._didPopRoute();

  Future<bool> _didPopRoute() async {
    List<bool> _ = [];

    for (var item in _activeProviders) {
      if (item is FlutteringProviderObserver) {
        _.add(await (item as FlutteringProviderObserver).didPopRoute());
      }
    }

    return !_.contains(false);
  }

  static Future<bool> didPushRoute(String route) => _instance._didPushRoute(route);

  Future<bool> _didPushRoute(String route) async {
    List<bool> _ = [];

    for (var item in _activeProviders) {
      if (item is FlutteringProviderObserver) {
        _.add(await (item as FlutteringProviderObserver).didPushRoute(route));
      }
    }

    return !_.contains(false);
  }

  static void cancelRegistration<T extends IFlutteringProvider>(T provider, [String? version]) => _instance._cancelRegistration<T>(provider, version);

  void _cancelRegistration<T extends IFlutteringProvider>(T provider, [String? version]) {
    /// REMOVE IN RESGISTERED LAZY PROVIDERS
    _registeredLazyProviders.removeWhere((item) => item is LazyFlutteringCallback<T> && _registeredLazyProviders.contains(item));

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
