/// Created Date: Sunday, Jan 9th 2022
/// Author: Brennan Ngo
///
/// Copyright (c) 2022 ThemePlace
library fluttering;

import 'package:flutter/material.dart';

import '../provider.dart';
import '../widgets/plistener.dart';
import '../manager_provider.dart';

class Consumer<T extends IProvider> extends StatelessWidget {
  const Consumer({super.key, required this.builder, this.child, this.version});
  final Widget? child;
  final Widget Function(BuildContext, Widget?, T listenable) builder;
  final String? version;

  @override
  Widget build(BuildContext context) {
    return BaseConsumer(
      listenable: ManagerProvider.of<T>(version),
      builder: builder,
      child: child,
    );
  }
}
