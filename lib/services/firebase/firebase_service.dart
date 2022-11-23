import 'dart:async';
import 'package:flutter/foundation.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:gms_check/gms_check.dart';

import '../../debugger/index.dart';
import '../../utils/internet.dart';
import 'models/firebase_config.dart';

abstract class IFirebaseService {
  /// check if the Firebase is enable or not
  bool get isEnabled => false;

  Future<void> init(FirebaseConfig config, {String? name, FirebaseOptions? options});

  Future<String?> getMessagingToken();

  FirebaseRemoteConfig? get remoteConfig;

  FirebaseApp? get firebaseApp;
}

class FirebaseService extends IFirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() => _instance;

  FirebaseService._internal();

  bool _isEnabled = false;

  @override
  bool get isEnabled => _isEnabled;

  FirebaseApp? _firebaseApp;
  @override
  FirebaseApp? get firebaseApp => _firebaseApp;

  @override
  Future<bool> init(FirebaseConfig config, {String? name, FirebaseOptions? options}) async {
    try {
      _isEnabled = config.enableFirebase;
      if (!_isEnabled) return false;

      var startTime = DateTime.now();

      if (!InternetConnection.instance.hasConnection) return false;

      _firebaseApp = await Firebase.initializeApp(name: name, options: options);

      Debug.log("============ ENABLED FIREBASE ${config.enableRemoteConfigFirebase} ==============");

      if (!kIsWeb && config.enableRemoteConfigFirebase) {
        Debug.log("============ ENABLED REMOTE CONFIG ${config.enableRemoteConfigFirebase} ==============");
        _remoteConfig = FirebaseRemoteConfig.instance;
        await _remoteConfig!.setConfigSettings(
          RemoteConfigSettings(
            fetchTimeout: config.fetchTimeout,
            minimumFetchInterval: config.minimumFetchInterval,
          ),
        );
        await _remoteConfig!.fetch();
        await _remoteConfig!.activate();
      }

      /// Require Play Services
      const message = '[FirebaseService] Init successfully';
      if (GmsCheck().isGmsAvailable) {
        _messaging = FirebaseMessaging.instance;
        Debug.log(message, startTime);
      } else {
        Debug.log('$message (without Google Play Services)', startTime);
      }

      return true;
    } catch (error) {
      Debug.log(error.toString());
      return false;
    }
  }

  /// Firebase Remote Config
  FirebaseRemoteConfig? _remoteConfig;

  @override
  FirebaseRemoteConfig? get remoteConfig => _remoteConfig;

  FirebaseMessaging? _messaging;

  FirebaseMessaging? get messaging => _messaging;

  @override
  Future<String?> getMessagingToken() async {
    return await messaging!.getToken();
  }
}
