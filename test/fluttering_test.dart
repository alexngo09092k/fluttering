import 'package:flutter_test/flutter_test.dart';
import 'package:fluttering/fluttering_platform_interface.dart';
import 'package:fluttering/fluttering_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutteringPlatform
    with MockPlatformInterfaceMixin
    implements FlutteringPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutteringPlatform initialPlatform = FlutteringPlatform.instance;

  test('$MethodChannelFluttering is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFluttering>());
  });

  test('getPlatformVersion', () async {
    MockFlutteringPlatform fakePlatform = MockFlutteringPlatform();
    FlutteringPlatform.instance = fakePlatform;
  });
}
