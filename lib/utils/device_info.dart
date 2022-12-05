/// Created Date: Sunday, Jan 9th 2022
/// Author: Brennan Ngo
///
/// Copyright (c) 2022 ThemePlace
library fluttering;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:fluttering/utils/platform.dart';
import './logs.dart';

/// ================== DEVICE INFO ================

abstract class IDeviceInfo {
  IosDeviceInfo? get ios;

  AndroidDeviceInfo? get android;

  WebBrowserInfo? get web;

  Map<String, dynamic>? get info;

  Future<bool> initial();
}

class DeviceInfo extends IDeviceInfo {
  static final IDeviceInfo _instance = DeviceInfo._internal();
  static IDeviceInfo get instance => _instance;

  factory DeviceInfo() => _instance as DeviceInfo;

  DeviceInfo._internal() {
    deviceInfoPlugin = DeviceInfoPlugin();
  }

  late final DeviceInfoPlugin deviceInfoPlugin;

  /// Information derived from `UIDevice`.
  ///
  /// See: https://developer.apple.com/documentation/uikit/uidevice
  IosDeviceInfo? _ios;

  /// This information does not change from call to call. Cache it.
  ///  Information derived from `android.os.Build`.
  ///
  /// See: https://developer.android.com/reference/android/os/Build.html
  AndroidDeviceInfo? _android;

  /// Information derived from `Navigator`.
  WebBrowserInfo? _web;

  /// This information does not change from call to call. Cache it.
  Map<String, dynamic>? _info;

  @override
  AndroidDeviceInfo? get android => _android;

  @override
  Map<String, dynamic>? get info => _info;

  @override
  IosDeviceInfo? get ios => _ios;

  @override
  WebBrowserInfo? get web => _web;

  @override
  Future<bool> initial() async {
    if (CurrentPlatform.instance.isIos) {
      _ios = await deviceInfoPlugin.iosInfo;
      Debug.log('device info ios $ios');
    }
    if (CurrentPlatform.instance.isAndroid) {
      _android = await deviceInfoPlugin.androidInfo;
      Debug.log('device info android $android');
    }
    if (CurrentPlatform.instance.kIsWeb) {
      _web = await deviceInfoPlugin.webBrowserInfo;
      Debug.log('device info web $web');
    }
    _info = (await deviceInfoPlugin.deviceInfo).toMap();

    return true;
  }
}
