import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tumitas/config/config.dart';
import 'package:tumitas/models/block.dart';
import 'package:tumitas/models/bucket.dart';
import 'package:tumitas/widgets/block_type_dropdown.dart';
import 'package:tumitas/widgets/play_space_widget.dart';
import 'package:tumitas/widgets/task_title_dialog.dart';

class PlayPage extends StatefulWidget {
  const PlayPage({super.key});

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  String nextBlockTitle = '';
  double nextBlockPosition = 0.0;
  double blockCoordinateX = 0.0;
  BlockType selectedBlockType = BlockType.block1x1;
  bool isShowNextBlock = true;
  bool isShowSwipeDownAnimation = false;

  // final random = Random();

  // Block nextBlock = Block(
  //   blockColorList[Random().nextInt(blockColorList.length)],
  //   BlockType.block1x1,
  //   'Title',
  //   'nextBlockDescription',
  // );
  Bucket bucket = Bucket(
      bucketTitle: 'Bucket Title',
      color: Colors.grey,
      bucketSizeCells: BucketSizeCells(5, 6),
      bucketIntoBlock: [],
      bucketMaxPosition: []);

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _blockTypeSelect(BlockType? type) {
    setState(() {
      selectedBlockType = type ?? BlockType.block1x1;
    });
    print(selectedBlockType);
  }

  void _handleSubmitted(String newTitle) {
    setState(() {
      nextBlockTitle = newTitle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            PlaySpaceWidget(
              bucket: bucket,
              selectedBlockType: selectedBlockType,
              nextBlockTitle: nextBlockTitle,
            ),
            Container(
                width: 250,
                color: Colors.green[200],
                child: Column(
                  children: [
                    BlockTypeDropdownWidget(
                      initValue: selectedBlockType,
                      onSelected: _blockTypeSelect,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => TaskTitleDialog(
                              TextEditingController(text: nextBlockTitle),
                              onSubmitted: _handleSubmitted,
                            ),
                          );
                        },
                        child: const Text('Task', style: TextStyle(fontSize: 20))),
                    ElevatedButton(
                        onPressed: () {
                          // bucket.getMaxPosition();
                        },
                        child: const Text('getP', style: TextStyle(fontSize: 20))),
                    ElevatedButton(
                        onPressed: () {
                          _blockTypeSelect(BlockType.block2x2);
                        },
                        child: const Text('newB', style: TextStyle(fontSize: 20))),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
