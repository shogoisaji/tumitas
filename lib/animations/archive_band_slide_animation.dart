import 'package:flutter/material.dart';

class ArchiveBandSlideAnimation extends StatefulWidget {
  final Widget child;
  final Animation animation;
  const ArchiveBandSlideAnimation({
    super.key,
    required this.child,
    required this.animation,
  });

  @override
  State<ArchiveBandSlideAnimation> createState() => _ArchiveBandSlideAnimationState();
}

class _ArchiveBandSlideAnimationState extends State<ArchiveBandSlideAnimation> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: widget.animation,
        builder: (context, child) => Transform.translate(
              offset: Offset(
                0,
                -widget.animation.value * 500,
              ),
              child: widget.child,
            ));
  }
}
