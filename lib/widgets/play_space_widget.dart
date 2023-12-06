import 'package:flutter/material.dart';
import 'package:tumitas/animations/shake_animation.dart';
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

  void saveCurrentBucket(Bucket bucket) async {
    await SqfliteHelper.instance.insertBucket(bucket);
  }

  @override
  Widget build(BuildContext context) {
    final double oneBlockSize = (MediaQuery.of(context).size.width - 50) / widget.bucket.bucketLayoutSizeX;

    void onSwipeDown() {
      if (nextBlock == null) return;
      final newPositionX = (blockCoordinateX + 10) ~/ oneBlockSize; // +10は誤差対策
      final addAvailable = widget.bucket.addNewBlock(nextBlock!, newPositionX);
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
      SqfliteHelper.instance.updateBucketIntoBlock(widget.currentBucketId, widget.bucket);
    }

    void setNextBlockPosition() {
      if (nextBlock == null) return;
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
        // next block area
        Container(
          width: oneBlockSize * widget.bucket.bucketLayoutSizeX,
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
                        child: BlockWidget(nextBlock!, oneBlockSize),
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
                            setState(() {});
                            onSwipeDown();
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
        BucketWidget(widget.bucket, oneBlockSize),
      ],
    );
  }
}
