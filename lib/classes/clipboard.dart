import 'dart:async';

import 'package:flutter/services.dart';

abstract class IFlutteringClipboard {
  static final FlutteringClipboard _instance = FlutteringClipboard._internal();
  static FlutteringClipboard get instance => _instance;

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
class FlutteringClipboard extends IFlutteringClipboard {
  static final IFlutteringClipboard _instance = FlutteringClipboard._internal();
  static IFlutteringClipboard get instance => _instance;

  factory FlutteringClipboard() => _instance as FlutteringClipboard;

  FlutteringClipboard._internal() {
    _controller = StreamController<FlutteringClipboardEvent>.broadcast();
  }

  late final StreamController<FlutteringClipboardEvent> _controller;

  /// copy receives a string text and saves to Clipboard
  /// returns void
  @override
  Future<void> copy(String text) async {
    Clipboard.setData(ClipboardData(text: text));
    _controller.sink.add(
      FlutteringClipboardEvent<String>(FlutteringClipboardEventStatus.copy, text),
    );
  }

  /// Paste retrieves the data from clipboard.
  @override
  Future<String> paste() async {
    ClipboardData? data = await Clipboard.getData('text/plain');
    _controller.sink.add(
      FlutteringClipboardEvent<String>(
        FlutteringClipboardEventStatus.paste,
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

class FlutteringClipboardEvent<T> {
  final FlutteringClipboardEventStatus status;
  final T value;

  FlutteringClipboardEvent(this.status, this.value);
}

enum FlutteringClipboardEventStatus {
  copy,
  paste,
}
