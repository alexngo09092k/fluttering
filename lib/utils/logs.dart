/// Created Date: Sunday, Jan 9th 2022
/// Author: Brennan Ngo
///
/// Copyright (c) 2022 ThemePlace
library fluttering;

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

bool _flutteringDebugMode = kDebugMode;

class Debug {
  static set debugMode(value) {
    _flutteringDebugMode = value;
  }

  static bool get debugMode => _flutteringDebugMode;

  static void log([dynamic data, DateTime? startTime]) {
    if (!Debug.debugMode) return;
    var time = '';
    if (startTime != null) {
      final endTime = DateTime.now().difference(startTime);
      final icon = endTime.inMilliseconds > 2000
          ? '⌛️ Slow-'
          : endTime.inMilliseconds > 1000
              ? '⏰ Medium-'
              : '⚡️ Fast-';
      time = '[$icon${endTime.inMilliseconds}ms]';
    }

    final String? dataString = stringifyMessage(data);

    try {
      final now = DateFormat('h:mm:ss-ms').format(DateTime.now());
      debugPrint('ℹ️ [${now}ms]$time$dataString');

      if (dataString != null && dataString.contains('is not a subtype of type')) {
        throw Exception();
      }
    } catch (e, trace) {
      debugPrint('🔴 $dataString');
      debugPrint(trace.toString());
    }
  }

  static String? stringifyMessage(dynamic message) {
    const decoder = JsonDecoder();
    const encoder = JsonEncoder.withIndent('  ');

    if (message is String) {
      try {
        final raw = decoder.convert(message);
        return encoder.convert(raw);
      } catch (e) {
        return message.toString();
      }
    } else if (message is Map || message is Iterable) {
      return encoder.convert(message);
    } else {
      return message.toString();
    }
  }
}
