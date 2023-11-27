import 'package:flutter/material.dart';
import 'package:tumitas/animations/shake_animation.dart';
import 'package:tumitas/config/config.dart';
import 'package:tumitas/models/block.dart';
import 'package:tumitas/models/bucket.dart';
import 'package:tumitas/widgets/block_widget.dart';
import 'package:tumitas/widgets/bucket_widget.dart';

class PlaySpaceWidget extends StatefulWidget {
  final Bucket bucket;
  final Block? nextSettingBlock;

  const PlaySpaceWidget({
    Key? key,
    required this.bucket,
    required this.nextSettingBlock,
  }) : super(key: key);

  @override
  State<PlaySpaceWidget> createState() => _PlaySpaceWidgetState();
}

class _PlaySpaceWidgetState extends State<PlaySpaceWidget> with TickerProviderStateMixin {
  late AnimationController _shakeAnimationController;
  late AnimationController _swipeDownAnimationController;
  double blockCoordinateX = 0.0;
  bool isShowSwipeDownAnimation = false;
  Block? nextBlock;

  @override
  void initState() {
    super.initState();
    _shakeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _swipeDownAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    nextBlock = widget.nextSettingBlock;
  }

// nextSettingBlockの変更を監視
  @override
  void didUpdateWidget(PlaySpaceWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.nextSettingBlock != oldWidget.nextSettingBlock) {
      setState(() {
        nextBlock = widget.nextSettingBlock;
        print(nextBlock!.blockType.toString());

        blockCoordinateX = 0.0;
      });
    }
  }

  @override
  void dispose() {
    _shakeAnimationController.dispose();
    _swipeDownAnimationController.dispose();
    super.dispose();
  }

  void _setNextBlockPosition() {
    if (nextBlock == null) return;
    setState(() {
      blockCoordinateX = ((blockCoordinateX + oneBlockSize / 2) ~/ oneBlockSize) * oneBlockSize;
      if (blockCoordinateX >
          widget.bucket.bucketLayoutSize.x * oneBlockSize - nextBlock!.blockType.blockSize.x * oneBlockSize) {
        blockCoordinateX =
            widget.bucket.bucketLayoutSize.x * oneBlockSize - nextBlock!.blockType.blockSize.x * oneBlockSize;
      }
    });
  }

  void _onSwipeDown() {
    if (nextBlock == null) return;
    final addAvailable = widget.bucket.addNewBlock(nextBlock!, blockCoordinateX ~/ oneBlockSize);
    if (!addAvailable) {
      _shakeAnimationController.repeat();
      Future.delayed(const Duration(milliseconds: 500), () {
        _shakeAnimationController.reset();
      });
      return;
    }
    setState(() {
      nextBlock = null;
    });
    _swipeDownAnimationController.forward();
    debugPrint('swipe down');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // next block area
        Container(
          width: oneBlockSize * widget.bucket.bucketLayoutSize.x,
          height: oneBlockSize * 2,
          margin: const EdgeInsets.only(bottom: 10),
          child: Stack(
            children: [
              nextBlock != null
                  ? Positioned(
                      bottom: 0,
                      left: blockCoordinateX,
                      child: ShakeAnimation(
                        animationController: _shakeAnimationController,
                        child: BlockWidget(
                          nextBlock!,
                        ),
                      ))
                  : Container(),
              Positioned(
                bottom: 0,
                left: blockCoordinateX,
                child: Draggable(
                    data: 1,
                    onDragUpdate: (details) {
                      if (nextBlock == null) return;
                      setState(
                        () {
                          blockCoordinateX += details.delta.dx;
                          if (blockCoordinateX < 0) {
                            blockCoordinateX = 0;
                          } else if (blockCoordinateX >
                              widget.bucket.bucketLayoutSize.x * oneBlockSize -
                                  nextBlock!.blockType.blockSize.x * oneBlockSize) {
                            blockCoordinateX = widget.bucket.bucketLayoutSize.x * oneBlockSize -
                                nextBlock!.blockType.blockSize.x * oneBlockSize;
                          }
                        },
                      );
                    },
                    onDragEnd: (details) {
                      _setNextBlockPosition();
                    },
                    axis: Axis.horizontal,
                    childWhenDragging: Container(),
                    feedback: Container(color: Colors.transparent),
                    child: GestureDetector(
                        onVerticalDragUpdate: (details) {
                          if (details.delta.dy > 5) {
                            setState(() {});
                            _onSwipeDown();
                          }
                        },
                        child: nextBlock != null
                            ? Container(
                                width: nextBlock!.blockType.blockSize.x * oneBlockSize,
                                height: nextBlock!.blockType.blockSize.y * oneBlockSize,
                                color: Colors.transparent,
                              )
                            : Container())),
              ),
            ],
          ),
        ),
        // bucket area
        BucketWidget(widget.bucket),
      ],
    );
  }
}
