/// Created Date: Sunday, Jan 9th 2022
/// Author: Brennan Ngo
///
/// Copyright (c) 2022 ThemePlace
library fluttering;

import 'package:flutter/material.dart';
import 'package:fluttering/provider/provider.dart';
import 'package:fluttering/provider/widgets/pplistener.dart';
import 'package:fluttering/provider/manager_provider.dart';

class AutoPFlutteringProviderListener<T extends IFlutteringProvider, R> extends StatelessWidget {
  const AutoPFlutteringProviderListener({
    super.key,
    required this.select,
    required this.builder,
    this.child,
  });

  final R Function(T) select;
  final Widget Function(BuildContext, Widget?, T, R?) builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return FlutteringPropProviderListener<T, R>(
      listenable: FlutteringManagerProvider.of<T>(),
      select: select,
      builder: builder,
      child: child,
    );
  }
}
