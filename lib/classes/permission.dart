/// Created Date: Sunday, Jan 9th 2022
/// Author: Brennan Ngo
///
/// Copyright (c) 2022 ThemePlace
library fluttering;

import 'package:fluttering/debugger/logs.dart';
import 'package:permission_handler/permission_handler.dart';

/// ================== MANAGER PERMISSION ================

abstract class IFlutteringPermission {
  requestPermission({
    required List<Permission> permission,
    Function? onHasPermisson,
    Function? onNoPermisson,
  });

  bool checkingStatus({
    PermissionStatus? status,
    Function? onHasPermisson,
    Function? onNoPermisson,
  });
}

class FlutteringPermission extends IFlutteringPermission {
  static final FlutteringPermission _instance = FlutteringPermission._internal();
  static FlutteringPermission get instance => _instance;

  factory FlutteringPermission() => _instance;

  FlutteringPermission._internal();

  @override
  requestPermission({
    required List<Permission> permission,
    Function? onHasPermisson,
    Function? onNoPermisson,
  }) async {
    Map<Permission, PermissionStatus> statuses = await permission.request();
    final List<bool> _ = [];
    for (var p in permission) {
      if (statuses[p] != null) {
        PermissionStatus status = statuses[p]!;
        _.add(checkingStatus(status: status));
      }
    }
    if (_.contains(false)) {
      if (onNoPermisson != null) onNoPermisson();
    } else {
      if (onHasPermisson != null) onHasPermisson();
    }
  }

  @override
  bool checkingStatus({
    PermissionStatus? status,
    Function? onHasPermisson,
    Function? onNoPermisson,
  }) {
    Debug.log('Permission $status');
    switch (status) {

      /// The user denied access to the requested feature.
      case PermissionStatus.denied:

      /// The OS denied access to the requested feature. The user cannot change
      /// this app's status, possibly due to active restrictions such as parental
      /// controls being in place.
      /// *Only supported on iOS.*
      case PermissionStatus.restricted:

      /// dialog will not be shown when requesting this permission. The user may
      /// still change the permission status in the settings.
      /// *Only supported on Android.*
      case PermissionStatus.permanentlyDenied:
        if (onNoPermisson != null) onNoPermisson();
        return false;

      /// The user granted access to the requested feature.
      case PermissionStatus.granted:

      ///User has authorized this application for limited access.
      /// *Only supported on iOS (iOS14+).*
      case PermissionStatus.limited:
        if (onHasPermisson != null) onHasPermisson();
        return true;
      default:
        return false;
    }
  }
}
