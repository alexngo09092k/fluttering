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
  static Future<bool> Function()? restartApp;

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

    Future<bool> setup() async {
      if (onWillInitialize != null) await onWillInitialize();

      await initialize();

      if (onDidInitialize != null) await onDidInitialize();

      return ManagerProvider.registerProviders(
        providers: providers,
        lazyProviders: lazyProviders,
      );
    }

    restartApp = () async {
      List<bool> result = [];

      /// reinitial app
      result.add(await setup());

      /// reopen app
      result.add(await ManagerProvider.willOpenApp());

      /// resplash app
      result.add(await ManagerProvider.willSplash());

      return !result.contains(false);
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
