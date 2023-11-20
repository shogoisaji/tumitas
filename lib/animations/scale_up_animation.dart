import 'package:flutter/material.dart';

class ScaleUpAnimation extends StatefulWidget {
  final Widget child;
  final AnimationController animationController;
  const ScaleUpAnimation({
    super.key,
    required this.child,
    required this.animationController,
  });

  @override
  State<ScaleUpAnimation> createState() => _ScaleUpAnimationState();
}

class _ScaleUpAnimationState extends State<ScaleUpAnimation> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: widget.animationController,
        builder: (context, child) => Transform.scale(
              scale: 1 + widget.animationController.value * 0.1,
              child: widget.child,
            ));
  }
}
