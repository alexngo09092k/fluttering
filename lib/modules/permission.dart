/// Created Date: Sunday, Jan 9th 2022
/// Author: Brennan Ngo
///
/// Copyright (c) 2022 ThemePlace
library fluttering;

import 'package:permission_handler/permission_handler.dart';

import './logs.dart';

/// ================== MANAGER PERMISSION ================

abstract class IUserPermission {
  requestPermission({
    required List<Permission> permission,
    Function? onHasPermission,
    Function? onNoPermission,
  });

  bool checkingStatus({
    PermissionStatus? status,
    Function? onHasPermission,
    Function? onNoPermission,
  });
}

class UserPermission extends IUserPermission {
  static final IUserPermission _instance = UserPermission._internal();
  static IUserPermission get instance => _instance;

  UserPermission._internal();

  @override
  requestPermission({
    required List<Permission> permission,
    Function? onHasPermission,
    Function? onNoPermission,
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
      if (onNoPermission != null) onNoPermission();
    } else {
      if (onHasPermission != null) onHasPermission();
    }
  }

  @override
  bool checkingStatus({
    PermissionStatus? status,
    Function? onHasPermission,
    Function? onNoPermission,
  }) {
    Debug.log('PERMISSION $status');
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
        if (onNoPermission != null) onNoPermission();
        return false;

      /// The user granted access to the requested feature.
      case PermissionStatus.granted:

      ///User has authorized this application for limited access.
      /// *Only supported on iOS (iOS14+).*
      case PermissionStatus.limited:
        if (onHasPermission != null) onHasPermission();
        return true;
      default:
        return false;
    }
  }
}
