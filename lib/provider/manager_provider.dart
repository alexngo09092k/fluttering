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
  List<IFlutteringProvider> get providers;
  List<LazyCallback> get lazyProviders;

  static T of<T extends IFlutteringProvider>([BuildContext? context, String? version]) {
    throw ErrorDescription("Not found provider");
  }

  static Future<bool> willSplash() async {
    return Future.value(true);
  }

  static Future<bool> willCloseApp() {
    return Future.value(true);
  }

  static Future<bool> didSplash() async {
    return Future.value(true);
  }

  /// is called when registed providers
  Future<bool> onRegisted();

  /// is called before go to splash screen
  Future<bool> onWillSplash();

  /// is called when went to splash screen
  Future<bool> onDidSplash();

  /// is called when closed app
  Future<bool> onWillCloseApp();
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

  /// Defined your lazy providers are used in app
  final List<IFlutteringProvider Function()> _lazyProviders = [];
  @override
  List<IFlutteringProvider Function()> get lazyProviders => _lazyProviders;

  static T of<T extends IFlutteringProvider>([BuildContext? context, String? version]) {
    for (var item in _instance.providers) {
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
          return p;
        }
        return p;
      }
    }
    throw ErrorDescription("Not found provider");
  }

  static Future<bool> willSplash() async {
    List<bool> _ = [];

    for (var item in _instance.providers) {
      if (item is IFlutteringProviderDelegate) {
        _.add(await item.willSplash());
      }
    }

    for (var item in _instance.lazyProviders) {
      if (item is LazyCallback<IFlutteringProviderDelegate>) {
        IFlutteringProviderDelegate p = item();
        _.add(await p.willSplash());
      }
    }

    _instance.onWillSplash();

    return !_.contains(false);
  }

  static Future<bool> didSplash() async {
    List<bool> _ = [];

    for (var item in _instance.providers) {
      if (item is IFlutteringProviderDelegate) {
        _.add(await item.didSplash());
      }
    }

    for (var item in _instance.lazyProviders) {
      if (item is LazyCallback<IFlutteringProviderDelegate>) {
        IFlutteringProviderDelegate p = item();
        _.add(await p.didSplash());
      }
    }

    _instance.onDidSplash();

    return !_.contains(false);
  }

  static Future<bool> willCloseApp() async {
    List<bool> _ = [];

    for (var item in _instance.providers) {
      if (item is IFlutteringProviderDelegate) {
        _.add(await item.willCloseApp());
      }
    }

    for (var item in _instance.lazyProviders) {
      if (item is LazyCallback<IFlutteringProviderDelegate>) {
        IFlutteringProviderDelegate p = item();
        _.add(await p.willCloseApp());
      }
    }

    _instance.onWillCloseApp();

    return !_.contains(false);
  }

  static void registerProviders({List<IFlutteringProvider> providers = const [], List<LazyCallback> lazyProviders = const []}) {
    _instance.providers.clear();
    _instance.providers.addAll(providers);

    _instance.lazyProviders.clear();
    _instance.lazyProviders.addAll(lazyProviders);

    _instance.onRegisted();
  }

  @override
  Future<bool> onRegisted() async {
    List<bool> _ = [];

    for (var item in _instance.providers) {
      if (item is IFlutteringProviderDelegate) {
        _.add(await item.onRegisted());
      }
    }

    for (var item in _instance.lazyProviders) {
      if (item is LazyCallback<IFlutteringProviderDelegate>) {
        IFlutteringProviderDelegate p = item();
        _.add(await p.onRegisted());
      }
    }

    return !_.contains(false);
  }

  @override
  Future<bool> onWillSplash() async {
    return true;
  }

  @override
  Future<bool> onDidSplash() async {
    return true;
  }

  @override
  Future<bool> onWillCloseApp() async {
    return true;
  }
}
