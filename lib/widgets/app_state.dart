/// Created Date: Sunday, Jan 9th 2022
/// Author: Brennan Ngo
///
/// Copyright (c) 2022 ThemePlace
library fluttering;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/index.dart';
import '../provider/index.dart';

abstract class AwesomeAppState<T extends StatefulWidget, R extends IProvider> extends ProviderState<T, R> with WidgetsBindingObserver {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Size screen = const Size(0, 0);

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback(onNextFrame);

    _caculateScreen();

    ManagerProvider.willOpenApp();

    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    ManagerProvider.changedAppLifecycleState(state);
    super.didChangeAppLifecycleState(state);
  }

  void onNextFrame(Duration timestamp) {}

  _caculateScreen() {
    double devicePixelRatio = WidgetsBinding.instance.window.devicePixelRatio;
    double physicalSizeWidth = WidgetsBinding.instance.window.physicalSize.width;
    double physicalSizeHeight = WidgetsBinding.instance.window.physicalSize.height;

    screen = Size(physicalSizeWidth / devicePixelRatio, physicalSizeHeight / devicePixelRatio);
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
