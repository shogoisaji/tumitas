import 'package:flutter/material.dart';
import 'package:tumitas/animations/scale_up_animation.dart';
import 'package:tumitas/animations/shake_animation.dart';
import 'package:tumitas/animations/swipe_down_animation.dart';
import 'package:tumitas/config/config.dart';
import 'package:tumitas/models/block.dart';
import 'package:tumitas/models/bucket.dart';
import 'package:tumitas/widgets/block_type_dropdown.dart';
import 'package:tumitas/widgets/block_widget.dart';
import 'package:tumitas/widgets/bucket_widget.dart';
import 'package:tumitas/widgets/task_title_dialog.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

Block nextBlock = Block(
  Colors.red,
  BlockSize(1, 1),
  // title: 'sample1',
);
Bucket bucket = Bucket(color: Colors.grey, bucketSize: BucketSize(5, 6));

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  late AnimationController _shakeAnimationController;
  late AnimationController _swipeDownAnimationController;
  String nextBlockTitle = '';
  double nextBlockPosition = 0.0;
  double blockCoodinateX = 0.0;
  BlockType? selectedBlockType;
  bool isShowNextBlock = true;
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
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _shakeAnimationController.dispose();
    _swipeDownAnimationController.dispose();
    super.dispose();
  }

  void _generateNewBlock() {
    setState(() {
      isShowNextBlock = true;
      blockCoodinateX = 0.0;
      final blockSize = selectedBlockType != null
          ? selectedBlockType!.blockSize
          : BlockSize(1, 1);
      nextBlock = Block(
        Colors.red,
        blockSize,
        title: nextBlockTitle,
      );
    });
  }

  void _blockTypeSelect(BlockType? type) {
    setState(() {
      selectedBlockType = type;
    });
    _generateNewBlock();
  }

  void _handleSubmitted(String newTitle) {
    setState(() {
      nextBlockTitle = newTitle;
    });
    _generateNewBlock();
  }

  void _setNextBlockPosition() {
    setState(() {
      blockCoodinateX =
          ((blockCoodinateX + oneBlockSize / 2) ~/ oneBlockSize) * oneBlockSize;
      if (blockCoodinateX >
          bucket.bucketSize.x * oneBlockSize -
              nextBlock.blockSize.x * oneBlockSize) {
        blockCoodinateX = bucket.bucketSize.x * oneBlockSize -
            nextBlock.blockSize.x * oneBlockSize;
      }
    });
  }

  void _onSwipeDown() {
    final addAvailable =
        bucket.addNewBlock(nextBlock, blockCoodinateX ~/ oneBlockSize);
    if (!addAvailable) {
      _shakeAnimationController.repeat();
      Future.delayed(const Duration(milliseconds: 600), () {
        _shakeAnimationController.stop();
      });
      return;
    }
    setState(() {
      isShowSwipeDownAnimation = true;
    });
    _swipeDownAnimationController.forward();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isShowSwipeDownAnimation = false;
      });
    });
    _generateNewBlock();
    isShowNextBlock = false;
    debugPrint('swipe down');
    nextBlockTitle = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.bottomLeft,
                    color: Colors.red[200],
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                BucketWidget(bucket),
                                Stack(
                                  children: [
                                    // swipe down animation block

                                    // show block
                                    isShowNextBlock
                                        ? Padding(
                                            padding: EdgeInsets.only(
                                                left: blockCoodinateX + 10),
                                            child: ShakeAnimation(
                                              animationController:
                                                  _shakeAnimationController,
                                              child: BlockWidget(
                                                nextBlock,
                                              ),
                                            ))
                                        : Container(),
                                    // draggable block
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: blockCoodinateX + 10),
                                      child: Draggable(
                                          data: 1,
                                          onDragUpdate: (details) {
                                            setState(
                                              () {
                                                blockCoodinateX +=
                                                    details.delta.dx;
                                                if (blockCoodinateX < 0) {
                                                  blockCoodinateX = 0;
                                                } else if (blockCoodinateX >
                                                    bucket.bucketSize.x *
                                                            oneBlockSize -
                                                        nextBlock.blockSize.x *
                                                            oneBlockSize) {
                                                  blockCoodinateX = bucket
                                                              .bucketSize.x *
                                                          oneBlockSize -
                                                      nextBlock.blockSize.x *
                                                          oneBlockSize;
                                                }
                                              },
                                            );
                                          },
                                          onDragEnd: (details) {
                                            _setNextBlockPosition();
                                          },
                                          axis: Axis.horizontal,
                                          childWhenDragging: Container(),
                                          feedback: Container(
                                              color: Colors.transparent),
                                          child: GestureDetector(
                                              onVerticalDragUpdate: (details) {
                                                if (details.delta.dy > 5 &&
                                                    isShowNextBlock) {
                                                  setState(() {});
                                                  _onSwipeDown();
                                                }
                                              },
                                              child: isShowNextBlock
                                                  ? BlockWidget(
                                                      nextBlock,
                                                    )
                                                  : Container())),
                                    ),
                                    Positioned(
                                      top: 0,
                                      left: 5,
                                      child: isShowSwipeDownAnimation
                                          ? SwipeDownAnimation(
                                              downDistance: 100,
                                              animationController:
                                                  _swipeDownAnimationController,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: blockCoodinateX),
                                                child: BlockWidget(
                                                  nextBlock,
                                                ),
                                              ),
                                            )
                                          : Container(),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        )),
                  ),
                ),
              ],
            ),
          ),
          Container(
              width: 250,
              color: Colors.green[200],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BlockTypeDropdownWidget(
                    initValue: selectedBlockType ?? BlockType.block1x1,
                    onSelected: _blockTypeSelect,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => TaskTitleDialog(
                            TextEditingController(text: nextBlock.title),
                            onSubmitted: _handleSubmitted,
                          ),
                        );
                      },
                      child:
                          const Text('Task', style: TextStyle(fontSize: 20))),
                  ElevatedButton(
                      onPressed: () {
                        // bucket.getMaxPosition();
                      },
                      child:
                          const Text('getP', style: TextStyle(fontSize: 20))),
                  ElevatedButton(
                      onPressed: () {
                        _generateNewBlock();
                      },
                      child:
                          const Text('newB', style: TextStyle(fontSize: 20))),
                ],
              )),
        ],
      ),
    );
  }
}
