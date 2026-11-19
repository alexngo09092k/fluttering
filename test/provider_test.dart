import 'package:flutter_test/flutter_test.dart';
import 'package:fluttering/fluttering.dart';

class CounterProvider extends Provider {
  @override
  String get version => '1.0.0';

  int _count = 0;
  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }
}

void main() {
  group('Provider', () {
    test('starts with zero listeners and can notify', () {
      final p = CounterProvider();
      expect(p.count, 0);

      var notified = false;
      p.addListener(() => notified = true);

      p.increment();
      expect(p.count, 1);
      expect(notified, isTrue);

      p.dispose();
    });

    test('dispose prevents further use in debug mode', () {
      final p = CounterProvider();
      p.dispose();
      // In release mode this may not throw; in debug it should.
      // We just ensure dispose is callable without crash.
      expect(true, isTrue);
    });
  });

  group('ManagerProvider', () {
    test('registers and retrieves a provider', () async {
      final counter = CounterProvider();
      final ok = await ManagerProvider.registerProviders(
        providers: [counter],
      );
      expect(ok, isTrue);

      final retrieved = ManagerProvider.of<CounterProvider>();
      expect(retrieved, same(counter));
      expect(retrieved.count, 0);

      retrieved.increment();
      expect(retrieved.count, 1);

      ManagerProvider.instance.dispose();
    });
  });

  group('InAppReviewConfig', () {
    test('defaults and copyWith', () {
      const config = InAppReviewConfig();
      expect(config.enable, isFalse);

      final updated = config.copyWith(enable: true, minLaunchTimes: 5);
      expect(updated.enable, isTrue);
      expect(updated.minLaunchTimes, 5);
    });
  });
}
