/// Created Date: Sunday, Jan 9th 2022
/// Author: Brennan Ngo
///
/// Copyright (c) 2022 ThemePlace
library fluttering;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttering/provider/provider_delegate.dart';
import 'package:fluttering/provider/typedef.dart';

abstract class FlutteringProviderState<T extends StatefulWidget, R extends IProvider> extends State<T> {
  late R provider;

  @override
  void initState() {
    provider = ManagerProvider.of<R>();
    super.initState();
  }
}

abstract class FlutteringProviderStateObserver<T extends StatefulWidget, R extends IProvider> extends FlutteringProviderState<T, R> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  Future<bool> didPopRoute() {
    if (provider is FlutteringProviderObserver) (provider as FlutteringProviderObserver).didPopRoute();
    return super.didPopRoute();
  }

  @override
  Future<bool> didPushRoute(String route) {
    if (provider is FlutteringProviderObserver) (provider as FlutteringProviderObserver).didPushRoute(route);
    return super.didPushRoute(route);
  }

  @override
  void dispose() {
    if (provider is FlutteringProviderObserver) (provider as FlutteringProviderObserver).willPopRoute();
    super.dispose();
  }
}
