/// Created Date: Sunday, Jan 9th 2022
/// Author: Brennan Ngo
///
/// Copyright (c) 2022 ThemePlace
library fluttering;

import 'package:flutter/material.dart';

class FlutteringProviderDelegate {
  /// is called when provider is registerd
  Future<bool> registered() => Future.value(true);

  /// is called when open app
  Future<bool> willOpenApp() => Future.value(true);

  /// is called when closed app
  Future<bool> willCloseApp() => Future.value(true);

  /// is called when splash screen is opend
  Future<bool> willSplash() => Future.value(true);

  /// Called when the system puts the app in the background or returns
  /// the app to the foreground.
  ///
  /// An example of implementing this method is provided in the class-level
  /// documentation for the [WidgetsBindingObserver] class.
  ///
  /// This method exposes notifications from [SystemChannels.lifecycle].
  Future<bool> changedAppLifecycleState(AppLifecycleState state) => Future.value(true);
}