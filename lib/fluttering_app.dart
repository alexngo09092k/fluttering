/// Created Date: Sunday, Jan 9th 2022
/// Author: Brennan Ngo
///
/// Copyright (c) 2022 ThemePlace
library fluttering;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttering/fluttering.dart';

abstract class FlutteringAppState<T extends StatefulWidget> extends State<T> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    ManagerProvider.willSplash();
    super.initState();
  }

  @override
  void dispose() {
    ManagerCache.instance.clean();
    AsyncStorage.instance.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

void runFlutteringApp(
  Widget app, {
  List<Provider> providers = const [],
  Future<bool> Function()? onWillInitialize,
  Future<bool> Function()? onDidInitialize,
  Function(Object?)? onError,
}) {
  Future<bool> initialize() async {
    await DeviceInfo.instance.initial();

    await AsyncStorage.instance.initial();

    await ManagerCache.instance.initial();

    InternetConnection.instance.initial('google.com');

    return true;
  }

  runZonedGuarded(() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();

      if (onWillInitialize != null) await onWillInitialize();

      await initialize();

      if (onDidInitialize != null) await onDidInitialize();

      ManagerProvider.registerProviders(providers);

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
