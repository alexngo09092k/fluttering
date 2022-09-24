/// Created Date: Sunday, Jan 9th 2022
/// Author: Brennan Ngo
///
/// Copyright (c) 2022 ThemePlace
library fluttering;

import 'package:flutter/material.dart';
import 'package:fluttering/provider/provider.dart';
import 'package:fluttering/provider/widgets/plistener.dart';
import 'package:fluttering/provider/manager_provider.dart';

class AutoFlutteringProviderListener<T extends IFlutteringProvider> extends StatelessWidget {
  const AutoFlutteringProviderListener({super.key, required this.builder, this.child});
  final Widget? child;
  final Widget Function(BuildContext, Widget?, T listenable) builder;

  @override
  Widget build(BuildContext context) {
    return FlutteringProviderListener(
      listenable: FlutteringManagerProvider.of<T>(),
      builder: builder,
      child: child,
    );
  }
}
