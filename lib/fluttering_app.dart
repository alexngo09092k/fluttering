/// Created Date: Sunday, Jan 9th 2022
/// Author: Brennan Ngo
///
/// Copyright (c) 2022 ThemePlace
library fluttering;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttering/provider/typedef.dart';
import 'package:fluttering/classes/typedef.dart';
import 'package:fluttering/debugger/logs.dart';

abstract class FlutteringAppState<T extends StatefulWidget> extends State<T> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    ManagerProvider.willSplash();
    super.initState();
  }

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

void runFlutteringApp(
  Widget app, {
  List<IProvider> providers = const [],
  List<IProvider Function()> lazyProviders = const [],
  Future<bool> Function()? onWillInitialize,
  Future<bool> Function()? onDidInitialize,
  Function(Object?)? onError,
}) {
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
