/// Created Date: Sunday, Jan 9th 2022
/// Author: Brennan Ngo
/// 
/// Copyright (c) 2022 ThemePlace
library fluttering;

import 'package:flutter/foundation.dart' as foundation;

class CurrentPlatform {
  static final CurrentPlatform _instance = CurrentPlatform._internal();
  static CurrentPlatform get instance => _instance;

  factory CurrentPlatform() => _instance;

  CurrentPlatform._internal();

  bool get kIsWeb => foundation.kIsWeb;
  bool get isIos => foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;
  bool get isAndroid => foundation.defaultTargetPlatform == foundation.TargetPlatform.android;
  bool get isMacOS => foundation.defaultTargetPlatform == foundation.TargetPlatform.macOS;
  bool get isMobile => isIos || isAndroid;
}
