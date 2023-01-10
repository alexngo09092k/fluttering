/// Created Date: Sunday, Jan 9th 2022
/// Author: Brennan Ngo
///
/// Copyright (c) 2022 ThemePlace
library fluttering;

import 'package:flutter/material.dart';

abstract class ProviderObserver {
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {}
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {}
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {}
}
