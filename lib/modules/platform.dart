/// Created Date: Sunday, Jan 9th 2022
/// Author: Brennan Ngo
/// 
/// Copyright (c) 2022 ThemePlace
library fluttering;

import 'package:flutter/foundation.dart' as foundation;
import 'package:fluttering/fluttering.dart';
import 'package:huawei_hmsavailability/huawei_hmsavailability.dart';

class CurrentPlatform {
  static final CurrentPlatform _instance = CurrentPlatform._internal();
  static CurrentPlatform get instance => _instance;

  CurrentPlatform._internal();

  bool get kIsWeb => foundation.kIsWeb;
  bool get isIos => foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;
  bool get isAndroid => foundation.defaultTargetPlatform == foundation.TargetPlatform.android;
  bool get isMacOS => foundation.defaultTargetPlatform == foundation.TargetPlatform.macOS;
  bool get isMobile => isIos || isAndroid;
  bool get isHuawei => DeviceInfo.instance.android != null && (DeviceInfo.instance.android!.manufacturer).toUpperCase() == 'HUAWEI';

  Future<bool> get isGmsAvailable async => isMobile && !isHuawei;
  Future<bool> get isHmsAvailable async {
    if(isIos) return false;
    try {
    // 0: HMS Core (APK) is available.
    // 1: No HMS Core (APK) is found on device.
    // 2: HMS Core (APK) installed is out of date.
    // 3: HMS Core (APK) installed on the device is unavailable.
    // 9: HMS Core (APK) installed on the device is not the official version.
    // 21: The device is too old to support HMS Core (APK).
      final int resultCode = await (HmsApiAvailability()).isHMSAvailable();
      return isHuawei || resultCode == 0;
    }catch(error) {
      Debug.log(error);
    }
    return isHuawei;
  }
}
