import 'dart:convert';

class FirebaseConfig {
  final bool enableFirebase;
  final bool enableCrashAnalytics;
  final bool enableRemoteConfigFirebase;
  final Duration fetchTimeout;
  final Duration minimumFetchInterval;

  FirebaseConfig({
    required this.enableFirebase,
    required this.enableCrashAnalytics,
    required this.enableRemoteConfigFirebase,
    required this.fetchTimeout,
    required this.minimumFetchInterval,
  });

  FirebaseConfig copyWith({
    bool? enableFirebase,
    bool? enableCrashAnalytics,
    bool? enableRemoteConfigFirebase,
    Duration? fetchTimeout,
    Duration? minimumFetchInterval,
  }) {
    return FirebaseConfig(
      enableFirebase: enableFirebase ?? this.enableFirebase,
      enableCrashAnalytics: enableCrashAnalytics ?? this.enableCrashAnalytics,
      enableRemoteConfigFirebase: enableRemoteConfigFirebase ?? this.enableRemoteConfigFirebase,
      fetchTimeout: fetchTimeout ?? this.fetchTimeout,
      minimumFetchInterval: minimumFetchInterval ?? this.minimumFetchInterval,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'enableFirebase': enableFirebase,
      'enableCrashAnalytics': enableCrashAnalytics,
      'enableRemoteConfigFirebase': enableRemoteConfigFirebase,
      'fetchTimeout': fetchTimeout.inSeconds,
      'minimumFetchInterval': minimumFetchInterval.inSeconds,
    };
  }

  factory FirebaseConfig.fromMap(Map<String, dynamic> map) {
    return FirebaseConfig(
      enableFirebase: map['enableFirebase'] ?? false,
      enableCrashAnalytics: map['enableCrashAnalytics'] ?? false,
      enableRemoteConfigFirebase: map['enableRemoteConfigFirebase'] ?? false,
      fetchTimeout: Duration(seconds: map['fetchTimeout']?.toInt() ?? 0),
      minimumFetchInterval: Duration(seconds: map['minimumFetchInterval']?.toInt() ?? 0),
    );
  }

  String toJson() => json.encode(toMap());

  factory FirebaseConfig.fromJson(String source) => FirebaseConfig.fromMap(json.decode(source));

  @override
  String toString() {
    return 'FirebaseConfig(enableFirebase: $enableFirebase, enableCrashAnalytics: $enableCrashAnalytics, enableRemoteConfigFirebase: $enableRemoteConfigFirebase, fetchTimeout: $fetchTimeout, minimumFetchInterval: $minimumFetchInterval)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FirebaseConfig &&
        other.enableFirebase == enableFirebase &&
        other.enableCrashAnalytics == enableCrashAnalytics &&
        other.enableRemoteConfigFirebase == enableRemoteConfigFirebase &&
        other.fetchTimeout == fetchTimeout &&
        other.minimumFetchInterval == minimumFetchInterval;
  }

  @override
  int get hashCode {
    return enableFirebase.hashCode ^
        enableCrashAnalytics.hashCode ^
        enableRemoteConfigFirebase.hashCode ^
        fetchTimeout.hashCode ^
        minimumFetchInterval.hashCode;
  }
}
