// import 'package:flutter/material.dart';

// class SwipeDownAnimation extends StatefulWidget {
//   final Widget child;
//   final double downDistance;
//   final AnimationController animationController;
//   const SwipeDownAnimation({
//     super.key,
//     required this.child,
//     required this.animationController,
//     required this.downDistance,
//   });

//   @override
//   State<SwipeDownAnimation> createState() => _SwipeDownAnimationState();
// }

// class _SwipeDownAnimationState extends State<SwipeDownAnimation> {
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//         animation: widget.animationController,
//         builder: (context, child) => Transform.translate(
//               offset: Offset(
//                   0, widget.animationController.value * widget.downDistance),
//               child: widget.child,
//             ));
//   }
// }
