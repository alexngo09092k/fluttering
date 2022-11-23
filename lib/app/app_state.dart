/// Created Date: Sunday, Jan 9th 2022
/// Author: Brennan Ngo
///
/// Copyright (c) 2022 ThemePlace
library fluttering;

import 'package:flutter/material.dart';

import '../utils/index.dart';
import '../provider/index.dart';

abstract class AwesomeAppState<T extends StatefulWidget> extends State<T> with WidgetsBindingObserver {
  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback(onNextFrame);
    ManagerProvider.willOpenApp();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    ManagerProvider.changedAppLifecycleState(state);
    super.didChangeAppLifecycleState(state);
  }

  void onNextFrame(Duration timestamp) {}

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
