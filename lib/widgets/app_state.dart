/// Created Date: Sunday, Jan 9th 2022
/// Author: Brennan Ngo
///
/// Copyright (c) 2022 ThemePlace
// ignore_for_file: deprecated_member_use

library fluttering;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../provider/index.dart';
import '../modules/index.dart';
import '../app.dart';

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

    _shouldEnablednAppReview();

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

  _shouldEnablednAppReview() {
    try {
      if(AwesomeApp.instance != null && AwesomeApp.instance!.inAppReview.enable) {
        final inAppReviewService = InAppReviewService();
        inAppReviewService.monitor(config: AwesomeApp.instance!.inAppReview);
      }
    }catch(error){
      Debug.log('SHOULD ENABLE APP REVIEW $error');
    }
  }

  _caculateScreen() {
    double devicePixelRatio = WidgetsBinding.instance.window.devicePixelRatio;
    double physicalSizeWidth = WidgetsBinding.instance.window.physicalSize.width;
    double physicalSizeHeight = WidgetsBinding.instance.window.physicalSize.height;

    screen = Size(physicalSizeWidth / devicePixelRatio, physicalSizeHeight / devicePixelRatio);
  }


  static Future<T?> useContext<T>({Future<T?> Function(BuildContext)? callback}) async {
    if (navigatorKey.currentContext == null || callback == null) return null;
    return callback(navigatorKey.currentContext!);
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
    if (navigatorKey.currentContext == null) return null;
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

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? snack({required SnackBar Function(BuildContext) builder}) {
    if (navigatorKey.currentContext == null) return null;
    return ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(builder(navigatorKey.currentContext!));
  }

  static dimiss() {
    if (navigatorKey.currentContext == null) return;
    Navigator.of(navigatorKey.currentContext!).pop();
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
