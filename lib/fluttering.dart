/// Created Date: Sunday, Jan 9th 2022
/// Author: Brennan Ngo
///
/// Copyright (c) 2022 ThemePlace
library fluttering;

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttering/typedef.dart';
import 'package:fluttering/debugger/logs.dart';

export 'package:fluttering/typedef.dart';
export 'package:fluttering/debugger/logs.dart';
export 'package:fluttering/fluttering_app.dart';

void runAwesomeApp(
  Widget app, {
  List<IProvider> providers = const [],
  List<IProvider Function()> lazyProviders = const [],
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

  runZonedGuarded(() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();

      if (onWillInitialize != null) await onWillInitialize();

      await initialize();

      if (onDidInitialize != null) await onDidInitialize();

      ManagerProvider.registerProviders(
        providers: providers,
        lazyProviders: lazyProviders,
      );

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
