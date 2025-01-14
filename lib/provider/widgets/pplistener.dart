/// Created Date: Sunday, Jan 9th 2022
/// Author: Brennan Ngo
///
/// Copyright (c) 2022 ThemePlace
library fluttering;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../modules/index.dart';
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
  final Widget Function(BuildContext, Widget?, T, R) builder;
  final Widget? child;
  final bool debugMode;

  @override
  State<BasePropConsumer<T, R>> createState() => _BasePropConsumerState<T, R>();
}

class _BasePropConsumerState<T extends IProvider, R> extends State<BasePropConsumer<T, R>> {
  late ValueNotifier<R> _r;

  @override
  void initState() {
    _r = ValueNotifier<R>(widget.select(widget.listenable));
    widget.listenable.addListener(_listen);
    super.initState();
  }

  _listen() {
    R value = widget.select(widget.listenable);
    if (
      _r.value != value || 
      ((R is List) && !listEquals(_r.value as List, value as List)) ||
      ((R is Set) && !setEquals(_r.value as Set, value as Set)) ||
      ((R is Map) && !mapEquals(_r.value as Map, value as Map))
      ) {
      if (widget.debugMode) {
        Debug.log("value of $T changed from ${_r.value} to $value");
      }
      _r.value = value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _r,
      child: widget.child,
      builder: (_, __) => widget.builder(_, __, widget.listenable, _r.value),
    );
  }

  @override
  void dispose() {
    widget.listenable.removeListener(_listen);
    super.dispose();
  }
}
