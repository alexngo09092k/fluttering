/// Created Date: Sunday, Jan 9th 2022
/// Author: Brennan Ngo
///
/// Copyright (c) 2022 ThemePlace
library fluttering;

import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

/// ================== MANAGER INTERNET ================

abstract class IInternetConnection {
  Stream<bool> get connectionChange;
  bool get hasConnection;

  Future<bool> initial(String lookUpAddress);

  void dispose();

  Future<bool> checkConnection();
}

class InternetConnection extends IInternetConnection {
  String? _lookUpAddress;
  static final IInternetConnection _instance = InternetConnection._internal();
  static IInternetConnection get instance => _instance;

  InternetConnection._internal();

  bool _hasConnection = true;

  @override
  bool get hasConnection => _hasConnection;

  final StreamController<bool> _connectionChangeController = StreamController.broadcast();

  final Connectivity _connectivity = Connectivity();

  @override
  Future<bool> initial(String lookUpAddress) async {
    _lookUpAddress = lookUpAddress;
    _connectivity.onConnectivityChanged.listen(_connectionChange);
    return await checkConnection();
  }

  @override
  Stream<bool> get connectionChange => _connectionChangeController.stream;

  @override
  void dispose() {
    _connectionChangeController.close();
  }

  void _connectionChange(ConnectivityResult result) {
    checkConnection();
  }

  @override
  Future<bool> checkConnection() async {
    assert(_lookUpAddress != null || _lookUpAddress != '');
    bool previousConnection = _hasConnection;

    try {
      final result = await InternetAddress.lookup(_lookUpAddress!);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _hasConnection = true;
      } else {
        _hasConnection = false;
      }
    } on SocketException catch (_) {
      _hasConnection = false;
    }

    if (previousConnection != _hasConnection) {
      _connectionChangeController.add(_hasConnection);
    }

    return _hasConnection;
  }
}
