import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'fluttering_method_channel.dart';

abstract class FlutteringPlatform extends PlatformInterface {
  /// Constructs a FlutteringPlatform.
  FlutteringPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutteringPlatform _instance = MethodChannelFluttering();

  /// The default instance of [FlutteringPlatform] to use.
  ///
  /// Defaults to [MethodChannelFluttering].
  static FlutteringPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutteringPlatform] when
  /// they register themselves.
  static set instance(FlutteringPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
