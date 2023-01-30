/// Created Date: Sunday, Jan 9th 2022
/// Author: Brennan Ngo
///
/// Copyright (c) 2022 ThemePlace
library fluttering;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttering/fluttering.dart';

abstract class AwesomeAppState<T extends StatefulWidget> extends State<T> with WidgetsBindingObserver {
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

  static Future<T?> dialog<T>({
    required Widget Function(BuildContext) builder,
    bool barrierDismissible = true,
    Color? barrierColor = Colors.black54,
    String? barrierLabel,
    bool useSafeArea = true,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
    Offset? anchorPoint,
  }) async {
    if (navigatorKey.currentContext != null) {
      return showDialog<T>(
        context: navigatorKey.currentContext!,
        builder: builder,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
        barrierLabel: barrierLabel,
        useRootNavigator: useRootNavigator,
        useSafeArea: useSafeArea,
        routeSettings: routeSettings,
        anchorPoint: anchorPoint,
      );
    }
    return null;
  }

  static dimiss() {
    if (navigatorKey.currentContext != null) {
      Navigator.of(navigatorKey.currentContext!).pop();
    }
  }

  @override
  void dispose() {
    ManagerProvider.willCloseApp().then((_) {
      AsyncStorage.instance.dispose();
      WidgetsBinding.instance.removeObserver(this);
      ManagerProvider.instance.dispose();
    });
    super.dispose();
  }
}
