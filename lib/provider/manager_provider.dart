/// Created Date: Sunday, Jan 9th 2022
/// Author: Brennan Ngo
///
/// Copyright (c) 2022 ThemePlace
library fluttering;

import 'package:flutter/material.dart';
import 'package:fluttering/provider/lifecycle_provider.dart';
import 'package:fluttering/provider/provider.dart';

typedef LazyCallback<T extends IFlutteringProvider> = T Function();

abstract class IFlutteringManagerProvider {
  /// Providers were working on project on start app
  /// Should be Delegate Provider
  List<IFlutteringProvider> get providers;

  /// Providers will create on your project and remove after create a instance of it
  /// Should'nt be Delegate Provider
  List<LazyCallback> get lazyProviders;

  /// Providers were working on your project
  List<IFlutteringProvider> get activeProviders;

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
  static final IFlutteringManagerProvider _instance = FlutteringManagerProvider._internal();
  static IFlutteringManagerProvider get instance => _instance;

  factory FlutteringManagerProvider() => _instance as FlutteringManagerProvider;

  FlutteringManagerProvider._internal();

  /// Defined your providers are used in app
  final List<IFlutteringProvider> _providers = [];
  @override
  List<IFlutteringProvider> get providers => _providers;

  /// create instance for provider;
  final List<IFlutteringProvider> _activeProviders = [];
  @override
  List<IFlutteringProvider> get activeProviders => _activeProviders;

  /// Defined your lazy providers are used in app
  final List<IFlutteringProvider Function()> _lazyProviders = [];
  @override
  List<IFlutteringProvider Function()> get lazyProviders => _lazyProviders;

  static T of<T extends IFlutteringProvider>([String? version]) {
    for (var item in _instance.activeProviders) {
      if (item is T) {
        if (version != null && item.version == version) {
          return item;
        }
        return item;
      }
    }
    for (var item in _instance.lazyProviders) {
      if (item is LazyCallback<T>) {
        final p = item();
        if (version != null && p.version == version) {
          _instance.lazyProviders.remove(item);
          _instance.activeProviders.add(p);
          return p;
        }
        _instance.lazyProviders.remove(item);
        _instance.activeProviders.add(p);
        return p;
      }
    }
    throw ErrorDescription("Not found provider");
  }

  static Future<bool> willSplash() async {
    List<bool> _ = [];

    for (var item in _instance.activeProviders) {
      if (item is IFlutteringProviderDelegate) {
        _.add(await item.willSplash());
      }
    }

    return !_.contains(false);
  }

  static Future<bool> didSplash() async {
    List<bool> _ = [];

    for (var item in _instance.activeProviders) {
      if (item is IFlutteringProviderDelegate) {
        _.add(await item.didSplash());
      }
    }

    return !_.contains(false);
  }

  static Future<bool> willCloseApp() async {
    List<bool> _ = [];

    for (var item in _instance.activeProviders) {
      if (item is IFlutteringProviderDelegate) {
        _.add(await item.willCloseApp());
      }
    }

    return !_.contains(false);
  }

  static Future<bool> registerProviders({List<IFlutteringProvider> providers = const [], List<LazyCallback> lazyProviders = const []}) async {
    _instance.providers.clear();
    _instance.providers.addAll(providers);

    _instance.lazyProviders.clear();
    _instance.lazyProviders.addAll(lazyProviders);

    _instance.activeProviders.clear();
    _instance.activeProviders.addAll(providers);

    List<bool> _ = [];

    await _delegateInLazyProviders();

    for (var item in _instance.activeProviders) {
      if (item is IFlutteringProviderDelegate) {
        _.add(await item.onRegisted());
      }
    }

    return !_.contains(false);
  }

  static Future<void> _delegateInLazyProviders() async {
    for (var item in _instance.lazyProviders) {
      if (item is LazyCallback<IFlutteringProviderDelegate>) {
        IFlutteringProviderDelegate p = item();
        _instance.lazyProviders.remove(item);
        _instance.activeProviders.add(p);
      }
    }
  }

  @override
  void dispose() {
    for (var item in _instance.activeProviders) {
      item.dispose();
    }
  }
}
