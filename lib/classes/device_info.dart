/// Created Date: Sunday, Jan 9th 2022
/// Author: Brennan Ngo
///
/// Copyright (c) 2022 ThemePlace
library fluttering;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:fluttering/classes/platform.dart';
import 'package:fluttering/debugger/logs.dart';

/// ================== DEVICE INFO ================

abstract class IFlutteringDeviceInfo {
  IosDeviceInfo? get ios;

  AndroidDeviceInfo? get android;

  WebBrowserInfo? get web;

  Map<String, dynamic>? get info;

  Future<void> initial();
}

class FlutteringDeviceInfo extends IFlutteringDeviceInfo {
  static final IFlutteringDeviceInfo _instance = FlutteringDeviceInfo._internal();
  static IFlutteringDeviceInfo get instance => _instance;

  factory FlutteringDeviceInfo() => _instance as FlutteringDeviceInfo;

  FlutteringDeviceInfo._internal() {
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
  Future<void> initial() async {
    if (FlutteringPlatform.instance.isIos) {
      _ios = await deviceInfoPlugin.iosInfo;
      Debug.log('device info ios $ios');
    }
    if (FlutteringPlatform.instance.isAndroid) {
      _android = await deviceInfoPlugin.androidInfo;
      Debug.log('device info android $android');
    }
    if (FlutteringPlatform.instance.kIsWeb) {
      _web = await deviceInfoPlugin.webBrowserInfo;
      Debug.log('device info web $web');
    }
    _info = (await deviceInfoPlugin.deviceInfo).toMap();
  }
}
