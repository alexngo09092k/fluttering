/// Created Date: Sunday, Jan 9th 2022
/// Author: Brennan Ngo
///
/// Copyright (c) 2022 ThemePlace
library fluttering;

import 'dart:async';

import 'package:flutter/material.dart';

import '../manager_provider.dart';
import '../provider.dart';
import '../provider_observer.dart';

abstract class ProviderState<T extends StatefulWidget, R extends IProvider> extends State<T> {
  late R provider;

  @override
  void initState() {
    provider = ManagerProvider.of<R>();
    super.initState();
  }
}

abstract class ProviderStateObserver<T extends StatefulWidget, R extends IProvider> extends ProviderState<T, R> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback(onNextFrame);
    super.initState();
  }

  void onNextFrame(Duration timestamp) {}

  @override
  Future<bool> didPopRoute() {
    if (provider is ProviderObserver) (provider as ProviderObserver).didPopRoute();
    return super.didPopRoute();
  }

  @override
  Future<bool> didPushRoute(String route) {
    if (provider is ProviderObserver) (provider as ProviderObserver).didPushRoute(route);
    return super.didPushRoute(route);
  }

  @override
  void dispose() {
    if (provider is ProviderObserver) (provider as ProviderObserver).willPopRoute();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
