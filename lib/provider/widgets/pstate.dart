/// Created Date: Sunday, Jan 9th 2022
/// Author: Brennan Ngo
///
/// Copyright (c) 2022 ThemePlace
library fluttering;

import 'package:flutter/material.dart';

import '../manager_provider.dart';
import '../provider.dart';

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
}
