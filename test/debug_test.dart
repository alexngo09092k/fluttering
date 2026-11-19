import 'package:flutter_test/flutter_test.dart';
import 'package:fluttering/fluttering.dart';

void main() {
  test('Debug.log does not throw when debugMode is false', () {
    Debug.debugMode = false;
    expect(() => Debug.log('silent'), returnsNormally);
  });

  test('Debug.log works when debugMode is true', () {
    Debug.debugMode = true;
    expect(() => Debug.log({'key': 'value'}), returnsNormally);
    expect(() => Debug.log('hello'), returnsNormally);
  });
}
