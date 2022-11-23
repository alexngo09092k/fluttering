/// Created Date: Sunday, Jan 9th 2022
/// Author: Brennan Ngo
///
/// Copyright (c) 2022 ThemePlace
library fluttering;

import 'package:flutter/material.dart';

import '../provider.dart';

class BaseConsumer<T extends IProvider> extends StatelessWidget {
  const BaseConsumer({super.key, required this.listenable, required this.builder, this.child});
  final T listenable;
  final Widget? child;
  final Widget Function(BuildContext, Widget?, T listenable) builder;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: listenable,
      builder: (_, __) => builder(_, __, listenable),
      child: child,
    );
  }
}
