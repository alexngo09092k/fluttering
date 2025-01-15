import 'package:flutter/material.dart';

class AwesomeAnimation<T> extends StatefulWidget {
  const AwesomeAnimation({
    super.key,
    this.child,
    this.builder,
    this.onEnd,
    required this.setAnimation,
    this.after,
    this.duration = const Duration(milliseconds: 2000),
  });
  final Duration duration;
  final Function? onEnd;
  final Animation<T> Function(AnimationController) setAnimation;
  final Duration? after;
  final Widget Function(BuildContext, Widget, Animation<T>, AnimationController)? builder;
  final Widget? child;

  factory AwesomeAnimation.tweenSequence(
      {Widget? child,
      Widget Function(BuildContext, Widget, Animation<T>, AnimationController)? builder,
      Duration? after,
      Function? onEnd,
      Duration duration = const Duration(milliseconds: 2000),
      List<TweenSequenceItem<T>> items = const []}) {
    return AwesomeAnimation<T>(
      builder: builder,
      duration: duration,
      onEnd: onEnd,
      after: after,
      setAnimation: (controller) {
        return TweenSequence<T>(
          items,
        ).animate(controller);
      },
      child: child,
    );
  }

  @override
  State<AwesomeAnimation<T>> createState() => _AwesomeAnimationState<T>();
}

class _AwesomeAnimationState<T> extends State<AwesomeAnimation<T>> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<T> _animation;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _animation = widget.setAnimation(_controller);

    super.initState();

    if (widget.after != null) {
      Future.delayed(widget.after!, () {
        _controller.forward();
      });
    } else {
      _controller.forward();
    }

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (widget.onEnd != null) {
          widget.onEnd!();
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => widget.builder!(context, child ?? const SizedBox(), _animation, _controller),
      child: widget.child,
    );
  }
}
