/// Created Date: Sunday, Jan 9th 2022
/// Author: Brennan Ngo
///
/// Copyright (c) 2022 ThemePlace
library fluttering;

import 'package:flutter/material.dart';

import '../provider.dart';
import '../widgets/pplistener.dart';
import '../manager_provider.dart';

class PropConsumer<T extends IProvider, R> extends StatelessWidget {
  const PropConsumer({
    super.key,
    required this.select,
    required this.builder,
    this.child,
    this.version,
    this.debugMode = false,
  });

  final R Function(T) select;
  final Widget Function(BuildContext, Widget?, T, R?) builder;
  final Widget? child;
  final String? version;
  final bool debugMode;

  @override
  Widget build(BuildContext context) {
    return BasePropConsumer<T, R>(
      listenable: ManagerProvider.of<T>(version),
      select: select,
      builder: builder,
      debugMode: debugMode,
      child: child,
    );
  }
}
