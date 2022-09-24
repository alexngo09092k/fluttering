/// Created Date: Sunday, Jan 9th 2022
/// Author: Brennan Ngo
///
/// Copyright (c) 2022 ThemePlace
library fluttering;

import 'package:flutter/material.dart';
import 'package:fluttering/provider/manager_provider.dart';
import 'package:fluttering/provider/provider.dart';
import 'package:fluttering/provider/widgets/autoplistener.dart';
import 'package:fluttering/provider/widgets/autopplistener.dart';
import 'package:fluttering/provider/widgets/plistener.dart';
import 'package:fluttering/provider/widgets/pplistener.dart';

typedef ManagerProvider = FlutteringManagerProvider;

typedef Provider = FlutteringProvider;

typedef IProvider = IFlutteringProvider;

typedef BaseConsumer<T extends IProvider> = FlutteringProviderListener<T>;

typedef BasePropConsumer<T extends IProvider, R> = FlutteringPropProviderListener<T, R>;

typedef Consumer<T extends IProvider> = AutoFlutteringProviderListener<T>;

typedef PropConsumer<T extends IProvider, R> = AutoPFlutteringProviderListener<T, R>;

extension ExProvider on Provider {
  static T of<T extends IProvider>([BuildContext? context]) {
    return ManagerProvider.of<T>();
  }

  static Future<bool> willSplash() async {
    return ManagerProvider.willSplash();
  }

  static Future<bool> willCloseApp() {
    return ManagerProvider.willCloseApp();
  }

  static Future<bool> didSplash() async {
    return ManagerProvider.didSplash();
  }
}
