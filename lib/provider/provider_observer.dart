/// Route observer hooks for providers.
///
/// Created Date: Sunday, Jan 9th 2022
/// Author: Brennan Ngo
///
/// Copyright (c) 2022 ThemePlace
library fluttering;

import 'package:flutter/material.dart';

/// Optional route lifecycle callbacks that a provider can implement.
///
/// [ManagerProvider] forwards [RouteObserver] events to every active provider
/// that implements this interface.
abstract class ProviderObserver {
  /// Called when a route has been popped off the navigator.
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {}

  /// Called when a route has been pushed onto the navigator.
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {}

  /// Called when a route has been removed from the navigator.
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {}

  /// Called when a route has been replaced.
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {}
}
