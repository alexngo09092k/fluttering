/// Created Date: Sunday, Jan 9th 2022
/// Author: Brennan Ngo
///
/// Copyright (c) 2022 ThemePlace
library fluttering;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../utils/index.dart';
import '../provider.dart';

class BasePropConsumer<T extends IProvider, R> extends StatefulWidget {
  const BasePropConsumer({
    super.key,
    required this.listenable,
    required this.select,
    required this.builder,
    this.debugMode = kDebugMode,
    this.child,
  });
  final T listenable;
  final R Function(T) select;
  final Widget Function(BuildContext, Widget?, T, R?) builder;
  final Widget? child;
  final bool debugMode;

  @override
  State<BasePropConsumer<T, R>> createState() => _BasePropConsumerState<T, R>();
}

class _BasePropConsumerState<T extends IProvider, R> extends State<BasePropConsumer<T, R>> {
  ValueNotifier<R>? _r;

  @override
  void initState() {
    _r = ValueNotifier<R>(widget.select(widget.listenable));
    widget.listenable.addListener(_listen);
    super.initState();
  }

  _listen() {
    R value = widget.select(widget.listenable);
    if (_r != null && _r!.value != value) {
      if (widget.debugMode) {
        Debug.log("=====> value of $T changed from ${_r!.value} to $value");
      }
      _r!.value = value;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_r == null) return widget.builder(context, widget.child, widget.listenable, null);
    return AnimatedBuilder(
      animation: _r!,
      child: widget.child,
      builder: (_, __) => widget.builder(_, __, widget.listenable, _r!.value),
    );
  }

  @override
  void dispose() {
    widget.listenable.removeListener(_listen);
    super.dispose();
  }
}
