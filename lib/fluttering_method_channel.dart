import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'fluttering_platform_interface.dart';

/// An implementation of [FlutteringPlatform] that uses method channels.
class MethodChannelFluttering extends FlutteringPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('fluttering');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
