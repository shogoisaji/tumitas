import 'package:flutter/material.dart';

class ArchiveTextSlideAnimation extends StatefulWidget {
  final Widget child;
  final AnimationController animationController;
  const ArchiveTextSlideAnimation({
    super.key,
    required this.child,
    required this.animationController,
  });

  @override
  State<ArchiveTextSlideAnimation> createState() => _ArchiveTextSlideAnimationState();
}

class _ArchiveTextSlideAnimationState extends State<ArchiveTextSlideAnimation> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: widget.animationController,
        builder: (context, child) => Transform.translate(
              offset: Offset(-widget.animationController.value * 250, 0),
              child: widget.child,
            ));
  }
}
