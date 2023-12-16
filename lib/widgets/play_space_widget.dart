import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:tumitas/animations/shake_animation.dart';
import 'package:tumitas/animations/swipe_down_animation.dart';
import 'package:tumitas/config/config.dart';
import 'package:tumitas/models/block.dart';
import 'package:tumitas/models/bucket.dart';
import 'package:tumitas/services/sqflite_helper.dart';
import 'package:tumitas/widgets/block_widget.dart';
import 'package:tumitas/widgets/bucket_widget.dart';

class PlaySpaceWidget extends StatefulWidget {
  final Bucket bucket;
  final String currentBucketId;
  final Block? nextSettingBlock;

  const PlaySpaceWidget({
    Key? key,
    required this.bucket,
    required this.nextSettingBlock,
    required this.currentBucketId,
  }) : super(key: key);

  @override
  State<PlaySpaceWidget> createState() => _PlaySpaceWidgetState();
}

class _PlaySpaceWidgetState extends State<PlaySpaceWidget> with TickerProviderStateMixin {
  late AnimationController _shakeAnimationController;
  late AnimationController _swipeDownAnimationController;
  late RiveAnimationController _riveController;
  double blockCoordinateX = 0.0;
  double downDistance = 0.0;
  bool isSwiped = false;
  bool isArrowVisible = false;
  Block? nextBlock;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _shakeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _swipeDownAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _riveController = OneShotAnimation(
      'swipe',
      autoplay: true,
    );
    _riveController.isActive = true;
    nextBlock = widget.nextSettingBlock;
  }

// nextSettingBlockの変更を監視。これがないとbottomSheetで選択してもBlockが反映されない。
  @override
  void didUpdateWidget(PlaySpaceWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.nextSettingBlock != oldWidget.nextSettingBlock) {
      setState(() {
        nextBlock = widget.nextSettingBlock;
        blockCoordinateX = 0.0;
      });
    }
  }

  @override
  void dispose() {
    _shakeAnimationController.dispose();
    _swipeDownAnimationController.dispose();
    _riveController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void saveCurrentBucket(Bucket bucket) async {
    await SqfliteHelper.instance.insertBucket(bucket);
  }

  bool checkAddAvailable(int newPositionY) {
    if (nextBlock == null) return false;
    if (newPositionY + nextBlock!.blockType.blockSize.y - 1 < bucketLayoutSizeY) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final double oneBlockSize = MediaQuery.of(context).size.width > 600
        ? 120
        : (MediaQuery.of(context).size.width - 50) / widget.bucket.bucketLayoutSizeX;

    Future<void> onSwipeDown() async {
      if (nextBlock == null) return;
      _timer?.cancel();
      setState(() {
        isArrowVisible = false;
      });

      final int newPositionX = (blockCoordinateX + 10) ~/ oneBlockSize; // +10は誤差対策
      final int newPositionY = widget.bucket.getMaxPositionY(nextBlock!, newPositionX) + 1;
      final bool addAvailable = checkAddAvailable(newPositionY);
      final int duration = (700 ~/ bucketLayoutSizeY) * (bucketLayoutSizeY - newPositionY);

      if (!addAvailable) {
        _shakeAnimationController.repeat();
        Future.delayed(
            const Duration(
              milliseconds: 500,
            ), () {
          _shakeAnimationController.reset();
          setState(() {
            isSwiped = false;
          });
        });
      } else {
        _swipeDownAnimationController.forward();
        Future.delayed(
            Duration(
              milliseconds: duration,
            ), () {
          widget.bucket.addNewBlock(nextBlock!, newPositionX, newPositionY);
          SqfliteHelper.instance.updateBucketIntoBlock(widget.currentBucketId, widget.bucket);
          setState(() {
            nextBlock = null;
            isSwiped = false;
          });
          _swipeDownAnimationController.reset();
        });
      }
    }

    void setNextBlockPosition() {
      if (nextBlock == null) return;
      _timer?.cancel();
      setState(() {
        isArrowVisible = false;
      });
      _timer = Timer(const Duration(milliseconds: 1500), () {
        print('timer');
        setState(() {
          isArrowVisible = true;
        });
        _riveController.isActive = true;
      });
      setState(() {
        blockCoordinateX = ((blockCoordinateX + oneBlockSize / 2) ~/ oneBlockSize) * oneBlockSize;
        if (blockCoordinateX >
            widget.bucket.bucketLayoutSizeX * oneBlockSize - nextBlock!.blockType.blockSize.x * oneBlockSize) {
          blockCoordinateX =
              widget.bucket.bucketLayoutSizeX * oneBlockSize - nextBlock!.blockType.blockSize.x * oneBlockSize;
        }
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: oneBlockSize * (bucketLayoutSizeY + 2) + 100,
          padding: EdgeInsets.only(
              left: (MediaQuery.of(context).size.width - (widget.bucket.bucketLayoutSizeX * oneBlockSize + 14)) / 2),
          child: Stack(
            children: [
              // bucket area
              Positioned(top: oneBlockSize * 2 + 10, child: BucketWidget(widget.bucket, oneBlockSize)),
              // next block area
              Positioned(
                top: 0,
                left: 5,
                child: Container(
                  width: oneBlockSize * widget.bucket.bucketLayoutSizeX,
                  height: oneBlockSize * 2,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Stack(
                    children: [
                      nextBlock != null
                          ? Positioned(
                              bottom: 0,
                              left: blockCoordinateX,
                              child: SwipeDownAnimation(
                                animationController: _swipeDownAnimationController,
                                downDistance: bucketLayoutSizeY * oneBlockSize,
                                child: ShakeAnimation(
                                  animationController: _shakeAnimationController,
                                  child: BlockWidget(nextBlock!, oneBlockSize),
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
                                      widget.bucket.bucketLayoutSizeX * oneBlockSize -
                                          nextBlock!.blockType.blockSize.x * oneBlockSize) {
                                    blockCoordinateX = widget.bucket.bucketLayoutSizeX * oneBlockSize -
                                        nextBlock!.blockType.blockSize.x * oneBlockSize;
                                  }
                                },
                              );
                            },
                            onDragEnd: (details) {
                              setNextBlockPosition();
                            },
                            axis: Axis.horizontal,
                            childWhenDragging: Container(),
                            feedback: Container(color: Colors.transparent),
                            child: GestureDetector(
                                onVerticalDragUpdate: (details) {
                                  if (details.delta.dy > 5) {
                                    if (!isSwiped) {
                                      onSwipeDown();
                                    }
                                    setState(() {
                                      isSwiped = true;
                                    });
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
              ),
              isArrowVisible
                  ? Positioned(
                      top: oneBlockSize * 2 + 10,
                      left: oneBlockSize * 2.5 - 100,
                      child: SizedBox(
                          width: 200,
                          height: 200,
                          child: RiveAnimation.asset('assets/rive/arrow.riv',
                              controllers: [_riveController], fit: BoxFit.contain)),
                    )
                  : Container(),
            ],
          ),
        ),
      ],
    );
  }
}
