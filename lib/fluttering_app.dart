/// Created Date: Sunday, Jan 9th 2022
/// Author: Brennan Ngo
///
/// Copyright (c) 2022 ThemePlace
library fluttering;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttering/debugger/logs.dart';
import 'package:fluttering/classes/typedef.dart';
import 'package:fluttering/provider/typedef.dart';

abstract class FlutteringApp {
  static void Function()? restartApp;

  static void runAwesomeApp(
    Widget app, {
    List<IProvider> providers = const [],
    List<LazyProviderCallback> lazyProviders = const [],
    Future<bool> Function()? onWillInitialize,
    Future<bool> Function()? onDidInitialize,
    Function(Object?)? onError,
    bool debugMode = kDebugMode,
  }) {
    Debug.debugMode = debugMode;

    Future<bool> initialize() async {
      List<bool> result = [];
      result.add(await DeviceInfo.instance.initial());

      result.add(await AsyncStorage.instance.initial());

      result.add(await ManagerCache.instance.initial());

      result.add(await InternetConnection.instance.initial('google.com'));

      return !result.contains(false);
    }

    setup() async {
      if (onWillInitialize != null) await onWillInitialize();

      await initialize();

      if (onDidInitialize != null) await onDidInitialize();

      ManagerProvider.registerProviders(
        providers: providers,
        lazyProviders: lazyProviders,
      );
    }

    restartApp = () async {
      /// reinitial app
      await setup();

      /// reopen app
      await ManagerProvider.willOpenApp();

      /// resplash app
      ManagerProvider.willSplash();
    };

    runZonedGuarded(() async {
      try {
        WidgetsFlutterBinding.ensureInitialized();

        await setup();

        runApp(app);
      } catch (error) {
        Debug.log(error);
        if (onError != null) onError(error);
      }
    }, (e, stack) {
      Debug.log(e);
      Debug.log(stack);
      if (onError != null) onError(e);
    });
  }
}
