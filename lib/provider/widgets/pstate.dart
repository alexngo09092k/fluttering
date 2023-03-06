/// Created Date: Sunday, Jan 9th 2022
/// Author: Brennan Ngo
///
/// Copyright (c) 2022 ThemePlace
library fluttering;

import 'package:flutter/material.dart';

import '../manager_provider.dart';
import '../provider.dart';

abstract class ProviderStateless<R extends IProvider> extends StatelessWidget {
  ProviderStateless({super.key, String? version}){
    _provider = ManagerProvider.of<R>(version);
  }

  late final R _provider;
  R get provider => _provider;
}

abstract class ProviderStateful<T extends StatefulWidget, R extends IProvider> extends State<T> {
  late final R _provider;
  R get provider => _provider;
  
  bool listen() => false;
  
  @override
  void initState() {
    _provider = ManagerProvider.of<R>();
    if(listen()) {
      _provider.addListener(_listenChanged);
    }
    super.initState();
  }

  _listenChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    if(listen()) {
      _provider.removeListener(_listenChanged);
    }
    super.dispose();
  }
}

abstract class ProviderStateObserver<T extends StatefulWidget, R extends IProvider> extends ProviderStateful<T, R> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback(onNextFrame);
    super.initState();
  }

  void onNextFrame(Duration timestamp) {}
}
