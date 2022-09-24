/// Created Date: Sunday, Jan 9th 2022
/// Author: Brennan Ngo
/// 
/// Copyright (c) 2022 ThemePlace
library fluttering;

import 'package:flutter/foundation.dart' as foundation;

class FlutteringPlatform {
  static final FlutteringPlatform _instance = FlutteringPlatform._internal();
  static FlutteringPlatform get instance => _instance;

  factory FlutteringPlatform() => _instance;

  FlutteringPlatform._internal();

  bool get kIsWeb => foundation.kIsWeb;
  bool get isIos => foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;
  bool get isAndroid => foundation.defaultTargetPlatform == foundation.TargetPlatform.android;
  bool get isMacOS => foundation.defaultTargetPlatform == foundation.TargetPlatform.macOS;
  bool get isMobile => isIos || isAndroid;
}
