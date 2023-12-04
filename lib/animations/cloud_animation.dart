import 'dart:math';

import 'package:flutter/material.dart';

class CloudAnimation extends StatefulWidget {
  final Widget child;
  final int duration;
  const CloudAnimation({
    super.key,
    required this.child,
    required this.duration,
  });

  @override
  State<CloudAnimation> createState() => _CloudAnimationState();
}

class _CloudAnimationState extends State<CloudAnimation> with TickerProviderStateMixin {
  late AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: widget.duration));
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double random = Random().nextDouble();
    return AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) => Transform.translate(
              offset: Offset(
                  _animationController.value * 100 * (0.5 + random), _animationController.value * 10 * (0.5 + random)),
              child: widget.child,
            ));
  }
}
