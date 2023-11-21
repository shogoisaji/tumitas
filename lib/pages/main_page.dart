import 'package:flutter/material.dart';
import 'package:tumitas/animations/scale_up_animation.dart';
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

Block nextBlock = BlockType.block1x1.block;
Bucket bucket = Bucket(color: Colors.grey, bucketSize: BucketSize(5, 10));

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  String temporaryBlockTitle = '';
  double nextBlockPosition = 0.0;
  double blockCoodinateX = 0.0;
  BlockType? selectedBlockType;
  bool isShowNextBlock = true;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _generateNewBlock() {
    setState(() {
      isShowNextBlock = true;
      blockCoodinateX = 0.0;
      selectedBlockType != null
          ? selectedBlockType!.block
          : BlockType.block1x1.block;
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
      temporaryBlockTitle = newTitle;
      // nextBlock.title = newTitle;
    });
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
    bucket.addNewBlock(nextBlock, blockCoodinateX ~/ oneBlockSize);
    debugPrint('swipe down');
  }

  void _newBlockSet() {
    setState(() {
      selectedBlockType = BlockType.block1x1;
      isShowNextBlock = true;
      blockCoodinateX = 0.0;
      nextBlock = BlockType.block1x1.block;
      debugPrint('new block set');
    });
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
                    color: Colors.red[200],
                    child: Stack(children: [
                      Positioned(
                          bottom: 20,
                          left: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 5.0, bottom: 20.0),
                                child: Stack(
                                  children: [
                                    // dummy block
                                    isShowNextBlock
                                        ? Padding(
                                            padding: EdgeInsets.only(
                                                left: blockCoodinateX),
                                            child: BlockWidget(
                                              nextBlock,
                                            ))
                                        : Container(),
                                    // draggable block
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: blockCoodinateX),
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
                                                  setState(() {
                                                    isShowNextBlock = false;
                                                  });
                                                  _onSwipeDown();
                                                }
                                              },
                                              child: isShowNextBlock
                                                  ? BlockWidget(
                                                      nextBlock,
                                                    )
                                                  : Container())),
                                    ),
                                  ],
                                ),
                              ),
                              BucketWidget(bucket),
                            ],
                          ))
                    ]),
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
