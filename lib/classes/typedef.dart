/// Created Date: Sunday, Jan 9th 2022
/// Author: Brennan Ngo
///
/// Copyright (c) 2022 ThemePlace
library fluttering;

import 'package:fluttering/classes/cache.dart';
import 'package:fluttering/classes/clipboard.dart';
import 'package:fluttering/classes/device_info.dart';
import 'package:fluttering/classes/http.dart';
import 'package:fluttering/classes/internet.dart';
import 'package:fluttering/classes/permission.dart';
import 'package:fluttering/classes/platform.dart';
import 'package:fluttering/classes/shared.dart';

typedef UserPermission = FlutteringPermission;

typedef AsyncStorage = FlutteringShared;

typedef TemporaryStorage = FlutteringClipboard;

typedef AsyncStorageEvent = FlutteringSharedEvent;

typedef InternetConnection = FlutteringInternet;

typedef CurrentPlatform = FlutteringPlatform;

typedef DeviceInfo = FlutteringDeviceInfo;

typedef ManagerCache = FlutteringCache;

typedef ClientResponse = FlutteringResponse;

typedef ClientHttp = FlutteringHttp;
