import 'package:flutter/material.dart';

class ShakeAnimation extends StatefulWidget {
  final Widget child;
  final AnimationController animationController;
  const ShakeAnimation({
    super.key,
    required this.child,
    required this.animationController,
  });

  @override
  State<ShakeAnimation> createState() => _ShakeAnimationState();
}

class _ShakeAnimationState extends State<ShakeAnimation> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: widget.animationController,
        builder: (context, child) => Transform.translate(
              offset: widget.animationController.value != 0
                  ? Offset(widget.animationController.value * 5 - 10, 0)
                  : Offset.zero,
              child: widget.child,
            ));
  }
}
