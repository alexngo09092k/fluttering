import 'dart:async';

import 'package:flutter/services.dart';

abstract class ITemporaryStorage {
  static final TemporaryStorage _instance = TemporaryStorage._internal();
  static TemporaryStorage get instance => _instance;

  /// copy receives a string text and saves to Clipboard
  /// returns void
  Future<void> copy(String text);

  /// Paste retrieves the data from clipboard.
  Future<String> paste();

  /// controlC receives a string text and saves to Clipboard
  /// returns boolean value
  Future<bool> controlC(String text);

  /// controlV retrieves the data from clipboard.
  /// same as paste
  /// But returns dynamic data
  Future<dynamic> controlV();

  dispose();
}

/// A Flutter Clipboard Plugin.
class TemporaryStorage extends ITemporaryStorage {
  static final ITemporaryStorage _instance = TemporaryStorage._internal();
  static ITemporaryStorage get instance => _instance;

  factory TemporaryStorage() => _instance as TemporaryStorage;

  TemporaryStorage._internal() {
    _controller = StreamController<TemporaryStorageEvent>.broadcast();
  }

  late final StreamController<TemporaryStorageEvent> _controller;

  /// copy receives a string text and saves to Clipboard
  /// returns void
  @override
  Future<void> copy(String text) async {
    Clipboard.setData(ClipboardData(text: text));
    _controller.sink.add(
      TemporaryStorageEvent<String>(TemporaryStorageEventStatus.copy, text),
    );
  }

  /// Paste retrieves the data from clipboard.
  @override
  Future<String> paste() async {
    ClipboardData? data = await Clipboard.getData('text/plain');
    _controller.sink.add(
      TemporaryStorageEvent<String>(
        TemporaryStorageEventStatus.paste,
        data?.text?.toString() ?? "",
      ),
    );
    return data?.text?.toString() ?? "";
  }

  /// controlC receives a string text and saves to Clipboard
  /// returns boolean value
  @override
  Future<bool> controlC(String text) async {
    if (text.isNotEmpty) {
      await Clipboard.setData(ClipboardData(text: text));
      return true;
    } else {
      return false;
    }
  }

  /// controlV retrieves the data from clipboard.
  /// same as paste
  /// But returns dynamic data
  @override
  Future<dynamic> controlV() async {
    ClipboardData? data = await Clipboard.getData('text/plain');
    return data;
  }

  @override
  dispose() {
    _controller.close();
  }
}

class TemporaryStorageEvent<T> {
  final TemporaryStorageEventStatus status;
  final T value;

  TemporaryStorageEvent(this.status, this.value);
}

enum TemporaryStorageEventStatus {
  copy,
  paste,
}
