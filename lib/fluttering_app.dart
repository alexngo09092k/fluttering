/// Created Date: Sunday, Jan 9th 2022
/// Author: Brennan Ngo
///
/// Copyright (c) 2022 ThemePlace
library fluttering;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttering/provider/provider_delegate.dart';
import 'package:fluttering/provider/typedef.dart';
import 'package:fluttering/classes/typedef.dart';

abstract class FlutteringProviderState<T extends StatefulWidget, R extends IProvider> extends State<T> with WidgetsBindingObserver {
  late R provider;

  @override
  void initState() {
    provider = ManagerProvider.of<R>();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  Future<bool> didPopRoute() {
    if (provider is FlutteringProviderObserver) (provider as FlutteringProviderObserver).didPopRoute();
    return super.didPopRoute();
  }

  @override
  Future<bool> didPushRoute(String route) {
    if (provider is FlutteringProviderObserver) (provider as FlutteringProviderObserver).didPushRoute(route);
    return super.didPushRoute(route);
  }

  @override
  void dispose() {
    if (provider is FlutteringProviderObserver) (provider as FlutteringProviderObserver).willPopRoute();
    super.dispose();
  }
}

abstract class FlutteringAppState<T extends StatefulWidget> extends State<T> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    ManagerProvider.willOpenApp();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    ManagerProvider.changedAppLifecycleState(state);
    super.didChangeAppLifecycleState(state);
  }

  // @override
  // Future<bool> didPopRoute() {
  //   ManagerProvider.didPopRoute();
  //   return super.didPopRoute();
  // }

  // @override
  // Future<bool> didPushRoute(String route) {
  //   ManagerProvider.didPushRoute(route);
  //   return super.didPushRoute(route);
  // }

  @override
  void dispose() {
    ManagerProvider.willCloseApp().then((_) {
      ManagerCache.instance.clean();
      AsyncStorage.instance.dispose();
      WidgetsBinding.instance.removeObserver(this);
      ManagerProvider.instance.dispose();
    });
    super.dispose();
  }
}

abstract class FlutteringSplashState<T extends StatefulWidget> extends State<T> {
  @override
  void initState() {
    ManagerProvider.willSplash().then((_) => onSplash(_));
    super.initState();
  }

  void onSplash(bool resultOnWillSplash);

  @override
  void dispose() {
    super.dispose();
  }
}
