/// Created Date: Sunday, Jan 9th 2022
/// Author: Brennan Ngo
///
/// Copyright (c) 2022 ThemePlace
library fluttering;

import 'dart:async';

import 'package:fluttering/debugger/logs.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ================== MANAGER SHARED ================
/// Wraps NSUserDefaults (on iOS) and SharedPreferences (on Android), providing
/// a persistent store for simple data.
///
/// Data is persisted to disk asynchronously.

abstract class IFlutteringShared {
  bool get canStored;

  /// Saves a string [value] to persistent storage in the background.
  ///
  /// Note: Due to limitations in Android's SharedPreferences,
  /// values cannot start with any one of the following:
  ///
  /// - 'VGhpcyBpcyB0aGUgcHJlZml4IGZvciBhIGxpc3Qu'
  /// - 'VGhpcyBpcyB0aGUgcHJlZml4IGZvciBCaWdJbnRlZ2Vy'
  /// - 'VGhpcyBpcyB0aGUgcHJlZml4IGZvciBEb3VibGUu'
  Future<bool> setString(String key, String value);

  /// Reads a value from persistent storage, throwing an exception if it's not a
  /// String.
  String? getString(String key);

  /// Saves an integer [value] to persistent storage in the background.
  Future<bool> setInt(String key, int value);

  /// Reads a value from persistent storage, throwing an exception if it's not
  /// an int.
  int? getInt(String key);

  Future<bool> setBool(String key, bool value);

  /// Reads a value from persistent storage, throwing an exception if it's not a
  /// bool.
  bool? getBool(String key);

  Future<bool> setDouble(String key, double value);

  /// Reads a value from persistent storage, throwing an exception if it's not a
  /// String.
  double? getDouble(String key);

  /// Saves a list of strings [value] to persistent storage in the background.
  Future<bool> setStringList(String key, List<String> value);

  /// Removes an entry from persistent storage.
  Future<bool> remove(String key);

  /// Loads and parses the [SharedPreferences] for this app from disk.
  ///
  /// Because this is reading from disk, it shouldn't be awaited in
  /// performance-sensitive blocks.

  Future<bool> initial();

  /// Completes with true once the user preferences for the app has been closed.
  dispose();

  StreamSubscription<FlutteringSharedEvent> addListener(Function(FlutteringSharedEvent) listener);
}

class FlutteringShared extends IFlutteringShared {
  static final IFlutteringShared _instance = FlutteringShared._internal();
  static IFlutteringShared get instance => _instance;

  factory FlutteringShared() => _instance as FlutteringShared;

  SharedPreferences? _sharedPreferences;

  late StreamController<FlutteringSharedEvent> _streamController;

  FlutteringShared._internal() {
    _streamController = StreamController<FlutteringSharedEvent>.broadcast();
    initial();
  }

  @override
  bool get canStored => _sharedPreferences != null;

  @override
  Future<bool> setString(String key, String value) async {
    if (!canStored) return false;
    bool result = await _sharedPreferences!.setString(key, value);
    if (result) _publishEvent(FlutteringSharedEvent<String>(key, value));
    return result;
  }

  @override
  String? getString(String key) {
    if (!canStored) return null;
    String? value = _sharedPreferences!.getString(key);
    return value;
  }

  @override
  Future<bool> setInt(String key, int value) async {
    if (!canStored) return false;
    bool result = await _sharedPreferences!.setInt(key, value);
    if (result) _publishEvent(FlutteringSharedEvent<int>(key, value));
    return result;
  }

  @override
  int? getInt(String key) {
    if (!canStored) return null;
    int? value = _sharedPreferences!.getInt(key);
    return value;
  }

  @override
  Future<bool> setBool(String key, bool value) async {
    if (!canStored) return false;
    bool result = await _sharedPreferences!.setBool(key, value);
    if (result) _publishEvent(FlutteringSharedEvent<bool>(key, value));
    return result;
  }

  @override
  bool? getBool(String key) {
    if (!canStored) return null;
    bool? value = _sharedPreferences!.getBool(key);
    return value;
  }

  @override
  Future<bool> setStringList(String key, List<String> value) async {
    if (!canStored) return false;
    bool result = await _sharedPreferences!.setStringList(key, value);
    if (result) _publishEvent(FlutteringSharedEvent<List<String>>(key, value));
    return result;
  }

  List<String>? getStringList(String key) {
    if (!canStored) return null;
    List<String>? value = _sharedPreferences!.getStringList(key);
    return value;
  }

  @override
  Future<bool> setDouble(String key, double value) async {
    if (!canStored) return false;
    bool result = await _sharedPreferences!.setDouble(key, value);
    if (result) _publishEvent(FlutteringSharedEvent<double>(key, value));
    return result;
  }

  @override
  double? getDouble(String key) {
    if (!canStored) return null;
    double? value = _sharedPreferences!.getDouble(key);
    return value;
  }

  /// Loads and parses the [SharedPreferences] for this app from disk.
  ///
  /// Because this is reading from disk, it shouldn't be awaited in
  /// performance-sensitive blocks.
  @override
  Future<bool> initial() async {
    try {
      _sharedPreferences ??= await SharedPreferences.getInstance();
      return true;
    } catch (error) {
      // If there's an error, explicitly return the future with an error.
      // then set the completer to null so we can retry.
      Debug.log(error);
      return false;
    }
  }

  @override
  StreamSubscription<FlutteringSharedEvent> addListener(Function(FlutteringSharedEvent) listener) {
    return _streamController.stream.listen(listener);
  }

  _publishEvent(FlutteringSharedEvent event) {
    _streamController.sink.add(event);
  }

  @override
  dispose() {
    _streamController.close();
  }

  @override
  Future<bool> remove(String key) async {
    if (!canStored) return false;
    return _sharedPreferences!.remove(key);
  }
}

class FlutteringSharedEvent<T> {
  final String key;
  final T value;

  FlutteringSharedEvent(this.key, this.value);
}
