import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tumitas/animations/shake_animation.dart';
import 'package:tumitas/config/config.dart';
import 'package:tumitas/models/block.dart';
import 'package:tumitas/models/bucket.dart';
import 'package:tumitas/widgets/block_widget.dart';
import 'package:tumitas/widgets/bucket_widget.dart';

class PlaySpaceWidget extends StatefulWidget {
  final Bucket bucket;
  final BlockType selectedBlockType;
  final String nextBlockTitle;

  const PlaySpaceWidget({
    Key? key,
    required this.bucket,
    required this.selectedBlockType,
    required this.nextBlockTitle,
  }) : super(key: key);

  @override
  State<PlaySpaceWidget> createState() => _PlaySpaceWidgetState();
}

class _PlaySpaceWidgetState extends State<PlaySpaceWidget> with TickerProviderStateMixin {
  late AnimationController _shakeAnimationController;
  late AnimationController _swipeDownAnimationController;
  late Block nextBlock;
  double blockCoordinateX = 0.0;
  bool isShowNextBlock = false;
  bool isShowSwipeDownAnimation = false;

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
    _generateNewBlock();
  }

// selectedBlockTypeの変更を監視
  @override
  void didUpdateWidget(PlaySpaceWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedBlockType != oldWidget.selectedBlockType || widget.nextBlockTitle != oldWidget.nextBlockTitle) {
      _generateNewBlock();
    }
  }

  @override
  void dispose() {
    _shakeAnimationController.dispose();
    _swipeDownAnimationController.dispose();
    super.dispose();
  }

  void _generateNewBlock() {
    setState(() {
      isShowNextBlock = true;
      blockCoordinateX = 0.0;
      nextBlock = Block(
        blockColorList[Random().nextInt(blockColorList.length)],
        widget.selectedBlockType,
        widget.nextBlockTitle,
        'nextBlockDescription',
      );
    });
  }

  void _setNextBlockPosition() {
    setState(() {
      blockCoordinateX = ((blockCoordinateX + oneBlockSize / 2) ~/ oneBlockSize) * oneBlockSize;
      if (blockCoordinateX >
          widget.bucket.bucketSizeCells.x * oneBlockSize - nextBlock.blockType.blockSize.x * oneBlockSize) {
        blockCoordinateX =
            widget.bucket.bucketSizeCells.x * oneBlockSize - nextBlock.blockType.blockSize.x * oneBlockSize;
      }
    });
  }

  void _onSwipeDown() {
    final addAvailable = widget.bucket.addNewBlock(nextBlock, blockCoordinateX ~/ oneBlockSize);
    if (!addAvailable) {
      _shakeAnimationController.repeat();
      Future.delayed(const Duration(milliseconds: 500), () {
        _shakeAnimationController.reset();
      });
      return;
    }
    setState(() {
      isShowNextBlock = false;
      isShowSwipeDownAnimation = true;
    });
    _swipeDownAnimationController.forward();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isShowSwipeDownAnimation = false;
        _generateNewBlock();
      });
    });
    isShowNextBlock = false;
    debugPrint('swipe down');
    // nextBlockTitle = '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // next block area
        Container(
          width: oneBlockSize * widget.bucket.bucketSizeCells.x,
          height: oneBlockSize * 2,
          // color: Colors.black12, // 確認用
          margin: const EdgeInsets.only(bottom: 10),
          child: Stack(
            children: [
              isShowNextBlock
                  ? Positioned(
                      bottom: 0,
                      left: blockCoordinateX,
                      child: ShakeAnimation(
                        animationController: _shakeAnimationController,
                        child: BlockWidget(
                          nextBlock,
                        ),
                      ))
                  : Container(),
              Positioned(
                bottom: 0,
                left: blockCoordinateX,
                child: Draggable(
                    data: 1,
                    onDragUpdate: (details) {
                      setState(
                        () {
                          blockCoordinateX += details.delta.dx;
                          if (blockCoordinateX < 0) {
                            blockCoordinateX = 0;
                          } else if (blockCoordinateX >
                              widget.bucket.bucketSizeCells.x * oneBlockSize -
                                  nextBlock.blockType.blockSize.x * oneBlockSize) {
                            blockCoordinateX = widget.bucket.bucketSizeCells.x * oneBlockSize -
                                nextBlock.blockType.blockSize.x * oneBlockSize;
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
                          if (details.delta.dy > 5 && isShowNextBlock) {
                            setState(() {});
                            _onSwipeDown();
                          }
                        },
                        child: isShowNextBlock
                            ? Container(
                                width: nextBlock.blockType.blockSize.x * oneBlockSize,
                                height: nextBlock.blockType.blockSize.y * oneBlockSize,
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
