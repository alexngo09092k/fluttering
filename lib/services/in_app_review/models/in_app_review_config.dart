import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class InAppReviewConfig {
  final bool enable;
  final int? minLaunchTimes;
  final int? minDaysAfterInstall;
  final int? minDaysBeforeRemind;

  const InAppReviewConfig({
    this.enable = false,
    this.minLaunchTimes = 0,
    this.minDaysAfterInstall = 0,
    this.minDaysBeforeRemind = 0,
  });

  InAppReviewConfig copyWith({
    bool? enable,
    int? minLaunchTimes,
    int? minDaysAfterInstall,
    int? minDaysBeforeRemind,
  }) {
    return InAppReviewConfig(
      enable: enable ?? this.enable,
      minLaunchTimes: minLaunchTimes ?? this.minLaunchTimes,
      minDaysAfterInstall: minDaysAfterInstall ?? this.minDaysAfterInstall,
      minDaysBeforeRemind: minDaysBeforeRemind ?? this.minDaysBeforeRemind,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'enable': enable,
      'minLaunchTimes': minLaunchTimes,
      'minDaysAfterInstall': minDaysAfterInstall,
      'minDaysBeforeRemind': minDaysBeforeRemind,
    };
  }

  factory InAppReviewConfig.fromMap(Map<String, dynamic> map) {
    return InAppReviewConfig(
      enable: map['enable'] as bool,
      minLaunchTimes: map['minLaunchTimes'] != null ? map['minLaunchTimes'] as int : null,
      minDaysAfterInstall: map['minDaysAfterInstall'] != null ? map['minDaysAfterInstall'] as int : null,
      minDaysBeforeRemind: map['minDaysBeforeRemind'] != null ? map['minDaysBeforeRemind'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory InAppReviewConfig.fromJson(String source) => InAppReviewConfig.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'InAppReviewConfig(enable: $enable, minLaunchTimes: $minLaunchTimes, minDaysAfterInstall: $minDaysAfterInstall, minDaysBeforeRemind: $minDaysBeforeRemind)';
  }

  @override
  bool operator ==(covariant InAppReviewConfig other) {
    if (identical(this, other)) return true;

    return other.enable == enable &&
        other.minLaunchTimes == minLaunchTimes &&
        other.minDaysAfterInstall == minDaysAfterInstall &&
        other.minDaysBeforeRemind == minDaysBeforeRemind;
  }

  @override
  int get hashCode {
    return enable.hashCode ^ minLaunchTimes.hashCode ^ minDaysAfterInstall.hashCode ^ minDaysBeforeRemind.hashCode;
  }
}
