// ignore_for_file: public_member_api_docs, sort_constructors_first
/// Created Date: Sunday, Jan 9th 2022
/// Author: Brennan Ngo
///
/// Copyright (c) 2022 ThemePlace
library fluttering;

import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gms_check/gms_check.dart';

import '../utils/index.dart';
import '../../debugger/index.dart';
import '../../provider/index.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  Debug.log('=========== FIREBASE MESSAGE WITH ID ${message.messageId} ===========');
}

class AwesomeApp {
  static AwesomeApp? _instance;
  static AwesomeApp? get instance => _instance;

  final Widget app;
  final List<IProvider> providers;
  final List<LazyProviderCallback> lazyProviders;
  final Future<bool> Function()? onWillInitialize;
  final Future<bool> Function()? onDidInitialize;
  final Function(Object?)? onError;
  final bool debugMode;
  final bool enableAdvertisement;

  AwesomeApp({
    required this.app,
    this.providers = const [],
    this.lazyProviders = const [],
    this.onWillInitialize,
    this.onDidInitialize,
    this.onError,
    this.debugMode = kDebugMode,
    this.enableAdvertisement = true,
  }) {
    _instance = this;
  }

  void run() async {
    Debug.debugMode = debugMode;

    runZonedGuarded(() async {
      try {
        WidgetsFlutterBinding.ensureInitialized();

        GmsCheck().checkGmsAvailability(enableLog: kDebugMode);

        FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler,
        );

        if (onWillInitialize != null) await onWillInitialize!();

        await _initialize();

        if (onDidInitialize != null) await onDidInitialize!();

        ManagerProvider.registerProviders(
          providers: [
            ...providers,
            if (enableAdvertisement) AdsProvider.instance,
          ],
          lazyProviders: lazyProviders,
        );

        runApp(app);
      } catch (error) {
        Debug.log(error);
        if (onError != null) onError!(error);
      }
    }, (e, stack) {
      Debug.log(e);
      Debug.log(stack);
      if (onError != null) onError!(e);
    });
  }

  Future<bool> restart() async {
    List<bool> result = [];

    if (onWillInitialize != null) result.add(await onWillInitialize!());

    await _initialize();

    if (onDidInitialize != null) result.add(await onDidInitialize!());

    ManagerProvider.registerProviders(
      providers: providers,
      lazyProviders: lazyProviders,
    );

    /// reopen app
    result.add(await ManagerProvider.willOpenApp());

    /// resplash app
    result.add(await ManagerProvider.willSplash());

    return !result.contains(false);
  }

  Future<bool> _initialize() async {
    List<bool> result = [];
    result.add(await DeviceInfo.instance.initial());

    result.add(await AsyncStorage.instance.initial());

    result.add(await ManagerCache.instance.initial());

    result.add(await InternetConnection.instance.initial('google.com'));

    return !result.contains(false);
  }

  Future<bool> dispose() async {
    ManagerCache.instance.clean();
    AsyncStorage.instance.dispose();
    ManagerProvider.instance.dispose();

    return true;
  }
}
