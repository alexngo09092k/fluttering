import 'package:flutter/widgets.dart';
import 'in_app_review_manager.dart';
import 'models/in_app_review_config.dart';

class InAppReviewService with WidgetsBindingObserver {
  final InAppReviewManager _manager = InAppReviewManager();

  /// Start monitoring conditions to decide wheter a view attemp is made or not
  void monitor({InAppReviewConfig config = const InAppReviewConfig()}) {
    /// Minimum number of days to wait after install before a view attemp is made
    if (config.minDaysAfterInstall != null) _manager.setMinDaysAfterInstall(config.minDaysAfterInstall!);

    /// Minimum number of days after a view attemp was made to try again
    if (config.minDaysBeforeRemind != null) _manager.setMinDaysBeforeRemind(config.minDaysBeforeRemind!);

    /// Number of times of opening the app before a view attemp is made
    if (config.minLaunchTimes != null) _manager.setMinLaunchTimes(config.minLaunchTimes!);

    /// Enabled in app review
    if (config.enable) {
      _manager.monitor();
      _startObserver();
    }
  }

  _startObserver() {
    _ambiguate(WidgetsBinding.instance)?.addObserver(this);
    _afterLaunch();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _afterLaunch();
    }
  }

  void _afterLaunch() {
    _manager.applicationWasLaunched();
    _manager.showRateDialogIfMeetsConditions();
  }

  /// This allows a value of type T or T?
  /// to be treated as a value of type T?.
  ///
  /// We use this so that APIs that have become
  /// non-nullable can still be used with `!` and `?`
  /// to support older versions of the API as well.
  T? _ambiguate<T>(T? value) => value;
}
